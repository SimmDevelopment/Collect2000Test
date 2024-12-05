CREATE TABLE [dbo].[MiscExtra]
(
[Number] [int] NULL,
[Title] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TheData] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[tr_AIM_MiscExtra_InsertOrUpdate]
ON  [dbo].[MiscExtra]
FOR UPDATE,INSERT
AS
BEGIN


if not exists(select top 1 accounttransactionid from aim_accounttransaction atr with (nolock) join aim_accountreference ar with (nolock) on ar.accountreferenceid = atr.accountreferenceid
join inserted i on i.number = ar.referencenumber where ar.referencenumber = i.number and atr.transactiontypeid=20 and transactionstatustypeid = 1 and foreigntableuniqueid = i.id)
begin
insert into AIM_accounttransaction (accountreferenceid,transactiontypeid,transactionstatustypeid,
createddatetime,agencyid,commissionpercentage,balance,foreigntableuniqueid)
select accountreferenceid,20,1,getdate(),currentlyplacedagencyid,currentcommissionpercentage,current0,i.id from aim_accountreference ar with (nolock) join master m with (nolock) on m.number = ar.referencenumber
join inserted i on i.number = m.number
where isplaced = 1

end

END

GO
ALTER TABLE [dbo].[MiscExtra] ADD CONSTRAINT [PK_MiscExtra] PRIMARY KEY NONCLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [IX_Miscextra_ID] ON [dbo].[MiscExtra] ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_MiscExtra_Number] ON [dbo].[MiscExtra] ([Number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_MiscExtra_Title_Number] ON [dbo].[MiscExtra] ([Title], [Number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Table retains miscellaneous debtor account information ', 'SCHEMA', N'dbo', 'TABLE', N'MiscExtra', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity key', 'SCHEMA', N'dbo', 'TABLE', N'MiscExtra', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'MiscExtra', 'COLUMN', N'Number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Data associated with Title and account', 'SCHEMA', N'dbo', 'TABLE', N'MiscExtra', 'COLUMN', N'TheData'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descriptive Title of Data or Code, Search Key, Display name in Latitude', 'SCHEMA', N'dbo', 'TABLE', N'MiscExtra', 'COLUMN', N'Title'
GO
