CREATE TABLE [dbo].[Custom_Lake_Cumber_Import_Patient_Data]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RecType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PatientMRN] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PatientFirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PatientLastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PatientMiddleName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PatiendDOB] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PatientSex] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PatientAddr1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PatientAddr2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PatientAddrCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PatientAddrState] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PatientAddrZip] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PatientPriPhone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalChargeforCase] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill5] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill6] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill7] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill8] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill9] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill10] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill11] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill12] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill13] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill14] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill15] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SEQ] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Lake_Cumber_Import_Patient_Data] ADD CONSTRAINT [PK_Custom_Lake_Cumber_Import_Patient_Data] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
