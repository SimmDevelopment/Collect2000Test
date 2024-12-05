CREATE TABLE [dbo].[Custom_Recall_report]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[number] [int] NULL,
[account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[filename] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[recallcode] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Recall_report] ADD CONSTRAINT [PK_Custom_Recall_report] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
