# Material Master REST API

This repository contains a custom SICF REST handler class for bulk material master creation/update in SAP S/4HANA.

## Object

```text
ZCL_MM_MATERIAL_REST_API
```

The class implements:

```text
IF_HTTP_EXTENSION
```

## Deployment Through GitHub And Eclipse/ADT

1. Create a new GitHub repository, for example `sap-material-master-rest-api`.
2. Push this folder to the GitHub repository.
3. In SAP, install/use abapGit.
4. Use the local SAP package `$TMP`, or create a transportable package later if this must move beyond development.
5. In abapGit, clone the GitHub repository into the SAP package.
6. Pull the objects into SAP.
7. Activate class `ZCL_MM_MATERIAL_REST_API`.
8. Open Eclipse ADT project `DCD_150_pveeresh_en` and adjust any BAPI field names that differ in your S/4HANA release.
9. Create SICF service:

```text
/sap/bc/zmm/materials
```

10. Assign handler class:

```text
ZCL_MM_MATERIAL_REST_API
```

11. Activate the SICF node and test with HTTP `POST`.

## Notes

- Validate BAPI structure field names in SE11 before production use.
- Confirm material long text `TDID`; the draft uses `GRUN`.
- Confirm whether blank fields should mean "do not update".
- Commit is designed per material for partial-success processing.
