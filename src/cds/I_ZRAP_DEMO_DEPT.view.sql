@AbapCatalog.sqlViewName: 'ZRAPDEPTI'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View: Department'
define view entity I_ZRAP_DEMO_DEPT as select from ZRAP_DEMO_DEPT
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
    association [0..*] to I_ZRAP_DEMO_EMP as _Employees
        on $projection.DepartmentID = _Employees.DepartmentID
}
