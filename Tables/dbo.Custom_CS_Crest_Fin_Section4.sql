CREATE TABLE [dbo].[Custom_CS_Crest_Fin_Section4]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[LoanIdent] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplayIdent] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Relationship] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_CS_Crest_Fin_Section4] ADD CONSTRAINT [PK_Custom_CS_Crest_Fin_Section4] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
