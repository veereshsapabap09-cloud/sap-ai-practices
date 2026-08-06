Phase 10 Implementation Notes

Files added:
- src/ddic/ZRAP_DEMO_NR.table.xml (DB-backed counters for DEPT/EMP)
- Updated src/classes/ZRAP_DEMO_NUMGEN.clas.abap (uses zrap_demo_nr table for sequential IDs)
- Updated src/classes/ZRAP_DEMO_ACTION.clas.abap (full persistence logic for copy/promo/deactivate/activate/close/reopen)
- Unit tests added:
  - src/tests/zt_demo_numgen_db_test.clas.abap
  - src/tests/zt_demo_action_test.clas.abap

Notes & rationale:
- Number generator now uses a tiny DB table ZRAP_DEMO_NR to provide monotonic numeric counters. It performs an UPDATE to increment the counter and then reads the value. This is a lightweight approach suitable for demo environments and abapGit.
- Department IDs are formatted as 'D' + 9-digit zero-padded number; Employee IDs as 'E' + 9-digit zero-padded number. This yields fixed-length CHAR(10) IDs as required.
- CopyDepartment performs a deep copy: creates a new department header and duplicates associated employees with new EmployeeIDs and audit fields.
- Unit tests create transient records and validate the copy logic. Run these tests in the ABAP system after activating classes and tables.

Migration note:
- If you already imported the repository and used UUID-based IDs, the new DB counter will start from 1 unless you initialize the ZRAP_DEMO_NR table. To continue numbering after existing highest IDs, run a small script to set CURRENT_VALUE to the max existing numeric suffix for each object.

Example SQL to initialize counters (run once):
- For Departments: UPDATE zrap_demo_nr SET current_value = <max numeric part from existing DEPARTMENTID> WHERE object = 'DEPT'.
- For Employees: similarly with 'EMP'.

Next steps after Phase 10
- Run unit tests in ABAP to validate helper classes and action persistence.
- Activate the service binding and use the Postman/curl collection to run integration tests.
- If you want, I can prepare a small migration script to initialize counters based on existing data.
