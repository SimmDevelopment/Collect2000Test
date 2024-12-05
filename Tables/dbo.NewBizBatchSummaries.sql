CREATE TABLE [dbo].[NewBizBatchSummaries]
(
[BatchNumber] [int] NOT NULL IDENTITY(1, 1),
[CreatedDate] [datetime] NULL,
[ProcessedDate] [datetime] NULL,
[DollarsExpected] [money] NULL,
[DollarsActual] [money] NULL,
[ItemsExpected] [int] NULL,
[ItemsActual] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
