CREATE TABLE [dbo].[Braxtel_ContactQ_AuditTable]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[DialAttemptTime] [datetime] NOT NULL,
[DialSSN] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DialdPhoneNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DialResult] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DialCLID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CQTimeStamp] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Braxtel_ContactQ_AuditTable] ADD CONSTRAINT [PK_Braxtel_ContactQ_AuditTable] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dial Time Stamp', 'SCHEMA', N'dbo', 'TABLE', N'Braxtel_ContactQ_AuditTable', 'COLUMN', N'DialAttemptTime'
GO
