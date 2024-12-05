CREATE TABLE [dbo].[Deceased]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[DebtorID] [int] NOT NULL,
[SSN] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PostalCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB] [datetime] NULL,
[DOD] [datetime] NULL,
[MatchCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransmittedDate] [smalldatetime] NULL,
[ClaimDeadline] [datetime] NULL,
[DateFiled] [datetime] NULL,
[CaseNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Executor] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExecutorPhone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExecutorFax] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExecutorStreet1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExecutorStreet2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExecutorState] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExecutorCity] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExecutorZipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtDistrict] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtDivision] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtPhone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtStreet1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtStreet2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtState] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtZipcode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ctl] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[tr_AIM_Deceased_InsertOrUpdate]
ON  [dbo].[Deceased]
FOR UPDATE,INSERT
AS
BEGIN


if not exists(select top 1 accounttransactionid from aim_accounttransaction atr with (nolock) join aim_accountreference ar with (nolock) on ar.accountreferenceid = atr.accountreferenceid
join inserted i on i.accountid = ar.referencenumber  where ar.referencenumber = i.accountid and atr.transactiontypeid in (3,17) and transactionstatustypeid = 1 and foreigntableuniqueid = i.id)
begin
insert into AIM_accounttransaction (accountreferenceid,transactiontypeid,recallreasoncodeid,transactionstatustypeid,
createddatetime,agencyid,commissionpercentage,balance,foreigntableuniqueid)
select accountreferenceid,
CASE a.KeepsDeceased WHEN 1 THEN 17 ELSE 3 END,0,1,getdate(),currentlyplacedagencyid,currentcommissionpercentage,current0,i.id
from aim_accountreference ar with (nolock)
join master m with (nolock) on m.number = ar.referencenumber
join aim_agency a with (nolock) on a.agencyid = ar.currentlyplacedagencyid
join inserted i on i.accountid = m.number
where isplaced = 1 and (i.ctl <> 'AIM' or i.ctl is null)
end
END

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_Deceased_WorkFlow_SystemEvents]
ON [dbo].[Deceased]
FOR INSERT, UPDATE
AS

CREATE TABLE #EventAccounts (
	[AccountID] INTEGER NOT NULL,
	[EventVariable] SQL_VARIANT NULL
);

IF UPDATE([DOD]) BEGIN
	INSERT INTO #EventAccounts ([AccountID], [EventVariable])
	SELECT [INSERTED].[AccountID], CAST(NULL AS SQL_VARIANT)
	FROM [INSERTED]
	LEFT OUTER JOIN [DELETED]
	ON [INSERTED].[AccountID] = [DELETED].[AccountID]
	AND [INSERTED].[DebtorID] = [DELETED].[DebtorID]
	WHERE [INSERTED].[DOD] > '1900-01-01'
	AND ([DELETED].[DOD] IS NULL
		OR [DELETED].[DOD] <= '1900-01-01'
	);

	IF EXISTS (SELECT * FROM #EventAccounts) BEGIN
		EXEC [dbo].[WorkFlow_RaiseAccountsEventByName] @EventName = 'Deceased', @CreateNew = 0;

		TRUNCATE TABLE #EventAccounts;
	END;
END;

DROP TABLE #EventAccounts;

RETURN;

GO
ALTER TABLE [dbo].[Deceased] ADD CONSTRAINT [PK_Deceased] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Deceased_AccountID] ON [dbo].[Deceased] ([AccountID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Deceased_DebtorID] ON [dbo].[Deceased] ([DebtorID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table retains deceased and legal tracking information on  deceased Debtor''s estate ', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'FileNumber - Master.Number', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', 'COLUMN', N'AccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The case number for probate court ', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', 'COLUMN', N'CaseNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The deadline for filing claims against the debtor''s estate ', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', 'COLUMN', N'ClaimDeadline'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Mailing address of probate court city ', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', 'COLUMN', N'CourtCity'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Probate court district', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', 'COLUMN', N'CourtDistrict'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Probate court division', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', 'COLUMN', N'CourtDivision'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Probate court contact phone', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', 'COLUMN', N'CourtPhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Mailing addreress state of probate court ', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', 'COLUMN', N'CourtState'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Mailing address line 1 of probate court ', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', 'COLUMN', N'CourtStreet1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Mailing address line 2 of probate court', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', 'COLUMN', N'CourtStreet2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Mailing address zipcode of probate court  ', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', 'COLUMN', N'CourtZipcode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date that the claim was filed against the debtor''s estate ', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', 'COLUMN', N'DateFiled'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique DebtorID - Debtors.DebtorID', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', 'COLUMN', N'DebtorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Deceased Debtor Date of Birth ', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', 'COLUMN', N'DOB'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Deceased Debtor Date of Death', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', 'COLUMN', N'DOD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the executor of the debtor''s estate ', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', 'COLUMN', N'Executor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Mailing address city of executor  ', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', 'COLUMN', N'ExecutorCity'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fax number of executor ', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', 'COLUMN', N'ExecutorFax'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contact phone number of executor ', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', 'COLUMN', N'ExecutorPhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Mailing address state of executor ', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', 'COLUMN', N'ExecutorState'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Mailing address line 1 of executor ', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', 'COLUMN', N'ExecutorStreet1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Mailing address line 2 of executor ', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', 'COLUMN', N'ExecutorStreet2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Mailing address zipcode of executor ', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', 'COLUMN', N'ExecutorZipcode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Deceased Debtor First Name ', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', 'COLUMN', N'FirstName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Auto Generated Unique Identity Value', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Deceased Debtor Last name', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', 'COLUMN', N'LastName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'LexisNexis match code', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', 'COLUMN', N'MatchCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The zip code that the debtor died in', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', 'COLUMN', N'PostalCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Social Security Number of Deceased Debtor ', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', 'COLUMN', N'SSN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The state that the debtor died in ', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', 'COLUMN', N'State'
GO
EXEC sp_addextendedproperty N'MS_Description', N'LexiNexis transmit date', 'SCHEMA', N'dbo', 'TABLE', N'Deceased', 'COLUMN', N'TransmittedDate'
GO
