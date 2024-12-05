SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Mike Devlin
-- Create date: 11/21/2007
-- Description:	Update the master.QLevel value.
-- $History: /GSSI/Core/Database/8.1.0/StoredProcedures/dbo.Latitude_Update_Master_QLevel.sql $
--  
--  ****************** Version 1 ****************** 
--  User: jspindler   Date: 2009-05-21   Time: 16:08:06-04:00 
--  Updated in: /GSSI/Core/Database/8.1.0/StoredProcedures 
-- =============================================
CREATE PROCEDURE [dbo].[Latitude_Update_Master_QLevel] 
	@FileNumber int,
	@NewQLevel varchar(3)
AS
BEGIN
	SET NOCOUNT ON;

    UPDATE master
	SET QLevel = @NewQLevel
	WHERE number = @FileNumber

	RETURN @@ERROR
END


GO
