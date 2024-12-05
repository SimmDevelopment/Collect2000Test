CREATE TABLE [dbo].[Custom_ReportReference]
(
[ReportId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Configuration] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TreePath] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_ReportReference] ADD CONSTRAINT [PK_Custom_ReportReference] PRIMARY KEY CLUSTERED ([ReportId]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
