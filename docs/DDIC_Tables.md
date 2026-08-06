# DDIC Table Notes

This file documents the two transparent tables created in Phase 2.

ZRAP_DEMO_DEPT
- Key: DEPARTMENTID (CHAR10)
- Contains basic department information and audit fields.
- STATUS uses a single-character code: A = Active, C = Closed

ZRAP_DEMO_EMP
- Key: DEPARTMENTID + EMPLOYEEID (both CHAR10) — composite key to model composition under Department.
- SALARY uses DEC(15,2).
- JOININGDATE uses DATS.
- FK: DEPARTMENTID -> ZRAP_DEMO_DEPT

Notes:
- Field datatypes are specified using DATATYPE/LENGTH in the abapGit XML to avoid creating custom domains/data elements.
- Late-numbering (automatic generation of DEPARTMENTID and EMPLOYEEID) will be implemented via a Number Generator class in Phase 6 and handled in determinations.
- Audit fields (CREATEDBY, CREATEDON, CHANGEDBY, CHANGEDON) will be populated in determinations.
