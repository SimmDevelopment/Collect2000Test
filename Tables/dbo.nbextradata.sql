CREATE TABLE [dbo].[nbextradata]
(
[number] [int] NULL,
[ctl] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[extracode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[line1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line3] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line4] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line5] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'code used to look up Extradata', 'SCHEMA', N'dbo', 'TABLE', N'nbextradata', 'COLUMN', N'extracode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Extra Data Line1', 'SCHEMA', N'dbo', 'TABLE', N'nbextradata', 'COLUMN', N'line1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Extra Data Line2', 'SCHEMA', N'dbo', 'TABLE', N'nbextradata', 'COLUMN', N'line2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'extra data line 3', 'SCHEMA', N'dbo', 'TABLE', N'nbextradata', 'COLUMN', N'line3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Extra Data Line 4', 'SCHEMA', N'dbo', 'TABLE', N'nbextradata', 'COLUMN', N'line4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Extra Data Line 5', 'SCHEMA', N'dbo', 'TABLE', N'nbextradata', 'COLUMN', N'line5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number from Master', 'SCHEMA', N'dbo', 'TABLE', N'nbextradata', 'COLUMN', N'number'
GO
