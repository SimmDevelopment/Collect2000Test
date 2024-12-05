CREATE TABLE [dbo].[ClaimType]
(
[Code] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClaimType] ADD CONSTRAINT [pk_LoanType] PRIMARY KEY CLUSTERED ([Code]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
