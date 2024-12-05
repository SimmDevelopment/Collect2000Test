CREATE TABLE [dbo].[ImportNBMiscExtra]
(
[Number] [int] NULL,
[Title] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TheData] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Temporary holding table for NewBusiness load', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBMiscExtra', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBMiscExtra', 'COLUMN', N'Number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Data associated with Title and account', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBMiscExtra', 'COLUMN', N'TheData'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descriptive Title of Data or Code, Search Key, Display name in Latitude', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBMiscExtra', 'COLUMN', N'Title'
GO
