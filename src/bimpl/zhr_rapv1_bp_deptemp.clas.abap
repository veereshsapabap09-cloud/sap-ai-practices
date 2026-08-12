CLASS zhr_rapv1_bp_deptemp DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    "Behavior implementation stubs that are referenced from the behavior definition.
    "These methods adapt RAP runtime calls to helper classes. Signatures are kept generic
    "for demonstration; when binding to real RAP behavior, the signatures should match
    "the ADT generated behavior pool signatures.

    CLASS-METHODS generate_department_id
      RETURNING VALUE(rv_id) TYPE string.

    CLASS-METHODS generate_employee_id
      RETURNING VALUE(rv_id) TYPE string.

    CLASS-METHODS populate_audit_fields
      RETURNING VALUE(rt_audit) TYPE TABLE OF string.

    CLASS-METHODS validate_salary
      IMPORTING iv_salary TYPE p LENGTH 15 DECIMALS 2
      RETURNING VALUE(rv_error) TYPE string.

    CLASS-METHODS validate_email
      IMPORTING iv_email TYPE string
      RETURNING VALUE(rv_error) TYPE string.
ENDCLASS.

CLASS zhr_rapv1_bp_deptemp IMPLEMENTATION.
  METHOD generate_department_id.
    rv_id = zhr_rapv1_numgen=>generate_department_id( ).
  ENDMETHOD.

  METHOD generate_employee_id.
    rv_id = zhr_rapv1_numgen=>generate_employee_id( ).
  ENDMETHOD.

  METHOD populate_audit_fields.
    rt_audit = zhr_rapv1_util=>populate_audit_fields( ).
  ENDMETHOD.

  METHOD validate_salary.
    rv_error = zhr_rapv1_val=>validate_salary( iv_salary = iv_salary ).
  ENDMETHOD.

  METHOD validate_email.
    rv_error = zhr_rapv1_val=>validate_email( iv_email = iv_email ).
  ENDMETHOD.
ENDCLASS.
