CREATE TABLE [dbo].[LatitudeLegal_PaymentPlanInfo]
(
[AccountID] [int] NULL,
[PLAN_DATE] [datetime] NULL,
[PLAN_BAL] [money] NULL,
[FIRST_DATE] [datetime] NULL,
[FIRST_AMT] [money] NULL,
[PAY_AMT] [money] NULL,
[LAST_DATE] [datetime] NULL,
[LAST_AMT] [money] NULL,
[NO_PMTS] [int] NULL,
[FREQUENCY] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FORW_FILE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MASCO_FILE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FIRM_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FORW_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateTimeEntered] [datetime] NULL CONSTRAINT [DF__LatitudeL__DateT__452BC0D1] DEFAULT (getdate()),
[ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_LatitudeLegalPaymentPlanInfo_InsertTransaction]
ON [dbo].[LatitudeLegal_PaymentPlanInfo]
FOR INSERT
AS
SET NOCOUNT ON;

INSERT INTO LatitudeLegal_Transactions
(YGCID,AccountID,RecordType,FKID,Balance)
SELECT
INSERTED.FIRM_ID,INSERTED.AccountID,'43',INSERTED.ID,Master.current0
FROM
INSERTED  JOIN [Master] on INSERTED.AccountID = Master.number

RETURN


GO
ALTER TABLE [dbo].[LatitudeLegal_PaymentPlanInfo] ADD CONSTRAINT [PK_LatitudeLegal_PaymentPlanInfo] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_LatitudeLegal_PaymentPlanInfo_AccountID] ON [dbo].[LatitudeLegal_PaymentPlanInfo] ([AccountID]) ON [PRIMARY]
GO
