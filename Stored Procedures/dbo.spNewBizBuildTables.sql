SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*spNewBizBuildTables*/
CREATE PROCEDURE [dbo].[spNewBizBuildTables] 
AS 
SET NOCOUNT ON 
if exists (select * from dbo.sysobjects where id = object_id(N'[NewBizBDebtors]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) 
drop table [NewBizBDebtors] 
EXEC spCopyTableSchema @srctable = 'Debtors', @desttable = 'NewBizBDebtors' 
if exists (select * from dbo.sysobjects where id = object_id(N'[newbizbmaster]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) 
drop table [newbizbmaster] 
EXEC spCopyTableSchema @srctable = 'master', @desttable = 'NewBizBMaster' 
if exists (select * from dbo.sysobjects where id = object_id(N'[NewBizBMiscExtra]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) 
drop table [NewBizBMiscExtra] 
EXEC spCopyTableSchema @srctable = 'MiscExtra', @desttable = 'NewBizBMiscExtra' 
if exists (select * from dbo.sysobjects where id = object_id(N'[NewBizBNotes]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) 
drop table [NewBizBNotes] 
EXEC spCopyTableSchema @srctable = 'Notes', @desttable = 'NewBizBNotes' 
if exists (select * from dbo.sysobjects where id = object_id(N'[NewBizBDebtBuyerItems]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) 
drop table [NewBizBDebtBuyerItems] 
EXEC spCopyTableSchema @srctable = 'DebtBuyerItems', @desttable = 'NewBizBDebtBuyerItems' 
if exists (select * from dbo.sysobjects where id = object_id(N'[NewBizBExtraData]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) 
drop table [NewBizBExtraData] 
EXEC spCopyTableSchema @srctable = 'ExtraData', @desttable = 'NewBizBExtraData'

GO
