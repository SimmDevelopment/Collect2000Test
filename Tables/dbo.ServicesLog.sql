CREATE TABLE [dbo].[ServicesLog]
(
[TranDateTime] [datetime] NULL,
[ServiceId] [int] NULL,
[ByWho] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Comment] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CommentType] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
