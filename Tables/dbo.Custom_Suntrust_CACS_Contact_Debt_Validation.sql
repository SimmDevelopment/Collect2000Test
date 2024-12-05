CREATE TABLE [dbo].[Custom_Suntrust_CACS_Contact_Debt_Validation]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[ThirdPartyID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LocationCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcctNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastUpdate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AsOfDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AsOfDateDescription] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BalanceOnAOD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IntChgSinceAOD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FeesChgSinceAOD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OthDebtsSinceAOD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PaysSinceAOD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherCreditSinceAOD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrBalanceOnLastUpdate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Suntrust_CACS_Contact_Debt_Validation] ADD CONSTRAINT [Custom_Suntrust_CACS_Contact_Debt_Validation1] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
