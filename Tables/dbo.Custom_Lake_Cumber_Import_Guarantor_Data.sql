CREATE TABLE [dbo].[Custom_Lake_Cumber_Import_Guarantor_Data]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RecType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PatientMRN] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CaseIDNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filler2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GuarantorOrderInd] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GuarantorFirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GuarantorLastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GuarantorMiddle] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GuarantorSuffix] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GuarantorDOB] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GuarantorSex] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GuarantorSSN] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GuarantorAddr1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GuarantorAddr2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GuarantorCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GuarantorState] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GuarantorZip] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GuarantorExtendZip] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GuarantorPriPhoneNum] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GuarantorEmpName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GuarantorEmpAddr1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GuarantorEmpAddr2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GuarantorEmpCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GuarantorEmpState] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GuarantorEmpZip] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GuarantorEmpZipExt] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SEQ] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Lake_Cumber_Import_Guarantor_Data] ADD CONSTRAINT [PK_Custom_Lake_Cumber_Import_Guarantor_Data] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
