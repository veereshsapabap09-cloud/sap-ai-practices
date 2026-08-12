CLASS zhr_rapv1_val DEFINITION PUBLIC FINAL CREATE PUBLIC.
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

CLASS zhr_rapv1_val IMPLEMENTATION.
  METHOD validate_department_name.
    IF iv_name IS INITIAL.
      rv_error = 'Department name is mandatory'.
    ENDIF.
  ENDMETHOD.


  METHOD validate_salary.
    IF iv_salary < 0.
      rv_error = 'Salary cannot be negative'.
    ENDIF.
  ENDMETHOD.

  METHOD validate_joining_date.
    IF iv_date > sy-datum.
      rv_error = 'Joining date cannot be in the future'.
    ENDIF.
  ENDMETHOD.

  METHOD validate_email.
    IF iv_email IS NOT INITIAL.
      "Simple format check: must contain '@' and a '.' after '@'
      DATA(pos_at) = sy-index.
      pos_at = strpos( val = iv_email sub = '@' ).
      IF pos_at = 0.
        rv_error = 'Email must contain @'.
        RETURN.
      ENDIF.
      DATA(pos_dot) = strpos( val = iv_email sub = '.' ).
      IF pos_dot <= pos_at.
        rv_error = 'Email must contain a dot after @'.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD check_duplicate_employee.
    "In the demo we cannot query the DB from this static helper. Implementers should
    "perform a DB check in the behavior implementation using SELECT on ZHR_RAPV1_EMP.
    rv_error = ''.
  ENDMETHOD.
ENDCLASS.
