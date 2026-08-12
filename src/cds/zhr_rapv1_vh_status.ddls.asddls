@AbapCatalog.sqlViewName: 'ZHR1VHSTAT'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help: Department Status Codes'
define view entity ZHR_RAPV1_VH_STATUS as select from ZHR_RAPV1_C_DEPT
{
  key Status as Code,
       case Status
         when 'A' then 'Active'
         when 'C' then 'Closed'
         else 'Unknown'
       end as Description
}
