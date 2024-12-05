CREATE TABLE [dbo].[ServHistStatusCodes]
(
[StatusKey] [int] NOT NULL IDENTITY(0, 1),
[Name] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
