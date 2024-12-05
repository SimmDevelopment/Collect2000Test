CREATE TABLE [dbo].[HCSFeeMaint]
(
[Code] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FeeCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LoanType] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HCSFeeMaint] ADD CONSTRAINT [PK_HCSFeeMaint] PRIMARY KEY CLUSTERED ([Code]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
