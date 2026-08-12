CLASS zhr_rapv1_util DEFINITION PUBLIC FINAL CREATE PUBLIC.
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

CLASS zhr_rapv1_util IMPLEMENTATION.
  METHOD populate_audit_fields.
    DATA(lt) = VALUE string_table( ( |CREATEDBY:{ sy-uname }| ) ( |CREATEDON:{ sy-datum }| ) ( |CHANGEDBY:{ sy-uname }| ) ( |CHANGEDON:{ sy-datum }| ) ).
    rt_audit = lt.
  ENDMETHOD.

  METHOD default_status.
    rv_status = zhr_rapv1_const=>c_status_active.
  ENDMETHOD.

CLASS ZRAP_DEMO_UTIL IMPLEMENTATION.
ENDCLASS.
