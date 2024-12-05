CREATE TABLE [dbo].[LatitudeLegal_CaptionLegalNames]
(
[AccountID] [int] NULL,
[PLAINTIFF_1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PLAINTIFF_2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PLAINTIFF_3] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PLAINTIFF_4] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PLAINTIFF_5] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PLAINTIFF_6] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PLAINTIFF_7] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DEFENDANT_1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DEFENDANT_2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DEFENDANT_3] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DEFENDANT_4] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DEFENDANT_5] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DEFENDANT_6] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DEFENDANT_7] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DEFENDANT_8] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DEFENDANT_9] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FORW_FILE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MASCO_FILE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FIRM_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FORW_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateTimeEntered] [datetime] NULL CONSTRAINT [DF__LatitudeL__DateT__424F5426] DEFAULT (getdate()),
[ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [dbo].[trg_LatitudeLegalCaptionLegalNames_InsertTransaction]
ON [dbo].[LatitudeLegal_CaptionLegalNames]
FOR INSERT
AS
SET NOCOUNT ON;

INSERT INTO LatitudeLegal_Transactions
(YGCID,AccountID,RecordType,FKID,Balance)
SELECT
INSERTED.FIRM_ID,INSERTED.AccountID,'37',INSERTED.ID,Master.current0
FROM
INSERTED  JOIN [Master] on INSERTED.AccountID = Master.number

RETURN

GO
ALTER TABLE [dbo].[LatitudeLegal_CaptionLegalNames] ADD CONSTRAINT [PK_LatitudeLegal_CaptionLegalNames] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_LatitudeLegal_CaptionLegalNames_AccountID] ON [dbo].[LatitudeLegal_CaptionLegalNames] ([AccountID], [DateTimeEntered]) ON [PRIMARY]
GO
