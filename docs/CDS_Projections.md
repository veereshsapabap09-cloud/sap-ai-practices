CDS Projection Views

Files added:
- src/cds/P_ZRAP_DEMO_DEPT.view.sql
- src/cds/P_ZRAP_DEMO_EMP.view.sql

Notes and rationale:
- P_ZRAP_DEMO_DEPT is declared as a root projection view and includes a composition association to P_ZRAP_DEMO_EMP via @ObjectModel.composition to represent the aggregate (Department -> Employees).
- P_ZRAP_DEMO_EMP is a projection view for the child entity; it exposes the key fields and relevant UI line items.
- UI annotations are intentionally minimal to leave room for richer metadata extensions in Phase 7.
- SQL view names were chosen: ZRAPDEPTP (Department projection), ZRAPEMPP (Employee projection).

Activation order for ABAP system (abapGit import):
1. Transparent tables (already in Phase 2)
2. CDS Interface views (Phase 3)
3. CDS Projection views (this Phase 4)
4. Behavior definition (Phase 5)
