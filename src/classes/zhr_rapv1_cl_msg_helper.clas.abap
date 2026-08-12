CLASS zhr_rapv1_cl_msg_helper DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    "Deliberately simple: plain text templating only. Wiring this into
    "RAP's %msg / reported-table message population is deferred until
    "the exact generated message-handling API is confirmed against an
    "activated behavior definition in the target system (see README
    ""Known limitations") -- guessing that signature risks the same
    "class of failure as the earlier fabricated abapGit XML schemas.
    CLASS-METHODS build_text
      IMPORTING iv_template     TYPE string
                iv_v1           TYPE string OPTIONAL
                iv_v2           TYPE string OPTIONAL
      RETURNING VALUE(rv_text)  TYPE string.
ENDCLASS.

CLASS zhr_rapv1_cl_msg_helper IMPLEMENTATION.
  METHOD build_text.
    rv_text = iv_template.
    IF iv_v1 IS NOT INITIAL.
      REPLACE '&1' IN rv_text WITH iv_v1.
    ENDIF.
    IF iv_v2 IS NOT INITIAL.
      REPLACE '&2' IN rv_text WITH iv_v2.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
