CLASS zt_rapv1_val_test DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS test_validate_salary FOR TESTING.
    METHODS test_validate_email FOR TESTING.
    METHODS test_validate_department_name FOR TESTING.
    METHODS test_validate_employee_name FOR TESTING.
    METHODS test_validate_joining_date FOR TESTING.
ENDCLASS.

CLASS zt_rapv1_val_test IMPLEMENTATION.
  METHOD test_validate_salary.
    DATA(lv_err) = zhr_rapv1_val=>validate_salary( iv_salary = '-10' ).
    cl_abap_unit_assert=>assert_not_initial( lv_err ).

    lv_err = zhr_rapv1_val=>validate_salary( iv_salary = '1000' ).
    cl_abap_unit_assert=>assert_initial( lv_err ).
  ENDMETHOD.

  METHOD test_validate_email.
    DATA(lv_err) = zhr_rapv1_val=>validate_email( iv_email = 'no-at-sign' ).
    cl_abap_unit_assert=>assert_not_initial( lv_err ).

    lv_err = zhr_rapv1_val=>validate_email( iv_email = 'user@example.com' ).
    cl_abap_unit_assert=>assert_initial( lv_err ).
  ENDMETHOD.

  METHOD test_validate_department_name.
    DATA(lv_err) = zhr_rapv1_val=>validate_department_name( iv_name = '' ).
    cl_abap_unit_assert=>assert_not_initial( lv_err ).

    lv_err = zhr_rapv1_val=>validate_department_name( iv_name = 'Engineering' ).
    cl_abap_unit_assert=>assert_initial( lv_err ).
  ENDMETHOD.

  METHOD test_validate_employee_name.
    DATA(lv_err) = zhr_rapv1_val=>validate_employee_name( iv_name = '' ).
    cl_abap_unit_assert=>assert_not_initial( lv_err ).

    lv_err = zhr_rapv1_val=>validate_employee_name( iv_name = 'Jane Doe' ).
    cl_abap_unit_assert=>assert_initial( lv_err ).
  ENDMETHOD.

  METHOD test_validate_joining_date.
    DATA(lv_err) = zhr_rapv1_val=>validate_joining_date( iv_date = sy-datum + 1 ).
    cl_abap_unit_assert=>assert_not_initial( lv_err ).

    lv_err = zhr_rapv1_val=>validate_joining_date( iv_date = sy-datum ).
    cl_abap_unit_assert=>assert_initial( lv_err ).
  ENDMETHOD.
ENDCLASS.
