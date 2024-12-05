CREATE TABLE [dbo].[NBNotes]
(
[Number] [int] NOT NULL,
[created] [datetime] NULL,
[user0] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[action] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[result] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[comment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[seq] [int] NULL
) ON [PRIMARY]
GO
