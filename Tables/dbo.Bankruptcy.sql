CREATE TABLE [dbo].[Bankruptcy]
(
[BankruptcyID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[DebtorID] [int] NOT NULL,
[Chapter] [tinyint] NULL,
[DateFiled] [datetime] NULL,
[CaseNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CourtCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CourtDistrict] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CourtDivision] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CourtPhone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CourtStreet1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CourtStreet2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CourtState] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CourtZipcode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Trustee] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TrusteeStreet1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TrusteeStreet2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TrusteeCity] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TrusteeState] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TrusteeZipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TrusteePhone] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Has341Info] [bit] NOT NULL CONSTRAINT [DF_Bankruptcy_Has341Info] DEFAULT (0),
[DateTime341] [datetime] NULL,
[Location341] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Comments] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TransmittedDate] [smalldatetime] NULL,
[ConvertedFrom] [tinyint] NULL,
[DateNotice] [datetime] NULL,
[ProofFiled] [datetime] NULL,
[DischargeDate] [datetime] NULL,
[DismissalDate] [datetime] NULL,
[ConfirmationHearingDate] [datetime] NULL,
[HasAsset] [bit] NULL,
[Reaffirm] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReaffirmDateFiled] [datetime] NULL,
[ReaffirmAmount] [money] NULL,
[ReaffirmTerms] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VoluntaryDate] [datetime] NULL,
[VoluntaryAmount] [money] NULL,
[VoluntaryTerms] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SurrenderDate] [datetime] NULL,
[SurrenderMethod] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuctionHouse] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuctionDate] [datetime] NULL,
[AuctionAmount] [money] NULL,
[AuctionFee] [money] NULL,
[AuctionAmountApplied] [money] NULL,
[SecuredAmount] [money] NULL,
[SecuredPercentage] [smallmoney] NULL,
[UnsecuredAmount] [money] NULL,
[UnsecuredPercentage] [smallmoney] NULL,
[ctl] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WithdrawnDate] [datetime] NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_Bankruptcy_CreatedDate] DEFAULT (getdate()),
[UpdatedDate] [datetime] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[tr_AIM_Bankruptcy_InsertOrUpdate]
ON  [dbo].[Bankruptcy]
FOR UPDATE,INSERT
AS
BEGIN


if not exists(select top 1 accounttransactionid from aim_accounttransaction atr with (nolock) join aim_accountreference ar with (nolock) on ar.accountreferenceid = atr.accountreferenceid
join inserted i on i.accountid = ar.referencenumber where ar.referencenumber = i.accountid and atr.transactiontypeid in (18,3) and transactionstatustypeid = 1 and foreigntableuniqueid = i.bankruptcyid)
begin
insert into AIM_accounttransaction (accountreferenceid,transactiontypeid,recallreasoncodeid,transactionstatustypeid,
createddatetime,agencyid,commissionpercentage,balance,foreigntableuniqueid)
select accountreferenceid,
CASE WHEN a.KeepsBanko = 1 THEN 18 WHEN a.KeepsBanko = 0 and (i.DismissalDate is not null AND i.DismissalDate > '1900-01-01 00:00:00.000' ) THEN 18 ELSE 3 END,
0,1,getdate(),currentlyplacedagencyid,currentcommissionpercentage,current0,i.bankruptcyid
from aim_accountreference ar with (nolock) join master m with (nolock) on m.number = ar.referencenumber
join aim_Agency a with (nolock) on a.agencyid = ar.currentlyplacedagencyid
join inserted i on i.accountid = m.number
where isplaced = 1 and (i.ctl <> 'AIM' or i.ctl is null)

END


UPDATE dbo.Bankruptcy SET DateTime341 = '19000101'
FROM dbo.Bankruptcy B
JOIN INSERTED I ON I.Debtorid = B.DebtorID
WHERE I.DateTime341 < '19000101';

UPDATE dbo.Bankruptcy SET UpdatedDate = GETDATE()
FROM dbo.Bankruptcy B
JOIN INSERTED I ON I.Debtorid = B.DebtorID;


END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_Bankruptcy_WorkFlow_SystemEvents]
ON [dbo].[Bankruptcy]
FOR INSERT, UPDATE
AS

CREATE TABLE #EventAccounts (
	[AccountID] INTEGER NOT NULL,
	[EventVariable] SQL_VARIANT NULL
);

IF UPDATE([Chapter]) OR UPDATE([Status]) BEGIN
	INSERT INTO #EventAccounts ([AccountID], [EventVariable])
	SELECT [INSERTED].[AccountID], CAST(NULL AS SQL_VARIANT)
	FROM [INSERTED]
	LEFT OUTER JOIN [DELETED]
	ON [INSERTED].[AccountID] = [DELETED].[AccountID]
	AND [INSERTED].[DebtorID] = [DELETED].[DebtorID]
	WHERE [INSERTED].[Chapter] IN ('7', '11', '12', '13')
	AND [INSERTED].[Status] IN ('Filed - Not Discharged', 'Meeting of Creditors Set', 'Discharged')
	AND ([DELETED].[Chapter] NOT IN ('7', '11', '12', '13')
		OR [DELETED].[Status] NOT IN ('Filed - Not Discharged', 'Meeting of Creditors Set', 'Discharged')
		OR [DELETED].[BankruptcyID] IS NULL
	);

	IF EXISTS (SELECT * FROM #EventAccounts) BEGIN
		EXEC [dbo].[WorkFlow_RaiseAccountsEventByName] @EventName = 'Bankruptcy', @CreateNew = 0;

		TRUNCATE TABLE #EventAccounts;
	END;
END;

DROP TABLE #EventAccounts;

RETURN;

GO
ALTER TABLE [dbo].[Bankruptcy] ADD CONSTRAINT [PK_Bankruptcy] PRIMARY KEY CLUSTERED ([BankruptcyID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Bankruptcy_AccountID] ON [dbo].[Bankruptcy] ([AccountID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Bankruptcy_DebtorID] ON [dbo].[Bankruptcy] ([DebtorID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bankruptcy Information Table for Debtor Account', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'FileNumber - Master.Number ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'AccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The amount for which the item was auctioned ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'AuctionAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The amount of the auction funds applied to the account ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'AuctionAmountApplied'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date that the item will be auctioned ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'AuctionDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The fee for the auction ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'AuctionFee'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The name of the auction house which will auction off the item ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'AuctionHouse'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Auto Generated Unique Identifier ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'BankruptcyID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Case number assigned to the bankruptcy ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'CaseNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates how bankruptcy was filed. Chapters 7, 11, 12 or 13  ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'Chapter'
GO
EXEC sp_addextendedproperty N'MS_Description', N'General Comments ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'Comments'
GO
EXEC sp_addextendedproperty N'MS_Description', N'If the bankruptcy was originally filed under a different chapter, this would contain the original chapter number ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'ConvertedFrom'
GO
EXEC sp_addextendedproperty N'MS_Description', N'City for bankruptcy court address', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'CourtCity'
GO
EXEC sp_addextendedproperty N'MS_Description', N'District for court holding bankruptcy proceedings', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'CourtDistrict'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Division for court holding bankruptcy proceedings', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'CourtDivision'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Phone number for court assigned to bankruptcy proceedings', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'CourtPhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'State for bankruptcy court address', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'CourtState'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Address line 1 for bankruptcy court', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'CourtStreet1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Address line 2 for bankruptcy court', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'CourtStreet2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Zipcode for bankruptcy court address', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'CourtZipcode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Row Creation Date TimeStamp', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'CreatedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date case was filed with the bankruptcy court ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'DateFiled'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date that notice was received that the debtor has filed for bankruptcy ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'DateNotice'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Meeting of Creditors date ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'DateTime341'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Debtor Identifier - Debtor.DebtorID ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'DebtorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date that the debtor was discharged as bankrupt ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'DischargeDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date that the bankruptcy case was dismissed ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'DismissalDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Has information from Meeting of Creditors ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'Has341Info'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates the debt is secured for Chapter 7', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'HasAsset'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Location for Meeting of Creditors ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'Location341'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date that proof of claim was sent to the court ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'ProofFiled'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The method through which the account will be discharged when the debtor reaffirms the debt under new terms', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'Reaffirm'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The amount that the debtor has reaffirmed to pay ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'ReaffirmAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date that the reaffirmation is filed with the court ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'ReaffirmDateFiled'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Free text describing the agreed upon terms of reaffirmation ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'ReaffirmTerms'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The amount of the debt which is secured ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'SecuredAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The percentage of the debt amount which is secured', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'SecuredPercentage'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current status of Bankruptcy proceedings ... Attorney Retained - Not Filed , Filed - Not Discharged, Meeting of Creditors Set, Discharged, Dismissed ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'Status'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date that the item is surrendered when the debtor has chosen to surrender collateral', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'SurrenderDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Whether the item is shipped or picked up ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'SurrenderMethod'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of trustee given for bankruptcy case ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'Trustee'
GO
EXEC sp_addextendedproperty N'MS_Description', N'City for bankruptcy trustee ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'TrusteeCity'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Phone number for bankruptcy trustee ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'TrusteePhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'State for bankruptcy trustee address ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'TrusteeState'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Address line 1 for bankruptcy trustee ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'TrusteeStreet1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Address line 2 for bankruptcy trustee ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'TrusteeStreet2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Zipcode for bankruptcy trustee address ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'TrusteeZipcode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The amount of the debt which is unsecured ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'UnsecuredAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The percentage of the debt amount which is unsecured', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'UnsecuredPercentage'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Last updated Date Timestamp', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'UpdatedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The amount that the debtor will pay ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'VoluntaryAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date that the debtor has decided to pay off the debt when the choice is made to voluntarily pay off the debt, possibly under new terms, without officially filing through the court ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'VoluntaryDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Free text describing the terms of payment ', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'VoluntaryTerms'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bankruptcy withdrawn, the Petitioner has decided not file file bankruptcy and has taken back the petition', 'SCHEMA', N'dbo', 'TABLE', N'Bankruptcy', 'COLUMN', N'WithdrawnDate'
GO
