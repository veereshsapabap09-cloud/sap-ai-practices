CLASS zrap_demo_util DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS populate_audit_fields
      RETURNING VALUE(rt_audit) TYPE TABLE OF string.

    CLASS-METHODS default_status
      RETURNING VALUE(rv_status) TYPE string.

    CLASS-METHODS auth_check
      IMPORTING iv_action TYPE string
      RETURNING VALUE(rv_allowed) TYPE abap_bool.

    CLASS-METHODS auth_check_emp
      IMPORTING iv_action TYPE string
      RETURNING VALUE(rv_allowed) TYPE abap_bool.
protected section.
private section.
ENDCLASS.



CLASS ZRAP_DEMO_UTIL IMPLEMENTATION.
ENDCLASS.
