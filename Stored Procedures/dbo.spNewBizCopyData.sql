SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*spNewBizCopyData*/
CREATE PROCEDURE [dbo].[spNewBizCopyData] 
AS 
EXEC spCopyToTable @srctable = '[NewBizBMaster]', @desttable = '[master]' 
EXEC spCopyToTable @srctable = '[NewBizBDebtors]', @desttable = '[Debtors]' 
EXEC spCopyToTable @srctable = '[NewBizBMiscExtra]', @desttable = '[MiscExtra]' 
EXEC spCopyToTable @srctable = '[NewBizBNotes]', @desttable = '[notes]' 
EXEC spCopyToTable @srctable = '[NewBizBDebtBuyerItems]', @desttable = '[DebtBuyerItems]' 
EXEC spCopyToTable @srctable = '[NewBizBExtraData]', @desttable = '[ExtraData]'

GO
