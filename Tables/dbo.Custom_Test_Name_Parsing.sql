CREATE TABLE [dbo].[Custom_Test_Name_Parsing]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[FullName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MiddleName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Suffix] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Test_Name_Parsing] ADD CONSTRAINT [PK_Custom_Test_Name_Parsing] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
