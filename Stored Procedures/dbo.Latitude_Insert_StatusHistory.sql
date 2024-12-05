SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Mike Devlin
-- Create date: 11/14/2007
-- Description:	Insert a record in the StatusHistory table.
--				Called after the status has been updated.
-- History: tag removed
--  
--  ****************** Version 1 ****************** 
--  User: jspindler   Date: 2009-05-21   Time: 16:08:06-04:00 
--  Updated in: /GSSI/Core/Database/8.1.0/StoredProcedures 
-- =============================================
CREATE PROCEDURE [dbo].[Latitude_Insert_StatusHistory]
	@FileNumber int,
	@UserName varchar(50),
	@OldStatus varchar(5),
	@NewStatus varchar(5)
AS
BEGIN
	INSERT INTO StatusHistory
	(AccountID, DateChanged, UserName, OldStatus, NewStatus)
	VALUES
	(@FileNumber, GetDate(), @UserName, @OldStatus, @NewStatus)

	Return @@Error
END
GO
