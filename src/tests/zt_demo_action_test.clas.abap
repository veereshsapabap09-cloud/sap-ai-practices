CLASS zt_demo_action_test DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS test_copy_department FOR TESTING.
ENDCLASS.

CLASS zt_demo_action_test IMPLEMENTATION.
  METHOD test_copy_department.
    " Create a temp department
    DATA(lv_deptid) = zrap_demo_numgen=>generate_department_id( ).
    DATA(ls_dept) = VALUE zrap_demo_dept(
      departmentid = lv_deptid
      departmentname = 'UT Dept'
      manager = ''
      createdby = sy-uname
      createdon = sy-datum
      changedby = sy-uname
      changedon = sy-datum
      status = zrap_demo_const=>c_status_active ).
    INSERT zrap_demo_dept FROM ls_dept.
    cl_abap_unit_assert=>assert_subrc( 0 ).

    " Insert an employee
    DATA(lv_empid) = zrap_demo_numgen=>generate_employee_id( ).
    DATA(ls_emp) = VALUE zrap_demo_emp(
      departmentid = lv_deptid
      employeeid = lv_empid
      employeename = 'UT Employee'
      email = 'ut@example.com'
      phone = ''
      designation = 'Junior'
      salary = 1000
      joiningdate = sy-datum
      active = 'X'
      createdby = sy-uname
      createdon = sy-datum
      changedby = sy-uname
      changedon = sy-datum ).
    INSERT zrap_demo_emp FROM ls_emp.
    cl_abap_unit_assert=>assert_subrc( 0 ).

    " Call copy
    DATA(lv_new) = zrap_demo_action=>copy_department( iv_deptid = lv_deptid ).
    cl_abap_unit_assert=>assert_not_initial( lv_new ).

    " Verify new department exists
    DATA(ls_new) = VALUE zrap_demo_dept( ).
    SELECT SINGLE * FROM zrap_demo_dept INTO @ls_new WHERE departmentid = @lv_new.
    cl_abap_unit_assert=>assert_initial( sy-subrc ).

    " Verify employees copied
    DATA(lt_emps) = VALUE zrap_demo_emp_tab( ).
    SELECT * FROM zrap_demo_emp INTO TABLE @lt_emps WHERE departmentid = @lv_new.
    cl_abap_unit_assert=>assert_not_initial( lt_emps ).
  ENDMETHOD.
ENDCLASS.
