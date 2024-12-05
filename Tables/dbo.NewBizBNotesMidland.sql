CREATE TABLE [dbo].[NewBizBNotesMidland]
(
[number] [int] NULL,
[ctl] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[created] [datetime] NULL,
[user0] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[action] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[result] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[comment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Seq] [int] NULL,
[IsPrivate] [bit] NULL,
[UtcCreated] [datetime] NULL CONSTRAINT [DF__NewBizBNo__UtcCr__18DD0151] DEFAULT (getutcdate())
) ON [PRIMARY]
GO
