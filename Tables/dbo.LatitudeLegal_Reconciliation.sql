CREATE TABLE [dbo].[LatitudeLegal_Reconciliation]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[FORW_FILE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FIRM_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DPLACED] [datetime] NULL,
[DEBT_NAME] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRED_NAME] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D1_BAL] [money] NULL,
[IDATE] [datetime] NULL,
[IAMT] [money] NULL,
[IDUE] [money] NULL,
[PAID] [money] NULL,
[COST_BAL] [money] NULL,
[DEBT_CS] [varchar] (23) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DEBT_ZIP] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRED_NAME2] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COMM] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SFEE] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RFILE] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RECEIVEDDATE] [datetime] NULL,
[SENTDATE] [datetime] NULL,
[SENTFLAG] [bit] NULL,
[MASCO_FILE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FORW_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DEBT_CNTRY] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [dbo].[trg_LatitudeLegalReconciliation_InsertTransaction]
ON [dbo].[LatitudeLegal_Reconciliation]
FOR INSERT
AS
SET NOCOUNT ON;

INSERT INTO LatitudeLegal_Transactions
(YGCID,AccountID,RecordType,FKID,Balance)
SELECT
INSERTED.FIRM_ID,INSERTED.AccountID,'38',INSERTED.ID,Master.current0
FROM
INSERTED  JOIN [Master] on INSERTED.AccountID = Master.number

RETURN


GO
ALTER TABLE [dbo].[LatitudeLegal_Reconciliation] ADD CONSTRAINT [PK_LatitudeLegal_Reconciliation] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_LatitudeLegal_Reconciliation_AccountID] ON [dbo].[LatitudeLegal_Reconciliation] ([AccountID]) ON [PRIMARY]
GO
