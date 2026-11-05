CREATE DATABASE IF NOT EXISTS crownfield_eye_hospital;

USE crownfield_eye_hospital;

CREATE TABLE Patient
(
    PatientID VARCHAR(10) PRIMARY KEY,
    PatientName VARCHAR(100) NOT NULL,
    Postcode VARCHAR(10) NOT NULL
);

INSERT INTO Patient
(PatientID, PatientName, Postcode)
VALUES
('OP001', 'Amina Yusuf', 'NE1 4AB'),
('OP002', 'Daniel Reed', 'N16 7QP'),
('OP003', 'Sofia Bennett', 'E8 2LD'),
('OP004', 'Michael Okoro', 'SE6 3RT');

############################################

SELECT * FROM Patient;

CREATE TABLE Specialty
(
    SpecialtyID INT PRIMARY KEY,
    SpecialtyName VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO Specialty
(SpecialtyID, SpecialtyName)
VALUES
(1, 'Glaucoma'),
(2, 'Retina'),
(3, 'Cornea');

SELECT * FROM Specialty;

############################################

CREATE TABLE Clinician
(
    ClinicianID INT PRIMARY KEY,
    ClinicianName VARCHAR(100) NOT NULL,
    SpecialtyID INT,

    FOREIGN KEY (SpecialtyID)
        REFERENCES Specialty(SpecialtyID)
);

INSERT INTO Clinician
(ClinicianID, ClinicianName, SpecialtyID)
VALUES
(1, 'Dr Maya Shah', 1),
(2, 'Dr Leo Grant', 2),
(3, 'Dr Priya Nair', 3);

SELECT * FROM Clinician;

##############################################

CREATE TABLE Clinic
(
    ClinicID INT PRIMARY KEY,
    ClinicName VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO Clinic
(ClinicID, ClinicName)
VALUES
(1, 'City Road'),
(2, 'Bedford'),
(3, 'Croydon');

SELECT * FROM Clinic;

##############################################

CREATE TABLE Appointment
(
    AppointmentID INT PRIMARY KEY,
    PatientID VARCHAR(10) NOT NULL,
    ClinicianID INT NOT NULL,
    ClinicID INT NOT NULL,
    AppointmentDate DATE NOT NULL,
    AppointmentTime TIME NOT NULL,
    Notes VARCHAR(255),

    FOREIGN KEY (PatientID)
        REFERENCES Patient(PatientID),

    FOREIGN KEY (ClinicianID)
        REFERENCES Clinician(ClinicianID),

    FOREIGN KEY (ClinicID)
        REFERENCES Clinic(ClinicID)
);

INSERT INTO Appointment
(AppointmentID, PatientID, ClinicianID, ClinicID,
 AppointmentDate, AppointmentTime, Notes)
VALUES
(1, 'OP001', 1, 1,
 '2026-10-05', '09:00:00', 'Review IOP'),

(2, 'OP001', 1, 2,
 '2026-11-16', '10:15:00', 'Visual field test'),

(3, 'OP002', 2, 1,
 '2026-10-05', '09:30:00', 'OCT before review'),

(4, 'OP003', 1, 1,
 '2026-10-06', '11:00:00', 'Monitor'),

(5, 'OP004', 3, 3,
 '2026-10-07', '14:00:00', 'Corneal topography');

SELECT * FROM Appointment;

#####################################################

CREATE TABLE Diagnosis
(
    DiagnosisID INT PRIMARY KEY,
    AppointmentID INT NOT NULL,
    DiagnosisText VARCHAR(255) NOT NULL,

    FOREIGN KEY (AppointmentID)
        REFERENCES Appointment(AppointmentID)
);

INSERT INTO Diagnosis
(DiagnosisID, AppointmentID, DiagnosisText)
VALUES
(1, 1, 'Ocular hypertension'),
(2, 2, 'Ocular hypertension'),
(3, 3, 'Diabetic macular oedema'),
(4, 4, 'Glaucoma suspect'),
(5, 5, 'Keratoconus');

SELECT * FROM Diagnosis;

####################################################

CREATE TABLE Medicine
(
    MedicineID INT PRIMARY KEY,
    MedicineName VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO Medicine
(MedicineID, MedicineName)
VALUES
(1, 'Latanoprost'),
(2, 'Timolol'),
(3, 'Aflibercept'),
(4, 'Sodium chloride drops');

SELECT * FROM Medicine;

######################################################

CREATE TABLE Prescription
(
    PrescriptionID INT PRIMARY KEY,
    AppointmentID INT NOT NULL,

    FOREIGN KEY (AppointmentID)
        REFERENCES Appointment(AppointmentID)
);

INSERT INTO Prescription
(PrescriptionID, AppointmentID)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 5);

SELECT * FROM Prescription;

############################################################

CREATE TABLE PrescriptionItem
(
    PrescriptionItemID INT PRIMARY KEY,
    PrescriptionID INT NOT NULL,
    MedicineID INT NOT NULL,
    Dose VARCHAR(100),
    Route VARCHAR(100),
    Frequency VARCHAR(100),
    Duration VARCHAR(100),

    FOREIGN KEY (PrescriptionID)
        REFERENCES Prescription(PrescriptionID),

    FOREIGN KEY (MedicineID)
        REFERENCES Medicine(MedicineID)
);

INSERT INTO PrescriptionItem
(PrescriptionItemID, PrescriptionID, MedicineID,
 Dose, Route, Frequency, Duration)
VALUES
(1, 1, 1, NULL, NULL, NULL, NULL),
(2, 1, 2, NULL, NULL, NULL, NULL),
(3, 2, 1, NULL, NULL, NULL, NULL),
(4, 3, 3, NULL, NULL, NULL, NULL),
(5, 4, 4, NULL, NULL, NULL, NULL);

SELECT * FROM PrescriptionItem;

########################################################

CREATE TABLE FollowUpPlan
(
    FollowUpID INT PRIMARY KEY,
    AppointmentID INT NOT NULL UNIQUE,
    ReviewIntervalWeeks INT NOT NULL,
    DueDate DATE NOT NULL,
    Priority ENUM('Routine', 'High', 'Urgent') NOT NULL,
    Status ENUM('Planned', 'Booked', 'Completed', 'Cancelled')
        DEFAULT NULL,

    FOREIGN KEY (AppointmentID)
        REFERENCES Appointment(AppointmentID)
);

INSERT INTO FollowUpPlan
(FollowUpID, AppointmentID, ReviewIntervalWeeks,
 DueDate, Priority, Status)
VALUES
(1, 1, 6,
 DATE_ADD('2026-10-05', INTERVAL 6 WEEK), 'High', NULL),

(2, 2, 12,
 DATE_ADD('2026-11-16', INTERVAL 12 WEEK), 'Routine', NULL),

(3, 3, 4,
 DATE_ADD('2026-10-05', INTERVAL 4 WEEK), 'Urgent', NULL),

(4, 4, 26,
 DATE_ADD('2026-10-06', INTERVAL 26 WEEK), 'Routine', NULL),

(5, 5, 8,
 DATE_ADD('2026-10-07', INTERVAL 8 WEEK), 'Routine', NULL);

SELECT * FROM FollowUpPlan;

##################################################################

SHOW TABLES;

##################################################################

INSERT INTO Patient
(PatientID, PatientName, Postcode)
VALUES
('OP005', 'Isla Turner', 'N1 2AB'),
('OP006', 'Noah Clark', 'N16 8CD'),
('OP007', 'Amelia Scott', 'E8 3EF'),
('OP008', 'Oliver Hughes', 'SE6 4GH'),
('OP009', 'Grace Evans', 'EC1V 5AJ'),
('OP010', 'Ethan Baker', 'E2 6BL'),
('OP011', 'Mia Roberts', 'N4 7DP'),
('OP012', 'Leo Walker', 'SE15 8ER'),
('OP013', 'Sophie Hall', 'E9 9FS'),
('OP014', 'Jack Adams', 'N7 1GT');

SELECT * FROM Patient
ORDER BY PatientID;

#############################################################


INSERT INTO Clinician
(ClinicianID, ClinicianName, SpecialtyID)
VALUES
(4, 'Dr Alice Morgan', 1),
(5, 'Dr Chloe Reed', 2),
(6, 'Dr Daniel Brooks', 3),
(7, 'Dr Emma Collins', 1),
(8, 'Dr Farah Ahmed', 2),
(9, 'Dr George Ellis', 3),
(10, 'Dr Hannah Clarke', 1),
(11, 'Dr Imran Malik', 2),
(12, 'Dr Jessica Ward', 3),
(13, 'Dr Kai Lewis', 1);

SELECT * FROM Clinician
ORDER BY ClinicianID;

#############################################################

INSERT INTO Appointment
(AppointmentID, PatientID, ClinicianID, ClinicID,
 AppointmentDate, AppointmentTime, Notes)
VALUES
(6, 'OP005', 4, 1,
 '2026-10-19', '09:00:00', 'Fictional test appointment'),

(7, 'OP006', 5, 1,
 '2026-10-20', '09:30:00', 'Fictional test appointment'),

(8, 'OP007', 6, 3,
 '2026-10-21', '10:00:00', 'Fictional test appointment'),

(9, 'OP008', 7, 2,
 '2026-10-22', '10:30:00', 'Fictional test appointment'),

(10, 'OP009', 8, 1,
 '2026-10-23', '11:00:00', 'Fictional test appointment'),

(11, 'OP010', 9, 3,
 '2026-10-26', '11:30:00', 'Fictional test appointment'),

(12, 'OP011', 10, 2,
 '2026-10-27', '13:00:00', 'Fictional test appointment'),

(13, 'OP012', 11, 1,
 '2026-10-28', '13:30:00', 'Fictional test appointment'),

(14, 'OP013', 12, 3,
 '2026-10-29', '14:00:00', 'Fictional test appointment'),

(15, 'OP014', 13, 1,
 '2026-10-30', '14:30:00', 'Fictional test appointment');

SELECT * FROM Appointment
ORDER BY AppointmentID;

###########################################################

SELECT * FROM Appointment
ORDER BY AppointmentID;

##########################################################

INSERT INTO Diagnosis
(DiagnosisID, AppointmentID, DiagnosisText)
VALUES
(6, 6, 'Ocular hypertension'),
(7, 7, 'Diabetic macular oedema'),
(8, 8, 'Keratoconus'),
(9, 9, 'Glaucoma suspect'),
(10, 10, 'Diabetic macular oedema'),
(11, 11, 'Keratoconus'),
(12, 12, 'Ocular hypertension'),
(13, 13, 'Diabetic macular oedema'),
(14, 14, 'Keratoconus'),
(15, 15, 'Glaucoma suspect');

SELECT * FROM Diagnosis
ORDER BY DiagnosisID;

#############################################################

INSERT INTO Prescription
(PrescriptionID, AppointmentID)
VALUES
(5, 6),
(6, 7),
(7, 8),
(8, 9),
(9, 10),
(10, 11),
(11, 12),
(12, 13),
(13, 14),
(14, 15);

SELECT * FROM Prescription
ORDER BY PrescriptionID;

#############################################################

INSERT INTO Medicine
(MedicineID, MedicineName)
VALUES
(5, 'Bimatoprost'),
(6, 'Ranibizumab'),
(7, 'Carmellose sodium'),
(8, 'Travoprost'),
(9, 'Faricimab'),
(10, 'Hypromellose'),
(11, 'Dorzolamide'),
(12, 'Dexamethasone'),
(13, 'Sodium hyaluronate'),
(14, 'Brimonidine');

SELECT * FROM Medicine
ORDER BY MedicineID;

##############################################################

INSERT INTO PrescriptionItem
(PrescriptionItemID, PrescriptionID, MedicineID,
 Dose, Route, Frequency, Duration)
VALUES
(6, 5, 5,
 '1 drop', 'Ocular', 'Once daily', 'Ongoing'),

(7, 6, 6,
 '0.5 mg', 'Intravitreal', 'Once', 'Single administration'),

(8, 7, 7,
 '1 drop', 'Ocular', 'As required', 'Until review'),

(9, 8, 8,
 '1 drop', 'Ocular', 'Once daily', 'Ongoing'),

(10, 9, 9,
 '6 mg', 'Intravitreal', 'Once', 'Single administration'),

(11, 10, 10,
 '1 drop', 'Ocular', 'Up to three times daily as required',
 'Until review'),

(12, 11, 11,
 '1 drop', 'Ocular', 'Three times daily', 'Ongoing'),

(13, 12, 12,
 '700 micrograms (1 implant)', 'Intravitreal',
 'Once', 'Single administration'),

(14, 13, 13,
 '2 drops', 'Ocular', 'Four times daily', 'Until review'),

(15, 14, 14,
 '1 drop', 'Ocular', 'Twice daily', 'Ongoing');

SELECT * FROM PrescriptionItem
ORDER BY PrescriptionItemID;

###############################################################

INSERT INTO FollowUpPlan
(FollowUpID, AppointmentID, ReviewIntervalWeeks,
 DueDate, Priority, Status)
VALUES
(6, 6, 6,
 DATE_ADD('2026-10-19', INTERVAL 6 WEEK),
 'High', 'Booked'),

(7, 7, 4,
 DATE_ADD('2026-10-20', INTERVAL 4 WEEK),
 'Urgent', 'Booked'),

(8, 8, 8,
 DATE_ADD('2026-10-21', INTERVAL 8 WEEK),
 'Routine', 'Planned'),

(9, 9, 12,
 DATE_ADD('2026-10-22', INTERVAL 12 WEEK),
 'Routine', 'Planned'),

(10, 10, 4,
 DATE_ADD('2026-10-23', INTERVAL 4 WEEK),
 'Urgent', 'Booked'),

(11, 11, 8,
 DATE_ADD('2026-10-26', INTERVAL 8 WEEK),
 'Routine', 'Planned'),

(12, 12, 6,
 DATE_ADD('2026-10-27', INTERVAL 6 WEEK),
 'High', 'Booked'),

(13, 13, 4,
 DATE_ADD('2026-10-28', INTERVAL 4 WEEK),
 'Urgent', 'Booked'),

(14, 14, 8,
 DATE_ADD('2026-10-29', INTERVAL 8 WEEK),
 'Routine', 'Planned'),

(15, 15, 12,
 DATE_ADD('2026-10-30', INTERVAL 12 WEEK),
 'Routine', 'Planned');

SELECT * FROM FollowUpPlan
ORDER BY FollowUpID;

################################################################

INSERT INTO Clinic
(ClinicID, ClinicName)
VALUES
(4, 'Islington'),
(5, 'Hackney'),
(6, 'Camden'),
(7, 'Stratford'),
(8, 'Brixton'),
(9, 'Lewisham'),
(10, 'Walthamstow'),
(11, 'Greenwich'),
(12, 'Tottenham'),
(13, 'Bromley');

SELECT * FROM Clinic
ORDER BY ClinicID;

##################################################################

INSERT INTO Specialty
(SpecialtyID, SpecialtyName)
VALUES
(4, 'Cataract'),
(5, 'Paediatric ophthalmology'),
(6, 'Neuro-ophthalmology'),
(7, 'Oculoplastics'),
(8, 'Uveitis'),
(9, 'Strabismus'),
(10, 'Refractive surgery'),
(11, 'Ocular oncology'),
(12, 'Ophthalmic genetics'),
(13, 'Vitreoretinal surgery');

SELECT * FROM Specialty
ORDER BY SpecialtyID;

#########################################################

SELECT 'Patient' AS TableName, COUNT(*) AS RecordCount
FROM Patient

UNION ALL
SELECT 'Specialty', COUNT(*) FROM Specialty

UNION ALL
SELECT 'Clinician', COUNT(*) FROM Clinician

UNION ALL
SELECT 'Clinic', COUNT(*) FROM Clinic

UNION ALL
SELECT 'Appointment', COUNT(*) FROM Appointment

UNION ALL
SELECT 'Diagnosis', COUNT(*) FROM Diagnosis

UNION ALL
SELECT 'Medicine', COUNT(*) FROM Medicine

UNION ALL
SELECT 'Prescription', COUNT(*) FROM Prescription

UNION ALL
SELECT 'PrescriptionItem', COUNT(*) FROM PrescriptionItem

UNION ALL
SELECT 'FollowUpPlan', COUNT(*) FROM FollowUpPlan;

##################################################################################

SELECT FollowUpID, AppointmentID, Status
FROM FollowUpPlan
WHERE FollowUpID = 8;

#########################################################

UPDATE FollowUpPlan
SET Status = 'Booked'
WHERE FollowUpID = 8
  AND Status = 'Planned';

SELECT FollowUpID, AppointmentID, Status
FROM FollowUpPlan
WHERE FollowUpID = 8;

##########################################################

INSERT INTO Clinic
(ClinicID, ClinicName)
VALUES
(99, 'Temporary demonstration clinic');

SELECT ClinicID, ClinicName
FROM Clinic
WHERE ClinicID = 99;

#########################################################

DELETE FROM Clinic
WHERE ClinicID = 99;

SELECT
    COUNT(*) AS TotalClinics,
    COUNT(CASE WHEN ClinicID = 99 THEN 1 END)
        AS TemporaryClinicRemaining
FROM Clinic;

###########################################################

USE crownfield_eye_hospital;

##########################################################

ALTER TABLE FollowUpPlan
ADD CONSTRAINT chk_review_interval_positive
CHECK (ReviewIntervalWeeks > 0);