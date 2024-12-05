CREATE TABLE [dbo].[Attunely_Portfolios]
(
[PortfolioKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UniverseKey] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Client] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DefaultOriginatorClass_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PortfolioClass_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriorPlacements] [int] NOT NULL,
[Status_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordTime] [datetime2] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attunely_Portfolios] ADD CONSTRAINT [PK_Attunely_Portfolios] PRIMARY KEY CLUSTERED ([PortfolioKey]) ON [PRIMARY]
GO
