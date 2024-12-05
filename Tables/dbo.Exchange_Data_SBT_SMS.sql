CREATE TABLE [dbo].[Exchange_Data_SBT_SMS]
(
[Exchange_Data_SBT_SMS_Id] [int] NOT NULL IDENTITY(1, 1),
[Import_Name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Import_FileName] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Import_Date] [datetime] NULL,
[Import_Complete] [bit] NULL,
[Import_Status] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data1] [varchar] (3500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data2] [varchar] (3500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data3] [varchar] (3500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data4] [varchar] (3500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data5] [varchar] (3500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data6] [varchar] (3500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data7] [varchar] (3500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data8] [varchar] (3500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data9] [varchar] (3500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data10] [varchar] (3500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data11] [varchar] (3500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data12] [varchar] (3500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data13] [varchar] (3500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data14] [varchar] (3500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data15] [varchar] (3500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data16] [varchar] (3500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data17] [varchar] (3500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data18] [varchar] (3500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data19] [varchar] (3500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data20] [varchar] (3500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data21] [varchar] (3500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Exchange_Data_SBT_SMS] ADD CONSTRAINT [PK_Exchange_Data_SBT_SMS] PRIMARY KEY CLUSTERED ([Exchange_Data_SBT_SMS_Id]) ON [PRIMARY]
GO
