CREATE TABLE [dbo].[Services_OlbAffr_CH01]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NULL,
[CH01] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChProductCode] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CharacteristicID] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CharacteristicValue] [decimal] (15, 5) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_OlbAffr_CH01] ADD CONSTRAINT [PK_Services_OlbAffr_CH01] PRIMARY KEY CLUSTERED ([Id]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
