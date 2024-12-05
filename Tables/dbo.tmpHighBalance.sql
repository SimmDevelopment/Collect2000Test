CREATE TABLE [dbo].[tmpHighBalance]
(
[Number] [int] NULL,
[DONE] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__tmpHighBal__DONE__7E4E643D] DEFAULT ('N'),
[Zipcode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SetFollowup] [bit] NOT NULL CONSTRAINT [DF__tmpHighBa__SetFo__7F428876] DEFAULT (0),
[LastAccessed] [datetime] NOT NULL CONSTRAINT [DF__tmpHighBa__LastA__0036ACAF] DEFAULT (getdate())
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_CQ_tmpHighBalance_Number] ON [dbo].[tmpHighBalance] ([Number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
