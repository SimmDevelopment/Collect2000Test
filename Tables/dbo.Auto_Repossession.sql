CREATE TABLE [dbo].[Auto_Repossession]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[Status] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__Auto_Repo__Statu__6F85E603] DEFAULT ('Unassigned'),
[DateRepoAssigned] [datetime] NULL,
[DateintoStorage] [datetime] NULL,
[CollateralCondition] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__Auto_Repo__Colla__707A0A3C] DEFAULT ('Average'),
[CollateralDrivable] [bit] NULL CONSTRAINT [DF__Auto_Repo__Colla__716E2E75] DEFAULT ((0)),
[CollateralLeaseEndRepo] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__Auto_Repo__Colla__726252AE] DEFAULT ('Lease End'),
[CollateralRedeemedby] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CollateralRepoCode] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CollatoralStorageLocation] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCollateralReleasedtoBuyer] [datetime] NULL,
[CollateralReleased] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__Auto_Repo__Colla__735676E7] DEFAULT ('Voluntary'),
[RepoAddress1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RepoAddress2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RepoCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RepoState] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RepoZipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateRepoCompleted] [datetime] NULL,
[RedemptionDate] [datetime] NULL,
[RedemptionAmount] [money] NULL CONSTRAINT [DF__Auto_Repo__Redem__744A9B20] DEFAULT ((0)),
[StorageComments] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgencyName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgencyPhone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BalanceAtRepo] [money] NULL,
[RepoFees] [money] NULL,
[PropertyStorageFee] [money] NULL,
[KeyCutFee] [money] NULL,
[MiscFees] [money] NULL,
[ImpoundFee] [money] NULL,
[RepoExpenses] [money] NULL,
[PoliceEntity] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Auto_Repossession] ADD CONSTRAINT [PK_Auto_Repossession] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
