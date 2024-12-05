CREATE TABLE [dbo].[HCFAItems]
(
[form_id] [int] NOT NULL,
[item_uid] [int] NOT NULL IDENTITY(1, 1),
[serv_start_dte] [datetime] NULL,
[serv_end_dte] [datetime] NULL,
[serv_place_cd] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[serv_type_cd] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cpt_hcpcs_cd] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[proc_mod_cd] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[diag_cd] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[charge_amt] [money] NULL,
[units_no] [smallint] NULL,
[epsdt] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[emg] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cob] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[reserved_24k] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[print_item] [bit] NULL,
[comment_xx] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[item_paid_amt] [money] NULL,
[item_bal_amt] [money] NULL,
[timestamp] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HCFAItems] ADD CONSTRAINT [PK_HCFAItems] PRIMARY KEY NONCLUSTERED ([item_uid]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IFK_HCFAItems] ON [dbo].[HCFAItems] ([form_id]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAItems', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAItems', 'COLUMN', N'charge_amt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAItems', 'COLUMN', N'cob'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAItems', 'COLUMN', N'comment_xx'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAItems', 'COLUMN', N'cpt_hcpcs_cd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAItems', 'COLUMN', N'diag_cd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAItems', 'COLUMN', N'emg'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAItems', 'COLUMN', N'epsdt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAItems', 'COLUMN', N'form_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAItems', 'COLUMN', N'item_bal_amt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAItems', 'COLUMN', N'item_paid_amt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAItems', 'COLUMN', N'item_uid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAItems', 'COLUMN', N'print_item'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAItems', 'COLUMN', N'proc_mod_cd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAItems', 'COLUMN', N'reserved_24k'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAItems', 'COLUMN', N'serv_end_dte'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAItems', 'COLUMN', N'serv_place_cd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAItems', 'COLUMN', N'serv_start_dte'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAItems', 'COLUMN', N'serv_type_cd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAItems', 'COLUMN', N'timestamp'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAItems', 'COLUMN', N'units_no'
GO
