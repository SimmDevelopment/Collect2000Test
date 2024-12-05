CREATE TABLE [dbo].[LatitudeLegal_Payments]
(
[AccountID] [int] NOT NULL,
[RET_CODE] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAY_DATE] [datetime] NULL,
[GROSS_PAY] [money] NULL,
[NET_CLIENT] [money] NULL,
[CHECK_AMT] [money] NULL,
[COST_RET] [money] NULL,
[FEES] [money] NULL,
[AGENT_FEES] [money] NULL,
[FORW_CUT] [money] NULL,
[COST_REC] [money] NULL,
[BPJ] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TA_NO] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RMIT_NO] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LINE1_3] [money] NULL,
[LINE1_5] [money] NULL,
[LINE1_6] [money] NULL,
[LINE2_1] [money] NULL,
[LINE2_2] [money] NULL,
[LINE2_5] [money] NULL,
[LINE2_6] [money] NULL,
[LINE2_7] [money] NULL,
[LINE2_8] [money] NULL,
[DESCR] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[POST_DATE] [datetime] NULL,
[REMIT_DATE] [datetime] NULL,
[TA_CODE] [char] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COMMENT] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ID] [int] NOT NULL IDENTITY(1, 1),
[FORW_FILE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MASCO_FILE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FIRM_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FORW_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateTimeEntered] [datetime] NULL CONSTRAINT [DF__LatitudeL__DateT__47140943] DEFAULT (getdate())
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [dbo].[trg_LatitudeLegalPayments_InsertTransaction]
ON [dbo].[LatitudeLegal_Payments]
FOR INSERT
AS
SET NOCOUNT ON;

INSERT INTO LatitudeLegal_Transactions
(YGCID,AccountID,RecordType,FKID,Balance)
SELECT
INSERTED.FIRM_ID,INSERTED.AccountID,'30',INSERTED.ID,Master.current0
FROM
INSERTED  JOIN [Master] on INSERTED.AccountID = Master.number

RETURN


GO
ALTER TABLE [dbo].[LatitudeLegal_Payments] ADD CONSTRAINT [PK_LatitudeLegal_Payments] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_LatitudeLegal_Payments_AccountID] ON [dbo].[LatitudeLegal_Payments] ([AccountID], [RET_CODE]) ON [PRIMARY]
GO
