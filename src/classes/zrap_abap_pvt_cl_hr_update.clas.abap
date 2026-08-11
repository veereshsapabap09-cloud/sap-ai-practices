CLASS zrap_abap_pvt_cl_hr_update DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_correction_request,
             personnel_number TYPE c LENGTH 8,
             requested_by     TYPE syuname,
             requested_on     TYPE d,
             remark           TYPE string,
           END OF ty_correction_request.

    "NOT IMPLEMENTED (intentionally): writing to PA0001/PA0002/PA0000
    "requires the standard HR_MAINTAIN_MASTERDATA function module (or an
    "equivalent supported infotype API), with field-by-field structure
    "mapping and BEGDA/ENDDA delimiting logic that has not been verified
    "against this target system's release/configuration. Per the
    "read-only fallback instruction, this method does not call any HR
    "update API yet -- it only confirms the request was received, so the
    "RAP action has something real and honest to acknowledge. See README
    ""Known limitations" for the scope needed before this can safely
    "write to an infotype.
    CLASS-METHODS record_correction_request
      IMPORTING is_request        TYPE ty_correction_request
      RETURNING VALUE(rv_logged)  TYPE abap_bool.
ENDCLASS.

CLASS zrap_abap_pvt_cl_hr_update IMPLEMENTATION.
  METHOD record_correction_request.
    "PoC scope: no persistence yet. Options for a real follow-up, in
    "order of preference: (1) SAP standard application log via
    "BAL_LOG_CREATE/BAL_LOG_MSG_ADD (no new DDIC object needed), or
    "(2) a dedicated Z log table if a persistent audit trail is
    "required (would need explicit sign-off since it's outside this
    "PoC's "no new DDIC objects" constraint).
    rv_logged = abap_true.
  ENDMETHOD.
ENDCLASS.
