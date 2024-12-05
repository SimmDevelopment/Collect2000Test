CREATE TABLE [dbo].[ReportParameterType]
(
[ReportParameterTypeID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [int] NOT NULL,
[ParameterXML] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Enabled] [bit] NOT NULL CONSTRAINT [DF__ReportPar__Enabl__61E03B74] DEFAULT (1),
[CreatedBy] [int] NULL,
[CreatedDate] [datetime] NULL CONSTRAINT [DF__ReportPar__Creat__62D45FAD] DEFAULT (getdate()),
[ModifiedBy] [int] NULL,
[ModifiedDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReportParameterType] ADD CONSTRAINT [PK_ReportParameterType] PRIMARY KEY CLUSTERED ([ReportParameterTypeID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
