CREATE TABLE [dbo].[letterstats]
(
[number] [int] NOT NULL,
[code] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[systemyear] [smallint] NOT NULL,
[systemmonth] [smallint] NOT NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Aggregate table retaining number of letters sent', 'SCHEMA', N'dbo', 'TABLE', N'letterstats', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Letter code  of letter', 'SCHEMA', N'dbo', 'TABLE', N'letterstats', 'COLUMN', N'code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total number of letters sent', 'SCHEMA', N'dbo', 'TABLE', N'letterstats', 'COLUMN', N'number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Billing Cycle Month', 'SCHEMA', N'dbo', 'TABLE', N'letterstats', 'COLUMN', N'systemmonth'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Billing Cycle Year', 'SCHEMA', N'dbo', 'TABLE', N'letterstats', 'COLUMN', N'systemyear'
GO
