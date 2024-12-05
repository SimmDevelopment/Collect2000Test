CREATE TABLE [dbo].[Custom_BatchDetail]
(
[BatchDetailErrorID] [int] NOT NULL IDENTITY(1, 1),
[CustomerReferenceID] [int] NULL,
[BatchHistoryID] [int] NULL,
[MessageID] [int] NULL,
[Message] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MessageLevelID] [int] NULL,
[TableName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServiceName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[number] [int] NULL,
[Detail] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Amount] [money] NULL,
[customer] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
