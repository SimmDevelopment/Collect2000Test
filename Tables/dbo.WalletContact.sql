CREATE TABLE [dbo].[WalletContact]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[WalletId] [int] NOT NULL,
[AccountAddress1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountAddress2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountCity] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountState] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountZipcode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankAddress] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankCity] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankState] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankZipcode] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankPhone] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WalletContact] ADD CONSTRAINT [PK_WalletContact] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
