CREATE TABLE [dbo].[FirstData_RecallReport]
(
[RunDate] [datetime] NOT NULL,
[Account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[currentprincipal] [money] NULL,
[FileName] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[principalformatted] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[totalprincipalformatted] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ID] [int] NOT NULL IDENTITY(1, 1),
[number] [int] NULL,
[totalprincipal] [money] NULL
) ON [PRIMARY]
GO
