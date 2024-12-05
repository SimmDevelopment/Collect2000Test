CREATE TABLE [dbo].[AIM_Contact]
(
[ContactId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactTypeId] [int] NULL,
[Address] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Role] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Prefix] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MiddleName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Suffix] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Direct] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Home] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mobile] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fax] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DebtorLine] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPhone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WebSite] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Company] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReferredBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Source] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConfidentialityReceived] [bit] NULL CONSTRAINT [DF__AIM_Conta__Confi__2112549F] DEFAULT ((0)),
[QuestionnaireReceived] [bit] NULL CONSTRAINT [DF__AIM_Conta__Quest__220678D8] DEFAULT ((0)),
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedOn] [datetime] NULL CONSTRAINT [DF__AIM_Conta__Creat__22FA9D11] DEFAULT (getdate()),
[UpdatedOn] [datetime] NULL CONSTRAINT [DF__AIM_Conta__Updat__23EEC14A] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_Contact] ADD CONSTRAINT [PK_AIM_Contact] PRIMARY KEY CLUSTERED ([ContactId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_Contact] ADD CONSTRAINT [FK_AIM_Contact_AIM_ContactType] FOREIGN KEY ([ContactTypeId]) REFERENCES [dbo].[AIM_ContactType] ([ContactTypeId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'contact address', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Contact', 'COLUMN', N'Address'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contact city', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Contact', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Contact', 'COLUMN', N'ContactId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'contact type', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Contact', 'COLUMN', N'ContactTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contact email', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Contact', 'COLUMN', N'Email'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contact Name', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Contact', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contact Phone', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Contact', 'COLUMN', N'Phone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contact role', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Contact', 'COLUMN', N'Role'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contact state', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Contact', 'COLUMN', N'State'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contact zip', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Contact', 'COLUMN', N'Zip'
GO
