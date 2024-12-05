CREATE TABLE [dbo].[NameAddress]
(
[TransDate] [datetime] NULL,
[TransType] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Ohomephone] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OworkPhone] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NHomePhone] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NWorkPhone] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OStreet1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Ostreet2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Ocity] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Ozipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OState] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NStreet1] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Nstreet2] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NCity] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NState] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Nzipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Transmitted] [datetime] NULL,
[Desk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Number] [real] NULL,
[OStatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Nstatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransmittedYes] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[attorney] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [NameAddress1] ON [dbo].[NameAddress] ([Number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account from Master', 'SCHEMA', N'dbo', 'TABLE', N'NameAddress', 'COLUMN', N'Account'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Attorney from Master', 'SCHEMA', N'dbo', 'TABLE', N'NameAddress', 'COLUMN', N'attorney'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer from Master', 'SCHEMA', N'dbo', 'TABLE', N'NameAddress', 'COLUMN', N'customer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Desk that Made the change', 'SCHEMA', N'dbo', 'TABLE', N'NameAddress', 'COLUMN', N'Desk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name from Master', 'SCHEMA', N'dbo', 'TABLE', N'NameAddress', 'COLUMN', N'name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'New City', 'SCHEMA', N'dbo', 'TABLE', N'NameAddress', 'COLUMN', N'NCity'
GO
EXEC sp_addextendedproperty N'MS_Description', N'New Home Phone', 'SCHEMA', N'dbo', 'TABLE', N'NameAddress', 'COLUMN', N'NHomePhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'New State', 'SCHEMA', N'dbo', 'TABLE', N'NameAddress', 'COLUMN', N'NState'
GO
EXEC sp_addextendedproperty N'MS_Description', N'New Status', 'SCHEMA', N'dbo', 'TABLE', N'NameAddress', 'COLUMN', N'Nstatus'
GO
EXEC sp_addextendedproperty N'MS_Description', N'New Street1', 'SCHEMA', N'dbo', 'TABLE', N'NameAddress', 'COLUMN', N'NStreet1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'New Street2', 'SCHEMA', N'dbo', 'TABLE', N'NameAddress', 'COLUMN', N'Nstreet2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number from Master', 'SCHEMA', N'dbo', 'TABLE', N'NameAddress', 'COLUMN', N'Number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'New Work Phone', 'SCHEMA', N'dbo', 'TABLE', N'NameAddress', 'COLUMN', N'NWorkPhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'New Zipcode', 'SCHEMA', N'dbo', 'TABLE', N'NameAddress', 'COLUMN', N'Nzipcode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Old City', 'SCHEMA', N'dbo', 'TABLE', N'NameAddress', 'COLUMN', N'Ocity'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Old Home phone', 'SCHEMA', N'dbo', 'TABLE', N'NameAddress', 'COLUMN', N'Ohomephone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Old State', 'SCHEMA', N'dbo', 'TABLE', N'NameAddress', 'COLUMN', N'OState'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Old Status', 'SCHEMA', N'dbo', 'TABLE', N'NameAddress', 'COLUMN', N'OStatus'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Old Street1', 'SCHEMA', N'dbo', 'TABLE', N'NameAddress', 'COLUMN', N'OStreet1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Old Steet2', 'SCHEMA', N'dbo', 'TABLE', N'NameAddress', 'COLUMN', N'Ostreet2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Old Work Phone', 'SCHEMA', N'dbo', 'TABLE', N'NameAddress', 'COLUMN', N'OworkPhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Old Zipcode', 'SCHEMA', N'dbo', 'TABLE', N'NameAddress', 'COLUMN', N'Ozipcode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date Row Inserted', 'SCHEMA', N'dbo', 'TABLE', N'NameAddress', 'COLUMN', N'TransDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Type of Transaction', 'SCHEMA', N'dbo', 'TABLE', N'NameAddress', 'COLUMN', N'TransType'
GO
