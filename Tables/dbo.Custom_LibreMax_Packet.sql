CREATE TABLE [dbo].[Custom_LibreMax_Packet]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[DateAdded] [datetime] NULL,
[SOC NBR] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PKT NBR] [float] NULL,
[CLIENT CD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PORT NBR] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2ND ACCT NBR] [float] NULL,
[GRAD FACTOR] [float] NULL,
[SEP DT] [datetime] NULL,
[GRACE END DT] [datetime] NULL,
[DEF BEG DT] [datetime] NULL,
[DEF END DT] [datetime] NULL,
[PDG END DT] [datetime] NULL,
[LAST PAY DUE DT] [datetime] NULL,
[ACCRUE THRU DT] [datetime] NULL,
[INT CAP DT] [datetime] NULL,
[ACCRUE STOP DT] [datetime] NULL,
[STATUS EFF DT] [datetime] NULL,
[NEXT PAY DUE DT] [datetime] NULL,
[DELINQ DT] [datetime] NULL,
[DEFAULT DT] [datetime] NULL,
[LAST NOTICE DT] [datetime] NULL,
[CERT DT] [datetime] NULL,
[FIX PAY AMT] [float] NULL,
[CUR DUE AMT] [float] NULL,
[PAST DUE AMT] [float] NULL,
[LAST PRIN PD] [float] NULL,
[LAST INT PD] [float] NULL,
[MAX INT] [float] NULL,
[LATE CHG DUE] [float] NULL,
[LATE CHG PD] [float] NULL,
[LAST LATE CHG PD] [float] NULL,
[GRACE MTHS] [float] NULL,
[PDG MTHS] [float] NULL,
[FORB MTHS] [float] NULL,
[DEF MTHS 1] [float] NULL,
[DEF MTHS 2] [float] NULL,
[DEF MTHS 3] [float] NULL,
[DEF MTHS 4] [float] NULL,
[DEF MTHS 5] [float] NULL,
[DEF MTHS 6] [float] NULL,
[MPI] [float] NULL,
[STATUS] [float] NULL,
[DISB CNT] [float] NULL,
[NEW NOTE DT] [datetime] NULL,
[OLD NOTE DT] [datetime] NULL,
[OLD DISB DT] [datetime] NULL,
[NEW DISB DT] [datetime] NULL,
[NEW SALE DT] [datetime] NULL,
[NEW SCH REF DT] [datetime] NULL,
[NEW CLM FILED DT] [datetime] NULL,
[NEW CLM PD DT] [datetime] NULL,
[NEW CLM REJ DT] [datetime] NULL,
[OLA] [float] NULL,
[IRB] [float] NULL,
[IRGC] [float] NULL,
[IRGP] [float] NULL,
[SCH REF AMT] [float] NULL,
[INT CAP AMT] [float] NULL,
[BORR PRIN PD] [float] NULL,
[BORR INT PD] [float] NULL,
[CLM PRIN PD] [float] NULL,
[CLM INT PD] [float] NULL,
[PBO] [float] NULL,
[ADB] [float] NULL,
[INT RATE] [float] NULL,
[DEF TYPE 1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DEF TYPE 2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DEF TYPE 3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DEF TYPE 4] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DEF TYPE 5] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DEF TYPE 6] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DEF CAT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CLM CD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REPAY PLAN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FICE NBR] [float] NULL,
[LOAN TYPE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GUAR] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SUSP CD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SENS CD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PRIV CD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BILL TYPE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAST NOTICE SENT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SALE ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BATCH ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SALE ELIG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAST PAID DT] [datetime] NULL,
[FIRST DISB DT] [datetime] NULL,
[ONTIME PAYMENTS] [float] NULL,
[RECORD INDICATOR] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BILL CYCLE] [float] NULL,
[SPECIAL FLAG 3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[INCENT PLAN OPT] [float] NULL,
[INCOME SENS BEG DT] [datetime] NULL,
[INCOME SENS END DT] [datetime] NULL,
[INCOME SENS MOS] [float] NULL,
[OLD REPAY PLAN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REMOTE SERVICE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ORIGINATION FEE] [float] NULL,
[INS PREMIUM] [float] NULL,
[REPAY OPTION] [float] NULL,
[ACTUAL GRAD DT] [datetime] NULL,
[INT ONLY END DT] [datetime] NULL,
[PARTIAL PRIN END DT] [datetime] NULL,
[BIRTH DT] [datetime] NULL,
[DISC NBR PMTS] [float] NULL,
[ERROR CAT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LIAB TYPE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REASON] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STATUS CD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PRVCY NOTE SENT DT] [datetime] NULL,
[FIRST PAY DUE DT] [datetime] NULL,
[DAYS DELQ] [float] NULL,
[HOME EQUITY BEG DT] [datetime] NULL,
[HOME EQUITY END DT] [datetime] NULL,
[NBR PMTS MADE] [float] NULL,
[ADDR CSGN CD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAST SCH CAMPUS CD] [float] NULL,
[ENRL CD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BORR CITIZEN CD] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DISPUTE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACH REMOVAL DT] [datetime] NULL,
[ACH PAYMENTS] [float] NULL,
[DAILY ACCRUED INT] [float] NULL,
[PAID IN FULL DT] [datetime] NULL,
[MTD ACCRUED INT] [float] NULL,
[CURR MO PRIN PD] [float] NULL,
[CURR MO INT PD] [float] NULL,
[REPAY BEG DT] [datetime] NULL,
[PREPAID AMT] [float] NULL,
[SPECIAL FLAG 5] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LOCATION CODE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LOCATION DATE] [datetime] NULL,
[NON-SUB BALANCE] [float] NULL,
[BIP CURRENT PYMT COUNTER] [float] NULL,
[MTD WRITE DOWN/UP] [float] NULL,
[MTD LATE FEES PAID] [float] NULL,
[SCHOOL NAME] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDRESS EFF DATE] [datetime] NULL,
[PY 1098E AMT] [float] NULL,
[YTD INT PAID] [float] NULL,
[PMT-FORGIVE-CNTR] [float] NULL,
[PMT-FORGIVE-DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PKT-IBR-IRB] [float] NULL,
[PKT-IBR-IRGC] [float] NULL,
[PKT-IBR-IRGP] [float] NULL,
[PKT-IBR-ADI] [float] NULL,
[BAN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_LibreMax_Packet] ADD CONSTRAINT [PK_Custom_LibreMax_Packet] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
