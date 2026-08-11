UI Metadata Extension Notes

Files added in Phase 7:
- src/metadata/ZRAP_DEMO_UI.annotations.xml
- src/metadata/ZRAP_DEMO_ValueHelps.annotations.xml
- src/cds/V_ZRAP_DEMO_STATUS.view.sql
- src/cds/V_ZRAP_DEMO_DESIGNATION.view.sql

Overview
- The UI annotations provide a starting object page layout for Department with an Employees facet.
- Value help CDS views support simple picklists for Status and Designation. Manager value help is routed to the Employees association of the Department projection.

How annotations map to behavior/actions
- The UI action placeholders (ActivateDepartment, CloseDepartment, ReopenDepartment, CopyDepartment) reference the action names declared in the behavior definition. After the OData service is bound, the Fiori Elements runtime will display these actions where appropriate.
- Feature control flags declared in the behavior definition (CanEdit, CanDelete, HidePromote) should be used by the UI runtime to enable/disable actions. The behavior implementation must expose these flags via the $metadata or via appropriate annotations (this can be added later if required by your Fiori runtime).

Next steps before running the Fiori app
1. Import and activate all DDIC and CDS objects (tables -> interface views -> projection views -> value help views).
2. Import and activate behavior definition and ABAP classes (already created in Phase 6).
3. Create the OData V4 service definition and binding (Phase 8/9). The UI annotations will then be picked up by Fiori Elements.

Notes
- The value help views are intentionally simple and read from projections. For production, you may want to provide dedicated static tables or enums for stable code lists.
- If you want, I can extend the UI annotations with more detailed FieldGroups, Identification fields, HeaderActions and Search facets in a follow-up step.
