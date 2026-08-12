@AbapCatalog.sqlViewName: 'ZHR1DEPTI'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View: Department'
define view entity ZHR_RAPV1_I_DEPT as select from ZHR_RAPV1_DEPT
{
    key DEPARTMENTID    as DepartmentID,
        DEPARTMENTNAME  as DepartmentName,
        MANAGER         as Manager,
        CREATEDBY       as CreatedBy,
        CREATEDON       as CreatedOn,
        CHANGEDBY       as ChangedBy,
        CHANGEDON       as ChangedOn,
        STATUS          as Status,

    // Association to employees (composition will be declared at projection level)
    association [0..*] to ZHR_RAPV1_I_EMP as _Employees
        on $projection.DepartmentID = _Employees.DepartmentID
}
