Behavior Definition - Design Notes

File added: src/bdef/ZRAP_DEMO_BP.behavior.xml

Overview
- This document describes the behavior definition declared in the XML file. The behavior definition declares the managed, draft-enabled RAP contract for Department (root) and Employee (child) entities.

Mapping of Business Requirements to Behavior Elements
- Root entity (Department): P_ZRAP_DEMO_DEPT (projection) - declared as managed root with draft enabled.
- Child entity (Employee): P_ZRAP_DEMO_EMP (projection) - declared as composition child and draft-enabled.

Determinations (to be implemented in Phase 6)
- GenerateDepartmentID (ZRAP_DEMO_NUMGEN.generate_department_id): Late numbering for Department IDs. Trigger: prepare/activate.
- GenerateEmployeeID (ZRAP_DEMO_NUMGEN.generate_employee_id): Late numbering for Employee IDs. Trigger: prepare/activate.
- Populate audit fields (ZRAP_DEMO_UTIL.populate_audit_fields): Fill CreatedBy/CreatedOn/ChangedBy/ChangedOn on create/change.
- DefaultStatus (ZRAP_DEMO_UTIL.default_status): Set default Status 'A' for new departments.

Validations (to be implemented in Phase 6)
- DepartmentName mandatory -> ZRAP_DEMO_VAL.validate_department_name
- EmployeeName mandatory -> ZRAP_DEMO_VAL.validate_employee_name
- Salary non-negative -> ZRAP_DEMO_VAL.validate_salary
- Joining date not in future -> ZRAP_DEMO_VAL.validate_joining_date
- Email format check -> ZRAP_DEMO_VAL.validate_email
- Duplicate employee (within same department) -> ZRAP_DEMO_VAL.check_duplicate_employee

Actions (to be implemented in Phase 6)
- Department actions (instance): ActivateDepartment, CloseDepartment, ReopenDepartment -> ZRAP_DEMO_ACTION
- Department factory action: CopyDepartment -> ZRAP_DEMO_ACTION
- Employee actions (instance): PromoteEmployee, DeactivateEmployee -> ZRAP_DEMO_ACTION

Feature Controls
- CanEdit / CanDelete on Department governed by Status = 'C' (Closed)
- HidePromote when employee is already manager (IsManager flag expected to be derived/available in projection or determination)

Authorization
- Simple authorization check stubs are declared; these are placeholders for integration with the customer's authorization concept (PFCG roles/objects).

Locks
- Standard RAP draft-locking will be used. Special lock logic (if necessary) will be implemented in behavior implementation.

Next steps
- Phase 6: Implement ABAP classes and the behavior pool implementing the determinations, validations, actions and number-generation logic. Unit tests will also be created for helper classes.
