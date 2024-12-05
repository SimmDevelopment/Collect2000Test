CREATE TABLE [dbo].[Courts]
(
[CourtID] [int] NOT NULL IDENTITY(1, 1),
[CourtName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[County] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fax] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Salutation] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClerkFirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClerkMiddleName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClerkLastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_Courts_DateCreated] DEFAULT (getdate()),
[DateUpdated] [datetime] NOT NULL CONSTRAINT [DF_Courts_DateUpdated] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Courts] ADD CONSTRAINT [PK_Courts] PRIMARY KEY CLUSTERED ([CourtID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Court mailing address line 1 ', 'SCHEMA', N'dbo', 'TABLE', N'Courts', 'COLUMN', N'Address1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Court mailing address line 2 ', 'SCHEMA', N'dbo', 'TABLE', N'Courts', 'COLUMN', N'Address2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'City name for the assigned court ', 'SCHEMA', N'dbo', 'TABLE', N'Courts', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'First name of the court clerk assigned to the debtor account ', 'SCHEMA', N'dbo', 'TABLE', N'Courts', 'COLUMN', N'ClerkFirstName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Last name of the court clerk assigned to the debtor account ', 'SCHEMA', N'dbo', 'TABLE', N'Courts', 'COLUMN', N'ClerkLastName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Middle name of the court clerk assigned to the debtor account ', 'SCHEMA', N'dbo', 'TABLE', N'Courts', 'COLUMN', N'ClerkMiddleName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Auto Generated Unique Identity ', 'SCHEMA', N'dbo', 'TABLE', N'Courts', 'COLUMN', N'CourtID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the court used for the debtor account case ', 'SCHEMA', N'dbo', 'TABLE', N'Courts', 'COLUMN', N'CourtName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date entered into system ', 'SCHEMA', N'dbo', 'TABLE', N'Courts', 'COLUMN', N'DateCreated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date last updated in system ', 'SCHEMA', N'dbo', 'TABLE', N'Courts', 'COLUMN', N'DateUpdated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fax number for the assigned court ', 'SCHEMA', N'dbo', 'TABLE', N'Courts', 'COLUMN', N'Fax'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Phone number for the assigned court ', 'SCHEMA', N'dbo', 'TABLE', N'Courts', 'COLUMN', N'Phone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Salutation used for clerk i.e. ''The Honorable'', etc. ', 'SCHEMA', N'dbo', 'TABLE', N'Courts', 'COLUMN', N'Salutation'
GO
EXEC sp_addextendedproperty N'MS_Description', N'State of the assigned court ', 'SCHEMA', N'dbo', 'TABLE', N'Courts', 'COLUMN', N'State'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Zipcode for the assigned court ', 'SCHEMA', N'dbo', 'TABLE', N'Courts', 'COLUMN', N'Zipcode'
GO
