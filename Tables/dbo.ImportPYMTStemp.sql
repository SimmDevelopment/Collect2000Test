CREATE TABLE [dbo].[ImportPYMTStemp]
(
[Number] [int] NULL,
[ID1] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrentBal] [money] NULL,
[BatchNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Amount] [money] NULL,
[DatePaid] [datetime] NULL,
[CheckNbr] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Comment] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WhenLoaded] [datetime] NULL,
[FileName] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BatchType] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Message] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Temporary holding table used by Import Excel', 'SCHEMA', N'dbo', 'TABLE', N'ImportPYMTStemp', NULL, NULL
GO
