-- This file contains the SQL statements to create the tables and insert the data for the requests database.
-- We will use SQLite to create the database and the tables.

CREATE TABLE Nurse(
   Nurse_ID CHAR(14),
   First_Name VARCHAR(20) NOT NULL,
   Last_Name VARCHAR(30) NOT NULL,
   Address_Street_Number BYTE NOT NULL,
   Address_Street_Name VARCHAR(50) NOT NULL,
   Address_City VARCHAR(50) NOT NULL,
   Address_Country VARCHAR(30) NOT NULL,
   Address_Additional_Information TEXT,
   Qualification_level BYTE,
   CreatedOn DATETIME NOT NULL,
   CreatedBy INT,
   ChangedOn DATETIME NOT NULL,
   ChangedBy INT,
   PRIMARY KEY(Nurse_ID)
);
-- Constraint qualitification level between 1 and 4

CREATE TABLE Specialization(
   Specialization_Identification_Number CHAR(4),
   Name VARCHAR(50) NOT NULL,
   Description TEXT NOT NULL,
   PRIMARY KEY(Specialization_Identification_Number)
);


CREATE TABLE Medicine(
   Medecine_ID INTEGER AUTOINCREMENT,
   Name VARCHAR(50) NOT NULL,
   Description TEXT NOT NULL,
   Side_Effects TEXT NOT NULL,
   Unit_Price DOUBLE,
   PRIMARY KEY(Medecine_ID)
);

CREATE TABLE Secretary(
   Secretary_ID CHAR(14),
   First_Name VARCHAR(20) NOT NULL,
   Last_Name VARCHAR(30) NOT NULL,
   Role VARCHAR(50) NOT NULL,
   Address_Street_Number BYTE NOT NULL,
   Address_Street_Name VARCHAR(50) NOT NULL,
   Address_City VARCHAR(50) NOT NULL,
   Address_Country VARCHAR(30) NOT NULL,
   Address_Additional_Information TEXT,
   CreatedOn DATETIME NOT NULL,
   CreatedBy INT,
   ChangedOn DATETIME NOT NULL,
   ChangedBy INT,
   PRIMARY KEY(Secretary_ID)
);

CREATE TABLE Language_(
   Code CHAR(2),
   Name VARCHAR(50) NOT NULL,
   PRIMARY KEY(Code)
);

CREATE TABLE Doctor(
   Doctor_ID CHAR(14),
   First_Name VARCHAR(20) NOT NULL,
   Last_Name VARCHAR(30) NOT NULL,
   Address_Street_Number BYTE NOT NULL,
   Address_Street_Name VARCHAR(50) NOT NULL,
   Address_City VARCHAR(50) NOT NULL,
   Address_Country VARCHAR(30) NOT NULL,
   Address_Additional_Information TEXT,
   CreatedOn DATETIME NOT NULL,
   CreatedBy INT,
   ChangedOn DATETIME NOT NULL,
   ChangedBy INT,
   Specialization_Identification_Number CHAR(4) NOT NULL,
   PRIMARY KEY(Doctor_ID),
   FOREIGN KEY(Specialization_Identification_Number) REFERENCES Specialization(Specialization_Identification_Number)
);

CREATE TABLE Patient(
   Patient_ID CHAR(14),
   First_Name VARCHAR(20) NOT NULL,
   Last_Name VARCHAR(30) NOT NULL,
   Nationality VARCHAR(30),
   Problem_Description TEXT,
   Gender CHAR(1) NOT NULL,
   Address_Street_Number BYTE NOT NULL,
   Address_Street_Name VARCHAR(50) NOT NULL,
   Address_City VARCHAR(50) NOT NULL,
   Address_Country VARCHAR(30) NOT NULL,
   Address_Additional_Information TEXT,
   CreatedOn DATETIME NOT NULL,
   CreatedBy INT,
   ChangedOn DATETIME NOT NULL,
   ChangedBy INT,
   Main_Language_Code CHAR(2) NOT NULL,
   Doctor_ID CHAR(14) NOT NULL,
   PRIMARY KEY(Patient_ID),
   FOREIGN KEY(Main_Language_Code) REFERENCES Language_(Code),
   FOREIGN KEY(Doctor_ID) REFERENCES Doctor(Doctor_ID)
);
-- Gender constraint (M or F)


CREATE TABLE Prescription(
   Prescription_ID INTEGER AUTOINCREMENT,
   Date_of_issuance DATETIME,
   CreatedOn DATETIME NOT NULL,
   CreatedBy INT,
   ChangedOn DATETIME NOT NULL,
   ChangedBy INT,
   Patient_ID CHAR(14) NOT NULL,
   Doctor_ID CHAR(14) NOT NULL,
   PRIMARY KEY(Prescription_ID),
   FOREIGN KEY(Patient_ID) REFERENCES Patient(Patient_ID),
   FOREIGN KEY(Doctor_ID) REFERENCES Doctor(Doctor_ID)
);

CREATE TABLE Medical_file(
   File_ID INTEGER AUTOINCREMENT,
   Name VARCHAR(50) NOT NULL,
   Type VARCHAR(20) NOT NULL,
   Path VARCHAR(100) NOT NULL,
   CreatedOn DATETIME NOT NULL,
   CreatedBy INT,
   ChangedOn DATETIME NOT NULL,
   ChangedBy INT,
   Patient_ID CHAR(14) NOT NULL,
   PRIMARY KEY(File_ID),
   FOREIGN KEY(Patient_ID) REFERENCES Patient(Patient_ID)
);

CREATE TABLE Doctor_Appointment(
   Appointment_ID INTEGER AUTOINCREMENT,
   Start_Date_Time DATETIME NOT NULL,
   End_Date_Time DATETIME NOT NULL,
   Fee DOUBLE, -- Nullable because it must be filled after the appointment
   CreatedOn DATETIME NOT NULL,
   CreatedBy INT,
   ChangedOn DATETIME NOT NULL,
   ChangedBy INT,
   Secretary_ID CHAR(14) NOT NULL,
   Patient_ID CHAR(14) NOT NULL,
   Doctor_ID CHAR(14) NOT NULL,
   PRIMARY KEY(Appointment_ID),
   FOREIGN KEY(Secretary_ID) REFERENCES Secretary(Secretary_ID),
   FOREIGN KEY(Patient_ID) REFERENCES Patient(Patient_ID),
   FOREIGN KEY(Doctor_ID) REFERENCES Doctor(Doctor_ID)
);

CREATE TABLE Nurse_Appointment(
   Appointment_ID INTEGER AUTOINCREMENT,
   Start_Date_Time DATETIME NOT NULL,
   End_Date_Time DATETIME NOT NULL,
   Fee DOUBLE, -- Nullable because it must be filled after the appointment
   CreatedOn DATETIME NOT NULL,
   CreatedBy INT,
   ChangedOn DATETIME NOT NULL,
   ChangedBy INT,
   Nurse_ID CHAR(14) NOT NULL,
   Secretary_ID CHAR(14) NOT NULL,
   Patient_ID CHAR(14) NOT NULL,
   PRIMARY KEY(Appointment_ID),
   FOREIGN KEY(Nurse_ID) REFERENCES Nurse(Nurse_ID),
   FOREIGN KEY(Secretary_ID) REFERENCES Secretary(Secretary_ID),
   FOREIGN KEY(Patient_ID) REFERENCES Patient(Patient_ID)
);

CREATE TABLE Has(
   Doctor_ID CHAR(14),
   Specialization_Identification_Number CHAR(4),
   PRIMARY KEY(Doctor_ID, Specialization_Identification_Number),
   FOREIGN KEY(Doctor_ID) REFERENCES Doctor(Doctor_ID),
   FOREIGN KEY(Specialization_Identification_Number) REFERENCES Specialization(Specialization_Identification_Number)
);

CREATE TABLE Contains(
   Medecine_ID INT,
   Prescription_ID INT,
   Quantity INT,
   PRIMARY KEY(Medecine_ID, Prescription_ID),
   FOREIGN KEY(Medecine_ID) REFERENCES Medicine(Medecine_ID),
   FOREIGN KEY(Prescription_ID) REFERENCES Prescription(Prescription_ID)
);

CREATE TABLE Handles(
   Doctor_ID CHAR(14),
   Secretary_ID CHAR(14),
   PRIMARY KEY(Doctor_ID, Secretary_ID),
   FOREIGN KEY(Doctor_ID) REFERENCES Doctor(Doctor_ID),
   FOREIGN KEY(Secretary_ID) REFERENCES Secretary(Secretary_ID)
);

CREATE TABLE Heals(
   Patient_ID CHAR(14),
   Nurse_ID CHAR(14),
   PRIMARY KEY(Patient_ID, Nurse_ID),
   FOREIGN KEY(Patient_ID) REFERENCES Patient(Patient_ID),
   FOREIGN KEY(Nurse_ID) REFERENCES Nurse(Nurse_ID)
);

CREATE TABLE Speaks(
   Doctor_ID CHAR(14),
   Code_Language CHAR(2),
   PRIMARY KEY(Doctor_ID, Code),
   FOREIGN KEY(Doctor_ID) REFERENCES Doctor(Doctor_ID),
   FOREIGN KEY(Code_Language) REFERENCES Language_(Code)
);

-- Creating triggers
CREATE TRIGGER IF NOT EXISTS Trg_Insert_Doctor
   BEFORE INSERT 
   ON Doctor
   FOR EACH ROW
   BEGIN
      SET NEW.CreatedOn = CURRENT_TIMESTAMP;
      SET NEW.CreatedBy = USER();
      SET NEW.ChangedOn = CURRENT_TIMESTAMP;
      SET NEW.ChangedBy = USER();
   END;

CREATE TRIGGER IF NOT EXISTS Trg_Update_Doctor
    BEFORE UPDATE 
    ON Doctor
    FOR EACH ROW
    BEGIN
        SET NEW.ChangedOn = CURRENT_TIMESTAMP;
        SET NEW.ChangedBy = USER();
    END;

CREATE TRIGGER IF NOT EXISTS Trg_Insert_Secretary
    BEFORE INSERT 
    ON Secretary
    FOR EACH ROW
    BEGIN
        SET NEW.CreatedOn = CURRENT_TIMESTAMP;
        SET NEW.CreatedBy = USER();
        SET NEW.ChangedOn = CURRENT_TIMESTAMP;
        SET NEW.ChangedBy = USER();
    END;

CREATE TRIGGER IF NOT EXISTS Trg_Update_Secretary
    BEFORE UPDATE 
    ON Secretary
    FOR EACH ROW
    BEGIN
        SET NEW.ChangedOn = CURRENT_TIMESTAMP;
        SET NEW.ChangedBy = USER();
    END;

CREATE TRIGGER IF NOT EXISTS Trg_Insert_Nurse
    BEFORE INSERT 
    ON Nurse
    FOR EACH ROW
    BEGIN
        SET NEW.CreatedOn = CURRENT_TIMESTAMP;
        SET NEW.CreatedBy = USER();
        SET NEW.ChangedOn = CURRENT_TIMESTAMP;
        SET NEW.ChangedBy = USER();
    END;

CREATE TRIGGER IF NOT EXISTS Trg_Update_Nurse
    BEFORE UPDATE 
    ON Nurse
    FOR EACH ROW
    BEGIN
        SET NEW.ChangedOn = CURRENT_TIMESTAMP;
        SET NEW.ChangedBy = USER();
    END;

CREATE TRIGGER IF NOT EXISTS Trg_Insert_Patient
    BEFORE INSERT 
    ON Patient
    FOR EACH ROW
    BEGIN
        SET NEW.CreatedOn = CURRENT_TIMESTAMP;
        SET NEW.CreatedBy = USER();
        SET NEW.ChangedOn = CURRENT_TIMESTAMP;
        SET NEW.ChangedBy = USER();
    END;

CREATE TRIGGER IF NOT EXISTS Trg_Update_Patient
    BEFORE UPDATE 
    ON Patient
    FOR EACH ROW
    BEGIN
        SET NEW.ChangedOn = CURRENT_TIMESTAMP;
        SET NEW.ChangedBy = USER();
    END;

CREATE TRIGGER IF NOT EXISTS Trg_Insert_Medicine
    BEFORE INSERT 
    ON Medicine
    FOR EACH ROW
    BEGIN
        SET NEW.CreatedOn = CURRENT_TIMESTAMP;
        SET NEW.CreatedBy = USER();
        SET NEW.ChangedOn = CURRENT_TIMESTAMP;
        SET NEW.ChangedBy = USER();
    END;

CREATE TRIGGER IF NOT EXISTS Trg_Update_Medicine
    BEFORE UPDATE 
    ON Medicine
    FOR EACH ROW
    BEGIN
        SET NEW.ChangedOn = CURRENT_TIMESTAMP;
        SET NEW.ChangedBy = USER();
    END;

CREATE TRIGGER IF NOT EXISTS Trg_Insert_Prescription
    BEFORE INSERT 
    ON Prescription
    FOR EACH ROW
    BEGIN
        SET NEW.CreatedOn = CURRENT_TIMESTAMP;
        SET NEW.CreatedBy = USER();
        SET NEW.ChangedOn = CURRENT_TIMESTAMP;
        SET NEW.ChangedBy = USER();
    END;

CREATE TRIGGER IF NOT EXISTS Trg_Update_Prescription
    BEFORE UPDATE 
    ON Prescription
    FOR EACH ROW
    BEGIN
        SET NEW.ChangedOn = CURRENT_TIMESTAMP;
        SET NEW.ChangedBy = USER();
    END;

CREATE TRIGGER IF NOT EXISTS Trg_Insert_Appointment
    BEFORE INSERT 
    ON Appointment
    FOR EACH ROW
    BEGIN
        SET NEW.CreatedOn = CURRENT_TIMESTAMP;
        SET NEW.CreatedBy = USER();
        SET NEW.ChangedOn = CURRENT_TIMESTAMP;
        SET NEW.ChangedBy = USER();
    END;

CREATE TRIGGER IF NOT EXISTS Trg_Update_Appointment
    BEFORE UPDATE 
    ON Appointment
    FOR EACH ROW
    BEGIN
        SET NEW.ChangedOn = CURRENT_TIMESTAMP;
        SET NEW.ChangedBy = USER();
    END;

CREATE TRIGGER IF NOT EXISTS Trg_Doctor_Doctor_Appointment_Overlap -- Prevents a doctor from having two appointments at the same time
    BEFORE INSERT 
    ON Doctor_Appointment
    FOR EACH ROW
    WHEN (( SELECT COUNT (*) 
        FROM Doctor_Appointment
        WHERE Doctor_ID = NEW.Doctor_ID 
        AND NEW.Start_Date_Time <= Doctor_Appointment.End_Date_Time 
        AND NEW.End_Date_Time > Doctor_Appointment.Start_Date_Time)) > 0 
    BEGIN
        SELECT RAISE(ABORT, 'Doctor already has an appointment at this time');
    END;

CREATE TRIGGER IF NOT EXISTS Trg_Patient_Doctor_Appointment_Overlap -- Prevents a patient from having two doctor appointments at the same time
    BEFORE INSERT 
    ON Doctor_Appointment
    FOR EACH ROW
    WHEN  
        (SELECT COUNT (*) 
        FROM Doctor_Appointment
        WHERE Patient_ID = NEW.Patient_ID 
        AND((NEW.Start_Date_Time <= Doctor_Appointment.End_Date_Time 
        AND NEW.End_Date_Time > Doctor_Appointment.Start_Date_Time))) > 0
    BEGIN
        SELECT RAISE(ABORT, 'Patient already has an appointment at this time');
    END;

CREATE TRIGGER IF NOT EXISTS Trg_Nurse_Nurse_Appointment_Overlap -- Prevents a nurse from having two appointments at the same time
    BEFORE INSERT 
    ON Nurse_Appointment
    FOR EACH ROW
    WHEN 
        (SELECT COUNT(*) 
        FROM Nurse_Appointment
        WHERE Nurse_ID = NEW.Nurse_ID 
        AND((NEW.Start_Date_Time <= Nurse_Appointment.End_Date_Time 
        AND NEW.End_Date_Time > Nurse_Appointment.Start_Date_Time))) > 0
    BEGIN
        SELECT RAISE(ABORT, 'Nurse already has an appointment at this time');
    END;

CREATE TRIGGER IF NOT EXISTS Trg_Patient_Nurse_Appointment_Overlap -- Prevents a patient from having two nurse appointments at the same time
    BEFORE INSERT 
    ON Nurse_Appointment
    FOR EACH ROW
    WHEN EXISTS 
        (SELECT COUNT(*) 
        FROM Nurse_Appointment
        WHERE Patient_ID = NEW.Patient_ID 
        AND((NEW.Start_Date_Time <= Nurse_Appointment.End_Date_Time 
        AND NEW.End_Date_Time > Nurse_Appointment.Start_Date_Time))) > 0
    BEGIN
        SELECT RAISE(ABORT, 'Patient already has an appointment at this time');
    END;




-- Inserting DATA
INSERT INTO Nurse (Nurse_ID, First_Name, Last_Name, Address_Street_Number, Address_Street_Name, Address_City, Address_Country, Address_Additional_Information, Qualification_level, CreatedOn, ChangedOn) VALUES ("NRS12345678900", "Maelie", "Cheng Peng", "123", "Main Street", "Bordeaux", "France", "Additional Information", 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO Nurse (Nurse_ID, First_Name, Last_Name, Address_Street_Number, Address_Street_Name, Address_City, Address_Country, Address_Additional_Information, Qualification_level) VALUES ("NRS12345678901", "Elyne", "Qiu", "11", "Rue de la Paix", "Paris", "France", "Additional Information", 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO Nurse (Nurse_ID, First_Name, Last_Name, Address_Street_Number, Address_Street_Name, Address_City, Address_Country, Address_Additional_Information, Qualification_level) VALUES ("NRS12345678902", "Léa", "Liu", "123", "Main Street", "Bordeaux", "France", "Additional Information", 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO Specialization (Specialization_ID, Name, Description) VALUES ("SPC12345678900", "General Medicine", "General Medicine Description");
INSERT INTO Specialization (Specialization_ID, Name, Description) VALUES ("SPC12345678901", "Cardiology", "Cardiology Description");
INSERT INTO Specialization (Specialization_ID, Name, Description) VALUES ("SPC12345678902", "Dermatology", "Dermatology Description");

INSERT INTO Medicine (Medicine_ID, Name, Description, Side_Effects, Unit_Price) VALUES ("MED12345678900", "Paracetamol", "Paracetamol Description", "Nausea", 10);