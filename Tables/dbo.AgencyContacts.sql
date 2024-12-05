CREATE TABLE [dbo].[AgencyContacts]
(
[LastName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Middle] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Addr1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Addr2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZipCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone1] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone2] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone3] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UID] [int] NOT NULL IDENTITY(1, 1),
[AgencyCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone1Type] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone2Type] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone3Type] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyContacts', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyContacts', 'COLUMN', N'Addr1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyContacts', 'COLUMN', N'Addr2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyContacts', 'COLUMN', N'AgencyCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyContacts', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyContacts', 'COLUMN', N'FirstName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyContacts', 'COLUMN', N'LastName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyContacts', 'COLUMN', N'Middle'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyContacts', 'COLUMN', N'Phone1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyContacts', 'COLUMN', N'Phone1Type'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyContacts', 'COLUMN', N'Phone2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyContacts', 'COLUMN', N'Phone2Type'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyContacts', 'COLUMN', N'Phone3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyContacts', 'COLUMN', N'Phone3Type'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyContacts', 'COLUMN', N'State'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyContacts', 'COLUMN', N'UID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyContacts', 'COLUMN', N'ZipCode'
GO
