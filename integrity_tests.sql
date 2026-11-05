USE crownfield_eye_hospital;

INSERT INTO Patient
(PatientID, PatientName, Postcode)
VALUES
('OP001', 'Duplicate ID test', 'N1 2AB');

###########################################

INSERT INTO Appointment
(AppointmentID, PatientID, ClinicianID, ClinicID,
 AppointmentDate, AppointmentTime, Notes)
VALUES
(99, 'OP999', 1, 1,
 '2026-11-02', '09:00:00', 'Foreign key test');

 #####################################################

 USE crownfield_eye_hospital;


UPDATE FollowUpPlan
SET ReviewIntervalWeeks = 0
WHERE FollowUpID = 8;