CLASS zrap_abap_pvt_cl_dq_evaluator DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    "Central place for HR data-quality/mandatory-field rules. New rules
    "are added here only -- callers (RAP behavior implementation, future
    "bulk scan, future UI) never hard-code field checks themselves.

    TYPES: BEGIN OF ty_missing_info,
             personnel_number   TYPE c LENGTH 8,
             field_name         TYPE string,
             category           TYPE string,
             severity           TYPE string,
             is_mandatory       TYPE abap_bool,
             recommended_action TYPE string,
           END OF ty_missing_info.
    TYPES tt_missing_info TYPE STANDARD TABLE OF ty_missing_info WITH EMPTY KEY.

    TYPES: BEGIN OF ty_employee_check_input,
             personnel_number TYPE c LENGTH 8,
             last_name        TYPE string,
             first_name       TYPE string,
             personnel_area   TYPE c LENGTH 4,
             org_unit         TYPE c LENGTH 8,
             position         TYPE c LENGTH 8,
           END OF ty_employee_check_input.

    CLASS-METHODS evaluate
      IMPORTING is_employee      TYPE ty_employee_check_input
      RETURNING VALUE(rt_missing) TYPE tt_missing_info.
ENDCLASS.

CLASS zrap_abap_pvt_cl_dq_evaluator IMPLEMENTATION.
  METHOD evaluate.
    IF is_employee-last_name IS INITIAL.
      APPEND VALUE #( personnel_number   = is_employee-personnel_number
                       field_name         = 'LastName'
                       category           = 'Personal Information'
                       severity           = 'High'
                       is_mandatory       = abap_true
                       recommended_action = 'Update last name via HR master data maintenance' )
             TO rt_missing.
    ENDIF.

    IF is_employee-first_name IS INITIAL.
      APPEND VALUE #( personnel_number   = is_employee-personnel_number
                       field_name         = 'FirstName'
                       category           = 'Personal Information'
                       severity           = 'High'
                       is_mandatory       = abap_true
                       recommended_action = 'Update first name via HR master data maintenance' )
             TO rt_missing.
    ENDIF.

    IF is_employee-personnel_area IS INITIAL.
      APPEND VALUE #( personnel_number   = is_employee-personnel_number
                       field_name         = 'PersonnelArea'
                       category           = 'Organizational Information'
                       severity           = 'Medium'
                       is_mandatory       = abap_true
                       recommended_action = 'Assign personnel area via organizational reassignment' )
             TO rt_missing.
    ENDIF.

    IF is_employee-org_unit IS INITIAL.
      APPEND VALUE #( personnel_number   = is_employee-personnel_number
                       field_name         = 'OrganizationalUnit'
                       category           = 'Organizational Information'
                       severity           = 'Medium'
                       is_mandatory       = abap_true
                       recommended_action = 'Assign organizational unit via organizational reassignment' )
             TO rt_missing.
    ENDIF.

    IF is_employee-position IS INITIAL.
      APPEND VALUE #( personnel_number   = is_employee-personnel_number
                       field_name         = 'Position'
                       category           = 'Organizational Information'
                       severity           = 'Low'
                       is_mandatory       = abap_false
                       recommended_action = 'Assign position via organizational reassignment' )
             TO rt_missing.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
