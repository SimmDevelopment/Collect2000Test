CREATE TABLE [dbo].[Services_LexisNexis_CAC]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[UniqueID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MiddleInitial] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Suffix] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StreetAddress] [varchar] (59) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SocialSecurityNumber] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerEquifaxMemebrNumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumberUnpaidStudentLoansInGoodStanding] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EquifaxCurrentAddress] [varchar] (55) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EquifaxCurrentCity] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EquifaxCurrentState] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EquifaxCurrentZip] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Former1EquifaxAddress] [varchar] (55) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Former1EquifaxCity] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Former1EquifaxState] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Former1EquifaxZip] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Former2EquifaxAddress] [varchar] (55) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Former2EquifaxCity] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Former2EquifaxState] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Former2EquifaxZip] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SingleMostRecentPhone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[POE-CompanyName] [varchar] (45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[POE-CompanyAddressCity] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[POE-CompanyState] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OpenToBuyBankcardTrades] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NewBankcardInTheLast6Months] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumberOfThirdPartyCollectionsInTheLast6Months] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HighestBalanceOnMortgageTradeline] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[New1stMortgageInTheLast6Months] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HighCreditOfOpenAutoLoans] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AutoLoanUtilization] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClosedAuto-NoNewAuto] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NameAndDateOfTwoMostRecentRegularInuires] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OpenToBuyPersonalFinance] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OpenToBuyHELOC] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumberOfUnpaid3rdPartyCollections] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AggregateBalanceOnUnpaid3rdPartyCollections] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AggregateMonthlyPaymentForOpenTradelinesWithDrIn12Months] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalDerogTradelines] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalTradelinesWith30DaysPAstDueInPast24Months] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalTradelinesWith60DaysPAstDueInPast24Months] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalTradelinesWith90DaysPAstDueInPast24Months] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalTradelinesWith120-180DaysPAstDueInPast24Months] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BalanceOfAllHELOCTradelines] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PresenceOf1stMortgageTradeline] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HighCreditOf1stMortgage] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PresenceOfAutoLoan] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumberOfOpenAutoLoans] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BalanceOfOpenAutoLoans] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SatJudgements/LiensIndicator] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumberOfJudgement] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AggregatDollarAmountOfJudgment] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumberOfTaxLiens] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AggregateDollarAmountOfTaxLiens] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[1stMortgageCreditorName1] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[1stMortgageCreditorName2] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[1stMortgageHighCredit1] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[1stMortgageHighCredit2] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[1stMortgageDate1] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[1stMortgageDate2] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[1stMortgageBalance1] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[1stMortgageBalance2] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2ndMortgageCreditorName1] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2ndMortgageCreditorName2] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2ndMortgageHighCredit1] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2ndMortgageHighCredit2] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2ndMortgageDate1] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2ndMortgageDate2] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2ndMortgageBalance1] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2ndMortgageBalance2] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankcardCreditorName1] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankcardCreditorName2] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankcardCreditorName3] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankcardCreditorName4] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankcardCreditorName5] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankcardBalance1] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankcardBalance2] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankcardBalance3] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankcardBalance4] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankcardBalance5] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankcardHighCredit1] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankcardHighCredit2] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankcardHighCredit3] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankcardHighCredit4] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankcardHighCredit5] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecoveryScore] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EqSequenceNumber] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FactaFraudAlertIndicator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FactaFraudAlertCodeIndicator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FactaAlertCodeIndicator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FactaAddressDiscrepancyIndicator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EquifaxMDBSocialSecurityNumber] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_LexisNexis_CAC] ADD CONSTRAINT [PK_Services_LexisNexis_CAC] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO