CREATE TABLE [dbo].[LatitudeLegal_ClaimBalanceInterestInfo]
(
[AccountID] [int] NULL,
[RATES_PRE] [float] NULL,
[RATES_POST] [float] NULL,
[PER_DIEM] [money] NULL,
[INT_BASE] [money] NULL,
[IAMOUNT] [money] NULL,
[IPAID] [money] NULL,
[IDATE] [datetime] NULL,
[PRIN_AMT] [money] NULL,
[PRIN_PAID] [money] NULL,
[CNTRCT_AMT] [money] NULL,
[CNTRCT_PAID] [money] NULL,
[STAT_AMT] [money] NULL,
[STAT_PAID] [money] NULL,
[COST_AMT] [money] NULL,
[COST_PAID] [money] NULL,
[DBAL] [money] NULL,
[IBAL] [money] NULL,
[STAT_FLAG] [bit] NULL,
[FORW_FILE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MASCO_FILE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FIRM_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FORW_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateTimeEntered] [datetime] NULL CONSTRAINT [DF__LatitudeL__DateT__4343785F] DEFAULT (getdate()),
[ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_LatitudeLegalClaimBalanceInterestInfo_InsertTransaction]
ON [dbo].[LatitudeLegal_ClaimBalanceInterestInfo]
FOR INSERT
AS
SET NOCOUNT ON;

INSERT INTO LatitudeLegal_Transactions
(YGCID,AccountID,RecordType,FKID,Balance)
SELECT
INSERTED.FIRM_ID,INSERTED.AccountID,'42',INSERTED.ID,Master.current0
FROM
INSERTED  JOIN [Master] on INSERTED.AccountID = Master.number

RETURN


GO
ALTER TABLE [dbo].[LatitudeLegal_ClaimBalanceInterestInfo] ADD CONSTRAINT [PK_LatitudeLegal_ClaimBalanceInterestInfo] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_LatitudeLegal_ClaimBalanceInterestInfo_AccountID] ON [dbo].[LatitudeLegal_ClaimBalanceInterestInfo] ([AccountID], [DateTimeEntered]) ON [PRIMARY]
GO
