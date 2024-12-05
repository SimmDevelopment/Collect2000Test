CREATE TABLE [dbo].[Exchange_Data]
(
[Exchange_Data_Id] [int] NOT NULL IDENTITY(1, 1),
[Import_Name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Import_File_Name] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Import_Status] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Data1] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data2] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data3] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data4] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data5] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data6] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data7] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data8] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data9] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Exchange_Data] ADD CONSTRAINT [PK_Exchange_Data] PRIMARY KEY CLUSTERED ([Exchange_Data_Id]) ON [PRIMARY]
GO
