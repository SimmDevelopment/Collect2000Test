CREATE TABLE [dbo].[ExcelMappings]
(
[TableName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FieldName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DataType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DisplayName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ControlName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Allow] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ExcelMappings] ADD CONSTRAINT [PK_ExcelMappings] PRIMARY KEY CLUSTERED ([TableName], [FieldName], [DisplayName]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Mapping definition table used to map Excel Layout to Latitude data', 'SCHEMA', N'dbo', 'TABLE', N'ExcelMappings', NULL, NULL
GO
