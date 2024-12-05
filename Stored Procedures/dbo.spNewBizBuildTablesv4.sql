SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*spNewBizBuildTablesv4*/
CREATE PROCEDURE [dbo].[spNewBizBuildTablesv4] @Table_Identifier  VARCHAR(100)
AS 
SET NOCOUNT ON 

DECLARE @Table_Name SYSNAME;
DECLARE @SQL NVARCHAR(500);

SET @Table_Name = QUOTENAME('NewBizBDebtors' + @Table_Identifier);
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = OBJECT_ID(@Table_Name) AND OBJECTPROPERTY(ID, N'IsUserTable') = 1) BEGIN
	SELECT @SQL = 'DROP TABLE ' + @Table_Name;
	EXEC sp_executesql @SQL;
END;
EXEC spCopyTableSchemav4 @srctable = 'Debtors', @desttable = @Table_Name;

SET @Table_Name = QUOTENAME('NewBizBMaster' + @Table_Identifier);
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = OBJECT_ID(@Table_Name  + '') AND OBJECTPROPERTY(ID, N'IsUserTable') = 1) BEGIN
	SELECT @SQL = 'DROP TABLE ' + @Table_Name;
	EXEC sp_executesql @SQL;
END;
EXEC spCopyTableSchemav4 @srctable = 'master', @desttable = @Table_Name; 

SET @Table_Name = QUOTENAME('NewBizBMiscExtra' + @Table_Identifier);
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = OBJECT_ID(@Table_Name) AND OBJECTPROPERTY(ID, N'IsUserTable') = 1) BEGIN
	SELECT @SQL = 'DROP TABLE ' + @Table_Name;
	EXEC(@SQL) 
END
EXEC spCopyTableSchemav4 @srctable = 'MiscExtra', @desttable = @Table_Name;

SET @Table_Name = QUOTENAME('NewBizBNotes' + @Table_Identifier);
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = OBJECT_ID(@Table_Name) AND OBJECTPROPERTY(ID, N'IsUserTable') = 1) BEGIN
	SELECT @SQL = 'DROP TABLE ' + @Table_Name;
	EXEC(@SQL) 
END
EXEC spCopyTableSchemav4 @srctable = 'Notes', @desttable = @Table_Name;

SET @Table_Name = QUOTENAME('NewBizBDebtBuyerItems' + @Table_Identifier);
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = OBJECT_ID(@Table_Name) AND OBJECTPROPERTY(ID, N'IsUserTable') = 1) BEGIN
	SELECT @SQL = 'DROP TABLE ' + @Table_Name;
	EXEC sp_executesql @SQL;
END
EXEC spCopyTableSchemav4 @srctable = 'DebtBuyerItems', @desttable = @Table_Name;

SET @Table_Name = QUOTENAME('NewBizBExtraData' + @Table_Identifier);
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = OBJECT_ID(@Table_Name) AND OBJECTPROPERTY(ID, N'IsUserTable') = 1) BEGIN
	SELECT @SQL = 'DROP TABLE ' + @Table_Name;
	EXEC sp_executesql @SQL;
END
EXEC spCopyTableSchemav4 @srctable = 'ExtraData', @desttable = @Table_Name;


GO
