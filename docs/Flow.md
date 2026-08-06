# Flow

This document will describe the runtime flow and sequence for create/change/delete operations, draft handling, late numbering, determinations, validations and actions.

Key flows:
- Create Department (Draft -> Prepare -> Activate)
- Create Employee (child under Department)
- Factory action: Copy Department including employees
- Actions: Promote, Deactivate, Activate, Close, Reopen
