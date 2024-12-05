CREATE TABLE [dbo].[ExtraControl]
(
[ExtraCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Title] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ctl] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Title1] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Title2] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Title3] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Title4] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Title5] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description3] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description4] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description5] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [ExtraControl1] ON [dbo].[ExtraControl] ([ExtraCode]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table provides the definition for custom user fields, which are assigned as Extra Data and are assigned a unique extra data code.  Extra data codes may be added to the debtor account to hold additional information based on your agencys criteria.', 'SCHEMA', N'dbo', 'TABLE', N'ExtraControl', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description of line1 title', 'SCHEMA', N'dbo', 'TABLE', N'ExtraControl', 'COLUMN', N'Description1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description of line2 title', 'SCHEMA', N'dbo', 'TABLE', N'ExtraControl', 'COLUMN', N'Description2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description of line3 title', 'SCHEMA', N'dbo', 'TABLE', N'ExtraControl', 'COLUMN', N'Description3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description of line4 title', 'SCHEMA', N'dbo', 'TABLE', N'ExtraControl', 'COLUMN', N'Description4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description of line5 title', 'SCHEMA', N'dbo', 'TABLE', N'ExtraControl', 'COLUMN', N'Description5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A unique two character code to assign the key for the  ExtraData table', 'SCHEMA', N'dbo', 'TABLE', N'ExtraControl', 'COLUMN', N'ExtraCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Display title of the ExtraData', 'SCHEMA', N'dbo', 'TABLE', N'ExtraControl', 'COLUMN', N'Title'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Display Title for line1 of Extradata', 'SCHEMA', N'dbo', 'TABLE', N'ExtraControl', 'COLUMN', N'Title1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Display Title for line2 of Extradata', 'SCHEMA', N'dbo', 'TABLE', N'ExtraControl', 'COLUMN', N'Title2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Display Title for line3 of Extradata', 'SCHEMA', N'dbo', 'TABLE', N'ExtraControl', 'COLUMN', N'Title3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Display Title for line4 of Extradata', 'SCHEMA', N'dbo', 'TABLE', N'ExtraControl', 'COLUMN', N'Title4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Display Title for line5 of Extradata', 'SCHEMA', N'dbo', 'TABLE', N'ExtraControl', 'COLUMN', N'Title5'
GO
