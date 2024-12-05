CREATE TABLE [dbo].[AIM_Agency]
(
[AgencyId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactName] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CommissionPercentage] [float] NULL,
[City] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fax] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileFormat] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PaymentExtensionDays] [int] NULL,
[NetOrGross] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgencyTier] [int] NOT NULL CONSTRAINT [DF__AIM_Agenc__Agenc__0D0B5BF2] DEFAULT ((1)),
[AlphaCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FTPUserName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FTPPassWord] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KeepsBanko] [bit] NULL,
[KeepsDeceased] [bit] NULL,
[FTPFolderPath] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgencyGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DefaultFeeSchedule] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FTPImportFolderPath] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DefaultLawList] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FTPType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FTPServerURL] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FTPOverrideGlobalSettings] [bit] NULL CONSTRAINT [DF__AIM_Agenc__FTPOv__0DFF802B] DEFAULT ((0)),
[PGPEnabled] [bit] NULL CONSTRAINT [DF__AIM_Agenc__PGPEn__0EF3A464] DEFAULT ((0)),
[PGPAIMPublicKey] [image] NULL,
[PGPAIMPrivateKey] [image] NULL,
[PGPAgencyPublicKey] [image] NULL,
[PGPAIMPrivatePassphrase] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgencyVersion] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FTPPassiveMode] [bit] NULL,
[KeepsComplaint] [bit] NULL,
[KeepsDispute] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_Agency] ADD CONSTRAINT [PK_Agency] PRIMARY KEY CLUSTERED ([AgencyId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_Agency] ADD CONSTRAINT [IX_Agency] UNIQUE NONCLUSTERED ([Name]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency Address', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Agency', 'COLUMN', N'Address'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency Address', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Agency', 'COLUMN', N'Address1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Agency', 'COLUMN', N'AgencyId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency tier', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Agency', 'COLUMN', N'AgencyTier'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency city', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Agency', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency Default commission percentage', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Agency', 'COLUMN', N'CommissionPercentage'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency contact', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Agency', 'COLUMN', N'ContactName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency Email', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Agency', 'COLUMN', N'Email'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency Fax', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Agency', 'COLUMN', N'Fax'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency Default File Format (Excel,Fixed,Delimited,XML)', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Agency', 'COLUMN', N'FileFormat'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency''s Name', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Agency', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency accounting format', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Agency', 'COLUMN', N'NetOrGross'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency default payment extension days', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Agency', 'COLUMN', N'PaymentExtensionDays'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency Phone', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Agency', 'COLUMN', N'Phone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency State', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Agency', 'COLUMN', N'State'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency Zipcode', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Agency', 'COLUMN', N'Zip'
GO
