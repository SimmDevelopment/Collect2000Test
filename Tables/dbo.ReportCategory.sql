CREATE TABLE [dbo].[ReportCategory]
(
[ReportCategoryID] [int] NOT NULL IDENTITY(1, 1),
[ParentReportCategoryID] [int] NULL,
[CategoryName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CategoryDescription] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShowOnOutlookBox] [bit] NOT NULL CONSTRAINT [DF__ReportCat__ShowO__5762AD01] DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReportCategory] ADD CONSTRAINT [PK_ReportCategory] PRIMARY KEY CLUSTERED ([ReportCategoryID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReportCategory] ADD CONSTRAINT [FK_ReportCategory_ReportCategory] FOREIGN KEY ([ParentReportCategoryID]) REFERENCES [dbo].[ReportCategory] ([ReportCategoryID])
GO
