SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionSetDefaultEmail    Script Date: 3/26/2007 9:52:01 AM ******/
-- =============================================
-- Author:		LionSetCompanyName
-- Create date: 12/08/2006
-- =============================================
CREATE PROCEDURE [dbo].[LionSetDefaultEmail]
	@defaultEmail varchar(2000)
AS
BEGIN
	SET NOCOUNT ON;

	Declare @defaultEmailKey varchar(100)
	set @defaultEmailKey = 'DefaultEmail'

	Declare @errorId int
	Declare @tranzName varchar(32)
	
	set @errorId = 0
	set @tranzName = 'SetLionCompanyName'

	BEGIN TRANSACTION @tranzName

	delete from LionAppSettings where Name=@defaultEmailKey
	
	SELECT @errorId = @@ERROR
	IF (@errorId <> 0) GOTO ERRORHANDLER

	Insert into LionAppSettings([Name],[Value])
	Values(@defaultEmailKey,@defaultEmail)

	SELECT @errorId = @@ERROR
	IF (@errorId <> 0) GOTO ERRORHANDLER
	
	COMMIT TRANSACTION @tranzName
	return

	ERRORHANDLER:
	if( @errorId != 0 )
	BEGIN
		--rollback the transaction
		ROLLBACK TRANSACTION @tranzName
		
		RAISERROR (N'Unable to set default email to %s. Error id %d',15,1, @defaultEmail,@errorId);
	END


END


GO
