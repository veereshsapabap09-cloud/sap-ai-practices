CLASS zcl_mm_material_provider DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS process_json
      IMPORTING iv_json        TYPE string
      RETURNING VALUE(rv_json) TYPE string.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_material,
             material_code        TYPE matnr,
             industry_sector      TYPE mbrsh,
             material_type        TYPE mtart,
             plant                TYPE werks_d,
             storage_location     TYPE lgort_d,
             short_text           TYPE maktx,
             base_uom             TYPE meins,
             material_group       TYPE matkl,
             old_material_number  TYPE bismt,
             product_hierarchy    TYPE prodh_d,
             basic_material       TYPE wrkst,
             storage_bin          TYPE lgpbe,
             order_unit           TYPE bstme,
             alternative_quantity TYPE umrez,
             base_quantity        TYPE umren,
             variable_order_unit  TYPE vabme,
             long_text            TYPE string,
             purchasing_group     TYPE ekgrp,
             purchase_value_key   TYPE ekwsl,
             post_to_insp_stock   TYPE insmk,
             profit_center        TYPE prctr,
             valuation_category   TYPE bwtty_d,
             price_determination  TYPE mlast,
             valuation_class      TYPE bklas,
             project_stock        TYPE sobsk,
             price_unit           TYPE peinh,
             price_control        TYPE vprsv,
             moving_average_price TYPE verpr,
             standard_price       TYPE stprs,
           END OF ty_material.

    TYPES tt_material TYPE STANDARD TABLE OF ty_material WITH EMPTY KEY.

    TYPES: BEGIN OF ty_request,
             request_id    TYPE string,
             source_system TYPE string,
             test_run      TYPE abap_bool,
             materials     TYPE tt_material,
           END OF ty_request.

    TYPES: BEGIN OF ty_message,
             material_code TYPE matnr,
             type          TYPE bapi_mtype,
             message       TYPE bapi_msg,
           END OF ty_message.

    TYPES tt_message TYPE STANDARD TABLE OF ty_message WITH EMPTY KEY.

    TYPES: BEGIN OF ty_response,
             request_id      TYPE string,
             status          TYPE string,
             total_records   TYPE i,
             success_records TYPE i,
             failed_records  TYPE i,
             messages        TYPE tt_message,
           END OF ty_response.

    METHODS deserialize_request
      IMPORTING iv_json           TYPE string
      RETURNING VALUE(rs_request) TYPE ty_request.

    METHODS process_request
      IMPORTING is_request         TYPE ty_request
      RETURNING VALUE(rs_response) TYPE ty_response.

    METHODS process_material
      IMPORTING is_material        TYPE ty_material
                iv_test_run        TYPE abap_bool
      RETURNING VALUE(rt_messages) TYPE tt_message.

    METHODS material_exists
      IMPORTING iv_material      TYPE matnr
      RETURNING VALUE(rv_exists) TYPE abap_bool.

    METHODS call_material_bapi
      IMPORTING is_material        TYPE ty_material
                iv_test_run        TYPE abap_bool
      RETURNING VALUE(rt_messages) TYPE tt_message.

    METHODS save_material_long_text
      IMPORTING is_material        TYPE ty_material
      RETURNING VALUE(rt_messages) TYPE tt_message.

    METHODS append_bapi_messages
      IMPORTING iv_material        TYPE matnr
                it_return          TYPE bapiret2_t
      CHANGING  ct_messages        TYPE tt_message.

    METHODS serialize_response
      IMPORTING is_response    TYPE ty_response
      RETURNING VALUE(rv_json) TYPE string.
ENDCLASS.

CLASS zcl_mm_material_provider IMPLEMENTATION.
  METHOD process_json.
    DATA(ls_request) = deserialize_request( iv_json ).
    DATA(ls_response) = process_request( ls_request ).
    rv_json = serialize_response( ls_response ).
  ENDMETHOD.

  METHOD deserialize_request.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json        = iv_json
        pretty_name = /ui2/cl_json=>pretty_mode-camel_case
      CHANGING
        data        = rs_request ).
  ENDMETHOD.

  METHOD process_request.
    DATA lt_item_messages TYPE tt_message.

    rs_response-request_id = is_request-request_id.
    rs_response-total_records = lines( is_request-materials ).

    LOOP AT is_request-materials INTO DATA(ls_material).
      CLEAR lt_item_messages.

      lt_item_messages = process_material(
        is_material = ls_material
        iv_test_run = is_request-test_run ).

      APPEND LINES OF lt_item_messages TO rs_response-messages.

      IF line_exists( lt_item_messages[ type = 'E' ] )
      OR line_exists( lt_item_messages[ type = 'A' ] ).
        rs_response-failed_records = rs_response-failed_records + 1.
      ELSE.
        rs_response-success_records = rs_response-success_records + 1.
      ENDIF.
    ENDLOOP.

    IF rs_response-failed_records = 0.
      rs_response-status = 'SUCCESS'.
    ELSEIF rs_response-success_records = 0.
      rs_response-status = 'ERROR'.
    ELSE.
      rs_response-status = 'PARTIAL_SUCCESS'.
    ENDIF.
  ENDMETHOD.

  METHOD process_material.
    IF is_material-material_code IS INITIAL.
      APPEND VALUE #(
        material_code = is_material-material_code
        type          = 'E'
        message       = 'Material Code is mandatory' ) TO rt_messages.
      RETURN.
    ENDIF.

    IF is_material-material_type IS INITIAL.
      APPEND VALUE #(
        material_code = is_material-material_code
        type          = 'E'
        message       = 'Material Type is mandatory' ) TO rt_messages.
      RETURN.
    ENDIF.

    rt_messages = call_material_bapi(
      is_material = is_material
      iv_test_run = iv_test_run ).

    IF line_exists( rt_messages[ type = 'E' ] )
    OR line_exists( rt_messages[ type = 'A' ] ).
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      RETURN.
    ENDIF.

    IF iv_test_run = abap_true.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      APPEND VALUE #(
        material_code = is_material-material_code
        type          = 'S'
        message       = 'Test run completed successfully' ) TO rt_messages.
      RETURN.
    ENDIF.

    IF is_material-long_text IS NOT INITIAL.
      DATA(lt_text_messages) = save_material_long_text( is_material ).
      APPEND LINES OF lt_text_messages TO rt_messages.
    ENDIF.

    IF line_exists( rt_messages[ type = 'E' ] )
    OR line_exists( rt_messages[ type = 'A' ] ).
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD material_exists.
    SELECT SINGLE matnr
      FROM mara
      WHERE matnr = @iv_material
      INTO @DATA(lv_matnr).

    rv_exists = xsdbool( sy-subrc = 0 ).
  ENDMETHOD.

  METHOD call_material_bapi.
    DATA: ls_headdata             TYPE bapimathead,
          ls_clientdata           TYPE bapi_mara,
          ls_clientdatax          TYPE bapi_marax,
          ls_plantdata            TYPE bapi_marc,
          ls_plantdatax           TYPE bapi_marcx,
          ls_storagelocationdata  TYPE bapi_mard,
          ls_storagelocationdatax TYPE bapi_mardx,
          ls_valuationdata        TYPE bapi_mbew,
          ls_valuationdatax       TYPE bapi_mbewx,
          lt_description          TYPE STANDARD TABLE OF bapi_makt WITH EMPTY KEY,
          lt_unitsofmeasure       TYPE STANDARD TABLE OF bapi_marm WITH EMPTY KEY,
          lt_unitsofmeasurex      TYPE STANDARD TABLE OF bapi_marmx WITH EMPTY KEY,
          lt_return               TYPE bapiret2_t.

    ls_headdata-material   = is_material-material_code.
    ls_headdata-ind_sector = is_material-industry_sector.
    ls_headdata-matl_type  = is_material-material_type.
    ls_headdata-basic_view    = abap_true.
    ls_headdata-purchase_view = abap_true.
    ls_headdata-storage_view  = abap_true.
    ls_headdata-account_view  = abap_true.

    IF is_material-plant IS NOT INITIAL.
      ls_headdata-mrp_view = abap_true.
    ENDIF.

    IF is_material-short_text IS NOT INITIAL.
      APPEND VALUE #( langu = sy-langu matl_desc = is_material-short_text ) TO lt_description.
    ENDIF.

    ls_clientdata-base_uom = is_material-base_uom.
    ls_clientdatax-base_uom = xsdbool( is_material-base_uom IS NOT INITIAL ).
    ls_clientdata-matl_group = is_material-material_group.
    ls_clientdatax-matl_group = xsdbool( is_material-material_group IS NOT INITIAL ).
    ls_clientdata-old_mat_no = is_material-old_material_number.
    ls_clientdatax-old_mat_no = xsdbool( is_material-old_material_number IS NOT INITIAL ).
    ls_clientdata-prod_hier = is_material-product_hierarchy.
    ls_clientdatax-prod_hier = xsdbool( is_material-product_hierarchy IS NOT INITIAL ).
    ls_clientdata-basic_matl = is_material-basic_material.
    ls_clientdatax-basic_matl = xsdbool( is_material-basic_material IS NOT INITIAL ).

    IF is_material-order_unit IS NOT INITIAL.
      ls_clientdata-po_unit = is_material-order_unit.
      ls_clientdatax-po_unit = abap_true.
    ENDIF.

    ls_plantdata-plant = is_material-plant.
    ls_plantdatax-plant = is_material-plant.
    ls_plantdata-pur_group = is_material-purchasing_group.
    ls_plantdatax-pur_group = xsdbool( is_material-purchasing_group IS NOT INITIAL ).
    ls_plantdata-pur_valkey = is_material-purchase_value_key.
    ls_plantdatax-pur_valkey = xsdbool( is_material-purchase_value_key IS NOT INITIAL ).
    ls_plantdata-profit_ctr = is_material-profit_center.
    ls_plantdatax-profit_ctr = xsdbool( is_material-profit_center IS NOT INITIAL ).

    ls_storagelocationdata-plant = is_material-plant.
    ls_storagelocationdata-stge_loc = is_material-storage_location.
    ls_storagelocationdata-stge_bin = is_material-storage_bin.
    ls_storagelocationdatax-plant = is_material-plant.
    ls_storagelocationdatax-stge_loc = is_material-storage_location.
    ls_storagelocationdatax-stge_bin = xsdbool( is_material-storage_bin IS NOT INITIAL ).

    ls_valuationdata-val_area = is_material-plant.
    ls_valuationdata-val_cat = is_material-valuation_category.
    ls_valuationdata-ml_settle = is_material-price_determination.
    ls_valuationdata-val_class = is_material-valuation_class.
    ls_valuationdata-price_unit = is_material-price_unit.
    ls_valuationdata-price_ctrl = is_material-price_control.
    ls_valuationdata-moving_pr = is_material-moving_average_price.
    ls_valuationdata-std_price = is_material-standard_price.
    ls_valuationdatax-val_area = is_material-plant.
    ls_valuationdatax-val_cat = xsdbool( is_material-valuation_category IS NOT INITIAL ).
    ls_valuationdatax-ml_settle = xsdbool( is_material-price_determination IS NOT INITIAL ).
    ls_valuationdatax-val_class = xsdbool( is_material-valuation_class IS NOT INITIAL ).
    ls_valuationdatax-price_unit = xsdbool( is_material-price_unit IS NOT INITIAL ).
    ls_valuationdatax-price_ctrl = xsdbool( is_material-price_control IS NOT INITIAL ).
    ls_valuationdatax-moving_pr = xsdbool( is_material-moving_average_price IS NOT INITIAL ).
    ls_valuationdatax-std_price = xsdbool( is_material-standard_price IS NOT INITIAL ).

    IF is_material-alternative_quantity IS NOT INITIAL
    AND is_material-base_quantity IS NOT INITIAL
    AND is_material-order_unit IS NOT INITIAL.
      APPEND VALUE #(
        alt_unit   = is_material-order_unit
        numerator  = is_material-alternative_quantity
        denominatr = is_material-base_quantity ) TO lt_unitsofmeasure.

      APPEND VALUE #(
        alt_unit   = is_material-order_unit
        numerator  = abap_true
        denominatr = abap_true ) TO lt_unitsofmeasurex.
    ENDIF.

    CALL FUNCTION 'BAPI_MATERIAL_SAVEDATA'
      EXPORTING
        headdata             = ls_headdata
        clientdata           = ls_clientdata
        clientdatax          = ls_clientdatax
        plantdata            = ls_plantdata
        plantdatax           = ls_plantdatax
        storagelocationdata  = ls_storagelocationdata
        storagelocationdatax = ls_storagelocationdatax
        valuationdata        = ls_valuationdata
        valuationdatax       = ls_valuationdatax
      TABLES
        materialdescription  = lt_description
        unitsofmeasure       = lt_unitsofmeasure
        unitsofmeasurex      = lt_unitsofmeasurex
        returnmessages       = lt_return.

    append_bapi_messages(
      EXPORTING
        iv_material = is_material-material_code
        it_return   = lt_return
      CHANGING
        ct_messages = rt_messages ).

    IF rt_messages IS INITIAL.
      APPEND VALUE #(
        material_code = is_material-material_code
        type          = 'S'
        message       = 'Material processed successfully' ) TO rt_messages.
    ENDIF.
  ENDMETHOD.

  METHOD save_material_long_text.
    DATA: lt_lines  TYPE STANDARD TABLE OF tline WITH EMPTY KEY,
          lv_name   TYPE thead-tdname,
          ls_header TYPE thead.

    lv_name = is_material-material_code.

    CALL FUNCTION 'CONVERT_STREAM_TO_ITF_TEXT'
      EXPORTING
        language    = sy-langu
      TABLES
        text_stream = VALUE string_table( ( is_material-long_text ) )
        itf_text    = lt_lines.

    ls_header-tdobject = 'MATERIAL'.
    ls_header-tdname   = lv_name.
    ls_header-tdid     = 'GRUN'.
    ls_header-tdspras  = sy-langu.

    CALL FUNCTION 'SAVE_TEXT'
      EXPORTING
        header          = ls_header
        savemode_direct = abap_false
      TABLES
        lines           = lt_lines
      EXCEPTIONS
        id              = 1
        language        = 2
        name            = 3
        object          = 4
        OTHERS          = 5.

    IF sy-subrc <> 0.
      APPEND VALUE #(
        material_code = is_material-material_code
        type          = 'E'
        message       = |Material long text save failed. SY-SUBRC { sy-subrc }| ) TO rt_messages.
    ELSE.
      APPEND VALUE #(
        material_code = is_material-material_code
        type          = 'S'
        message       = 'Material long text saved successfully' ) TO rt_messages.
    ENDIF.
  ENDMETHOD.

  METHOD append_bapi_messages.
    LOOP AT it_return INTO DATA(ls_return).
      APPEND VALUE #(
        material_code = iv_material
        type          = ls_return-type
        message       = ls_return-message ) TO ct_messages.
    ENDLOOP.
  ENDMETHOD.

  METHOD serialize_response.
    rv_json = /ui2/cl_json=>serialize(
      data        = is_response
      pretty_name = /ui2/cl_json=>pretty_mode-camel_case
      compress    = abap_true ).
  ENDMETHOD.
ENDCLASS.
