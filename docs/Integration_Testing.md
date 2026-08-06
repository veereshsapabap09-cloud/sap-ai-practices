Integration Test Scripts

This file contains step-by-step tests to validate core scenarios for the RAP application after service activation.

Prerequisites
- Service binding activated and reachable at ${baseUrl}/sap/opu/odata4/sap/ZRAP_DEMO_SRV/
- User with permissions to create/edit data in the ABAP system

Test 1: Create Department (Draft flow)
1. POST /Departments with payload {"DepartmentName":"Research","Manager":""}
   - Expect: 201 Created with draft context returned (if draft-enabled)
2. Prepare/Save/Activate sequence (client-driven or via OData draft actions)
   - Expect: DepartmentID generated (non-empty), CreatedBy/CreatedOn populated

Test 2: Create Employee under Department
1. POST /Departments('<DeptID>')/_Employees with payload {"EmployeeName":"Alice","Email":"alice@example.com","Designation":"Junior","Salary":"5000","JoiningDate":"2024-01-01","Active":"X"}
   - Expect: EmployeeID generated, CreatedBy/CreatedOn populated
2. Validate duplicate prevention by attempting to create second employee with same email in same department
   - Expect: Validation error returned from service

Test 3: Validations
- Attempt to create employee with negative salary -> expect validation error
- Attempt to create employee with future JoiningDate -> expect validation error
- Attempt to create employee with invalid email -> expect validation error

Test 4: Actions
- Call POST /Departments/$action/CopyDepartment with {"DepartmentID":"<DeptID>"} -> expect new DepartmentID in response
- Call PromoteEmployee action on an employee and verify designation change or success response

Test 5: Feature controls
- Close a department via CloseDepartment action and then attempt to edit or delete -> expect feature-controlled rejection or disabled operations

Logging and troubleshooting
- If validation messages are not visible, check server logs (ST22/SLG1) and ensure behavior implementation raises RAP exceptions properly.
