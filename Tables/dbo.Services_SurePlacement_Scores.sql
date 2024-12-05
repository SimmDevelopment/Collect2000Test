CREATE TABLE [dbo].[Services_SurePlacement_Scores]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NOT NULL,
[Contactability] [int] NULL,
[Liquidity] [int] NULL,
[RecoverScore] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_SurePlacement_Scores] ADD CONSTRAINT [PK_Services_SurePlacement_Scores] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
