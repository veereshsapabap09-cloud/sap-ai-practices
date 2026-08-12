@AbapCatalog.sqlViewName: 'ZHR1EMPI'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View: Employee'
define view entity ZHR_RAPV1_I_EMP as select from ZHR_RAPV1_EMP
{
    key DEPARTMENTID    as DepartmentID,
    key EMPLOYEEID      as EmployeeID,
        EMPLOYEENAME    as EmployeeName,
        EMAIL,
        PHONE,
        DESIGNATION,
        SALARY,
        JOININGDATE     as JoiningDate,
        ACTIVE,
        CREATEDBY       as CreatedBy,
        CREATEDON       as CreatedOn,
        CHANGEDBY       as ChangedBy,
        CHANGEDON       as ChangedOn
}
