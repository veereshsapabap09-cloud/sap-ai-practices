@AbapCatalog.sqlViewName: 'ZRAPDEPTP'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View: Department (Root)'
@ClientHandling.algorithm: #SAME
@Metadata.ignorePropagatedAnnotations: true
define root view entity P_ZRAP_DEMO_DEPT
  as projection on I_ZRAP_DEMO_DEPT
{
    key DepartmentID,
        DepartmentName,
        Manager,
        Status,
        CreatedBy,
        CreatedOn,
        ChangedBy,
        ChangedOn,

    // Composition to child projection (employees)
    @ObjectModel.composition: true
    @EndUserText.label: 'Employees of Department'
    association [0..*] to P_ZRAP_DEMO_EMP as _Employees
        on $projection.DepartmentID = _Employees.DepartmentID

    // Basic UI annotations (identification and line item placeholders)
    @UI.identification: [{position:10}]
    @UI.headerInfo: [{type: #STANDARD, title: 'DepartmentName'}]
    DepartmentName as Title
}
