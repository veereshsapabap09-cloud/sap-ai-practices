@AbapCatalog.sqlViewName: 'ZHR1VHORG'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help: Organizational Unit'
define view entity ZHR_RAPV1_VH_ORGUNIT
  as select from hrp1000
{
      key objid as OrgUnit,
          stext  as OrgUnitText,
          begda  as ValidityStartDate,
          endda  as ValidityEndDate
}
where
      otype = 'O'
  and plvar = '01'
  and begda <= $session.system_date
  and endda >= $session.system_date
