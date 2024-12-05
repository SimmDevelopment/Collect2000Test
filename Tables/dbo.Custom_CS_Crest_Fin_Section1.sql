CREATE TABLE [dbo].[Custom_CS_Crest_Fin_Section1]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[LoanIdent] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplayIdent] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Portfolio] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoanNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoanGroup] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoanType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoanClass1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoanClass1Description] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RetailerName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateOfBirth] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TIN1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TIN2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneLabel1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneNumber1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneLabel2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneNumber2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoApplicantFirstName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoApplicantLastName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoApplicantEmail] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoApplicantPhone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_CS_Crest_Fin_Section1] ADD CONSTRAINT [PK_Custom_CS_Crest_Fin_Section1] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
