SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 05/02/2006
-- Description: This is the SP that the DBReflector will call to get all the columns contained in a given table
-- =============================================
/*
usage.CONSTRAINT_NAME
select top 10 * from INFORMATION_SCHEMA.KEY_COLUMN_USAGE
*/
CREATE PROCEDURE [dbo].[DBReflectorGetTableColumns]
	@tableName varchar(255)
AS
BEGIN
	SET NOCOUNT ON;

	Select	col.TABLE_NAME			AS [TableName],
			col.COLUMN_NAME			as [ColumnName],
			col.ORDINAL_POSITION	as [OrdinalPosition],
			col.COLUMN_NAME			as [ColumnName],

--			Case
--				When exists( 
--						Select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS const with (nolock)
--						left join INFORMATION_SCHEMA.KEY_COLUMN_USAGE usage on usage.TABLE_NAME=const.TABLE_NAME
--						Where const.TABLE_NAME=@tableName and usage.COLUMN_NAME=col.COLUMN_NAME and const.CONSTRAINT_TYPE='PRIMARY KEY' )
--				Then	'True'
--				Else	'False'
--			End						as [IsPrimaryKey],

			Case
				When usage.CONSTRAINT_NAME is not null then 'True'
				Else	'False'
			End						as [IsPrimaryKey],			

			Case
				When col.Is_Nullable='YES' Then 'True'
				Else 'False'
			End						as [IsNullable],
			col.DATA_TYPE			as [DataType],
			col.CHARACTER_MAXIMUM_LENGTH as [CharacterMaxLen],			
--usage.CONSTRAINT_NAME,
--usage.*,
--tCon.*,
			--col.*,
			'end'
	From INFORMATION_SCHEMA.COLUMNS col with (nolock)
--	left join INFORMATION_SCHEMA.KEY_COLUMN_USAGE keyCol on keyCol.COLUMN_NAME=col.COLUMN_NAME and keyCol.TABLE_NAME=col.TABLE_NAME
--	left join INFORMATION_SCHEMA.TABLE_CONSTRAINTS tCon on tCon.TABLE_NAME=col.TABLE_NAME and tCon.CONSTRAINT_NAME=keyCol.CONSTRAINT_NAME

	left join INFORMATION_SCHEMA.TABLE_CONSTRAINTS tCon 
		on tCon.TABLE_NAME=col.TABLE_NAME 
		--and tCon.CONSTRAINT_NAME=keyCol.CONSTRAINT_NAME
		and tCon.CONSTRAINT_TYPE='PRIMARY KEY'

	left join INFORMATION_SCHEMA.KEY_COLUMN_USAGE usage 
		on	usage.TABLE_NAME=@tableName
			and usage.COLUMN_NAME=col.COLUMN_NAME
			and usage.CONSTRAINT_NAME=tCon.CONSTRAINT_NAME
		
	Where col.TABLE_NAME=@tableName
	Order by col.ORDINAL_POSITION asc	

END

GO
