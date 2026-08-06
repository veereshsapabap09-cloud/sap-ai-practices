CLASS zt_demo_numgen_test DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS test_generate_department_id FOR TESTING.
ENDCLASS.

CLASS zt_demo_numgen_test IMPLEMENTATION.
  METHOD test_generate_department_id.
    DATA(lv_id) = zrap_demo_numgen=>generate_department_id( ).
    cl_abap_unit_assert=>assert_not_initial( lv_id ).
    cl_abap_unit_assert=>assert_equals( act = strlen( lv_id ) exp = 10 ).
  ENDMETHOD.
ENDCLASS.
