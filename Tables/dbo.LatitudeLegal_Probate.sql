CREATE TABLE [dbo].[LatitudeLegal_Probate]
(
[AccountID] [int] NULL,
[FORW_FILE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MASCO_FILE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FIRM_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FORW_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DEBTOR_NO] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOD] [datetime] NULL,
[PRB_CASE_NO] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PRB_ST] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PRB_CTY] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PRB_CRT] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PRB_DATE] [datetime] NULL,
[PRB_EXP] [datetime] NULL,
[REP_NAME] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REP_STRT1] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REP_STRT2] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REP_CITY] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REP_ST] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REP_ZIP] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REP_PHONE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ATTY_NAME] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ATTY_FIRM] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ATTY_STRT1] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ATTY_STRT2] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ATTY_CITY] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ATTY_ST] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ATTY_ZIP] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ATTY_PHONE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REP_CNTRY] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ATTY_CNTRY] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateTimeEntered] [datetime] NULL CONSTRAINT [DF__LatitudeL__DateT__77DB34E2] DEFAULT (getdate()),
[ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_LatitudeLegalProbate_InsertTransaction]
ON [dbo].[LatitudeLegal_Probate]
FOR INSERT
AS
SET NOCOUNT ON;

INSERT INTO LatitudeLegal_Transactions
(YGCID,AccountID,RecordType,FKID,Balance)
SELECT
INSERTED.FIRM_ID,INSERTED.AccountID,'45',INSERTED.ID,Master.current0
FROM
INSERTED  JOIN [Master] on INSERTED.AccountID = Master.number

RETURN

GO
ALTER TABLE [dbo].[LatitudeLegal_Probate] ADD CONSTRAINT [PK_LatitudeLegal_Probate] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_LatitudeLegal_Probate_AccountID] ON [dbo].[LatitudeLegal_Probate] ([AccountID]) ON [PRIMARY]
GO
