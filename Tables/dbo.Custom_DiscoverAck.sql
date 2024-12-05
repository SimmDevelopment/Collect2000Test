CREATE TABLE [dbo].[Custom_DiscoverAck]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AccountNum] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Code] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MoneyVal] [money] NULL,
[Date] [datetime] NOT NULL,
[TranDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_DiscoverAck] ADD CONSTRAINT [PK_Custom_DiscoverAck] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
