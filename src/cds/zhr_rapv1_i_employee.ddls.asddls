@AbapCatalog.sqlViewName: 'ZHR1EMPLI'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View: Employee (HR Core Data)'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZHR_RAPV1_I_EMPLOYEE
  as select from pa0001 as OrgAssignment

    inner join pa0002 as PersonalData
      on  PersonalData.pernr = OrgAssignment.pernr
      and PersonalData.begda <= $session.system_date
      and PersonalData.endda >= $session.system_date

    left outer join pa0000 as Status
      on  Status.pernr = OrgAssignment.pernr
      and Status.begda <= $session.system_date
      and Status.endda >= $session.system_date

    association [0..1] to ZHR_RAPV1_VH_ORGUNIT as _OrgUnit
      on  $projection.OrganizationalUnit = _OrgUnit.OrgUnit

{
      key OrgAssignment.pernr             as PersonnelNumber,

          PersonalData.nachn              as LastName,
          PersonalData.vorna              as FirstName,
          PersonalData.gbdat              as DateOfBirth,
          PersonalData.gesch              as Gender,
          PersonalData.natio              as Nationality,
          PersonalData.famst              as MaritalStatus,

          OrgAssignment.bukrs             as CompanyCode,
          OrgAssignment.werks             as PersonnelArea,
          OrgAssignment.btrtl             as PersonnelSubarea,
          OrgAssignment.persg             as EmployeeGroup,
          OrgAssignment.persk             as EmployeeSubgroup,
          OrgAssignment.orgeh             as OrganizationalUnit,
          OrgAssignment.plans             as Position,
          OrgAssignment.kostl             as CostCenter,
          OrgAssignment.abkrs             as PayrollArea,

          // Employment status / last personnel action (from PA0000)
          Status.stat2                    as EmploymentStatus,
          Status.massn                    as LastActionType,
          Status.massg                    as LastActionReason,

          OrgAssignment.begda             as ValidityStartDate,
          OrgAssignment.endda             as ValidityEndDate,

          // Association to org unit value help (drives the F4 / org-unit filter)
          _OrgUnit
}
where
      OrgAssignment.begda <= $session.system_date
  and OrgAssignment.endda >= $session.system_date
