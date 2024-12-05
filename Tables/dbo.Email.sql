CREATE TABLE [dbo].[Email]
(
[EmailId] [int] NOT NULL IDENTITY(1, 1),
[DebtorId] [int] NULL,
[Email] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TypeCd] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Email_TypeCd] DEFAULT ('Home'),
[StatusCd] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Email_StatusCd] DEFAULT ('UNK'),
[Active] [bit] NOT NULL CONSTRAINT [DF_Email_Active] DEFAULT ((1)),
[Primary] [bit] NOT NULL CONSTRAINT [DF_Email_Primary] DEFAULT ((0)),
[ConsentGiven] [bit] NULL,
[WrittenConsent] [bit] NULL,
[ConsentSource] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConsentBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConsentDate] [datetime] NULL,
[CreatedWhen] [datetime] NOT NULL CONSTRAINT [DF_Email_CreatedWhen] DEFAULT (getutcdate()),
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ModifiedWhen] [datetime] NOT NULL CONSTRAINT [DF_Email_ModifiedWhen] DEFAULT (getutcdate()),
[ModifiedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[comment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DebtorAssociationId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Email] ADD CONSTRAINT [PK_Email] PRIMARY KEY CLUSTERED ([EmailId]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Email Addresses for a person.', 'SCHEMA', N'dbo', 'TABLE', N'Email', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Is this an active email address? Default to True.', 'SCHEMA', N'dbo', 'TABLE', N'Email', 'COLUMN', N'Active'
GO
EXEC sp_addextendedproperty N'MS_Description', N'comment for email Add/Edit.', 'SCHEMA', N'dbo', 'TABLE', N'Email', 'COLUMN', N'comment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The user that obtained the consent or refusal.', 'SCHEMA', N'dbo', 'TABLE', N'Email', 'COLUMN', N'ConsentBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date consent or refusal was recorded.', 'SCHEMA', N'dbo', 'TABLE', N'Email', 'COLUMN', N'ConsentDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Set to true when consent has been given, or false if refused. Default to null.', 'SCHEMA', N'dbo', 'TABLE', N'Email', 'COLUMN', N'ConsentGiven'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Free form text, whom was the consent obtained from or refused by.', 'SCHEMA', N'dbo', 'TABLE', N'Email', 'COLUMN', N'ConsentSource'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Record Created by user name.', 'SCHEMA', N'dbo', 'TABLE', N'Email', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Record Created date and time.', 'SCHEMA', N'dbo', 'TABLE', N'Email', 'COLUMN', N'CreatedWhen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK to DebtorAssociation table.', 'SCHEMA', N'dbo', 'TABLE', N'Email', 'COLUMN', N'DebtorAssociationId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK to debtor table.', 'SCHEMA', N'dbo', 'TABLE', N'Email', 'COLUMN', N'DebtorId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The email address for which this record exists to represent. Required to be a valid email address.', 'SCHEMA', N'dbo', 'TABLE', N'Email', 'COLUMN', N'Email'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary Key, identity field.', 'SCHEMA', N'dbo', 'TABLE', N'Email', 'COLUMN', N'EmailId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Record Modified by user name.', 'SCHEMA', N'dbo', 'TABLE', N'Email', 'COLUMN', N'ModifiedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Record Modification date and time.', 'SCHEMA', N'dbo', 'TABLE', N'Email', 'COLUMN', N'ModifiedWhen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'True if this is the primary email address for the person. The first email address for a person whould default to true, otherwise, it has to be manually maintained. Not Null, default to false.', 'SCHEMA', N'dbo', 'TABLE', N'Email', 'COLUMN', N'Primary'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Selected from listcode of ADDRSTATUS from ListItems. Default to Unknown.', 'SCHEMA', N'dbo', 'TABLE', N'Email', 'COLUMN', N'StatusCd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Selected from listcode of ADDRTYPE from ListItems. Default to Home.', 'SCHEMA', N'dbo', 'TABLE', N'Email', 'COLUMN', N'TypeCd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Required when consent is set to a non-null value. Set to true if consent was received in written form. Otherwise assume verbal consent and set to False. Default to null.', 'SCHEMA', N'dbo', 'TABLE', N'Email', 'COLUMN', N'WrittenConsent'
GO
