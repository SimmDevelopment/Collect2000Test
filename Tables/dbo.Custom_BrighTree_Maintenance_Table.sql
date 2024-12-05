CREATE TABLE [dbo].[Custom_BrighTree_Maintenance_Table]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CommunicationIdent] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RSPLastName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RSPFirstName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DebtorIdent] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PatientAccountNo] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreditorName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CommunicationType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CommunicationDate] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PaymentDate] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Amount] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrentBalance] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CommunicationText] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreditorContactFirstName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreditorContactLastName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreditorContactEmail] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreditorContactPhone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreditorContactExtension] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_BrighTree_Maintenance_Table] ADD CONSTRAINT [PK_Custom_BrighTree_Maintenance_Table] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
