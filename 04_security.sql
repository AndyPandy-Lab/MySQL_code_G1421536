USE crownfield_eye_hospital;

CREATE ROLE IF NOT EXISTS
    'hospital_admin',
    'hospital_doctor',
    'hospital_patient',
    'hospital_receptionist';

    ################################

    GRANT ALL PRIVILEGES
ON crownfield_eye_hospital.*
TO 'hospital_admin';


SHOW GRANTS FOR 'hospital_admin';

##########################################

GRANT SELECT ON crownfield_eye_hospital.Patient
TO 'hospital_doctor';

GRANT SELECT ON crownfield_eye_hospital.Appointment
TO 'hospital_doctor';

GRANT SELECT ON crownfield_eye_hospital.Medicine
TO 'hospital_doctor';

GRANT SELECT ON crownfield_eye_hospital.Clinic
TO 'hospital_doctor';

GRANT SELECT ON crownfield_eye_hospital.Clinician
TO 'hospital_doctor';

GRANT SELECT ON crownfield_eye_hospital.Specialty
TO 'hospital_doctor';

######################################################

GRANT SELECT, INSERT, UPDATE
ON crownfield_eye_hospital.Prescription
TO 'hospital_doctor';

GRANT SELECT, INSERT, UPDATE
ON crownfield_eye_hospital.PrescriptionItem
TO 'hospital_doctor';

GRANT SELECT, INSERT, UPDATE
ON crownfield_eye_hospital.FollowUpPlan
TO 'hospital_doctor';

GRANT SELECT, INSERT, UPDATE
ON crownfield_eye_hospital.Diagnosis
TO 'hospital_doctor';

SHOW GRANTS FOR 'hospital_doctor';

###########################################################

GRANT SELECT, INSERT, UPDATE
ON crownfield_eye_hospital.Patient
TO 'hospital_receptionist';

GRANT SELECT, INSERT, UPDATE
ON crownfield_eye_hospital.Appointment
TO 'hospital_receptionist';

GRANT SELECT
ON crownfield_eye_hospital.Clinic
TO 'hospital_receptionist';

GRANT SELECT
ON crownfield_eye_hospital.Clinician
TO 'hospital_receptionist';

SHOW GRANTS FOR 'hospital_receptionist';

##########################################################

CREATE SQL SECURITY DEFINER VIEW PatientAppointments AS
SELECT
    Appointment.AppointmentID,
    Appointment.PatientID,
    Appointment.AppointmentDate,
    Appointment.AppointmentTime,
    Clinic.ClinicName
FROM Appointment
INNER JOIN Clinic
    ON Appointment.ClinicID = Clinic.ClinicID
WHERE Appointment.PatientID =
      SUBSTRING_INDEX(USER(), '@', 1);

GRANT SELECT
ON crownfield_eye_hospital.PatientAppointments
TO 'hospital_patient';

SHOW GRANTS FOR 'hospital_patient';

###########################################################

CREATE USER 'OP001'@'localhost'
IDENTIFIED BY 'DemoPatient_2026!';

GRANT 'hospital_patient'
TO 'OP001'@'localhost';

SET DEFAULT ROLE 'hospital_patient'
TO 'OP001'@'localhost';

########################################################

CREATE USER IF NOT EXISTS 'doctor_demo'@'localhost'
IDENTIFIED BY 'DemoDoctor_2026!';

GRANT 'hospital_doctor'
TO 'doctor_demo'@'localhost';

SET DEFAULT ROLE 'hospital_doctor'
TO 'doctor_demo'@'localhost';

####################################################

CREATE USER IF NOT EXISTS 'receptionist_demo'@'localhost'
IDENTIFIED BY 'DemoReception_2026!';

GRANT 'hospital_receptionist'
TO 'receptionist_demo'@'localhost';

SET DEFAULT ROLE 'hospital_receptionist'
TO 'receptionist_demo'@'localhost';

################################################################
CREATE USER IF NOT EXISTS 'admin_demo'@'localhost'
IDENTIFIED BY 'DemoAdmin_2026!';

GRANT 'hospital_admin'
TO 'admin_demo'@'localhost';

SET DEFAULT ROLE 'hospital_admin'
TO 'admin_demo'@'localhost';
################################################################
SELECT
    USER AS AccountName,
    HOST AS AccountHost,
    DEFAULT_ROLE_USER AS DefaultRole
FROM mysql.default_roles
WHERE USER IN
    ('OP001', 'doctor_demo',
     'receptionist_demo', 'admin_demo')
ORDER BY USER;

################################################################

SELECT
    User,
    plugin AS AuthenticationMethod,
    authentication_string AS StoredPasswordHash
FROM mysql.user
WHERE User = 'OP001'
  AND Host = 'localhost';