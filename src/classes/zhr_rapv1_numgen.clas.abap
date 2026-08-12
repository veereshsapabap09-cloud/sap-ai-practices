CLASS zhr_rapv1_numgen DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS generate_department_id
      RETURNING VALUE(rv_id) TYPE string.

    CLASS-METHODS generate_employee_id
      RETURNING VALUE(rv_id) TYPE string.

  PRIVATE SECTION.
    CLASS-METHODS increment_counter
      IMPORTING iv_object TYPE string
      RETURNING VALUE(rv_value) TYPE i.
ENDCLASS.

CLASS zhr_rapv1_numgen IMPLEMENTATION.
  METHOD increment_counter.
    DATA(lv_object) = iv_object.
    DATA(lv_rows) = 0.

    " Try to increment the counter atomically in the DB
    UPDATE zhr_rapv1_nr SET current_value = current_value + 1 WHERE object = @lv_object.
    lv_rows = sy-subrc.
    IF sy-subrc = 0.
      " Read the updated value
      SELECT SINGLE current_value FROM zhr_rapv1_nr INTO @rv_value WHERE object = @lv_object.
    ELSE.
      " No row existed yet; create initial row with value 1
      rv_value = 1.
      INSERT zhr_rapv1_nr VALUES ( lv_object rv_value ).
      IF sy-subrc <> 0.
        " Possible race: another session inserted; try update again
        UPDATE zhr_rapv1_nr SET current_value = current_value + 1 WHERE object = @lv_object.
        SELECT SINGLE current_value FROM zhr_rapv1_nr INTO @rv_value WHERE object = @lv_object.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD generate_department_id.
    DATA(lv_num) = increment_counter( iv_object = 'DEPT' ).
    " Format: 'D' + 9-digit zero-padded number -> total length 10
    rv_id = |D{ lv_num ALPHA = IN }|.
    " Ensure zero padding to 9 digits
    rv_id = 'D' && lv_num.
    " Pad left with zeros to make 10 characters (D + 9 digits)
    rv_id = |{ rv_id ALPHA = IN WIDTH = 10 }|.
  ENDMETHOD.

  METHOD generate_employee_id.
    DATA(lv_num) = increment_counter( iv_object = 'EMP' ).
    rv_id = |E{ lv_num ALPHA = IN }|.
    rv_id = 'E' && lv_num.
    rv_id = |{ rv_id ALPHA = IN WIDTH = 10 }|.
  ENDMETHOD.
ENDCLASS.
