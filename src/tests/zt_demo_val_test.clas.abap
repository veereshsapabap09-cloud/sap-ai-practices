CLASS zt_demo_val_test DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS test_validate_salary FOR TESTING.
    METHODS test_validate_email FOR TESTING.
ENDCLASS.

CLASS zt_demo_val_test IMPLEMENTATION.
  METHOD test_validate_salary.
    DATA(lv_err) = zrap_demo_val=>validate_salary( iv_salary = '-10' ).
    cl_abap_unit_assert=>assert_not_initial( lv_err ).

    lv_err = zrap_demo_val=>validate_salary( iv_salary = '1000' ).
    cl_abap_unit_assert=>assert_initial( lv_err ).
  ENDMETHOD.

  METHOD test_validate_email.
    DATA(lv_err) = zrap_demo_val=>validate_email( iv_email = 'no-at-sign' ).
    cl_abap_unit_assert=>assert_not_initial( lv_err ).

    lv_err = zrap_demo_val=>validate_email( iv_email = 'user@example.com' ).
    cl_abap_unit_assert=>assert_initial( lv_err ).
  ENDMETHOD.
ENDCLASS.
