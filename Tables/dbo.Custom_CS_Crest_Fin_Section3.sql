CREATE TABLE [dbo].[Custom_CS_Crest_Fin_Section3]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[LoanIdent] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplayIdent] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrincipalPaid] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InterestPaid] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FeesPaid] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalPaid] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_CS_Crest_Fin_Section3] ADD CONSTRAINT [PK_Custom_CS_Crest_Fin_Section3] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
