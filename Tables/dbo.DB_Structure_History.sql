CREATE TABLE [dbo].[DB_Structure_History]
(
[DB_Structure_HistoryID] [int] NOT NULL IDENTITY(1, 1),
[RunTime] [datetime2] NOT NULL,
[Type] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DatabaseName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Schema_Name] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Table_Name] [sys].[sysname] NOT NULL,
[Index_Name] [sys].[sysname] NULL,
[Index_Type] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[indexKeys] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[includedColumns] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[partitionKeys] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[isPrimaryKey] [bit] NULL,
[isUnique] [bit] NULL,
[isUniqueConstraint] [bit] NULL,
[isFilteredIndex] [bit] NULL,
[filterDefinition] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Column_Name] [varchar] (79) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data_Type] [varchar] (79) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Size] [varchar] (79) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Precision_Scale] [varchar] (79) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DB_Structure_History] ADD CONSTRAINT [PK_DB_Structure_History] PRIMARY KEY CLUSTERED ([DB_Structure_HistoryID]) ON [PRIMARY]
GO
