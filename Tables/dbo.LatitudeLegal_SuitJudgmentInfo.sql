CREATE TABLE [dbo].[LatitudeLegal_SuitJudgmentInfo]
(
[AccountID] [int] NULL,
[SUIT_AMT] [money] NULL,
[SUIT_DATE] [datetime] NULL,
[CNTRCT_FEE] [money] NULL,
[STAT_FEE] [money] NULL,
[DOCKET_NO] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JDGMNT_NO] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JDGMNT_DATE] [datetime] NULL,
[JDGMNT_AMT] [money] NULL,
[PREJ_INT] [money] NULL,
[JDG_COSTS] [money] NULL,
[RATES_PRE] [float] NULL,
[RATES_POST] [float] NULL,
[STAT_FLAG] [bit] NULL,
[INT_FLAG] [bit] NULL,
[JUDG_PRIN] [money] NULL,
[ADJUSTMENT] [money] NULL,
[FORW_FILE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MASCO_FILE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FIRM_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FORW_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JDGMNT_BAL] [money] NULL,
[LEGAL_COUNTY] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LEGAL_STATE] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRT_DESIG] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRT_TYPE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JDGMNT_EXP_DATE] [datetime] NULL,
[LEGAL_CNTRY] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateTimeEntered] [datetime] NULL CONSTRAINT [DF__LatitudeL__DateT__461FE50A] DEFAULT (getdate()),
[ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [dbo].[trg_LatitudeLegalSuitJudgmentInfo_InsertTransaction]
ON [dbo].[LatitudeLegal_SuitJudgmentInfo]
FOR INSERT
AS
SET NOCOUNT ON;

INSERT INTO LatitudeLegal_Transactions
(YGCID,AccountID,RecordType,FKID,Balance)
SELECT
INSERTED.FIRM_ID,INSERTED.AccountID,'41',INSERTED.ID,Master.current0
FROM
INSERTED  JOIN [Master] on INSERTED.AccountID = Master.number

RETURN


GO
ALTER TABLE [dbo].[LatitudeLegal_SuitJudgmentInfo] ADD CONSTRAINT [PK_LatitudeLegal_SuitJudgmentInfo] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_LatitudeLegal_SuitJudgmentInfo_AccountID] ON [dbo].[LatitudeLegal_SuitJudgmentInfo] ([AccountID]) ON [PRIMARY]
GO
