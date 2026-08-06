# ESS Accelerator — ZABAP_GIT (PoC)

This repository contains the ESS Accelerator skeleton and artifacts for a RAP-based Employee Self Service framework.

Structure:
- docs/: Architecture and PlantUML diagrams
- src/: ABAP source artifacts by layer
  - ddic/: Domain and table templates (DDIC)
  - cds/: CDS views (Phase 4)
  - bdef/: Behavior definitions (Phase 5)
  - bimpl/: Behavior implementations (Phase 6)
  - services/: Business service layer classes
  - classes/: Shared classes
  - workflow/: Workflow metadata
  - test/: Unit tests and test data
- .abapgit.xml: ABAPGit manifest (skeleton)

Quick start
1. Import DDIC artifacts into ADT (create domains/data elements/tables) using the templates in ESS/src/ddic/ (recommended Workflow A: create in ADT then abapGit-export).
2. When Phase 4 is approved, add CDS sources under ESS/src/cds/ and follow the Phase plan.