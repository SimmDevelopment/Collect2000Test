CREATE TABLE [dbo].[Debtor_Assets]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[DebtorID] [int] NOT NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AssetType] [tinyint] NOT NULL,
[Description] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CurrentValue] [money] NULL,
[LienAmount] [money] NULL,
[ValueVerified] [bit] NOT NULL,
[LienVerified] [bit] NOT NULL,
[OutsideAssetID] [int] NULL,
[Created] [datetime] NOT NULL CONSTRAINT [DF__Debtor_As__Creat__39A4FF8C] DEFAULT (getdate()),
[Modified] [datetime] NOT NULL CONSTRAINT [DF__Debtor_As__Modif__3A9923C5] DEFAULT (getdate()),
[ModifiedBy] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[tr_AIM_DebtorAssets_InsertOrUpdate]
ON  [dbo].[Debtor_Assets]
FOR UPDATE,INSERT
AS
BEGIN


if not exists(select top 1 accounttransactionid from aim_accounttransaction atr with (nolock) join aim_accountreference ar  with (nolock) on ar.accountreferenceid = atr.accountreferenceid
join inserted i on i.accountid = ar.referencenumber where ar.referencenumber = i.accountid and atr.transactiontypeid=31 and transactionstatustypeid = 1 and foreigntableuniqueid = i.id)
begin
insert into AIM_accounttransaction (accountreferenceid,transactiontypeid,transactionstatustypeid,
createddatetime,agencyid,commissionpercentage,balance,foreigntableuniqueid)
select accountreferenceid,31,1,getdate(),currentlyplacedagencyid,currentcommissionpercentage,current0,i.id 
from aim_accountreference ar  with (nolock) 
join master m with (nolock) on m.number = ar.referencenumber
join inserted i on i.accountid = m.number
join aim_agency as a with (nolock)
on a.agencyid = currentlyplacedagencyid
where isplaced = 1 and i.ModifiedBy <> 'AIM' AND ISNULL(RTRIM(LTRIM(a.agencyversion)),'') != '8.2.2'

end

END

GO
ALTER TABLE [dbo].[Debtor_Assets] ADD CONSTRAINT [PK_Debtor_Assets] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Debtor_Assets_AccountID] ON [dbo].[Debtor_Assets] ([AccountID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Debtor_Assets_DebtorID] ON [dbo].[Debtor_Assets] ([DebtorID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Debtor_Assets] WITH NOCHECK ADD CONSTRAINT [FK_Debtor_Assets_Debtors] FOREIGN KEY ([DebtorID]) REFERENCES [dbo].[Debtors] ([DebtorID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table allows your agency to track asset information for each debtor attached to an account', 'SCHEMA', N'dbo', 'TABLE', N'Debtor_Assets', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'Debtor_Assets', 'COLUMN', N'AccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'1 - Other, 2 - Automobile, 3 - Real Property, 4 - Bank Account, 5 - Securities, 6 - Personal property, 7 - Business Equipment, 8 - Farm Equipment', 'SCHEMA', N'dbo', 'TABLE', N'Debtor_Assets', 'COLUMN', N'AssetType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The DateTime stamp for the creation of this debtor asset', 'SCHEMA', N'dbo', 'TABLE', N'Debtor_Assets', 'COLUMN', N'Created'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Users.LoginName when created in house, it will equal ''AIM'' when created externally', 'SCHEMA', N'dbo', 'TABLE', N'Debtor_Assets', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current value of asset', 'SCHEMA', N'dbo', 'TABLE', N'Debtor_Assets', 'COLUMN', N'CurrentValue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtor Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'Debtor_Assets', 'COLUMN', N'DebtorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description of asset', 'SCHEMA', N'dbo', 'TABLE', N'Debtor_Assets', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'Debtor_Assets', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total lien amount  placed on asset', 'SCHEMA', N'dbo', 'TABLE', N'Debtor_Assets', 'COLUMN', N'LienAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator for lein verification', 'SCHEMA', N'dbo', 'TABLE', N'Debtor_Assets', 'COLUMN', N'LienVerified'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The DateTime stamp for the last time this debtor asset was modified', 'SCHEMA', N'dbo', 'TABLE', N'Debtor_Assets', 'COLUMN', N'Modified'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The entity modifying the debtor asset, In the case of manual modification this will contain the Latitude username, in the case of an outside entity this will contain AIM', 'SCHEMA', N'dbo', 'TABLE', N'Debtor_Assets', 'COLUMN', N'ModifiedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of Asset', 'SCHEMA', N'dbo', 'TABLE', N'Debtor_Assets', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID of the asset in the third party system when created externally, NULL when created internally', 'SCHEMA', N'dbo', 'TABLE', N'Debtor_Assets', 'COLUMN', N'OutsideAssetID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator for asset value verification', 'SCHEMA', N'dbo', 'TABLE', N'Debtor_Assets', 'COLUMN', N'ValueVerified'
GO
