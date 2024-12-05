CREATE TABLE [dbo].[ReportEngine]
(
[ReportEngineID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TypeName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Enabled] [bit] NOT NULL CONSTRAINT [DF__ReportEng__Enabl__36F5DD6F] DEFAULT (1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReportEngine] ADD CONSTRAINT [PK_ReportEngine] PRIMARY KEY CLUSTERED ([ReportEngineID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
