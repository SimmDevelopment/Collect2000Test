CREATE TABLE [dbo].[CBRDictionary]
(
[Abbrev] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Lookup] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ccustomerid] [int] NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom CBR offsets  ', 'SCHEMA', N'dbo', 'TABLE', N'CBRDictionary', 'COLUMN', N'Abbrev'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer ID for applied offset ', 'SCHEMA', N'dbo', 'TABLE', N'CBRDictionary', 'COLUMN', N'ccustomerid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'value to be used for corresponding offset ', 'SCHEMA', N'dbo', 'TABLE', N'CBRDictionary', 'COLUMN', N'Lookup'
GO
