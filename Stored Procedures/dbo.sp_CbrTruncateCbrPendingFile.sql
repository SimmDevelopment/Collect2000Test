SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*dbo.sp_CbrTruncateCbrPendingFile*/
CREATE      PROCEDURE [dbo].[sp_CbrTruncateCbrPendingFile]
	@ErrNum	INT OUTPUT
-- Name:	sp_CbrTruncateCbrPendingFile
-- Function:	This procedure will delete all records from CbrPendingFile table
--		This sp should only be called from sp_CbrLoadCbrPendingTable
-- Creation:	01/16/2003 (jcc)    
-- Change History: 
--		09/01/2004 jc create a backup copy CbrForced_backup of the
--		CbrForced table
--		09/01/2004 jc create a backup copy CbrStopRequest_rollback of the
--		CbrStopRequest table 	
AS
	SET @ErrNum = 0

	--drop an existing CbrForced_backup table if there is one
	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CbrForced_backup]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CbrForced_backup]
	
	--drop an existing CbrStopRequest_rollback table if there is one
	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CbrStopRequest_rollback]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CbrStopRequest_rollback]

	--Create a backup copy of the CbrForced table
	SELECT * INTO CbrForced_backup FROM CbrForced
	
	--Create a rollback copy of the CbrStopRequest table
	SELECT * INTO CbrStopRequest_rollback FROM CbrStopRequest

	--Truncate CbrPendingFile table
	TRUNCATE TABLE CbrPendingFile


	IF (@@Error!=0)
	BEGIN
    	SET @ErrNum = @@Error
    	RAISERROR  ('20000',16,1,'Error encountered in sp_CbrTruncateCbrPendingFile.')
    	RETURN(1)
	END	

	SET @ErrNum = 0
GO
