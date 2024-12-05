CREATE TABLE [dbo].[Custom_Lake_Cumber_Import_INS_Data]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RecType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PatientMRN] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CaseIDNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filler1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsOrderIndicator] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsCarrierName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsClaimOfficeAddr1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsClaimOfficeAddr2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsClaimOfficeCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsClaimOfficeState] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsClaimOfficeZip] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsClaimOfficePhoneNum] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsGroupName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsGroupNum] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SuscriberID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubscriberRelationship] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubscriberFirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubscriberLastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubscriberMiddle] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubscriberSuffix] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubscriberDOB] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubscriberSex] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubscriberSSN] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill5] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill6] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill7] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SEQ] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Lake_Cumber_Import_INS_Data] ADD CONSTRAINT [PK_Custom_Lake_Cumber_Import_INS_Data] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
