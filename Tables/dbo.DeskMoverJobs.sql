CREATE TABLE [dbo].[DeskMoverJobs]
(
[Number] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsBatch] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Data] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Desk Mover program is used to move accounts to specific desks by entering selection conditions. This tool is used by management to distribute accounts for work by collection personnel.', 'SCHEMA', N'dbo', 'TABLE', N'DeskMoverJobs', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Y/N batch indicator', 'SCHEMA', N'dbo', 'TABLE', N'DeskMoverJobs', 'COLUMN', N'IsBatch'
GO
