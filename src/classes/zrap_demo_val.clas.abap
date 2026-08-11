CLASS zrap_demo_val DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS validate_department_name
      IMPORTING iv_name TYPE string
      RETURNING VALUE(rv_error) TYPE string.

    CLASS-METHODS validate_employee_name
      IMPORTING iv_name TYPE string
      RETURNING VALUE(rv_error) TYPE string.

    CLASS-METHODS validate_salary
      IMPORTING iv_salary TYPE p LENGTH 15 DECIMALS 2
      RETURNING VALUE(rv_error) TYPE string.

    CLASS-METHODS validate_joining_date
      IMPORTING iv_date TYPE d
      RETURNING VALUE(rv_error) TYPE string.

    CLASS-METHODS validate_email
      IMPORTING iv_email TYPE string
      RETURNING VALUE(rv_error) TYPE string.

    CLASS-METHODS check_duplicate_employee
      IMPORTING iv_deptid TYPE string
                iv_empname TYPE string
                iv_email   TYPE string
      RETURNING VALUE(rv_error) TYPE string.
protected section.
private section.
ENDCLASS.



CLASS ZRAP_DEMO_VAL IMPLEMENTATION.
ENDCLASS.
