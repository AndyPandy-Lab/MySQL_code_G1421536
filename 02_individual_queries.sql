USE crownfield_eye_hospital;

SELECT
    Clinic.ClinicID,
    Clinic.ClinicName,
    COUNT(Appointment.AppointmentID) AS AppointmentCount
FROM Clinic
INNER JOIN Appointment
    ON Clinic.ClinicID = Appointment.ClinicID
GROUP BY Clinic.ClinicID, Clinic.ClinicName
HAVING COUNT(Appointment.AppointmentID) >= 2
ORDER BY AppointmentCount DESC, Clinic.ClinicID;

##############################################################

SELECT
    Appointment.AppointmentID,
    Patient.PatientName,
    Clinic.ClinicName,
    Appointment.AppointmentDate,
    Appointment.AppointmentTime
FROM Appointment
INNER JOIN Patient
    ON Appointment.PatientID = Patient.PatientID
INNER JOIN Clinic
    ON Appointment.ClinicID = Clinic.ClinicID
ORDER BY
    Appointment.AppointmentDate,
    Appointment.AppointmentTime,
    Appointment.AppointmentID;

############################################################

    SELECT
    Appointment.AppointmentID,
    Patient.PatientName,
    Appointment.AppointmentDate,
    Prescription.PrescriptionID
FROM Appointment
INNER JOIN Patient
    ON Appointment.PatientID = Patient.PatientID
LEFT JOIN Prescription
    ON Appointment.AppointmentID = Prescription.AppointmentID
WHERE Prescription.PrescriptionID IS NULL
ORDER BY Appointment.AppointmentID;

#############################################################

SELECT PatientID, PatientName
FROM Patient
WHERE PatientID IN
(
    SELECT PatientID
    FROM Appointment
    GROUP BY PatientID
    HAVING COUNT(*) > 1
)
ORDER BY PatientID;
