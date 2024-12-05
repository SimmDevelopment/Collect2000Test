SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Attunely_GetNextBatch]
	@StartDate DATETIME,
	@EndDate DATETIME
AS
BEGIN
	DECLARE @AccountStubs INT
	DECLARE @LatestAccountStub DATETIME
	DECLARE @Agents INT
	DECLARE @LatestAgent DATETIME
	DECLARE @Attributes INT
	DECLARE @LatestAttribute DATETIME
	DECLARE @Calls INT
	DECLARE @LatestCall DATETIME
	DECLARE @ContactAddresses INT
	DECLARE @LatestContactAddress DATETIME
	DECLARE @ContactEmails INT
	DECLARE @LatestContactEmail DATETIME
	DECLARE @ContactPhones INT
	DECLARE @LatestContactPhone DATETIME
	DECLARE @Debts INT
	DECLARE @LatestDebt DATETIME
	DECLARE @Emails INT
	DECLARE @LatestEmail DATETIME
	DECLARE @Events INT
	DECLARE @LatestEvent DATETIME
	DECLARE @LegalActions INT
	DECLARE @LatestLegalAction DATETIME
	DECLARE @LegalComplaints INT
	DECLARE @LatestLegalComplaint DATETIME
	DECLARE @Letters INT
	DECLARE @LatestLetter DATETIME
	DECLARE @MappedCalls INT
	DECLARE @LatestMappedCall DATETIME
	DECLARE @Modifiers INT
	DECLARE @LatestModifier DATETIME
	DECLARE @Payments INT
	DECLARE @LatestPayment DATETIME
	DECLARE @Portfolios INT
	DECLARE @LatestPortfolio DATETIME
	DECLARE @ScheduledPayments INT
	DECLARE @LatestScheduledPayment DATETIME
	DECLARE @Smses INT
	DECLARE @LatestSms DATETIME

	SELECT TOP 1 @LatestAccountStub = LastAccountStubDate,
		@LatestAgent = LastAgentDate,
		@LatestAttribute = LastAttributeDate,
		@LatestCall = LastCallDate,
		@LatestContactAddress = LastContactAddressDate,
		@LatestContactEmail = LastContactEmailDate,
		@LatestContactPhone = LastContactPhoneDate,
		@LatestDebt = LastDebtDate,
		@LatestEmail = LastEmailDate,
		@LatestEvent = LastEventDate,
		@LatestLegalAction = LastLegalActionDate,
		@LatestLegalComplaint = LastLegalComplaintDate,
		@LatestLetter = LastLetterDate,
		@LatestMappedCall = LastMappedCallDate,
		@LatestModifier = LastModifierDate,
		@LatestPayment = LastPaymentDate,
		@LatestPortfolio = LastPortfolioDate,
		@LatestScheduledPayment = LastScheduledPaymentDate,
		@LatestSms = LastSmsDate
	FROM Attunely_BatchMasters 
	ORDER BY CreatedDate DESC

	DECLARE @TestDate DATETIME
		SELECT @AccountStubs = COUNT(*), @TestDate = MAX(RecordTime) FROM Attunely_AccountStubs WHERE RecordTime > @StartDate AND RecordTime <= @EndDate
	IF (@TestDate IS NOT NULL) SET @LatestAccountStub = @TestDate
	SELECT @Agents = COUNT(*), @TestDate = MAX(RecordTime) FROM Attunely_Agents WHERE RecordTime > @StartDate AND RecordTime <= @EndDate
	IF (@TestDate IS NOT NULL) SET @LatestAgent = @TestDate
	SELECT @Attributes = COUNT(*), @TestDate = MAX(RecordTime) FROM Attunely_Attributes WHERE RecordTime > @StartDate AND RecordTime <= @EndDate
	IF (@TestDate IS NOT NULL) SET @LatestAttribute = @TestDate
	SELECT @Calls = COUNT(*), @TestDate = MAX(RecordTime) FROM Attunely_Calls WHERE RecordTime > @StartDate AND RecordTime <= @EndDate
	IF (@TestDate IS NOT NULL) SET @LatestCall = @TestDate
	SELECT @ContactAddresses = COUNT(*), @TestDate = MAX(RecordTime) FROM Attunely_ContactAddresses WHERE RecordTime > @StartDate AND RecordTime <= @EndDate
	IF (@TestDate IS NOT NULL) SET @LatestContactAddress = @TestDate
	SELECT @ContactEmails = COUNT(*), @TestDate = MAX(RecordTime) FROM Attunely_ContactEmails WHERE RecordTime > @StartDate AND RecordTime <= @EndDate
	IF (@TestDate IS NOT NULL) SET @LatestContactEmail = @TestDate
	SELECT @ContactPhones = COUNT(*), @TestDate = MAX(RecordTime) FROM Attunely_ContactPhones WHERE RecordTime > @StartDate AND RecordTime <= @EndDate
	IF (@TestDate IS NOT NULL) SET @LatestContactPhone = @TestDate
	SELECT @Debts = COUNT(*), @TestDate = MAX(RecordTime) FROM Attunely_Debts WHERE RecordTime > @StartDate AND RecordTime <= @EndDate
	IF (@TestDate IS NOT NULL) SET @LatestDebt = @TestDate
	SELECT @Emails = COUNT(*), @TestDate = MAX(RecordTime) FROM Attunely_Emails WHERE RecordTime > @StartDate AND RecordTime <= @EndDate
	IF (@TestDate IS NOT NULL) SET @LatestEmail = @TestDate
	SELECT @Events = COUNT(*), @TestDate = MAX(RecordTime) FROM Attunely_Events WHERE RecordTime > @StartDate AND RecordTime <= @EndDate
	IF (@TestDate IS NOT NULL) SET @LatestEvent = @TestDate
	SELECT @LegalActions = COUNT(*), @TestDate = MAX(RecordTime) FROM Attunely_LegalActions WHERE RecordTime > @StartDate AND RecordTime <= @EndDate
	IF (@TestDate IS NOT NULL) SET @LatestLegalAction = @TestDate
	SELECT @LegalComplaints = COUNT(*), @TestDate = MAX(RecordTime) FROM Attunely_LegalComplaints WHERE RecordTime > @StartDate AND RecordTime <= @EndDate
	IF (@TestDate IS NOT NULL) SET @LatestLegalComplaint = @TestDate
	SELECT @Letters = COUNT(*), @TestDate = MAX(RecordTime) FROM Attunely_Letters WHERE RecordTime > @StartDate AND RecordTime <= @EndDate
	IF (@TestDate IS NOT NULL) SET @LatestLetter = @TestDate
	SELECT @MappedCalls = COUNT(*), @TestDate = MAX(RecordTime) FROM Attunely_MappedCalls WHERE RecordTime > @StartDate AND RecordTime <= @EndDate
	IF (@TestDate IS NOT NULL) SET @LatestMappedCall = @TestDate
	SELECT @Modifiers = COUNT(*), @TestDate = MAX(RecordTime) FROM Attunely_Modifiers WHERE RecordTime > @StartDate AND RecordTime <= @EndDate
	IF (@TestDate IS NOT NULL) SET @LatestModifier = @TestDate
	SELECT @Payments = COUNT(*), @TestDate = MAX(RecordTime) FROM Attunely_Payments WHERE RecordTime > @StartDate AND RecordTime <= @EndDate
	IF (@TestDate IS NOT NULL) SET @LatestPayment = @TestDate
	SELECT @Portfolios = COUNT(*), @TestDate = MAX(RecordTime) FROM Attunely_Portfolios WHERE RecordTime > @StartDate AND RecordTime <= @EndDate
	IF (@TestDate IS NOT NULL) SET @LatestPortfolio = @TestDate
	SELECT @ScheduledPayments = COUNT(*), @TestDate = MAX(RecordTime) FROM Attunely_ScheduledPayments WHERE RecordTime > @StartDate AND RecordTime <= @EndDate
	IF (@TestDate IS NOT NULL) SET @LatestScheduledPayment = @TestDate
	SELECT @Smses = COUNT(*), @TestDate = MAX(RecordTime) FROM Attunely_Smses WHERE RecordTime > @StartDate AND RecordTime <= @EndDate
	IF (@TestDate IS NOT NULL) SET @LatestSms = @TestDate


	SELECT NEWID() [Id],
		@AccountStubs [AccountStubsReconciled],
		@LatestAccountStub [LastAccountStubDate],
		@Agents [AgentsReconciled],
		@LatestAgent [LastAgentDate],
		@Attributes [AttributesReconciled],
		@LatestAttribute [LastAttributeDate],
		@Calls [CallsReconciled],
		@LatestCall [LastCallDate],
		@ContactAddresses [ContactAddressesReconciled],
		@LatestContactAddress [LastContactAddressDate],
		@ContactEmails [ContactEmailsReconciled],
		@LatestContactEmail [LastContactEmailDate],
		@ContactPhones [ContactPhonesReconciled],
		@LatestContactPhone [LastContactPhoneDate],
		@Debts [DebtsReconciled],
		@LatestDebt [LastDebtDate],
		@Emails [EmailsReconciled],
		@LatestEmail [LastEmailDate],
		@Events [EventsReconciled],
		@LatestEvent [LastEventDate],
		@LegalActions [LegalActionsReconciled],
		@LatestLegalAction [LastLegalActionDate],
		@LegalComplaints [LegalComplaintsReconciled],
		@LatestLegalComplaint [LastLegalComplaintDate],
		@Letters [LettersReconciled],
		@LatestLetter [LastLetterDate],
		@MappedCalls [MappedCallsReconciled],
		@LatestMappedCall [LastMappedCallDate],
		@Modifiers [ModifiersReconciled],
		@LatestModifier [LastModifierDate],
		@Payments [PaymentsReconciled],
		@LatestPayment [LastPaymentDate],
		@Portfolios [PortfoliosReconciled],
		@LatestPortfolio [LastPortfolioDate],
		@ScheduledPayments [ScheduledPaymentsReconciled],
		@LatestScheduledPayment [LastScheduledPaymentDate],
		@Smses [SmsesReconciled],
		@LatestSms [LastSmsDate],
		@EndDate [CreatedDate]
END
GO
