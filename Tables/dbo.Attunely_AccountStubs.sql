CREATE TABLE [dbo].[Attunely_AccountStubs]
(
[AccountKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UniverseKey] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordTime] [datetime2] NOT NULL,
[PortfolioKey] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attunely_AccountStubs] ADD CONSTRAINT [PK_Attunely_AccountStubs] PRIMARY KEY CLUSTERED ([AccountKey]) ON [PRIMARY]
GO
