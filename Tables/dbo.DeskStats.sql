CREATE TABLE [dbo].[DeskStats]
(
[Desk] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TheDate] [datetime] NOT NULL,
[Worked] [int] NULL CONSTRAINT [DF_DeskStats_Worked] DEFAULT (0),
[Contacted] [int] NULL CONSTRAINT [DF_DeskStats_Contacted] DEFAULT (0),
[Touched] [int] NULL CONSTRAINT [DF_DeskStats_Touched] DEFAULT (0),
[Collections] [money] NULL CONSTRAINT [DF_DeskStats_Collections] DEFAULT (0),
[Fees] [money] NULL CONSTRAINT [DF_DeskStats_Fees] DEFAULT (0),
[SystemMonth] [tinyint] NULL,
[SystemYear] [smallint] NULL,
[Attempts] [int] NOT NULL CONSTRAINT [DF__DeskStats__Attem__6013F5E0] DEFAULT (0)
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DeskStats_Desk_TheDate] ON [dbo].[DeskStats] ([Desk], [TheDate]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DeskStats_SysMonthandYear] ON [dbo].[DeskStats] ([SystemYear], [SystemMonth]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DeskStats_TheDate] ON [dbo].[DeskStats] ([TheDate]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Aggregate table that tracks account activity and collections by desk for each billing cycle.', 'SCHEMA', N'dbo', 'TABLE', N'DeskStats', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Call attempts to contact Debtor', 'SCHEMA', N'dbo', 'TABLE', N'DeskStats', 'COLUMN', N'Attempts'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total amount collected', 'SCHEMA', N'dbo', 'TABLE', N'DeskStats', 'COLUMN', N'Collections'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total accounts contacted', 'SCHEMA', N'dbo', 'TABLE', N'DeskStats', 'COLUMN', N'Contacted'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Defined Desk Code', 'SCHEMA', N'dbo', 'TABLE', N'DeskStats', 'COLUMN', N'Desk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Fees earned', 'SCHEMA', N'dbo', 'TABLE', N'DeskStats', 'COLUMN', N'Fees'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Billing Cycle Month', 'SCHEMA', N'dbo', 'TABLE', N'DeskStats', 'COLUMN', N'SystemMonth'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Billing Cycle Year', 'SCHEMA', N'dbo', 'TABLE', N'DeskStats', 'COLUMN', N'SystemYear'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTime of work day', 'SCHEMA', N'dbo', 'TABLE', N'DeskStats', 'COLUMN', N'TheDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total accounts touched', 'SCHEMA', N'dbo', 'TABLE', N'DeskStats', 'COLUMN', N'Touched'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total accounts worked', 'SCHEMA', N'dbo', 'TABLE', N'DeskStats', 'COLUMN', N'Worked'
GO
