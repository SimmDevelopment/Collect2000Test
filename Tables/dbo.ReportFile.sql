CREATE TABLE [dbo].[ReportFile]
(
[ReportFileID] [int] NOT NULL IDENTITY(1, 1),
[ReportID] [int] NOT NULL,
[ReportFile] [image] NOT NULL,
[OriginalFileName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [int] NULL,
[CreatedDate] [datetime] NULL,
[ModifiedBy] [int] NULL,
[ModifiedDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReportFile] ADD CONSTRAINT [PK_ReportFile] PRIMARY KEY CLUSTERED ([ReportFileID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReportFile] ADD CONSTRAINT [FK_ReportFile_Report] FOREIGN KEY ([ReportID]) REFERENCES [dbo].[Report] ([ReportID])
GO
