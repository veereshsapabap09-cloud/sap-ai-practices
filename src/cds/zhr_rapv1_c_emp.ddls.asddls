@AbapCatalog.sqlViewName: 'ZHR1EMPC'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View: Employee (Child)'
@ClientHandling.algorithm: #SAME
@Metadata.ignorePropagatedAnnotations: true
define view entity ZHR_RAPV1_C_EMP
  as projection on ZHR_RAPV1_I_EMP
{
    key DepartmentID,
    key EmployeeID,
        EmployeeName,
        Email,
        Phone,
        Designation,
        Salary,
        JoiningDate,
        Active,
        CreatedBy,
        CreatedOn,
        ChangedBy,
        ChangedOn

    // Association back to Department for value help; no composition here (handled at root)
    association to ZHR_RAPV1_C_DEPT as _Department
        on $projection.DepartmentID = _Department.DepartmentID

    // Basic UI annotations for line item display
    @UI.lineItem: [{position:10}, {value: EmployeeName}, {value: Designation}, {value: Email}]
    EmployeeName
}
