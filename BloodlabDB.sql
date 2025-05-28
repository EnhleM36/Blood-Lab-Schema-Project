-- Create database for a Pathology Blood Lab.
CREATE DATABASE BloodlabDB;
USE BloodlabDB;

-- Table for referring doctors.
CREATE TABLE Doctors (
    DoctorID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Specialty VARCHAR(100),
    PhoneNumber VARCHAR(20) NOT NULL,
    Email VARCHAR(100),
    FacilityName VARCHAR(100)
);

-- Table for lab staff with roles.
CREATE TABLE LabStaff (
    StaffID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Role VARCHAR(50) NOT NULL,
    Email VARCHAR(100),
    Phone VARCHAR(20)
);

-- Table for patients.
CREATE TABLE Patients (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender ENUM('Male', 'Female', 'Other'),
    Address VARCHAR(255),
    ContactInfo TEXT NOT NULL
);

-- Table for sample collection locations.
CREATE TABLE SampleLocations (
    LocationID INT AUTO_INCREMENT PRIMARY KEY,
    FacilityName VARCHAR(100),
    ContactInfo TEXT NOT NULL
);

-- Table for collected samples.
CREATE TABLE Samples (
    SampleID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    StaffID INT,
    DoctorID INT,
    LocationID INT,
    Barcode VARCHAR(100) UNIQUE,
    SampleType VARCHAR(50),
    CollectedDate DATETIME,
    ReceivedDate DATETIME,
    ProcessedDate DATETIME,
    StorageLocation VARCHAR(100),
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (StaffID) REFERENCES LabStaff(StaffID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
    FOREIGN KEY (LocationID) REFERENCES SampleLocations(LocationID)
);

-- Table for test categories
CREATE TABLE TestCategories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL UNIQUE,
    Description TEXT
);

-- Table for test types
CREATE TABLE TestTypes (
    TestTypeID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryID INT,
    Name VARCHAR(100) NOT NULL UNIQUE,
    Description TEXT,
    Methodology VARCHAR(100),
    SampleType VARCHAR(50),
    TurnaroundTime VARCHAR(50),
    Price DECIMAL(10, 2),
    LOINCCode VARCHAR(20),
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (CategoryID) REFERENCES TestCategories(CategoryID)
);

-- Table for doctors test orders.
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT NOT NULL,
    PhysicianID INT NOT NULL,
    OrderedDate DATETIME NOT NULL,
    Priority VARCHAR(20) DEFAULT 'Routine',
    Status VARCHAR(20) NOT NULL,
    ClinicalNotes TEXT,
    InsuranceInfo TEXT,
    CreatedBy INT,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (PhysicianID) REFERENCES Doctors(DoctorID),
    FOREIGN KEY (CreatedBy) REFERENCES LabStaff(StaffID)
);

-- Table for tests ordered.
CREATE TABLE OrderTests (
    OrderTestID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    TestTypeID INT NOT NULL,
    SampleID INT NOT NULL,
    OrderedBy INT NOT NULL,
    Status ENUM('Received', 'In Progress', 'Completed', 'Cancelled') NOT NULL DEFAULT 'In Progress',
    Priority VARCHAR(20),
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (TestTypeID) REFERENCES TestTypes(TestTypeID),
    FOREIGN KEY (SampleID) REFERENCES Samples(SampleID),
    FOREIGN KEY (OrderedBy) REFERENCES Doctors(DoctorID)
);

-- Table for test results.
CREATE TABLE TestResults (
    ResultID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    PerformedBy INT NOT NULL,
    VerifiedBy INT,
    NumericResult DECIMAL(10, 2),
    TextResult TEXT,
    Units VARCHAR(20),
    ResultFlag ENUM('H', 'L', 'A', 'N'),
    ReferenceRangeID INT,
    AnalyzedDate DATETIME NOT NULL,
    VerifiedDate DATETIME,
    InstrumentID VARCHAR(50),
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (PerformedBy) REFERENCES LabStaff(StaffID),
    FOREIGN KEY (VerifiedBy) REFERENCES LabStaff(StaffID)
);

-- Table for critical notifications.
CREATE TABLE CriticalNotifications (
    NotificationID INT AUTO_INCREMENT PRIMARY KEY,
    ResultID INT NOT NULL,
    ReportedBy INT NOT NULL,
    ReportedTo INT NOT NULL,
    NotificationDate DATETIME NOT NULL,
    NotificationMethod ENUM('Phone', 'Email', 'In Person', 'SMS') DEFAULT 'Phone',
    Acknowledgement BOOLEAN DEFAULT FALSE,
    Notes TEXT,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (ResultID) REFERENCES TestResults(ResultID),
    FOREIGN KEY (ReportedBy) REFERENCES LabStaff(StaffID),
    FOREIGN KEY (ReportedTo) REFERENCES Doctors(DoctorID)
);

-- Table for instruments.
CREATE TABLE Instruments (
    InstrumentID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Model VARCHAR(100) NOT NULL,
    Manufacturer VARCHAR(100),
    SerialNumber VARCHAR(50) UNIQUE NOT NULL,
    InstallationDate DATE NOT NULL,
    LastMaintenanceDate DATE NOT NULL,
    NextMaintenanceDate DATE NOT NULL,
    Status VARCHAR(20) NOT NULL,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table for quality control.
CREATE TABLE QualityControl (
    QCID INT AUTO_INCREMENT PRIMARY KEY,
    TestID INT NOT NULL,
    LotNumber VARCHAR(50) NOT NULL,
    PerformedBy INT NOT NULL,
    PerformedDate DATETIME NOT NULL,
    QCLevel VARCHAR(20) NOT NULL,
    ExpectedValue DECIMAL(10, 2) NOT NULL,
    ObtainedValue DECIMAL(10, 2) NOT NULL,
    StandardDeviation DECIMAL(10, 2) NOT NULL,
    Status ENUM('Pass', 'Fail', 'Review') NOT NULL,
    InstrumentID INT NOT NULL,
    Comments TEXT,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (TestID) REFERENCES TestTypes(TestTypeID),
    FOREIGN KEY (PerformedBy) REFERENCES LabStaff(StaffID),
    FOREIGN KEY (InstrumentID) REFERENCES Instruments(InstrumentID)
);


-- Table for report templates.
CREATE TABLE ReportTemplates (
    TemplateID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL UNIQUE,
    Description TEXT,
    TemplateData TEXT,
    Active BOOLEAN DEFAULT TRUE,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table for report generation.
CREATE TABLE Reports (
    ReportID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    PatientID INT NOT NULL,
    TemplateID INT NOT NULL,
    GeneratedBy INT NOT NULL,
    GeneratedDate DATETIME NOT NULL,
    DeliveryStatus ENUM('Pending', 'Completed', 'Cancelled') DEFAULT 'Pending',
    DeliveryDate DATETIME,
    Recipient VARCHAR(100),
    DocumentPath VARCHAR(255),
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (TemplateID) REFERENCES ReportTemplates(TemplateID),
    FOREIGN KEY (GeneratedBy) REFERENCES LabStaff(StaffID)
);

-- Table for audit logs ( to record and track user activity).
CREATE TABLE AuditLogs (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    Action VARCHAR(100),
    TargetTable VARCHAR(50),
    RecordID INT,
    Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES LabStaff(StaffID)
);

-- Table for billing
CREATE TABLE Billing (
    BillingID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    InsuranceProvider VARCHAR(100),
    InsuranceID VARCHAR(50),
    BillingDate DATE NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    PaymentStatus ENUM('Pending', 'Paid', 'Rejected', 'Partially Paid') NOT NULL DEFAULT 'Pending',
    PaymentDate DATE,
    InvoiceNumber VARCHAR(50) UNIQUE,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
