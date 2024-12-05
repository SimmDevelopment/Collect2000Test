SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Receiver_ProcessAutoRepossession]
@client_id int,
@file_number int,
@Status [varchar](30),
@DateRepoAssigned [datetime],
@DateintoStorage [datetime],
@CollateralCondition [varchar](30),
@CollateralDrivable [varchar](1),
@CollateralLeaseEndRepo  [varchar](30),
@CollateralRedeemedby [varchar](40),
@CollateralRepoCode [varchar](30),
@CollatoralStorageLocation [varchar](100),
@DateCollateralReleasedtoBuyer [datetime],
@CollateralReleased [varchar](30),
@RepoAddress1 [varchar](30),
@RepoAddress2 [varchar](30),
@RepoCity [varchar](50),
@RepoState [char](2),
@RepoZipcode [varchar](9),
@DateRepoCompleted [datetime],
@RedemptionDate [datetime],
@RedemptionAmount [money],
@StorageComments [varchar](300),
@AgencyName [varchar](30),
@AgencyPhone [varchar](50),
@BalanceAtRepo [money],
@RepoFees [money],
@PropertyStorageFee [money],
@KeyCutFee [money],
@MiscFees [money],
@ImpoundFee [money],
@RepoExpenses [money],
@PoliceEntity varchar(100)
AS
BEGIN

	DECLARE @receiverNumber INT
	SELECT @receivernumber = max(receivernumber) FROM receiver_reference WITH (NOLOCK) WHERE sendernumber = @file_number and clientid = @client_id
	IF(@receivernumber is null)
	BEGIN
		RAISERROR ('15001', 16, 1)
		RETURN
	END

	DECLARE @Qlevel varchar(5)

	SELECT @QLevel = [QLevel] FROM [dbo].[Master] WITH (NOLOCK)
	WHERE [number] = @receivernumber

	IF(@QLevel = '999') 
	BEGIN
		RAISERROR('Account has been returned, QLevel 999.',16,1)
		RETURN
	END

	IF NOT EXISTS(SELECT * FROM [Auto_Repossession]  (NOLOCK) WHERE [AccountID] = @receiverNumber) 
	BEGIN
		INSERT INTO [dbo].[Auto_Repossession](
		[AccountID],
		[Status],
		[DateRepoAssigned],
		[DateintoStorage],
		[CollateralCondition],
		[CollateralDrivable],
		[CollateralLeaseEndRepo],
		[CollateralRedeemedby],
		[CollateralRepoCode],
		[CollatoralStorageLocation],
		[DateCollateralReleasedtoBuyer],
		[CollateralReleased],
		[RepoAddress1],
		[RepoAddress2],
		[RepoCity],
		[RepoState],
		[RepoZipcode],
		[DateRepoCompleted],
		[RedemptionDate],
		[RedemptionAmount],
		[StorageComments],
		[AgencyName],
		[AgencyPhone],
		[BalanceAtRepo],
		[RepoFees],
		[PropertyStorageFee],
		[KeyCutFee],
		[MiscFees],
		[ImpoundFee],
		[RepoExpenses],
		[PoliceEntity])
		
		SELECT
		@receiverNumber,--[AccountID] [int] NOT NULL,
		@Status,--[Status] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Auto_Repossession_Status]  DEFAULT ('Unassigned'),
		@DateRepoAssigned,--[DateRepoAssigned] [datetime] NULL,
		@DateintoStorage,--[DateintoStorage] [datetime] NULL,
		@CollateralCondition,--[CollateralCondition] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Auto_Repossession_CollateralCondition]  DEFAULT ('Average'),
		CASE WHEN @CollateralDrivable IN('1','Y','T') THEN 1 ELSE 0 END,--[CollateralDrivable] [bit] NULL CONSTRAINT [DF_Auto_Repossession_CollateralDrivable]  DEFAULT ((0)),
		@CollateralLeaseEndRepo,--[CollateralLeaseEndRepo] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Auto_Repossession_CollateralLeaseEndRepo]  DEFAULT ('Lease End'),
		@CollateralRedeemedby,--[CollateralRedeemedby] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		@CollateralRepoCode,--[CollateralRepoCode] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		@CollatoralStorageLocation,--[CollatoralStorageLocation] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		@DateCollateralReleasedtoBuyer,--[DateCollateralReleasedtoBuyer] [datetime] NULL,
		@CollateralReleased,--[CollateralReleased] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Auto_Repossession_CollateralReleased]  DEFAULT ('Voluntary'),
		@RepoAddress1,--[RepoAddress1] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		@RepoAddress2,--[RepoAddress2] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		@RepoCity,--[RepoCity] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		@RepoState,--[RepoState] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		@RepoZipcode,--[RepoZipcode] [varchar](9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		@DateRepoCompleted,--[DateRepoCompleted] [datetime] NULL,
		@RedemptionDate,--[RedemptionDate] [datetime] NULL,
		@RedemptionAmount,--[RedemptionAmount] [money] NULL CONSTRAINT [DF_Auto_Repossession_RedemptionAmount]  DEFAULT ((0)),
		@StorageComments,--[StorageComments] [varchar](300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		@AgencyName,--[AgencyName] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		@AgencyPhone,--[AgencyPhone] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		@BalanceAtRepo,--[BalanceAtRepo] [money] NULL,
		@RepoFees,--[RepoFees] [money] NULL,
		@PropertyStorageFee,--[PropertyStorageFee] [money] NULL,
		@KeyCutFee,--[KeyCutFee] [money] NULL,
		@MiscFees,--[MiscFees] [money] NULL,
		@ImpoundFee,--[ImpoundFee] [money] NULL,
		@RepoExpenses,--[RepoExpenses] [money] NULL,
		@PoliceEntity--[PoliceEntity] varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	END
END

GO
