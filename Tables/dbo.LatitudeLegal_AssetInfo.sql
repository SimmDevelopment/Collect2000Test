CREATE TABLE [dbo].[LatitudeLegal_AssetInfo]
(
[AccountID] [int] NULL,
[BANK_NAME] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BANK_STREET] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BANK_CSZ] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BANK_ATTN] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BANK_PHONE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BANK_FAX] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BANK_ACCT] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MISC_ASSET1] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MISC_ASSET2] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MISC_ASSET3] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MISC_PHONE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BANK_NO] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FORW_FILE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MASCO_FILE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FIRM_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FORW_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BANK_CNTRY] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateTimeEntered] [datetime] NULL CONSTRAINT [DF__LatitudeL__DateT__415B2FED] DEFAULT (getdate()),
[ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_LatitudeLegalAssetInfo_InsertTransaction]
ON [dbo].[LatitudeLegal_AssetInfo]
FOR INSERT
AS
SET NOCOUNT ON;

INSERT INTO LatitudeLegal_Transactions
(YGCID,AccountID,RecordType,FKID,Balance)
SELECT
INSERTED.FIRM_ID,INSERTED.AccountID,'35',INSERTED.ID,Master.current0
FROM
INSERTED  JOIN [Master] on INSERTED.AccountID = Master.number

RETURN


GO
ALTER TABLE [dbo].[LatitudeLegal_AssetInfo] ADD CONSTRAINT [PK_LatitudeLegal_AssetInfo] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_LatitudeLegal_AssetInfo_AccountID] ON [dbo].[LatitudeLegal_AssetInfo] ([AccountID], [DateTimeEntered]) ON [PRIMARY]
GO
