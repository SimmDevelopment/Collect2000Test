CREATE TABLE [dbo].[ComplianceLog]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Who] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TransDate] [datetime] NOT NULL,
[AcceptReject] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ComplianceLog] ADD CONSTRAINT [PK_ComplianceLog] PRIMARY KEY CLUSTERED ([Id]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
