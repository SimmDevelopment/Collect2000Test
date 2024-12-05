CREATE TABLE [dbo].[LatitudeLegal_Messages]
(
[AccountID] [int] NOT NULL,
[PDATE] [datetime] NULL,
[PCODE] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PCMT] [varchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ID] [int] NOT NULL IDENTITY(1, 1),
[FORW_FILE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MASCO_FILE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FIRM_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FORW_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateTimeEntered] [datetime] NULL CONSTRAINT [DF__LatitudeL__DateT__48082D7C] DEFAULT (getdate())
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_LatitudeLegalMessages_InsertTransaction]
ON [dbo].[LatitudeLegal_Messages]
FOR INSERT
AS
SET NOCOUNT ON;

INSERT INTO LatitudeLegal_Transactions
(YGCID,AccountID,RecordType,FKID,Balance)
SELECT
INSERTED.FIRM_ID,INSERTED.AccountID,'39',INSERTED.ID,Master.current0
FROM
INSERTED  JOIN [Master] on INSERTED.AccountID = Master.number

RETURN

GO
ALTER TABLE [dbo].[LatitudeLegal_Messages] ADD CONSTRAINT [PK_LatitudeLegal_Messages] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_LatitudeLegal_Messages_AccountID] ON [dbo].[LatitudeLegal_Messages] ([AccountID], [PCODE]) ON [PRIMARY]
GO
