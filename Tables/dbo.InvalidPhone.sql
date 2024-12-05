CREATE TABLE [dbo].[InvalidPhone]
(
[Phone] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Table used to track invalid phone numbers.   Superseded by the Latitude phone panel', 'SCHEMA', N'dbo', 'TABLE', N'InvalidPhone', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Phone number ', 'SCHEMA', N'dbo', 'TABLE', N'InvalidPhone', 'COLUMN', N'Phone'
GO
