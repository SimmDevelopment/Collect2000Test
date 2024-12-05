CREATE TABLE [dbo].[WebAccess_AccountMessage]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Subject] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Body] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WebAccess_AccountMessage] ADD CONSTRAINT [PK__WebAccess_AccountMessage] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ__WebAccess_AccountMessage_Subject] ON [dbo].[WebAccess_AccountMessage] ([Subject]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'WebAccess_AccountMessage', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'WebAccess_AccountMessage', 'COLUMN', N'Body'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'WebAccess_AccountMessage', 'COLUMN', N'Subject'
GO
