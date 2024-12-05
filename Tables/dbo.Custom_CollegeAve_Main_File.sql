CREATE TABLE [dbo].[Custom_CollegeAve_Main_File]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SEQID_LOAN] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACCOUNT_BALANCE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AMOUNT_DUE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AMOUNT_PAST_DUE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DAYS_LATE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAST_PAYMENT_DATE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAST_PAYMENT_AMOUNT] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ItemizationDte] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InterestSinceItemizationAmt] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FeesSinceItemizationAmt] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PaymentsAndAdjsSinceItemizationAmt] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LOAN_PROGRAM] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LOAN_STATUS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LOAN_STATE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FULL_NAME] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDRESS_LINE_1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDRESS_LINE_2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CITY] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STATE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP4] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COUNTRY] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PROVINCE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FOREIGN_POSTAL_CODE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TELEPHONE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HOME_PHONE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CELL_PHONE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WORK_PHONE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WORK_PHONE_EXT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMAIL_PRIMARY] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COSIGNER_FULL_NAME] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COSIGNER_ADDRESS_LINE_1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COSIGNER_ADDRESS_LINE_2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COSIGNER_CITY] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COSIGNER_STATE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COSIGNER_ZIP] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COSIGNER_ZIP4] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COSIGNER_COUNTRY] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COSIGNER_PROVINCE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COSIGNER_FOREIGN_POSTAL_CODE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COSIGNER_DOB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COSIGNER_TELEPHONE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COSIGNER_HOME_PHONE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COSIGNER_CELL_PHONE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COSIGNER_WORK_PHONE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COSIGNER_WORK_PHONE_EXT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COSIGNER_EMAIL_PRIMARY] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriSSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoSSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SEQID_BORROWER] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NEW_FULL_PI_IND] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NO_PREV_PAYMENT_FLAG] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[current_creditor] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EnrollmentStatus] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SegmentationPriorityCatg] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BORROWER_PREFERRED_NOTIFICATION_CHANNEL] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COSIGNER_PREFERRED_NOTIFICATION_CHANNEL] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DelinqStage] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EOM_DAYS_LATE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EOMDelinqStage] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_CollegeAve_Main_File] ADD CONSTRAINT [PK_Custom_CollegeAve_Main_File] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO