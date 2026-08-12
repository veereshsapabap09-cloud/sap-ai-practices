CLASS zhr_rapv1_action DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS activate_department
      IMPORTING iv_deptid TYPE string
      RETURNING VALUE(rv_success) TYPE abap_bool.

    CLASS-METHODS close_department
      IMPORTING iv_deptid TYPE string
      RETURNING VALUE(rv_success) TYPE abap_bool.

    CLASS-METHODS reopen_department
      IMPORTING iv_deptid TYPE string
      RETURNING VALUE(rv_success) TYPE abap_bool.

    CLASS-METHODS copy_department
      IMPORTING iv_deptid TYPE string
      RETURNING VALUE(rv_new_deptid) TYPE string.

    CLASS-METHODS promote_employee
      IMPORTING iv_deptid TYPE string iv_empid TYPE string
      RETURNING VALUE(rv_success) TYPE abap_bool.

    CLASS-METHODS deactivate_employee
      IMPORTING iv_deptid TYPE string iv_empid TYPE string
      RETURNING VALUE(rv_success) TYPE abap_bool.
ENDCLASS.

CLASS zhr_rapv1_action IMPLEMENTATION.
  METHOD activate_department.
    DATA(ls_dept) = VALUE zhr_rapv1_dept( ).
    SELECT SINGLE * FROM zhr_rapv1_dept INTO @ls_dept WHERE departmentid = @iv_deptid.
    IF sy-subrc <> 0.
      rv_success = abap_false.
      RETURN.
    ENDIF.
    ls_dept-status = zhr_rapv1_const=>c_status_active.
    ls_dept-changedby = sy-uname.
    ls_dept-changedon = sy-datum.
    UPDATE zhr_rapv1_dept FROM ls_dept.
    rv_success = sy-subrc = 0.
  ENDMETHOD.

  METHOD close_department.
    DATA(ls_dept) = VALUE zhr_rapv1_dept( ).
    SELECT SINGLE * FROM zhr_rapv1_dept INTO @ls_dept WHERE departmentid = @iv_deptid.
    IF sy-subrc <> 0.
      rv_success = abap_false.
      RETURN.
    ENDIF.
    ls_dept-status = zhr_rapv1_const=>c_status_closed.
    ls_dept-changedby = sy-uname.
    ls_dept-changedon = sy-datum.
    UPDATE zhr_rapv1_dept FROM ls_dept.
    rv_success = sy-subrc = 0.
  ENDMETHOD.

  METHOD reopen_department.
    DATA(ls_dept) = VALUE zhr_rapv1_dept( ).
    SELECT SINGLE * FROM zhr_rapv1_dept INTO @ls_dept WHERE departmentid = @iv_deptid.
    IF sy-subrc <> 0.
      rv_success = abap_false.
      RETURN.
    ENDIF.
    ls_dept-status = zhr_rapv1_const=>c_status_active.
    ls_dept-changedby = sy-uname.
    ls_dept-changedon = sy-datum.
    UPDATE zhr_rapv1_dept FROM ls_dept.
    rv_success = sy-subrc = 0.
  ENDMETHOD.

  METHOD copy_department.
    rv_new_deptid = ''.
    " Read existing department
    DATA(ls_dept) = VALUE zhr_rapv1_dept( ).
    SELECT SINGLE * FROM zhr_rapv1_dept INTO @ls_dept WHERE departmentid = @iv_deptid.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    " Create new department header
    DATA(ls_new_dept) = ls_dept.
    ls_new_dept-departmentid = zhr_rapv1_numgen=>generate_department_id( ).
    ls_new_dept-createdby = sy-uname.
    ls_new_dept-createdon = sy-datum.
    ls_new_dept-changedby = sy-uname.
    ls_new_dept-changedon = sy-datum.
    INSERT zhr_rapv1_dept FROM ls_new_dept.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    rv_new_deptid = ls_new_dept-departmentid.

    " Copy employees
    DATA(lt_emps) = VALUE zhr_rapv1_emp_tab( ).
    SELECT * FROM zhr_rapv1_emp INTO TABLE @lt_emps WHERE departmentid = @iv_deptid.
    LOOP AT lt_emps INTO DATA(ls_emp).
      DATA(ls_new_emp) = ls_emp.
      ls_new_emp-departmentid = rv_new_deptid.
      ls_new_emp-employeeid = zhr_rapv1_numgen=>generate_employee_id( ).
      ls_new_emp-createdby = sy-uname.
      ls_new_emp-createdon = sy-datum.
      ls_new_emp-changedby = sy-uname.
      ls_new_emp-changedon = sy-datum.
      INSERT zhr_rapv1_emp FROM ls_new_emp.
    ENDLOOP.
  ENDMETHOD.

  METHOD promote_employee.
    rv_success = abap_false.
    DATA(ls_emp) = VALUE zhr_rapv1_emp( ).
    SELECT SINGLE * FROM zhr_rapv1_emp INTO @ls_emp WHERE departmentid = @iv_deptid AND employeeid = @iv_empid.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    " Simple promotion logic: prefix 'Senior ' if not already
    IF ls_emp-designation IS INITIAL.
      ls_emp-designation = 'Senior'.
    ELSEIF ls_emp-designation CP '*Senior*' = abap_false.
      ls_emp-designation = |Senior { ls_emp-designation }|.
    ENDIF.
    ls_emp-changedby = sy-uname.
    ls_emp-changedon = sy-datum.
    UPDATE zhr_rapv1_emp FROM ls_emp.
    rv_success = sy-subrc = 0.
  ENDMETHOD.

  METHOD deactivate_employee.
    rv_success = abap_false.
    DATA(ls_emp) = VALUE zhr_rapv1_emp( ).
    SELECT SINGLE * FROM zhr_rapv1_emp INTO @ls_emp WHERE departmentid = @iv_deptid AND employeeid = @iv_empid.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    ls_emp-active = 'N'.
    ls_emp-changedby = sy-uname.
    ls_emp-changedon = sy-datum.
    UPDATE zhr_rapv1_emp FROM ls_emp.
    rv_success = sy-subrc = 0.
  ENDMETHOD.
ENDCLASS.
