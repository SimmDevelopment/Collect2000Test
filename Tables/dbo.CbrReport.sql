CREATE TABLE [dbo].[CbrReport]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ReportType] [int] NULL,
[FileName] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Header] [varchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Trailer] [varchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CbrReport] ADD CONSTRAINT [PK_CbrReport] PRIMARY KEY CLUSTERED ([Id]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
