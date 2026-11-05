Crownfield Eye Hospital database
Student: Andrew Dolan
Student ID: G1421536
Module: CPU4103 Introduction to Database

This repository contains my SQL submission for a fictional eye-hospital database. It covers database creation, sample data, queries, a stored procedure, a trigger, transactions and access permissions. The patient and appointment records are teaching data.
Requirements
- MySQL 8.0.16 or later, with enforced CHECK constraints. See the MySQL CHECK-constraint documentation.
- Transactional tables using InnoDB, which is the normal default for MySQL.
- A SQL editor connected to the server.
- An administrator connection for setup, creating the procedure and trigger, and running the security script. The final security checks read the mysql system tables.
Use a fresh local teaching environment. The scripts create tables, a view, a procedure, a trigger and demonstration accounts. They are intended for their first execution and are not all safe to rerun against an existing setup.
Files and execution order
Run the files in this order:
1. 01_schema.sql — creates crownfield_eye_hospital, creates ten tables, inserts sample records, demonstrates a valid update and temporary-clinic deletion, and adds the positive review-interval CHECK constraint.
2. 02_individual_queries.sql — runs the individual queries: appointment counts by clinic, appointment details using joins, appointments without prescriptions, and patients with more than one appointment.
3. 03_procedure_and_trigger.sql — creates and calls GetPatientAppointments, creates UpdateFollowUpDueDate, and demonstrates an update followed by ROLLBACK.
4. 04_security.sql — creates the roles, grants permissions, creates the filtered patient view, creates the local demonstration accounts and assigns their default roles.
5. integrity_tests.sql — runs the deliberate failure tests described below. Run each test separately so that one expected error does not stop you seeing the other tests.
Setup steps
1. Open the SQL editor and connect to the local server as administrator.
2. Make sure the project tables and demonstration accounts do not already exist. The first script creates the database if needed.
3. Run 01_schema.sql once, followed by the remaining numbered files in the order above.
4. In 03_procedure_and_trigger.sql, keep START TRANSACTION, the update and ROLLBACK in the same connection. To see both results clearly, run the transaction and first SELECT, then run ROLLBACK and the second SELECT.
5. For patient-access tests, open a separate connection as OP001 at localhost, using the demonstration password defined in 04_security.sql.
6. Run the intentional integrity tests separately after the setup is complete.
The account details in 04_security.sql are demonstration credentials for this local teaching project.
Expected results
After 01_schema.sql, the table counts should be:
Table	Rows
Patient	14
Specialty	13
Clinician	13
Clinic	13
Appointment	15
Diagnosis	15
Medicine	14
Prescription	14
PrescriptionItem	15
FollowUpPlan	15


CALL GetPatientAppointments('OP001'); should return two appointments: City Road on 5 October 2026 and Bedford on 16 November 2026.

In the transaction demonstration, follow-up 8 changes from 8 to 10 weeks and its due date becomes 30 December 2026. ROLLBACK restores 8 weeks and 16 December 2026.

The OP001 patient account should be able to query crownfield_eye_hospital.PatientAppointments and see its two appointments. A direct SELECT from crownfield_eye_hospital.Patient should be refused. Run these access checks as the patient account, not as administrator.
Deliberate integrity-test errors
These statements in integrity_tests.sql are intended to fail:
- Adding patient ID OP001 again should cause duplicate-key error 1062.
- Adding an appointment for nonexistent patient OP999 should cause foreign-key error 1452.
- Setting a review interval to zero should cause CHECK-constraint error 3819 when the server enforces CHECK constraints.
These errors demonstrate the rules rejecting invalid data. They are not normal setup failures.
Assumptions and limits
- Each source row represents one appointment.
- Each appointment belongs to one patient, clinician and clinic.
- An appointment can have zero or several diagnoses and prescriptions.
- An appointment can have no more than one follow-up plan.
- Missing treatment instructions and original follow-up statuses remain NULL.
- Patient filtering assumes the database login name matches the patient ID, as with OP001.
- A prescription should contain at least one item. The foreign key alone does not enforce that minimum.
- The trigger recalculates the due date when FollowUpPlan is updated. Follow-up inserts and later changes to AppointmentDate need further handling.
- This is a teaching prototype. The recorded tests do not establish production readiness or cover concurrency and crash recovery.
Supporting evidence
The accompanying report explains the design, Crow's Foot diagram, screenshots, security tests and individual contribution.
