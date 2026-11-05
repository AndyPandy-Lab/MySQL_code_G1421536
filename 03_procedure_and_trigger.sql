USE crownfield_eye_hospital;


CREATE PROCEDURE GetPatientAppointments
(IN p_PatientID VARCHAR(10))

SELECT
    Appointment.AppointmentID,
    Appointment.PatientID,
    Appointment.AppointmentDate,
    Appointment.AppointmentTime,
    Clinic.ClinicName
FROM Appointment
INNER JOIN Clinic
    ON Appointment.ClinicID = Clinic.ClinicID
WHERE Appointment.PatientID = p_PatientID
ORDER BY Appointment.AppointmentDate,
         Appointment.AppointmentTime;


CALL GetPatientAppointments('OP001');

#################################################

CREATE TRIGGER UpdateFollowUpDueDate
BEFORE UPDATE ON FollowUpPlan
FOR EACH ROW
SET NEW.DueDate = DATE_ADD(
    (
        SELECT AppointmentDate
        FROM Appointment
        WHERE AppointmentID = NEW.AppointmentID
    ),
    INTERVAL NEW.ReviewIntervalWeeks WEEK
);

##################################################

START TRANSACTION;

UPDATE FollowUpPlan
SET ReviewIntervalWeeks = 10
WHERE FollowUpID = 8;

SELECT
    FollowUpID,
    ReviewIntervalWeeks,
    DueDate
FROM FollowUpPlan
WHERE FollowUpID = 8;

##################################################

ROLLBACK;

SELECT FollowUpID, ReviewIntervalWeeks, DueDate
FROM FollowUpPlan
WHERE FollowUpID = 8;