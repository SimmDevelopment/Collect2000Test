CREATE TABLE [dbo].[LatitudeLegal_DebtorInformation]
(
[AccountID] [int] NULL,
[FORW_FILE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MASCO_FILE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FIRM_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FORW_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D1_NAME] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D1_SALUT] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D1_ALIAS] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D1_STREET] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D1_CS] [varchar] (23) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D1_ZIP] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D1_PHONE] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D1_FAX] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D1_SSN] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RFILE] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D1_DOB] [datetime] NULL,
[D1_DL] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D1_STATE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D1_MAIL] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SERVICE_D] [datetime] NULL,
[ANSWER_DUE_D] [datetime] NULL,
[ANSWER_FILE_D] [datetime] NULL,
[DEFAULT_D] [datetime] NULL,
[TRIAL_D] [datetime] NULL,
[HEARING_D] [datetime] NULL,
[LIEN_D] [datetime] NULL,
[GARN_D] [datetime] NULL,
[SERVICE_TYPE] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D1_STRT2] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D1_CITY] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D1_CELL] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SCORE_FICO] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SCORE_COLLECT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SCORE_OTHER] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D1_CNTRY] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D1_STREET_LONG] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D1_STREET2_LONG] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateTimeEntered] [datetime] NULL CONSTRAINT [DF__LatitudeL__DateT__740AA3FE] DEFAULT (getdate()),
[ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE TRIGGER [dbo].[trg_LatitudeLegalDebtorInformation_InsertTransaction]
ON [dbo].[LatitudeLegal_DebtorInformation]
FOR INSERT
AS
SET NOCOUNT ON;

INSERT INTO LatitudeLegal_Transactions
(YGCID,AccountID,RecordType,FKID,Balance)
SELECT
INSERTED.FIRM_ID,INSERTED.AccountID,'31',INSERTED.ID,Master.current0
FROM
INSERTED  JOIN [Master] on INSERTED.AccountID = Master.number

RETURN


GO
ALTER TABLE [dbo].[LatitudeLegal_DebtorInformation] ADD CONSTRAINT [PK_LatitudeLegal_DebtorInformation] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_LatitudeLegal_DebtorInformation_AccountID] ON [dbo].[LatitudeLegal_DebtorInformation] ([AccountID], [DateTimeEntered]) ON [PRIMARY]
GO
