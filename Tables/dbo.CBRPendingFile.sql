CREATE TABLE [dbo].[CBRPendingFile]
(
[Number] [int] NULL,
[Entered] [datetime] NULL,
[Current0] [money] NULL,
[Status] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActivityType] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SpecialComment] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExceptionType] [int] NULL,
[Current1] [money] NULL,
[ActualPaymentAmount] [money] NULL,
[written] [bit] NOT NULL CONSTRAINT [DF__CbrPendin__writt__06C3AEAD] DEFAULT (0)
) ON [PRIMARY]
GO
