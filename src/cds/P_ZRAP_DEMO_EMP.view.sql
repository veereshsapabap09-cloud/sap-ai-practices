@AbapCatalog.sqlViewName: 'ZRAPEMPP'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View: Employee (Child)'
@ClientHandling.algorithm: #SAME
@Metadata.ignorePropagatedAnnotations: true
define view entity P_ZRAP_DEMO_EMP
  as projection on I_ZRAP_DEMO_EMP
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
    association to P_ZRAP_DEMO_DEPT as _Department
        on $projection.DepartmentID = _Department.DepartmentID

    // Basic UI annotations for line item display
    @UI.lineItem: [{position:10}, {value: EmployeeName}, {value: Designation}, {value: Email}]
    EmployeeName
}
