CLASS zrap_demo_bp DEFINITION PUBLIC FINAL CREATE PUBLIC.
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
protected section.
private section.
ENDCLASS.



CLASS ZRAP_DEMO_BP IMPLEMENTATION.
ENDCLASS.
