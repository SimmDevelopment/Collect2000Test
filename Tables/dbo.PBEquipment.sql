CREATE TABLE [dbo].[PBEquipment]
(
[Number] [int] NULL,
[Act#] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Collat_desc] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Lic#] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Vin#] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Yr] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mk] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mdl] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Ser] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Color] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Key_CD] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Cond] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Loc] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tag#] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Dlr#] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PLN_CD] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Repo_DT] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DSP_DT] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Ins] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Prd_Cmplt#] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Val] [money] NULL,
[UCC_CD] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fil_DT] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fil_Loc] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[X_COll] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LN#] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rec_Mthd_CD] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reas_CD] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Typ_CO_CD] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DSP_CD] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DSP_ANAL] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Recovered] [bit] NOT NULL CONSTRAINT [DF_PBEquipment_Recovered] DEFAULT ((0)),
[RecoveredDate] [datetime] NULL,
[Commissionable] [bit] NULL,
[WhenLoaded] [datetime] NULL CONSTRAINT [DF_PBEquipment_WhenLoaded] DEFAULT (getdate()),
[UID] [int] NOT NULL IDENTITY(1, 1),
[RecoveredSystemMonth] [int] NULL,
[RecoveredSystemYear] [int] NULL,
[AIMAgencyID] [int] NULL,
[AIMBatchID] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[tr_PBEquipment_InsertOrUpdate]
ON  [dbo].[PBEquipment]
FOR UPDATE,INSERT
AS

BEGIN
	if exists(select top 1 a.agencyid
				from inserted i
				join aim_accountreference ar with (nolock) on i.number = ar.referencenumber
				join aim_agency a with (nolock) on ar.currentlyplacedagencyid = a.agencyid
				where a.fileformat <> 'YGC')
		begin	
	IF NOT EXISTS
	(SELECT TOP 1 accounttransactionid 
	FROM aim_accounttransaction atr WITH (NOLOCK)
	JOIN aim_accountreference ar WITH (NOLOCK)
	ON ar.accountreferenceid = atr.accountreferenceid
	JOIN inserted i ON i.number = ar.referencenumber 
	WHERE ar.referencenumber = i.number AND transactionstatustypeid = 1 AND 
	((atr.transactiontypeid=27  AND foreigntableuniqueid = i.uid) OR (atr.transactiontypeid = 3))
	)
		BEGIN
		INSERT INTO AIM_accounttransaction (accountreferenceid,transactiontypeid,transactionstatustypeid,createddatetime,agencyid,commissionpercentage,balance,foreigntableuniqueid)
		SELECT accountreferenceid,27,1,getdate(),currentlyplacedagencyid,currentcommissionpercentage,current0,i.uid 
		FROM aim_accountreference ar WITH (NOLOCK)
		JOIN master m WITH (NOLOCK) ON m.number = ar.referencenumber
		JOIN inserted i ON i.number = m.number
		WHERE isplaced = 1

		END
		end
END

GO
ALTER TABLE [dbo].[PBEquipment] ADD CONSTRAINT [PK_PBEquipment] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PBEquipment_Number] ON [dbo].[PBEquipment] ([Number]) ON [PRIMARY]
GO
