CREATE TABLE [dbo].[MTDDESK]
(
[DESK] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[eom] [datetime] NULL,
[NAME] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MTDGross] [money] NULL,
[MTDFees] [money] NULL,
[MTDPDCgross] [money] NULL,
[MTDPDCFees] [money] NULL
) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [MtdDesk0] ON [dbo].[MTDDESK] ([DESK]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Aggregate table used by Standard Latitude Reports', 'SCHEMA', N'dbo', 'TABLE', N'MTDDESK', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Desk Code', 'SCHEMA', N'dbo', 'TABLE', N'MTDDESK', 'COLUMN', N'DESK'
GO
EXEC sp_addextendedproperty N'MS_Description', N'End of Month ', 'SCHEMA', N'dbo', 'TABLE', N'MTDDESK', 'COLUMN', N'eom'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month to date Fees earned', 'SCHEMA', N'dbo', 'TABLE', N'MTDDESK', 'COLUMN', N'MTDFees'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month to date Gross collections', 'SCHEMA', N'dbo', 'TABLE', N'MTDDESK', 'COLUMN', N'MTDGross'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month to date PDC fees', 'SCHEMA', N'dbo', 'TABLE', N'MTDDESK', 'COLUMN', N'MTDPDCFees'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month to date Gross PDC', 'SCHEMA', N'dbo', 'TABLE', N'MTDDESK', 'COLUMN', N'MTDPDCgross'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Desk Name', 'SCHEMA', N'dbo', 'TABLE', N'MTDDESK', 'COLUMN', N'NAME'
GO
