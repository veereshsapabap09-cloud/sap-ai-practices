@AbapCatalog.sqlViewName: 'VZRAPDESG'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help: Designation List'
define view entity V_ZRAP_DEMO_DESIGNATION as select distinct from P_ZRAP_DEMO_EMP
{
  key Designation as Code,
      Designation as Description
}
