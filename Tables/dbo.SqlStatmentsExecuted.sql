CREATE TABLE [dbo].[SqlStatmentsExecuted]
(
[WhenExecuted] [datetime] NULL,
[ByWho] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StatementExecuted] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
