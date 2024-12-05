CREATE TABLE [dbo].[LatitudeLegal_2ND3RDDebtorInformation]
(
[AccountID] [int] NULL,
[FORW_FILE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MASCO_FILE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FIRM_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FORW_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D2_NAME] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D2_STREET] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D2_CSZ] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D2_PHONE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D2_SSN] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D3_NAME] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D3_STREET] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D3_CSZ] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D3_PHONE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D3_SSN] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D2_DOB] [datetime] NULL,
[D3_DOB] [datetime] NULL,
[D2_DL] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D3_DL] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D2_CNTRY] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D3_CNTRY] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D2_STREET_LONG] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D2_STREET2_LONG] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D3_STREET_LONG] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D3_STREET2_LONG] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateTimeEntered] [datetime] NULL CONSTRAINT [DF__LatitudeL__DateT__72225B8C] DEFAULT (getdate()),
[ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_LatitudeLegal2ND3RDDebtorInformation_InsertTransaction]
ON [dbo].[LatitudeLegal_2ND3RDDebtorInformation]
FOR INSERT
AS
SET NOCOUNT ON;

INSERT INTO LatitudeLegal_Transactions
(YGCID,AccountID,RecordType,FKID,Balance)
SELECT
INSERTED.FIRM_ID,INSERTED.AccountID,'33',INSERTED.ID,Master.current0
FROM
INSERTED  JOIN [Master] on INSERTED.AccountID = Master.number

RETURN

GO
ALTER TABLE [dbo].[LatitudeLegal_2ND3RDDebtorInformation] ADD CONSTRAINT [PK_LatitudeLegal_2ND3RDDebtorInformation] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_LatitudeLegal_2ND3RDDebtorInformation_AccountID] ON [dbo].[LatitudeLegal_2ND3RDDebtorInformation] ([AccountID], [DateTimeEntered]) ON [PRIMARY]
GO
