CLASS zrap_demo_numgen DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS generate_department_id
      RETURNING VALUE(rv_id) TYPE string.

    CLASS-METHODS generate_employee_id
      RETURNING VALUE(rv_id) TYPE string.
ENDCLASS.

CLASS zrap_demo_numgen IMPLEMENTATION.
  METHOD generate_department_id.
    "Simple demo number generator: use UUID and take first 10 chars.
    "This provides uniqueness for demo purposes without creating a number-range object.
    DATA(uuid) = cl_system_uuid=>create_uuid_x16( ).
    rv_id = uuid+0(10).
  ENDMETHOD.

  METHOD generate_employee_id.
    DATA(uuid) = cl_system_uuid=>create_uuid_x16( ).
    rv_id = uuid+0(10).
  ENDMETHOD.
ENDCLASS.
