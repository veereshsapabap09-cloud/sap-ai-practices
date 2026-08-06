CDS Interface Views

Files added:
- src/cds/I_ZRAP_DEMO_DEPT.view.sql
- src/cds/I_ZRAP_DEMO_EMP.view.sql

Mapping notes:
- I_ZRAP_DEMO_DEPT maps directly to table ZRAP_DEMO_DEPT and exposes all fields required by the behavior layer. SQL view name: ZRAPDEPTI
- I_ZRAP_DEMO_EMP maps directly to table ZRAP_DEMO_EMP and exposes all fields required by the behavior layer. SQL view name: ZRAPEMPI
- Associations: I_ZRAP_DEMO_DEPT contains an association _Employees to I_ZRAP_DEMO_EMP on DepartmentID. The projection view will declare the composition relationship (composition to child) required by RAP.
- AccessControl.authorizationCheck is set to #NOT_REQUIRED at interface level for development; access control will be tightened in behavior/service as needed.
