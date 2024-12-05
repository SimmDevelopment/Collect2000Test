CREATE TABLE [dbo].[SettlementOffers]
(
[Id] [uniqueidentifier] NOT NULL,
[AccountId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PolicyId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExpirationDate] [datetime] NOT NULL,
[Priority] [int] NOT NULL,
[Description] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TotalAmount] [money] NOT NULL,
[IsSettlement] [bit] NOT NULL,
[Tier] [int] NOT NULL,
[Code] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UtcCreated] [datetime] NOT NULL,
[UtcUpdated] [datetime] NOT NULL,
[UtcConverted] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SettlementOffers] ADD CONSTRAINT [PK_SettlementOffers] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
