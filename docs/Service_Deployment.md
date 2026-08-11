Service Deployment & Activation Guide

This document explains how to activate and test the ZRAP_DEMO_SRV OData V4 service in an ABAP system after importing the repository via abapGit.

Prerequisites (activation order)
1. Import repository via abapGit and activate DDIC objects (src/ddic/*)
2. Activate CDS interface views (src/cds/I_*.view.sql)
3. Activate CDS projection views (src/cds/P_*.view.sql)
4. Activate value-help CDS views (src/cds/V_*.view.sql)
5. Activate Behavior Definition (src/bdef/ZRAP_DEMO_BP.behavior.xml)
6. Activate ABAP classes and behavior pool (src/classes/* and src/bimpl/*)
7. Activate UI metadata annotations (src/metadata/*)
8. Import and activate Service Definition (src/service/ZRAP_DEMO_SRV.service.xml)
9. Create and activate OData V4 service binding (src/service/ZRAP_DEMO_SRV.v4binding.xml)

Registering and Activating the OData Service (high-level)
- Using ADT (Eclipse/Business Application Studio):
  1. Right-click the service binding artifact and choose Activate.
  2. In transaction /IWFND/MAINT_SERVICE or the OData Publication UI, ensure the service is registered.
  3. Check the endpoint: GET /sap/opu/odata4/sap/ZRAP_DEMO_SRV/$metadata

- Using SICF (if required):
  - Ensure the service path is active under the ICF tree if your landscape requires SICF activation.

Testing the service
- Metadata:
  - GET: /sap/opu/odata4/sap/ZRAP_DEMO_SRV/$metadata
  - Confirm entity sets Departments and Employees appear and actions are present.

- Example: Read Departments
  - GET: /sap/opu/odata4/sap/ZRAP_DEMO_SRV/Departments

- Example: Create Department (Draft flow)
  - POST to /sap/opu/odata4/sap/ZRAP_DEMO_SRV/Departments
  - Use sample payloads in docs/service_test_payloads.json

- Example: Call action (CopyDepartment)
  - POST to /sap/opu/odata4/sap/ZRAP_DEMO_SRV/Departments/$action/CopyDepartment
  - Payload: { "DepartmentID": "D0001" }

Troubleshooting
- If actions are missing in $metadata: ensure the Behavior Definition is active and the service binding exposes actions.
- If draft operations fail: confirm Draft framework (CDS + behavior + service) is consistent and activated.
- Check system logs (ST22, SLG1) for server-side exceptions.

Security
- Replace the authorization stubs implemented in src/classes/ZRAP_DEMO_UTIL.clas.abap with real PFCG role checks before production.

