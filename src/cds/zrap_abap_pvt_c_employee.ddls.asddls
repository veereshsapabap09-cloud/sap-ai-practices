@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Employee'
@Metadata.allowExtensions: true
@ObjectModel.usageType: {
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
@Search.searchable: true
define root view entity ZRAP_ABAP_PVT_C_EMPLOYEE
  as projection on ZRAP_ABAP_PVT_I_EMPLOYEE as Employee
{
      key PersonnelNumber,

          LastName,
          FirstName,
          // Standard CDS string function -- no custom logic needed for display name.
          concat_with_space( FirstName, LastName, 1 ) as FullName,
          DateOfBirth,
          Gender,
          Nationality,
          MaritalStatus,

          CompanyCode,
          PersonnelArea,
          PersonnelSubarea,
          EmployeeGroup,
          EmployeeSubgroup,

          @Search.defaultSearchElement: true
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZRAP_ABAP_PVT_I_ORGUNIT_VH', element: 'OrgUnit' } }]
          OrganizationalUnit,

          Position,
          CostCenter,
          PayrollArea,

          EmploymentStatus,
          LastActionType,
          LastActionReason,

          ValidityStartDate,
          ValidityEndDate,

          // Data-quality indicator. Kept here (business logic), not in the
          // metadata extension (UI concern) -- see architecture separation
          // in README. Extend this condition as new mandatory fields are
          // identified; the missing-field *evaluator* class is the place
          // for the detailed, per-field breakdown (see Commit 4).
          case
            when LastName is initial or FirstName is initial
              or PersonnelArea is initial or OrganizationalUnit is initial
              or Position is initial
            then 'X'
            else ''
          end as HasMissingInformation,

          /* Associations */
          _OrgUnit
}
