CREATE TABLE [dbo].[Report]
(
[ReportID] [int] NOT NULL IDENTITY(1, 1),
[ReportEngineID] [int] NOT NULL,
[ReportName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReportDescription] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [int] NULL,
[CreatedDate] [datetime] NULL CONSTRAINT [DF__Report__CreatedD__39D24A1A] DEFAULT (getdate()),
[ModifiedBy] [int] NULL,
[ModifiedDate] [datetime] NULL,
[Enabled] [bit] NOT NULL CONSTRAINT [DF__Report__Enabled__3AC66E53] DEFAULT (1),
[LastRunDate] [datetime] NULL,
[LastRunUser] [int] NULL,
[ReportConnectionInformationXML] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReportCategoryID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Report] ADD CONSTRAINT [PK_Report] PRIMARY KEY CLUSTERED ([ReportID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Report] ADD CONSTRAINT [FK_Report_ReportCategory] FOREIGN KEY ([ReportCategoryID]) REFERENCES [dbo].[ReportCategory] ([ReportCategoryID])
GO
ALTER TABLE [dbo].[Report] ADD CONSTRAINT [FK_Report_ReportEngine] FOREIGN KEY ([ReportEngineID]) REFERENCES [dbo].[ReportEngine] ([ReportEngineID])
GO
