CREATE TABLE [dbo].[ABA]
(
[MICR] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Bank] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Addr] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[zip] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[aba] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FaX] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [ABA1] ON [dbo].[ABA] ([MICR]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'US Bank ABA routing table', 'SCHEMA', N'dbo', 'TABLE', N'ABA', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'ABA', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'ABA', 'COLUMN', N'aba'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bank Address', 'SCHEMA', N'dbo', 'TABLE', N'ABA', 'COLUMN', N'Addr'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bank Name', 'SCHEMA', N'dbo', 'TABLE', N'ABA', 'COLUMN', N'Bank'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bank City', 'SCHEMA', N'dbo', 'TABLE', N'ABA', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bank Fax', 'SCHEMA', N'dbo', 'TABLE', N'ABA', 'COLUMN', N'FaX'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Routing MICR of US Bank', 'SCHEMA', N'dbo', 'TABLE', N'ABA', 'COLUMN', N'MICR'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'ABA', 'COLUMN', N'MICR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bank Phone', 'SCHEMA', N'dbo', 'TABLE', N'ABA', 'COLUMN', N'Phone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bank State', 'SCHEMA', N'dbo', 'TABLE', N'ABA', 'COLUMN', N'State'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bank Zip Code', 'SCHEMA', N'dbo', 'TABLE', N'ABA', 'COLUMN', N'zip'
GO
