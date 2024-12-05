CREATE TABLE [dbo].[ListBuilderOptionSelectList]
(
[DisplayOrder] [int] NOT NULL,
[Code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (252) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubViewName] [varchar] (252) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ListBuilderOptionSelectList] ADD CONSTRAINT [PK_ListBuilderOptionSelectList] PRIMARY KEY CLUSTERED ([DisplayOrder], [Code]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ListBuilderOptionSelectList] ADD CONSTRAINT [UQ_ListBuilderOptionSelectList] UNIQUE NONCLUSTERED ([Code]) ON [PRIMARY]
GO
