CREATE TABLE [dbo].[AIM_AccountFilter]
(
[AccountFilterId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SqlString] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SqlImage] [image] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_AccountFilter] ADD CONSTRAINT [PK_AccountFilter] PRIMARY KEY CLUSTERED ([AccountFilterId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_AccountFilter] ADD CONSTRAINT [IX_AccountFilter] UNIQUE NONCLUSTERED ([Name]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountFilter', 'COLUMN', N'AccountFilterId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The name or description for this type table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountFilter', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the sql string for this account filter', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountFilter', 'COLUMN', N'SqlImage'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the sql string for this account filter', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountFilter', 'COLUMN', N'SqlString'
GO
