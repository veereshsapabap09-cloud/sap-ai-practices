# Architecture

This document will describe the overall architecture of the RAP demo, including the data model, CDS layering, behavior pool, number-range helper, determinations, validations and actions.

Planned objects (high level):
- Transparent tables: ZRAP_DEMO_DEPT, ZRAP_DEMO_EMP
- CDS Interface Views: I_ZRAP_DEMO_DEPT, I_ZRAP_DEMO_EMP
- Projection Views: P_ZRAP_DEMO_DEPT (root), P_ZRAP_DEMO_EMP (child)
- Behavior definition: ZRAP_DEMO_BP
- Behavior implementation classes and helpers
- Service definition: ZRAP_DEMO_SRV
- Service binding: OData V4
