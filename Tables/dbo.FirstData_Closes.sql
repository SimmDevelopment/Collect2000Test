CREATE TABLE [dbo].[FirstData_Closes]
(
[Number] [int] NOT NULL,
[Status] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReturnCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Narrative1] [varchar] (140) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Closed] [datetime] NOT NULL,
[Account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FirstData_Closes] ADD CONSTRAINT [PK_FirstData_Closes] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
