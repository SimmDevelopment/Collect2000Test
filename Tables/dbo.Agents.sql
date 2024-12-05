CREATE TABLE [dbo].[Agents]
(
[Code] [int] NOT NULL,
[Company] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fax] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip] [int] NULL,
[Address1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Contact] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Note] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateAdded] [datetime] NULL,
[WhoAdded] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'Agents', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'Agents', 'COLUMN', N'Address1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'Agents', 'COLUMN', N'Address2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'Agents', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'Agents', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'Agents', 'COLUMN', N'Company'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'Agents', 'COLUMN', N'Contact'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'Agents', 'COLUMN', N'DateAdded'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'Agents', 'COLUMN', N'Fax'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'Agents', 'COLUMN', N'Note'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'Agents', 'COLUMN', N'Phone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'Agents', 'COLUMN', N'State'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'Agents', 'COLUMN', N'WhoAdded'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'Agents', 'COLUMN', N'Zip'
GO
