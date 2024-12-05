CREATE TABLE [dbo].[ImportNBExtraData]
(
[number] [int] NOT NULL,
[ctl] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[extracode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line3] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line4] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line5] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Temporary holding table for NewBusiness load', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBExtraData', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Key code and display code for ExtraData', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBExtraData', 'COLUMN', N'extracode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Data line 1', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBExtraData', 'COLUMN', N'line1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Data line 2', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBExtraData', 'COLUMN', N'line2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Data line 3', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBExtraData', 'COLUMN', N'line3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Data line 4', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBExtraData', 'COLUMN', N'line4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Data line5', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBExtraData', 'COLUMN', N'line5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBExtraData', 'COLUMN', N'number'
GO
