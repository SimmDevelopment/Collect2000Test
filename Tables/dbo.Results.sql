CREATE TABLE [dbo].[Results]
(
[ID] [int] NOT NULL,
[Entered] [datetime] NULL,
[DueDate] [datetime] NULL,
[AcctID] [int] NULL,
[DebtorID] [tinyint] NULL,
[Amount] [money] NULL,
[Desk] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SendRM] [bit] NULL,
[PromiseMode] [tinyint] NULL,
[LetterCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FutureUID] [int] NULL,
[SendRMDate] [datetime] NULL,
[RMSentDate] [datetime] NULL,
[Suspended] [bit] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NOT NULL,
[Kept] [bit] NULL,
[DateCreated] [datetime] NULL,
[DateUpdated] [datetime] NULL,
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
