CLASS zhr_rapv1_bp_employee DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zhr_rapv1_c_employee.
ENDCLASS.

CLASS zhr_rapv1_bp_employee IMPLEMENTATION.

  METHOD read.
    "Unmanaged READ: query the interface view directly (never the raw
    "infotype tables) so the current-record/join logic from Commit 1 is
    "reused here, not duplicated.
    DATA lt_data TYPE TABLE OF zhr_rapv1_i_employee.

    IF keys IS NOT INITIAL.
      SELECT * FROM zhr_rapv1_i_employee
        FOR ALL ENTRIES IN @keys
        WHERE personnelnumber = @keys-personnelnumber
        INTO CORRESPONDING FIELDS OF TABLE @lt_data.
    ENDIF.

    result = VALUE #( FOR ls_data IN lt_data
      ( %tky-personnelnumber  = ls_data-personnelnumber
        LastName               = ls_data-lastname
        FirstName               = ls_data-firstname
        FullName               = |{ ls_data-firstname } { ls_data-lastname }|
        DateOfBirth             = ls_data-dateofbirth
        Gender                  = ls_data-gender
        Nationality             = ls_data-nationality
        MaritalStatus           = ls_data-maritalstatus
        CompanyCode             = ls_data-companycode
        PersonnelArea           = ls_data-personnelarea
        PersonnelSubarea        = ls_data-personnelsubarea
        EmployeeGroup           = ls_data-employeegroup
        EmployeeSubgroup        = ls_data-employeesubgroup
        OrganizationalUnit      = ls_data-organizationalunit
        Position                = ls_data-position
        CostCenter              = ls_data-costcenter
        PayrollArea             = ls_data-payrollarea
        EmploymentStatus        = ls_data-employmentstatus
        LastActionType          = ls_data-lastactiontype
        LastActionReason        = ls_data-lastactionreason
        ValidityStartDate       = ls_data-validitystartdate
        ValidityEndDate         = ls_data-validityenddate
        HasMissingInformation   = COND #( WHEN ls_data-lastname IS INITIAL
                                             OR ls_data-firstname IS INITIAL
                                             OR ls_data-personnelarea IS INITIAL
                                             OR ls_data-organizationalunit IS INITIAL
                                             OR ls_data-position IS INITIAL
                                           THEN abap_true ELSE abap_false ) ) ).
  ENDMETHOD.

  METHOD lock.
    "No exclusive lock taken: this PoC is read/action-only (see behavior
    "definition -- no create/update/delete declared). A real update path
    "would take the standard HR enqueue (ENQUEUE_EPERSONAL) here, not a
    "generic RAP lock, since PA-table concurrency is HR's own domain.
  ENDMETHOD.

  METHOD get_instance_features.
    result = VALUE #( FOR key IN keys
      ( %tky                                = key-%tky
        %features-%action-checkDataQuality  = if_abap_behv=>fc-o-enabled
        %features-%action-requestCorrection = if_abap_behv=>fc-o-enabled ) ).
  ENDMETHOD.

  METHOD checkdataquality.
    READ ENTITIES OF zhr_rapv1_c_employee IN LOCAL MODE
      ENTITY Employee
        FIELDS ( PersonnelNumber LastName FirstName PersonnelArea
                 OrganizationalUnit Position )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_employee).

    LOOP AT lt_employee INTO DATA(ls_employee).
      "Delegates to the DQ evaluator so the rule set stays in one place.
      "The detailed per-field list (lt_missing) is computed but not yet
      "surfaced back through RAP messages -- see README "Known
      "limitations" for why that's deferred rather than guessed at; the
      "recomputed HasMissingInformation flag is still visible to the
      "caller via the normal read that follows this action.
      DATA(lt_missing) = zhr_rapv1_cl_dq_evaluator=>evaluate(
        VALUE #( personnel_number = ls_employee-PersonnelNumber
                 last_name        = ls_employee-LastName
                 first_name       = ls_employee-FirstName
                 personnel_area   = ls_employee-PersonnelArea
                 org_unit         = ls_employee-OrganizationalUnit
                 position         = ls_employee-Position ) ).
      DATA(lv_missing_count) = lines( lt_missing ).

      APPEND CORRESPONDING #( ls_employee ) TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD requestcorrection.
    READ ENTITIES OF zhr_rapv1_c_employee IN LOCAL MODE
      ENTITY Employee
        FIELDS ( PersonnelNumber )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_employee).

    LOOP AT lt_employee INTO DATA(ls_employee).
      DATA(lv_logged) = zhr_rapv1_cl_hr_update=>record_correction_request(
        VALUE #( personnel_number = ls_employee-PersonnelNumber
                 requested_by     = sy-uname
                 requested_on     = sy-datum
                 remark           = 'Requested via HR Data Quality Dashboard' ) ).

      APPEND CORRESPONDING #( ls_employee ) TO result.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
