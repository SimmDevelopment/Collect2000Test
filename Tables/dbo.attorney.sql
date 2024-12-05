CREATE TABLE [dbo].[attorney]
(
[code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ctl] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street1] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[feerate] [money] NULL,
[distpct] [money] NULL,
[Contact] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nextagency] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Recalldays] [int] NULL,
[AttorneyId] [int] NOT NULL IDENTITY(1, 1),
[Fax] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Remarks] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Firm] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Initials] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[YouGotClaimsID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_Attorney_DateCreated] DEFAULT (getdate()),
[DateUpdated] [datetime] NOT NULL CONSTRAINT [DF_Attorney_DateUpdated] DEFAULT (getdate()),
[BarID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[attorney] ADD CONSTRAINT [PK_attorney] PRIMARY KEY CLUSTERED ([AttorneyId]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Attorneys', 'SCHEMA', N'dbo', 'TABLE', N'attorney', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Auto Generated Unique Identity Value', 'SCHEMA', N'dbo', 'TABLE', N'attorney', 'COLUMN', N'AttorneyId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bar Identification for Attorney', 'SCHEMA', N'dbo', 'TABLE', N'attorney', 'COLUMN', N'BarID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'City ', 'SCHEMA', N'dbo', 'TABLE', N'attorney', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User defined Alphanumeric Code Identifying Attorney', 'SCHEMA', N'dbo', 'TABLE', N'attorney', 'COLUMN', N'code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contact Name ', 'SCHEMA', N'dbo', 'TABLE', N'attorney', 'COLUMN', N'Contact'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not used ', 'SCHEMA', N'dbo', 'TABLE', N'attorney', 'COLUMN', N'ctl'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date information initially Loaded into system ', 'SCHEMA', N'dbo', 'TABLE', N'attorney', 'COLUMN', N'DateCreated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date of Last Update ', 'SCHEMA', N'dbo', 'TABLE', N'attorney', 'COLUMN', N'DateUpdated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Email Address ', 'SCHEMA', N'dbo', 'TABLE', N'attorney', 'COLUMN', N'Email'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fax Number ', 'SCHEMA', N'dbo', 'TABLE', N'attorney', 'COLUMN', N'Fax'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fee percentage  ', 'SCHEMA', N'dbo', 'TABLE', N'attorney', 'COLUMN', N'feerate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Attorney Firm or Incorporated Name', 'SCHEMA', N'dbo', 'TABLE', N'attorney', 'COLUMN', N'Firm'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Initials for Firm', 'SCHEMA', N'dbo', 'TABLE', N'attorney', 'COLUMN', N'Initials'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Attorney Name', 'SCHEMA', N'dbo', 'TABLE', N'attorney', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Area Code and Phone Number ', 'SCHEMA', N'dbo', 'TABLE', N'attorney', 'COLUMN', N'phone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Free form text for User remarks', 'SCHEMA', N'dbo', 'TABLE', N'attorney', 'COLUMN', N'Remarks'
GO
EXEC sp_addextendedproperty N'MS_Description', N'State Abbreviation ', 'SCHEMA', N'dbo', 'TABLE', N'attorney', 'COLUMN', N'State'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Street Address 1', 'SCHEMA', N'dbo', 'TABLE', N'attorney', 'COLUMN', N'Street1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Street Address 2', 'SCHEMA', N'dbo', 'TABLE', N'attorney', 'COLUMN', N'Street2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'5 or 9 digit Zip Code ', 'SCHEMA', N'dbo', 'TABLE', N'attorney', 'COLUMN', N'Zipcode'
GO
