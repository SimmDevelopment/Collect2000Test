CREATE TABLE [dbo].[Phones_CeaseAndDesist]
(
[Phones_CeaseAndDesistID] [int] NOT NULL IDENTITY(1, 1),
[PhoneNumber] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Enabled] [bit] NOT NULL CONSTRAINT [DF_Phones_CeaseAndDesist_Enabled] DEFAULT ((1)),
[Created] [datetime] NOT NULL CONSTRAINT [DF_Phones_CeaseAndDesist_Created] DEFAULT (getdate()),
[CreatedBy] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Phones_CeaseAndDesist_CreatedBy] DEFAULT (suser_sname()),
[Updated] [datetime] NOT NULL CONSTRAINT [DF_Phones_CeaseAndDesist_Updated] DEFAULT (getdate()),
[UpdatedBy] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Phones_CeaseAndDesist_UpdatedBy] DEFAULT (suser_sname())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Phones_CeaseAndDesist] ADD CONSTRAINT [PK_Phones_CeaseAndDesist] PRIMARY KEY CLUSTERED ([Phones_CeaseAndDesistID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ_Phones_CeaseAndDesist_PhoneNumber] ON [dbo].[Phones_CeaseAndDesist] ([PhoneNumber]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Holds phone numbers where the owner demanded to stop calling it.', 'SCHEMA', N'dbo', 'TABLE', N'Phones_CeaseAndDesist', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time stamp of record creation.', 'SCHEMA', N'dbo', 'TABLE', N'Phones_CeaseAndDesist', 'COLUMN', N'Created'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Latitude logon name or network name of user who created record.', 'SCHEMA', N'dbo', 'TABLE', N'Phones_CeaseAndDesist', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag that when turned off means to ignore the record.', 'SCHEMA', N'dbo', 'TABLE', N'Phones_CeaseAndDesist', 'COLUMN', N'Enabled'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The applicable phone number.', 'SCHEMA', N'dbo', 'TABLE', N'Phones_CeaseAndDesist', 'COLUMN', N'PhoneNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary Key', 'SCHEMA', N'dbo', 'TABLE', N'Phones_CeaseAndDesist', 'COLUMN', N'Phones_CeaseAndDesistID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time when record was last updated.', 'SCHEMA', N'dbo', 'TABLE', N'Phones_CeaseAndDesist', 'COLUMN', N'Updated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Latitude logon name or network name of user who last updated record.', 'SCHEMA', N'dbo', 'TABLE', N'Phones_CeaseAndDesist', 'COLUMN', N'UpdatedBy'
GO
