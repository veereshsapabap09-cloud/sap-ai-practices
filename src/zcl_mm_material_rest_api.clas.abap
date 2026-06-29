CLASS zcl_mm_material_rest_api DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_http_extension.

  PRIVATE SECTION.
    METHODS set_json_response
      IMPORTING io_server TYPE REF TO if_http_server
                iv_status TYPE i
                iv_reason TYPE string
                iv_json   TYPE string.
ENDCLASS.

CLASS zcl_mm_material_rest_api IMPLEMENTATION.
  METHOD if_http_extension~handle_request.
    DATA lv_method TYPE string.
    DATA lv_json   TYPE string.
    DATA lo_provider TYPE REF TO zcl_mm_material_provider.

    lv_method = server->request->get_header_field( '~request_method' ).

    IF lv_method <> 'POST'.
      set_json_response(
        io_server = server
        iv_status = 405
        iv_reason = 'Method Not Allowed'
        iv_json   = '{"status":"ERROR","messages":[{"type":"E","message":"Only POST is supported"}]}' ).
      RETURN.
    ENDIF.

    lv_json = server->request->get_cdata( ).
    CREATE OBJECT lo_provider.

    TRY.
        set_json_response(
          io_server = server
          iv_status = 200
          iv_reason = 'OK'
          iv_json   = lo_provider->process_json( lv_json ) ).

      CATCH cx_root INTO DATA(lx_error).
        set_json_response(
          io_server = server
          iv_status = 400
          iv_reason = 'Bad Request'
          iv_json   = |{{"status":"ERROR","messages":[{{"type":"E","message":"{ lx_error->get_text( ) }"}}]}}| ).
    ENDTRY.
  ENDMETHOD.

  METHOD set_json_response.
    io_server->response->set_status(
      code   = iv_status
      reason = iv_reason ).

    io_server->response->set_header_field(
      name  = 'Content-Type'
      value = 'application/json; charset=utf-8' ).

    io_server->response->set_cdata( iv_json ).
  ENDMETHOD.
ENDCLASS.
