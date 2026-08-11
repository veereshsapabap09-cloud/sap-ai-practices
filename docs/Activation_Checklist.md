Activation Checklist

1. Import repository via abapGit
2. Activate tables in src/ddic/
3. Activate CDS interface views (src/cds/I_*.view.sql)
4. Activate CDS projection views (src/cds/P_*.view.sql)
5. Activate value-help CDS views (src/cds/V_*.view.sql)
6. Activate behavior definition (src/bdef/ZRAP_DEMO_BP.behavior.xml)
7. Activate ABAP classes (src/classes/*) and behavior pool (src/bimpl/*)
8. Activate metadata annotations (src/metadata/*)
9. Activate service definition and binding (src/service/*)
10. Test endpoints using Postman or curl (see docs/postman_collection.json and docs/curl_examples.md)
