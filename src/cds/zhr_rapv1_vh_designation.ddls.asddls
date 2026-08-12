@AbapCatalog.sqlViewName: 'ZHR1VHDESG'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help: Designation List'
define view entity ZHR_RAPV1_VH_DESIGNATION as select distinct from ZHR_RAPV1_C_EMP
{
  key Designation as Code,
      Designation as Description
}
