CREATE TABLE [dbo].[LatitudeLegal_Bankruptcy]
(
[AccountID] [int] NULL,
[FORW_FILE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MASCO_FILE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FIRM_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FORW_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DEBTOR_NUM] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CHAPTER] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BK_FILENO] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LOC] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FILED_DATE] [datetime] NULL,
[DSMIS_DATE] [datetime] NULL,
[DSCHG_DATE] [datetime] NULL,
[CLOSE_DATE] [datetime] NULL,
[CNVRT_DATE] [datetime] NULL,
[MTG_341_DATE] [datetime] NULL,
[MTG_341_TIME] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MTG_341_LOC] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JUDGE_INIT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REAF_AMT] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REAF_DATE] [datetime] NULL,
[PAY_AMT] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAY_DATE] [datetime] NULL,
[CONF_DATE] [datetime] NULL,
[CURE_DATE] [datetime] NULL,
[DateTimeEntered] [datetime] NULL CONSTRAINT [DF__LatitudeL__DateT__79C37D54] DEFAULT (getdate()),
[ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_LatitudeLegalBankruptcy_InsertTransaction]
ON [dbo].[LatitudeLegal_Bankruptcy]
FOR INSERT
AS
SET NOCOUNT ON;

INSERT INTO LatitudeLegal_Transactions
(YGCID,AccountID,RecordType,FKID,Balance)
SELECT
INSERTED.FIRM_ID,INSERTED.AccountID,'44',INSERTED.ID,Master.current0
FROM
INSERTED  JOIN [Master] on INSERTED.AccountID = Master.number

RETURN


GO
ALTER TABLE [dbo].[LatitudeLegal_Bankruptcy] ADD CONSTRAINT [PK_LatitudeLegal_Bankruptcy] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_LatitudeLegal_Bankruptcy_AccountID] ON [dbo].[LatitudeLegal_Bankruptcy] ([AccountID], [DateTimeEntered]) ON [PRIMARY]
GO
