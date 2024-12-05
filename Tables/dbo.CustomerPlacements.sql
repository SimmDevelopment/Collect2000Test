CREATE TABLE [dbo].[CustomerPlacements]
(
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TotalAccounts] [bigint] NULL,
[OriginalSum] [money] NULL,
[ReceivedMax] [datetime] NULL,
[ReceivedMonth] [int] NOT NULL,
[ReceivedYear] [int] NOT NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [IX_CustomerPlacements] ON [dbo].[CustomerPlacements] ([Customer]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_CustomerPlacements_1] ON [dbo].[CustomerPlacements] ([Customer], [ReceivedYear], [ReceivedMonth]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
