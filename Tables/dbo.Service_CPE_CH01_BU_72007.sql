CREATE TABLE [dbo].[Service_CPE_CH01_BU_72007]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NULL,
[CH01] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CharacteristicID] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CharacteristicValue] [decimal] (15, 5) NULL,
[ChProductCode] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
