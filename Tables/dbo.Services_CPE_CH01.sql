CREATE TABLE [dbo].[Services_CPE_CH01]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NULL,
[CH01] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CharacteristicID] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CharacteristicValue] [decimal] (15, 5) NULL,
[ChProductCode] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_CPE_CH01] ADD CONSTRAINT [PK_Services_CPE_CH01] PRIMARY KEY CLUSTERED ([Id]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
