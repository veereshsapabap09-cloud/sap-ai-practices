# curl Examples for ZRAP_DEMO_SRV

Set the environment variable baseUrl to your ABAP system base (e.g. https://my.sap.system)

1) Get metadata

curl -u <user>:<pwd> "${baseUrl}/sap/opu/odata4/sap/ZRAP_DEMO_SRV/$metadata"

2) Read Departments

curl -u <user>:<pwd> "${baseUrl}/sap/opu/odata4/sap/ZRAP_DEMO_SRV/Departments"

3) Create Department (Draft)

curl -u <user>:<pwd> -H "Content-Type: application/json" -d '{"DepartmentName":"Research","Manager":""}' \
  "${baseUrl}/sap/opu/odata4/sap/ZRAP_DEMO_SRV/Departments"

4) Call CopyDepartment action (factory)

curl -u <user>:<pwd> -H "Content-Type: application/json" -d '{"DepartmentID":"D0001"}' \
  "${baseUrl}/sap/opu/odata4/sap/ZRAP_DEMO_SRV/Departments/$action/CopyDepartment"

5) PromoteEmployee action (example)

curl -u <user>:<pwd> -H "Content-Type: application/json" -d '{"DepartmentID":"D0001","EmployeeID":"E0001"}' \
  "${baseUrl}/sap/opu/odata4/sap/ZRAP_DEMO_SRV/Employees('<D0001>', '<E0001>')/$action/PromoteEmployee"
