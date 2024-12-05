CREATE TABLE [dbo].[QueryExecutionLog]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__QueryExecuti__ID__26074FDC] DEFAULT (newid()),
[UserID] [int] NOT NULL,
[Executed] [datetime] NOT NULL CONSTRAINT [DF__QueryExec__Execu__26FB7415] DEFAULT (getdate()),
[SQL] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[QueryExecutionLog] ADD CONSTRAINT [PK_QueryExecutionLog] PRIMARY KEY NONCLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
