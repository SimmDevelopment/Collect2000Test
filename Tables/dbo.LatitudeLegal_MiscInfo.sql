CREATE TABLE [dbo].[LatitudeLegal_MiscInfo]
(
[AccountID] [int] NULL,
[ADVA_NAME] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADVA_FIRM] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADVA_FIRM2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADVA_STREET] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADVA_CSZ] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADVA_SALUT] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADVA_PHONE] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADVA_FAX] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADVA_FILENO] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MISC_DATE1] [datetime] NULL,
[MISC_DATE2] [datetime] NULL,
[MISC_AMT1] [money] NULL,
[MISC_AMT2] [money] NULL,
[MISC_COMM1] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MISC_COMM2] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MISC_COMM3] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MISC_COMM4] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADVA_NUM] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FORW_FILE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MASCO_FILE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FIRM_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FORW_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADVA_CNTRY] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateTimeEntered] [datetime] NULL CONSTRAINT [DF__LatitudeL__DateT__44379C98] DEFAULT (getdate()),
[ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_LatitudeLegalMiscInfo_InsertTransaction]
ON [dbo].[LatitudeLegal_MiscInfo]
FOR INSERT
AS
SET NOCOUNT ON;

INSERT INTO LatitudeLegal_Transactions
(YGCID,AccountID,RecordType,FKID,Balance)
SELECT
INSERTED.FIRM_ID,INSERTED.AccountID,'36',INSERTED.ID,Master.current0
FROM
INSERTED  JOIN [Master] on INSERTED.AccountID = Master.number

RETURN

GO
ALTER TABLE [dbo].[LatitudeLegal_MiscInfo] ADD CONSTRAINT [PK_LatitudeLegal_MiscInfo] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_LatitudeLegal_MiscInfo_AccountID] ON [dbo].[LatitudeLegal_MiscInfo] ([AccountID]) ON [PRIMARY]
GO
