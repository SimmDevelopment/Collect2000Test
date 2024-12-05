CREATE TABLE [dbo].[CustomerStats]
(
[Customer] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TheDate] [datetime] NOT NULL,
[Touched] [int] NOT NULL CONSTRAINT [DF_CustomerStats_Touched] DEFAULT (0),
[Worked] [int] NOT NULL CONSTRAINT [DF_CustomerStats_Worked] DEFAULT (0),
[Contacted] [int] NOT NULL CONSTRAINT [DF_CustomerStats_Contacted] DEFAULT (0),
[Collections] [money] NOT NULL CONSTRAINT [DF_CustomerStats_Collections] DEFAULT (0),
[Fees] [money] NOT NULL CONSTRAINT [DF_CustomerStats_Fees] DEFAULT (0),
[NewItems] [int] NOT NULL CONSTRAINT [DF_CustomerStats_NewItems] DEFAULT (0),
[NewDollars] [money] NOT NULL CONSTRAINT [DF_CustomerStats_NewDollars] DEFAULT (0),
[SystemMonth] [tinyint] NOT NULL,
[SystemYear] [smallint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CustomerStats] ADD CONSTRAINT [PK_CustomerStats] PRIMARY KEY CLUSTERED ([Customer], [TheDate], [SystemMonth], [SystemYear]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_CustomerStats_SysMonthandYear] ON [dbo].[CustomerStats] ([SystemYear], [SystemMonth]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Aggregate table used to report account worked statistics by Customer.', 'SCHEMA', N'dbo', 'TABLE', N'CustomerStats', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total collections for date', 'SCHEMA', N'dbo', 'TABLE', N'CustomerStats', 'COLUMN', N'Collections'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of accounts contacted as per action/result settings updated to notes', 'SCHEMA', N'dbo', 'TABLE', N'CustomerStats', 'COLUMN', N'Contacted'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer Code', 'SCHEMA', N'dbo', 'TABLE', N'CustomerStats', 'COLUMN', N'Customer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total fees for date', 'SCHEMA', N'dbo', 'TABLE', N'CustomerStats', 'COLUMN', N'Fees'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current system month as defined in control file.', 'SCHEMA', N'dbo', 'TABLE', N'CustomerStats', 'COLUMN', N'SystemMonth'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current system year as defined in control file.', 'SCHEMA', N'dbo', 'TABLE', N'CustomerStats', 'COLUMN', N'SystemYear'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date of activity', 'SCHEMA', N'dbo', 'TABLE', N'CustomerStats', 'COLUMN', N'TheDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of accounts touched as per action/result settings updated to notes', 'SCHEMA', N'dbo', 'TABLE', N'CustomerStats', 'COLUMN', N'Touched'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of accounts worked as per action/result settings updated to notes', 'SCHEMA', N'dbo', 'TABLE', N'CustomerStats', 'COLUMN', N'Worked'
GO
