CREATE TABLE [dbo].[StatusHistory]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[DateChanged] [smalldatetime] NOT NULL,
[UserName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OldStatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NewStatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[StatusHistory] ADD CONSTRAINT [PK_StatusHistory] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_StatusHistory_AccountID] ON [dbo].[StatusHistory] ([AccountID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
