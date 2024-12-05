CREATE TABLE [dbo].[Garnishment]
(
[GarnishmentID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[CaseNumber] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Company] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Addr1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Addr2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Addr3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[City] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[State] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Zipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Contact] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Fax] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Phone] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Email] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DateFiled] [smalldatetime] NOT NULL,
[ServiceDate] [smalldatetime] NOT NULL,
[ExpireDate] [smalldatetime] NOT NULL,
[PrinAmt] [money] NOT NULL CONSTRAINT [DF_Garnishment_PrinAmt] DEFAULT (0),
[PreJmtInt] [money] NOT NULL CONSTRAINT [DF_Garnishment_PreJmtInt] DEFAULT (0),
[PostJmtInt] [money] NOT NULL CONSTRAINT [DF_Garnishment_PostJmtInt] DEFAULT (0),
[Costs] [money] NOT NULL CONSTRAINT [DF_Garnishment_Costs] DEFAULT (0),
[OtherAmt] [money] NOT NULL CONSTRAINT [DF_Garnishment_OtherAmt] DEFAULT (0),
[Active] [bit] NOT NULL CONSTRAINT [DF_Garnishment_Active] DEFAULT (1),
[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_Garnishment_DateCreated] DEFAULT (getdate()),
[DateUpdated] [datetime] NOT NULL CONSTRAINT [DF_Garnishment_DateUpdated] DEFAULT (getdate()),
[UpdateChecksum] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Garnishment_UpdateChecksum] DEFAULT (checksum(getdate())),
[UpdatedBy] [int] NOT NULL CONSTRAINT [DF_Garnishment_UpdatedBy] DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Garnishment] ADD CONSTRAINT [PK_Garnishment] PRIMARY KEY CLUSTERED ([GarnishmentID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Garnishment_AccountID] ON [dbo].[Garnishment] ([AccountID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table retains garnishment judgement information of respective Debtor', 'SCHEMA', N'dbo', 'TABLE', N'Garnishment', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Account Filenumber ID', 'SCHEMA', N'dbo', 'TABLE', N'Garnishment', 'COLUMN', N'AccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Active indicator', 'SCHEMA', N'dbo', 'TABLE', N'Garnishment', 'COLUMN', N'Active'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Address line 1 of Garnishee', 'SCHEMA', N'dbo', 'TABLE', N'Garnishment', 'COLUMN', N'Addr1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Address line 2 of Garnishee', 'SCHEMA', N'dbo', 'TABLE', N'Garnishment', 'COLUMN', N'Addr2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Address line 3 of Garnishee', 'SCHEMA', N'dbo', 'TABLE', N'Garnishment', 'COLUMN', N'Addr3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Case Number of Garnishment', 'SCHEMA', N'dbo', 'TABLE', N'Garnishment', 'COLUMN', N'CaseNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'City of Garnishee', 'SCHEMA', N'dbo', 'TABLE', N'Garnishment', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Company Name of Garnishee', 'SCHEMA', N'dbo', 'TABLE', N'Garnishment', 'COLUMN', N'Company'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contact for Garnishee', 'SCHEMA', N'dbo', 'TABLE', N'Garnishment', 'COLUMN', N'Contact'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Legal costs of case', 'SCHEMA', N'dbo', 'TABLE', N'Garnishment', 'COLUMN', N'Costs'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Datetimestamp created', 'SCHEMA', N'dbo', 'TABLE', N'Garnishment', 'COLUMN', N'DateCreated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date Garnishment filed', 'SCHEMA', N'dbo', 'TABLE', N'Garnishment', 'COLUMN', N'DateFiled'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp of last update', 'SCHEMA', N'dbo', 'TABLE', N'Garnishment', 'COLUMN', N'DateUpdated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contact email address', 'SCHEMA', N'dbo', 'TABLE', N'Garnishment', 'COLUMN', N'Email'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Expiration date of Garnishment action', 'SCHEMA', N'dbo', 'TABLE', N'Garnishment', 'COLUMN', N'ExpireDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fax for Garnishee', 'SCHEMA', N'dbo', 'TABLE', N'Garnishment', 'COLUMN', N'Fax'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'Garnishment', 'COLUMN', N'GarnishmentID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Other costs associated with case', 'SCHEMA', N'dbo', 'TABLE', N'Garnishment', 'COLUMN', N'OtherAmt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contact phone number', 'SCHEMA', N'dbo', 'TABLE', N'Garnishment', 'COLUMN', N'Phone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Post-judgement interest amount', 'SCHEMA', N'dbo', 'TABLE', N'Garnishment', 'COLUMN', N'PostJmtInt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Pre-judgement interest amount', 'SCHEMA', N'dbo', 'TABLE', N'Garnishment', 'COLUMN', N'PreJmtInt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Principal amount of Garnished wages', 'SCHEMA', N'dbo', 'TABLE', N'Garnishment', 'COLUMN', N'PrinAmt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Service Date of Garnishment', 'SCHEMA', N'dbo', 'TABLE', N'Garnishment', 'COLUMN', N'ServiceDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'State of Garnishee', 'SCHEMA', N'dbo', 'TABLE', N'Garnishment', 'COLUMN', N'State'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Logon Name', 'SCHEMA', N'dbo', 'TABLE', N'Garnishment', 'COLUMN', N'UpdatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Zipcode of Garnishee', 'SCHEMA', N'dbo', 'TABLE', N'Garnishment', 'COLUMN', N'Zipcode'
GO
