CREATE TABLE [bck].[debtor_assets_Remove_brianm_12052023_164212]
(
[historyid] [int] NOT NULL,
[ID] [int] NOT NULL,
[AccountID] [int] NOT NULL,
[DebtorID] [int] NOT NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AssetType] [tinyint] NOT NULL,
[Description] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CurrentValue] [money] NULL,
[LienAmount] [money] NULL,
[ValueVerified] [bit] NOT NULL,
[LienVerified] [bit] NOT NULL,
[OutsideAssetID] [int] NULL,
[Created] [datetime] NOT NULL,
[Modified] [datetime] NOT NULL,
[ModifiedBy] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
