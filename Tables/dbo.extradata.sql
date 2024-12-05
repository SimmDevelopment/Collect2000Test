CREATE TABLE [dbo].[extradata]
(
[number] [int] NOT NULL,
[ctl] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[extracode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line1] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line2] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line3] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line4] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line5] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Id] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[extradata] ADD CONSTRAINT [PK_extradata] PRIMARY KEY NONCLUSTERED ([Id]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [extradata2] ON [dbo].[extradata] ([line1]) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [ExtraData1] ON [dbo].[extradata] ([number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Displayed by the Work Form and allows user to create custom fields based on an ExtraData code that is selectable from the Work Form Account.', 'SCHEMA', N'dbo', 'TABLE', N'extradata', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Key code and display code for ExtraData', 'SCHEMA', N'dbo', 'TABLE', N'extradata', 'COLUMN', N'extracode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'extradata', 'COLUMN', N'Id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Data line 1', 'SCHEMA', N'dbo', 'TABLE', N'extradata', 'COLUMN', N'line1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Data line 2', 'SCHEMA', N'dbo', 'TABLE', N'extradata', 'COLUMN', N'line2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Data line 3', 'SCHEMA', N'dbo', 'TABLE', N'extradata', 'COLUMN', N'line3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Data line 4', 'SCHEMA', N'dbo', 'TABLE', N'extradata', 'COLUMN', N'line4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Data line 5', 'SCHEMA', N'dbo', 'TABLE', N'extradata', 'COLUMN', N'line5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'extradata', 'COLUMN', N'number'
GO
