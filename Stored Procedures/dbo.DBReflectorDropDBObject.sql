SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Sayed Ibrahim Hashimi
-- Create date: 12/29/2005
-- Description:	Will drop a database object given its name. This is used in the DBReflector package
--				if modified that may break, do not unknowlinginly chage it.
--				Each object type has 2 codes a long name and a short name
--
--					Type			Codes
--					stored proc		PROCEDURE
--									P
--					function		FUNCTION
--									F
--					table			TABLE
--									T
--					view			VIEW
--									V
-- =============================================
CREATE PROCEDURE [dbo].[DBReflectorDropDBObject]
	@Name varchar(128),
	@Type varchar(20)
AS
Declare @DropSql as varchar(1000)

Declare @DropProc as varchar(1000)
Declare @DropFunction as varchar(1000)
--Declare @DropTable as varchar(1000)
--Declare @DropView as varchar(1000)
BEGIN
	SET NOCOUNT ON;

	Set @DropProc = 'if exists (select * from dbo.sysobjects where id = object_id(N''[' + 
					@Name + ']'') and OBJECTPROPERTY(id, N''IsProcedure'') = 1)' + 
					' Drop Procedure [' + @Name + ']'
					
	Select @DropSql = 
		CASE(@Type)
			WHEN 'PROCEDURE' THEN @DropProc
			WHEN 'P' THEN @DropProc

			ELSE
				'error'-- Dropping of database object type [' + @Type + '] Not supported'
		END

		if( @DropSql='error' )
		begin
			Declare @ErrorMessage varchar(500)
			Set @ErrorMessage = 'Dropping of database object type [' + @Type + '] Not supported'
			RaisError(@ErrorMessage,10,1,@Type)
		end

		--SELECT @DropSql
		EXEC (@DropSql)
END




GO
