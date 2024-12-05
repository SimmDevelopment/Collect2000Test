CREATE TABLE [dbo].[SavedSQL2]
(
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Statement] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedBy] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NULL,
[UID] [int] NOT NULL IDENTITY(1, 1),
[ContextCode] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
