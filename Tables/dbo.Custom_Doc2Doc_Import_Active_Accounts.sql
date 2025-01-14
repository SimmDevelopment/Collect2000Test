CREATE TABLE [dbo].[Custom_Doc2Doc_Import_Active_Accounts]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[FileDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServicerSubAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServicerAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Servicer] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Entity] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubEntity] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GS2AccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AltLoanID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoanType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Principal_Balance_Outstanding] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Interest_Balance_Outstanding] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fees_Balance_Outstanding] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Total_Balance_Outstanding] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalAmountDue] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InterestRate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OriginationDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastPaymentDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastPaymentAmount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DaysDelinquent] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DelinquencyDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScheduledPaymentAmount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GraduationDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DefermentMonthsAvailable] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeferementTypesAvailable] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ForbearanceMonthsAvailable] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastForbearanceEndDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CloseReason] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReOpenReason] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OriginalSchoolName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastSchoolName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerBenefitFlag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RepaymentPlan] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Guarantor] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Offer1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Offer2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Offer3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InternationalBorrowerFlag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerSSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerDOB] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerFirstName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerMiddleName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerLastName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerSuffix] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerValidAddressFlag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerAddress1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerAddress2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerCity] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerState] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerZip] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerHomePhone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerWorkPhone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerCellPhone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerOtherPhone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerEmail1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerEmail2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerLexisNexisFlag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower1SSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Coborrower1DOB] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower1FirstName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower1MiddleName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower1LastName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower1Suffix] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower1ValidAddressFlag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower1Address1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower1Address2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower1City] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower1State] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower1Zip] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower1HomePhone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower1WorkPhone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower1CellPhone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower1OtherPhone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower1Email1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower1Email2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower1LexisNexisFlag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower2SSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower2DOB] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower2FirstName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower2MiddleName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower2LastName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower2Suffix] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower2ValidAddressFlag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower2Address1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower2Address2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower2City] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower2State] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower2Zip] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower2HomePhone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower2WorkPhone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower2CellPhone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower2OtherPhone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower2Email1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower2Email2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrower2LexisNexisFlag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reference1FirstName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reference1MiddleName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reference1LastName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reference1Suffix] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reference1Address1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reference1Address2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reference1City] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reference1State] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reference1Zip] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reference1HomePhone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reference1WorkPhone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reference1CellPhone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reference1OtherPhone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reference1Email1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reference1Email2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reference2FirstName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reference2MiddleName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reference2LastName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reference2Suffix] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reference2Address1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reference2Address2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reference2City] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reference2State] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reference2Zip] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reference2HomePhone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reference2WorkPhone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reference2CellPhone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reference2OtherPhone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reference2Email1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reference2Email2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoanGroup] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoanGroupid] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StatusCodes] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FullyAmortizedPaymentAmount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreDeterminedbalanceafterTaxCredit] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Month15ExpirationDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EntityofInstaller] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InstallerPhoneNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Commentslatest] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CompletionCertificationDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShutOffRequestDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CancelShutOffRequestDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Payment_Plan] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SpecialPaymentPlan] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SPPMonthlyPay] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerLanguagePreference] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrowerLanguagePreference] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ItemizationDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalBalanceOnItemizationDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PaymentsSinceItemizationDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InterestAccruedSinceItemizationDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FeesSinceItemizationDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreditsSinceItemizationDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrentTotalBalance] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Doc2Doc_Import_Active_Accounts] ADD CONSTRAINT [PK_Custom_Doc2Doc_Import_Active_Accounts] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
