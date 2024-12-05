CREATE TABLE [dbo].[ReportParameter]
(
[ReportParameterID] [int] NOT NULL IDENTITY(1, 1),
[ReportID] [int] NOT NULL,
[ReportParameterTypeID] [int] NOT NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Descripton] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Prompt] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MultiSelect] [bit] NOT NULL CONSTRAINT [DF__ReportPar__Multi__3DA2DAFE] DEFAULT (0),
[RangeKey] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RangeDirection] [bit] NULL,
[CreatedBy] [int] NULL,
[CreatedDate] [datetime] NULL CONSTRAINT [DF__ReportPar__Creat__3E96FF37] DEFAULT (getdate()),
[ModifiedBy] [int] NULL,
[ModifiedDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReportParameter] ADD CONSTRAINT [PK_ReportParameter] PRIMARY KEY CLUSTERED ([ReportParameterID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReportParameter] ADD CONSTRAINT [FK_ReportParameter_Report] FOREIGN KEY ([ReportID]) REFERENCES [dbo].[Report] ([ReportID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ReportParameter] ADD CONSTRAINT [FK_ReportParameter_ReportParameterType] FOREIGN KEY ([ReportParameterTypeID]) REFERENCES [dbo].[ReportParameterType] ([ReportParameterTypeID])
GO
