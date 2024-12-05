CREATE TABLE [dbo].[Custom_ExcelTemplate]
(
[TemplateID] [int] NOT NULL IDENTITY(1, 1),
[DateSaved] [datetime] NULL,
[FileName] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Details] [image] NULL
) ON [PRIMARY]
GO
