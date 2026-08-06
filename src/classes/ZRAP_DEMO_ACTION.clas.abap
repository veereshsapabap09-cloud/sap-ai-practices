CLASS zrap_demo_action DEFINITION PUBLIC FINAL CREATE PUBLIC.
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

CLASS zrap_demo_action IMPLEMENTATION.
  METHOD activate_department.
    "Demo behavior: normally would change status and persist. Here we return success.
    rv_success = abap_true.
  ENDMETHOD.

  METHOD close_department.
    rv_success = abap_true.
  ENDMETHOD.

  METHOD reopen_department.
    rv_success = abap_true.
  ENDMETHOD.

  METHOD copy_department.
    "Create a new department id and (in a real implementation) copy child records.
    rv_new_deptid = zrap_demo_numgen=>generate_department_id( ).
  ENDMETHOD.

  METHOD promote_employee.
    rv_success = abap_true.
  ENDMETHOD.

  METHOD deactivate_employee.
    rv_success = abap_true.
  ENDMETHOD.
ENDCLASS.
