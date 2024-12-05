CREATE TABLE [dbo].[OrderStatuses]
(
[Customer] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrderNumber] [int] NOT NULL,
[OrderDate] [datetime] NULL,
[DeliverDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OrderStatuses] ADD CONSTRAINT [PK_OrderStatuses] PRIMARY KEY CLUSTERED ([OrderNumber]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
