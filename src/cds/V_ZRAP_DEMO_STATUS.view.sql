@AbapCatalog.sqlViewName: 'VZRAPSTAT'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help: Department Status Codes'
define view entity V_ZRAP_DEMO_STATUS as select from P_ZRAP_DEMO_DEPT
{
  key Status as Code,
       case Status
         when 'A' then 'Active'
         when 'C' then 'Closed'
         else 'Unknown'
       end as Description
}
