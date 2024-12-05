CREATE TABLE [dbo].[NewBizBNotes]
(
[number] [int] NULL,
[ctl] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Created] [datetime] NULL,
[User0] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[action] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Result] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[comment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[seq] [int] NULL,
[fill1] [char] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fill2] [char] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsPrivate] [bit] NULL,
[UtcCreated] [datetime] NULL CONSTRAINT [DF__NewBizBNo__UtcCr__7080332A] DEFAULT (getutcdate())
) ON [PRIMARY]
GO
