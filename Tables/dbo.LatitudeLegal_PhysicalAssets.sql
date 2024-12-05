CREATE TABLE [dbo].[LatitudeLegal_PhysicalAssets]
(
[AccountID] [int] NULL,
[FORW_FILE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MASCO_FILE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FIRM_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FORW_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DBTR_NUM] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ASSET_ID] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ASSET_OWNER] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STREET] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STREET_2] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STREET_3] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CITY] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TOWN] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CNTY] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STATE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CNTRY] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PHONE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BLOCK] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LOT] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ASSET_VALUE] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ASSET_DESC] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ASSET_VIN] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ASSET_LIC_PLATE] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ASSET_COLOR] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ASSET_YEAR] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ASSET_MAKE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ASSET_MODEL] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REPO_FILE_NUM] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REPO_D] [datetime] NULL,
[REPO_AMT] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CERT_TITLE_NAME] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CERT_TITLE_D] [datetime] NULL,
[MORT_FRCL_D] [datetime] NULL,
[MORT_FRCL_FILENO] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MORT_FRCL_DISMIS_D] [datetime] NULL,
[MORT_PMT] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MORT_RATE] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MORT_BOOK_1] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MORT_PAGE_1] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MORT_BOOK_2] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MORT_PAGE_2] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MORT_RECRD_D] [datetime] NULL,
[MORT_DUE_D] [datetime] NULL,
[LIEN_FILE_NUM] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LIEN_CASE_NUM] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LIEN_D] [datetime] NULL,
[LIEN_BOOK] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LIEN_PAGE] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LIEN_AOL] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LIEN_RLSE_D] [datetime] NULL,
[LIEN_RLSE_BOOK] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LIEN_RLSE_PAGE] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LIEN_LITIG_D] [datetime] NULL,
[LIEN_LITIG_BOOK] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LIEN_LITIG_PAGE] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateTimeEntered] [datetime] NULL CONSTRAINT [DF__LatitudeL__DateT__75F2EC70] DEFAULT (getdate()),
[ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_LatitudeLegalPhysicalAssets_InsertTransaction]
ON [dbo].[LatitudeLegal_PhysicalAssets]
FOR INSERT
AS
SET NOCOUNT ON;

INSERT INTO LatitudeLegal_Transactions
(YGCID,AccountID,RecordType,FKID,Balance)
SELECT
INSERTED.FIRM_ID,INSERTED.AccountID,'46',INSERTED.ID,Master.current0
FROM
INSERTED  JOIN [Master] on INSERTED.AccountID = Master.number


RETURN

GO
ALTER TABLE [dbo].[LatitudeLegal_PhysicalAssets] ADD CONSTRAINT [PK_LatitudeLegal_PhysicalAssets] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_LatitudeLegal_PhysicalAssets_AccountID] ON [dbo].[LatitudeLegal_PhysicalAssets] ([AccountID]) ON [PRIMARY]
GO
