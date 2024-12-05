CREATE TABLE [dbo].[Services_Locators_LocatorsHome]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NULL,
[FileNumber] [int] NULL,
[Street1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZipCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HomePhone1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HomePhone2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HomePhone3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HomePhone4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmployerPhone1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Employer1Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Emp1Street1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Emp1Street2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Emp1City] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Emp1State] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Emp1ZC] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmployerPhone2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Employer2Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Emp2Street1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Emp2Street2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Emp2City] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Emp2State] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Emp2ZC] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_Locators_LocatorsHome] ADD CONSTRAINT [PK_Services_Locators_LocatorsHome] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
