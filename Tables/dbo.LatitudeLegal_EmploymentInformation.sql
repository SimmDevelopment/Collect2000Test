CREATE TABLE [dbo].[LatitudeLegal_EmploymentInformation]
(
[AccountID] [int] NULL,
[FORW_FILE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MASCO_FILE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FIRM_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FORW_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMP_NAME] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMP_STREET] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMP_PO] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMP_CS] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMP_ZO] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMP_PHONE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMP_FAX] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMP_ATTN] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMP_PAYR] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMP_NO] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMPLOYEE_NAME] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMP_INCOME] [money] NULL,
[EMP_FREQ] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMP_POS] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMP_TENURE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMP_CNTRY] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateTimeEntered] [datetime] NULL CONSTRAINT [DF__LatitudeL__DateT__703A131A] DEFAULT (getdate()),
[ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [dbo].[trg_LatitudeLegalEmploymentInformation_InsertTransaction]
ON [dbo].[LatitudeLegal_EmploymentInformation]
FOR INSERT
AS
SET NOCOUNT ON;

INSERT INTO LatitudeLegal_Transactions
(YGCID,AccountID,RecordType,FKID,Balance)
SELECT
INSERTED.FIRM_ID,INSERTED.AccountID,'34',INSERTED.ID,Master.current0
FROM
INSERTED  JOIN [Master] on INSERTED.AccountID = Master.number

RETURN


GO
ALTER TABLE [dbo].[LatitudeLegal_EmploymentInformation] ADD CONSTRAINT [PK_LatitudeLegal_EmploymentInformation] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_LatitudeLegal_EmploymentInformation_AccountID] ON [dbo].[LatitudeLegal_EmploymentInformation] ([AccountID], [DateTimeEntered]) ON [PRIMARY]
GO
