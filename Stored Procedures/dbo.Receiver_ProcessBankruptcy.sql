SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Receiver_ProcessBankruptcy]
@client_id int,
@debtor_number int,--OK
@file_number int,--OK
@chapter int,--OK
@date_filed datetime,--OK
@case_number varchar(20),--OK
@court_district varchar(200) = NULL,-- Might be NULL
@court_division varchar(100) = NULL,--OK
@court_phone varchar(50) = NULL,--OK
@court_street1 varchar(50) = NULL,--OK
@court_street2 varchar(50) = NULL,--OK
@court_city varchar(50) = NULL,--OK
@court_state varchar(3) = NULL,--OK
@court_zipcode varchar(15) = NULL,--OK
@trustee varchar(50) = NULL,--OK
@trustee_street1 varchar(50) = NULL,--OK
@trustee_street2 varchar(50) = NULL,--OK
@trustee_city varchar(50) = NULL,--OK
@trustee_state varchar(3) = NULL,--OK
@trustee_zipcode varchar(10) = NULL,--OK
@trustee_phone varchar(30) = NULL,--OK
@three_forty_one_info_flag varchar(1),--OK
@three_forty_one_date datetime,--OK
@three_forty_one_location varchar(200),--OK
@comments varchar(500),--OK
@status varchar(100),--OK
@transmit_date smalldatetime,--OK
@notice_date datetime = NULL,
@proof_filed_date datetime = NULL,
@discharge_date datetime = NULL,
@dismissal_date datetime = NULL,
@confirmation_hearing_date datetime = NULL,
@reaffirm_filed_date datetime = NULL,
@voluntary_date datetime = NULL,
@surrender_date datetime = NULL,
@auction_date datetime = NULL,
@reaffirm_amount money = NULL,
@voluntary_amount money = NULL,
@auction_amount money = NULL,
@auction_fee_amount money = NULL,
@auction_applied_amount money = NULL,
@secured_amount money = NULL,
@secured_percentage smallmoney = NULL,
@unsecured_amount money = NULL,
@unsecured_percentage smallmoney = NULL,
@converted_from_chapter tinyint = NULL,
@has_asset varchar(1) = NULL,
@reaffirm_flag char(1) = NULL,
@reaffirm_terms varchar(50) = NULL,
@voluntary_terms varchar(50) = NULL,
@surrender_method varchar(50) = NULL,
@auction_house varchar(50) = NULL
AS
BEGIN
	DECLARE @receiverNumber INT
	SELECT @receivernumber = max(receivernumber) FROM receiver_reference WITH (NOLOCK) WHERE sendernumber = @file_number and clientid = @client_id
	IF(@receivernumber is null)
	BEGIN
		RAISERROR ('15001', 16, 1)
		RETURN
	END

	DECLARE @dnumber int
	select @dnumber = max(receiverdebtorid )
	from receiver_debtorreference rd with (nolock)
	join debtors d with (nolock) on rd.receiverdebtorid = d.debtorid
	where senderdebtorid = @debtor_number
	and clientid = @client_id

	IF(@dnumber is null)
	BEGIN
		RAISERROR ('15001', 16, 1) -- TODO Which error to raise here?
		RETURN
	END

	DECLARE @Qlevel varchar(5)
	
	SELECT @QLevel = [QLevel] FROM [dbo].[Master] WITH (NOLOCK)
	WHERE [number] = @receiverNumber
	
	IF(@QLevel = '999') 
	BEGIN
		RAISERROR('Account has been returned, QLevel 999.',16,1)
		RETURN
	END
	
	DECLARE @bankoID int
	SELECT @bankoID = [BankruptcyID] 
	FROM [dbo].[Bankruptcy] WITH (NOLOCK)
	WHERE [AccountID] = @receiverNumber 
		AND [DebtorID] = @dnumber
		
	-- An Insert??
	IF(@bankoID IS NULL) 
	BEGIN
	
		INSERT INTO [dbo].[Bankruptcy]
		(
		[AccountID],
		[DebtorID],
		[Chapter],
		[DateFiled],
		[CaseNumber],
		[CourtCity],
		[CourtDistrict],
		[CourtDivision],
		[CourtPhone],
		[CourtStreet1],
		[CourtStreet2],
		[CourtState],
		[CourtZipcode],
		[Trustee],
		[TrusteeStreet1],
		[TrusteeStreet2],
		[TrusteeCity],
		[TrusteeState],
		[TrusteeZipcode],
		[TrusteePhone],
		[Has341Info],
		[DateTime341],
		[Location341],
		[Comments],
		[Status],
		[TransmittedDate],
		[ConvertedFrom],
		[DateNotice],
		[ProofFiled],
		[DischargeDate],
		[DismissalDate],
		[ConfirmationHearingDate],
		[HasAsset],
		[Reaffirm],
		[ReaffirmDateFiled],
		[ReaffirmAmount],
		[ReaffirmTerms],
		[VoluntaryDate],
		[VoluntaryAmount],
		[VoluntaryTerms],
		[SurrenderDate],
		[SurrenderMethod],
		[AuctionHouse],
		[AuctionDate],
		[AuctionAmount],
		[AuctionFee],
		[AuctionAmountApplied],
		[SecuredAmount],
		[SecuredPercentage],
		[UnsecuredAmount],
		[UnsecuredPercentage],
		[ctl])
		VALUES
		(@receiverNumber, --[AccountID] [int] NOT NULL,
		@dnumber, --[DebtorID] [int] NOT NULL,
		@chapter, --[Chapter] [tinyint] NULL,
		@date_filed,--[DateFiled] [datetime] NULL,
		ISNULL(@case_number,''), --[CaseNumber] [varchar](20) NOT NULL,
		ISNULL(@court_city,''), --[CourtCity] [varchar](50) NOT NULL,
		ISNULL(@court_district,''),--[CourtDistrict] [varchar](200) NOT NULL,
		--'',--[CourtDistrict] [varchar](200) NOT NULL,
		ISNULL(@court_division,''),--[CourtDivision] [varchar](100) NOT NULL,
		ISNULL(@court_phone,''),--[CourtPhone] [varchar](50) NOT NULL,
		ISNULL(@court_street1,''),--[CourtStreet1] [varchar](50) NOT NULL,
		ISNULL(@court_street2,''),--[CourtStreet2] [varchar](50) NOT NULL,
		ISNULL(@court_state,''),--[CourtState] [varchar](3) NOT NULL,
		ISNULL(@court_zipcode,''),--[CourtZipcode] [varchar](15) NOT NULL,
		ISNULL(@trustee,''),--[Trustee] [varchar](50) NOT NULL,
		ISNULL(@trustee_street1,''),--[TrusteeStreet1] [varchar](50) NOT NULL,
		ISNULL(@trustee_street2,''),--[TrusteeStreet2] [varchar](50) NOT NULL,
		ISNULL(@trustee_city,''),--[TrusteeCity] [varchar](100) NOT NULL,
		ISNULL(@trustee_state,''),--[TrusteeState] [varchar](3) NOT NULL,
		ISNULL(@trustee_zipcode,''),--[TrusteeZipcode] [varchar](10) NOT NULL,
		ISNULL(@trustee_phone,''),--[TrusteePhone] [varchar](30) NOT NULL,
		CASE WHEN @three_forty_one_info_flag IN('1','Y','T') THEN 1 ELSE 0 END, --[Has341Info] [bit] NOT NULL CONSTRAINT [DF_Bankruptcy_Has341Info]  DEFAULT (0),
		@three_forty_one_date,--[DateTime341] [datetime] NULL,
		ISNULL(@three_forty_one_location,''),--[Location341] [varchar](200) NOT NULL,
		ISNULL(@comments,''),--[Comments] [varchar](500) NOT NULL,
		ISNULL(@status,''),--[Status] [varchar](100) NOT NULL,
		@transmit_date,--[TransmittedDate] [smalldatetime] NULL,
		@converted_from_chapter,--[ConvertedFrom] [tinyint] NULL,
		@notice_date,--[DateNotice] [datetime] NULL,
		@proof_filed_date,--[ProofFiled] [datetime] NULL,
		@discharge_date,--[DischargeDate] [datetime] NULL,
		@dismissal_date,--[DismissalDate] [datetime] NULL,
		@confirmation_hearing_date,--[ConfirmationHearingDate] [datetime] NULL,
		CASE WHEN @has_asset IN('1','Y','T') THEN 1 ELSE 0 END,--[HasAsset] [bit] NULL,
		@reaffirm_flag,--[Reaffirm] [char](1) NULL,
		@reaffirm_filed_date,--[ReaffirmDateFiled] [datetime] NULL,
		@reaffirm_amount,--[ReaffirmAmount] [money] NULL,
		@reaffirm_terms,--[ReaffirmTerms] [varchar](50) NULL,
		@voluntary_date,--[VoluntaryDate] [datetime] NULL,
		@voluntary_amount,--[VoluntaryAmount] [money] NULL,
		@voluntary_terms,--[VoluntaryTerms] [varchar](50) NULL,
		@surrender_date,--[SurrenderDate] [datetime] NULL,
		@surrender_method,--[SurrenderMethod] [varchar](50) NULL,
		@auction_house,--[AuctionHouse] [varchar](50) NULL,
		@auction_date,--[AuctionDate] [datetime] NULL,
		@auction_amount,--[AuctionAmount] [money] NULL,
		@auction_fee_amount,--[AuctionFee] [money] NULL,
		@auction_applied_amount,--[AuctionAmountApplied] [money] NULL,
		@secured_amount,--[SecuredAmount] [money] NULL,
		@secured_percentage,--[SecuredPercentage] [smallmoney] NULL,
		@unsecured_amount,--[UnsecuredAmount] [money] NULL,
		@unsecured_percentage,--[UnsecuredPercentage] [smallmoney] NULL,
		'AIM' --[ctl] [varchar](3) NULL,		
		)
		
	END
	-- Otherwise an Update
	ELSE
	BEGIN
		UPDATE [dbo].[Bankruptcy]
		SET [Chapter] = @chapter,-- [tinyint] NULL,
		[DateFiled] = @date_filed,--[datetime] NULL,
		[CaseNumber] = ISNULL(@case_number,''), --[varchar](20) NOT NULL,
		[CourtCity] = ISNULL(@court_city,''), --[CourtCity] [varchar](50) NOT NULL,
		[CourtDistrict] = ISNULL(@court_district,''),--[CourtDistrict] [varchar](200) NOT NULL,
		[CourtDivision] = ISNULL(@court_division,''),--[CourtDivision] [varchar](100) NOT NULL,
		[CourtPhone] = ISNULL(@court_phone,''),--[CourtPhone] [varchar](50) NOT NULL,
		[CourtStreet1] = ISNULL(@court_street1,''),--[CourtStreet1] [varchar](50) NOT NULL,
		[CourtStreet2] = ISNULL(@court_street2,''),--[CourtStreet2] [varchar](50) NOT NULL,
		[CourtState] = ISNULL(@court_state,''),--[CourtState] [varchar](3) NOT NULL,
		[CourtZipcode] = ISNULL(@court_zipcode,''),--[CourtZipcode] [varchar](15) NOT NULL,
		[Trustee] = ISNULL(@trustee,''),--[Trustee] [varchar](50) NOT NULL,
		[TrusteeStreet1] = ISNULL(@trustee_street1,''),--[TrusteeStreet1] [varchar](50) NOT NULL,
		[TrusteeStreet2] = ISNULL(@trustee_street2,''),--[TrusteeStreet2] [varchar](50) NOT NULL,
		[TrusteeCity] = ISNULL(@trustee_city,''),--[TrusteeCity] [varchar](100) NOT NULL,
		[TrusteeState] = ISNULL(@trustee_state,''),--[TrusteeState] [varchar](3) NOT NULL,
		[TrusteeZipcode] = ISNULL(@trustee_zipcode,''),--[TrusteeZipcode] [varchar](10) NOT NULL,
		[TrusteePhone] = ISNULL(@trustee_phone,''),--[TrusteePhone] [varchar](30) NOT NULL,
		[Has341Info] = CASE WHEN @three_forty_one_info_flag IN('1','Y','T') THEN 1 ELSE 0 END, --[Has341Info] [bit] NOT NULL CONSTRAINT [DF_Bankruptcy_Has341Info]  DEFAULT (0),
		[DateTime341] = @three_forty_one_date,--[DateTime341] [datetime] NULL,
		[Location341] = ISNULL(@three_forty_one_location,''),--[Location341] [varchar](200) NOT NULL,
		[Comments] = ISNULL(@comments,''),--[Comments] [varchar](500) NOT NULL,
		[Status] = ISNULL(@status,''),--[Status] [varchar](100) NOT NULL,
		[TransmittedDate] = @transmit_date,--[TransmittedDate] [smalldatetime] NULL,
		[ConvertedFrom] = @converted_from_chapter,--[ConvertedFrom] [tinyint] NULL,
		[DateNotice] = @notice_date,--[DateNotice] [datetime] NULL,
		[ProofFiled] = @proof_filed_date,--[ProofFiled] [datetime] NULL,
		[DischargeDate] = @discharge_date,--[DischargeDate] [datetime] NULL,
		[DismissalDate] = @dismissal_date,--[DismissalDate] [datetime] NULL,
		[ConfirmationHearingDate] = @confirmation_hearing_date,--[ConfirmationHearingDate] [datetime] NULL,
		[HasAsset] = CASE WHEN @has_asset IN('1','Y','T') THEN 1 ELSE 0 END,--[HasAsset] [bit] NULL,
		[Reaffirm] = @reaffirm_flag,--[Reaffirm] [char](1) NULL,
		[ReaffirmDateFiled] = @reaffirm_filed_date,--[ReaffirmDateFiled] [datetime] NULL,
		[ReaffirmAmount] = @reaffirm_amount,--[ReaffirmAmount] [money] NULL,
		[ReaffirmTerms] = @reaffirm_terms,--[ReaffirmTerms] [varchar](50) NULL,
		[VoluntaryDate] = @voluntary_date,--[VoluntaryDate] [datetime] NULL,
		[VoluntaryAmount] = @voluntary_amount,--[VoluntaryAmount] [money] NULL,
		[VoluntaryTerms] = @voluntary_terms,--[VoluntaryTerms] [varchar](50) NULL,
		[SurrenderDate] = @surrender_date,--[SurrenderDate] [datetime] NULL,
		[SurrenderMethod] = @surrender_method,--[SurrenderMethod] [varchar](50) NULL,
		[AuctionHouse] = @auction_house,--[AuctionHouse] [varchar](50) NULL,
		[AuctionDate] = @auction_date,--[AuctionDate] [datetime] NULL,
		[AuctionAmount] = @auction_amount,--[AuctionAmount] [money] NULL,
		[AuctionFee] = @auction_fee_amount,--[AuctionFee] [money] NULL,
		[AuctionAmountApplied] = @auction_applied_amount,--[AuctionAmountApplied] [money] NULL,
		[SecuredAmount] = @secured_amount,--[SecuredAmount] [money] NULL,
		[SecuredPercentage] = @secured_percentage,--[SecuredPercentage] [smallmoney] NULL,
		[UnsecuredAmount] = @unsecured_amount,--[UnsecuredAmount] [money] NULL,
		[UnsecuredPercentage] = @unsecured_percentage, --[UnsecuredPercentage] [smallmoney] NULL,
		[Ctl] = 'AIM'
		WHERE [BankruptcyID] = @bankoID 
	END
END

GO
