CREATE TABLE [dbo].[PatientInfo]
(
[AccountID] [int] NOT NULL,
[Name] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZipCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSN] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sex] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Age] [tinyint] NULL,
[DOB] [datetime] NULL,
[MaritalStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmployerName] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WorkPhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PatientRecNumber] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GuarantorRecNumber] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdmissionDate] [datetime] NULL,
[ServiceDate] [datetime] NULL,
[DischargeDate] [datetime] NULL,
[FacilityName] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FacilityStreet1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FacilityStreet2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FacilityCity] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FacilityState] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FacilityZipCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FacilityCountry] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FacilityPhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FacilityFax] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DoctorName] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DoctorPhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DoctorFax] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KinName] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KinStreet1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KinStreet2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KinCity] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KinState] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KinZipCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KinCountry] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KinPhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HardCopy] [image] NULL,
[PatientRelationToGuarantor] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PatientRelationToGuarantorAdditionalInfo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccidentDate] [datetime] NULL,
[AccidentType] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FinancialClass] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ImportProcedures] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LocationCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Modifier] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PatientType] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlaceOfServiceCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProcedureCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServicingProviderCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DiagnosisCode1] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DiagnosisCode2] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DiagnosisCode3] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DoctorCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttendingDoctorName] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttendingDoctorPhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttendingDoctorFax] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttendingDoctorCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PatientInfo] ADD CONSTRAINT [pk_PatientInfo] PRIMARY KEY CLUSTERED ([AccountID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PatientInfo] WITH NOCHECK ADD CONSTRAINT [fk_PatientInfo_master] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[master] ([number]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number from Master', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'AccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date of Hospital Admission', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'AdmissionDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Age', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'Age'
GO
EXEC sp_addextendedproperty N'MS_Description', N'City', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'country', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'Country'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date Released fro Hopsital', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'DischargeDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date of Birth', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'DOB'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Doctror Fax', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'DoctorFax'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Doctor Name', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'DoctorName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Doctor Phone', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'DoctorPhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Employer Name', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'EmployerName'
GO
EXEC sp_addextendedproperty N'MS_Description', N' Hospital or Clinic City', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'FacilityCity'
GO
EXEC sp_addextendedproperty N'MS_Description', N' Hospital or Clinic Country', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'FacilityCountry'
GO
EXEC sp_addextendedproperty N'MS_Description', N' Hospital or Clinic Fax', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'FacilityFax'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Hospital or Clinic Name', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'FacilityName'
GO
EXEC sp_addextendedproperty N'MS_Description', N' Hospital or Clinic Phone', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'FacilityPhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N' Hospital or Clinic State', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'FacilityState'
GO
EXEC sp_addextendedproperty N'MS_Description', N' Hospital or Clinic Street1', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'FacilityStreet1'
GO
EXEC sp_addextendedproperty N'MS_Description', N' Hospital or Clinic Street2', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'FacilityStreet2'
GO
EXEC sp_addextendedproperty N'MS_Description', N' Hospital or Clinic ZipCode', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'FacilityZipCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account Number', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'GuarantorRecNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Relative City', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'KinCity'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Relative country', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'KinCountry'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Relastionship Name', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'KinName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Relative Phone', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'KinPhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Relattive State', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'KinState'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Relative Street1', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'KinStreet1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Relative Street2', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'KinStreet2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Relative Zipcode', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'KinZipCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Marital Status', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'MaritalStatus'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Patient Record Number', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'PatientRecNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Phone', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'Phone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date of Service', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'ServiceDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sex', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'Sex'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Social Security Number', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'SSN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'State', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'State'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Street1', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'Street1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Street2', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'Street2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Work Phone number', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'WorkPhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Zipcode', 'SCHEMA', N'dbo', 'TABLE', N'PatientInfo', 'COLUMN', N'ZipCode'
GO
