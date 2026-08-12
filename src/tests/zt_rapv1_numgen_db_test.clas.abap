CLASS zt_rapv1_numgen_db_test DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS test_generate_ids FOR TESTING.
ENDCLASS.

CLASS zt_rapv1_numgen_db_test IMPLEMENTATION.
  METHOD test_generate_ids.
    DATA(lv_did) = zhr_rapv1_numgen=>generate_department_id( ).
    DATA(lv_eid) = zhr_rapv1_numgen=>generate_employee_id( ).
    cl_abap_unit_assert=>assert_not_initial( lv_did ).
    cl_abap_unit_assert=>assert_not_initial( lv_eid ).
    cl_abap_unit_assert=>assert_equals( act = strlen( lv_did ) exp = 10 ).
    cl_abap_unit_assert=>assert_equals( act = strlen( lv_eid ) exp = 10 ).
    " Ensure prefix
    cl_abap_unit_assert=>assert_equals( act = lv_did+0(1) exp = 'D' ).
    cl_abap_unit_assert=>assert_equals( act = lv_eid+0(1) exp = 'E' ).
  ENDMETHOD.
ENDCLASS.
