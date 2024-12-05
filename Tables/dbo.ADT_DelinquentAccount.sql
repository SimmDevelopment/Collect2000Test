CREATE TABLE [dbo].[ADT_DelinquentAccount]
(
[ADT_DelinquentAccountID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[CreateDate] [datetime] NULL,
[CollectionLevel] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CollectionLevelText] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SiteNumber] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceNumber] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BranchType] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UnappliedAmount] [money] NULL,
[TimeZone] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumberOfSites] [int] NULL,
[Company] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SiteType] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Install31DelinquentAmount] [money] NULL,
[ConsentFlag] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Entered] [datetime] NOT NULL CONSTRAINT [DF_ADT_DelinquentAccount_Entered] DEFAULT (getdate()),
[USAAFlag] [bit] NULL,
[ActionDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ADT_DelinquentAccount] ADD CONSTRAINT [PK_ADT_DelinquentAccount] PRIMARY KEY CLUSTERED ([ADT_DelinquentAccountID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ADT_DelinquentAccount] ADD CONSTRAINT [FK_ADT_DelinquentAccount_master] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[master] ([number])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not used', 'SCHEMA', N'dbo', 'TABLE', N'ADT_DelinquentAccount', 'COLUMN', N'BranchType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Collection Stage Indicator, different values and descriptions per billing system', 'SCHEMA', N'dbo', 'TABLE', N'ADT_DelinquentAccount', 'COLUMN', N'CollectionLevel'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Text for CollectionLevel', 'SCHEMA', N'dbo', 'TABLE', N'ADT_DelinquentAccount', 'COLUMN', N'CollectionLevelText'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not used', 'SCHEMA', N'dbo', 'TABLE', N'ADT_DelinquentAccount', 'COLUMN', N'Company'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not currently used', 'SCHEMA', N'dbo', 'TABLE', N'ADT_DelinquentAccount', 'COLUMN', N'ConsentFlag'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not used', 'SCHEMA', N'dbo', 'TABLE', N'ADT_DelinquentAccount', 'COLUMN', N'CreateDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date record entered', 'SCHEMA', N'dbo', 'TABLE', N'ADT_DelinquentAccount', 'COLUMN', N'Entered'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Any install amounts not paid that are 31 days or greater past due', 'SCHEMA', N'dbo', 'TABLE', N'ADT_DelinquentAccount', 'COLUMN', N'Install31DelinquentAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not used', 'SCHEMA', N'dbo', 'TABLE', N'ADT_DelinquentAccount', 'COLUMN', N'InvoiceNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of sites the Customer has in service, shown in the Anchor', 'SCHEMA', N'dbo', 'TABLE', N'ADT_DelinquentAccount', 'COLUMN', N'NumberOfSites'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The site number for the customer, may be used to look up the site in the billing system(s)', 'SCHEMA', N'dbo', 'TABLE', N'ADT_DelinquentAccount', 'COLUMN', N'SiteNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not used', 'SCHEMA', N'dbo', 'TABLE', N'ADT_DelinquentAccount', 'COLUMN', N'SiteType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not used', 'SCHEMA', N'dbo', 'TABLE', N'ADT_DelinquentAccount', 'COLUMN', N'TimeZone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount of transactions pending or processed but not reflected in current balance total or past due balance', 'SCHEMA', N'dbo', 'TABLE', N'ADT_DelinquentAccount', 'COLUMN', N'UnappliedAmount'
GO
