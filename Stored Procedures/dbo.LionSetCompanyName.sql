SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionSetCompanyName    Script Date: 3/26/2007 9:52:01 AM ******/
-- =============================================
-- Author:		LionSetCompanyName
-- Create date: 12/08/2006
-- =============================================
CREATE PROCEDURE [dbo].[LionSetCompanyName]
	-- Add the parameters for the stored procedure here
	@company varchar(2000)
AS
BEGIN
	SET NOCOUNT ON;

	Declare @errorId int
	Declare @tranzName varchar(32)
	
	set @errorId = 0
	set @tranzName = 'SetLionCompanyName'

	BEGIN TRANSACTION @tranzName

	delete from LionAppSettings where Name='CompanyName'
	
	SELECT @errorId = @@ERROR
	IF (@errorId <> 0) GOTO ERRORHANDLER

	Insert into LionAppSettings([Name],[Value])
	Values('CompanyName',@company)

	SELECT @errorId = @@ERROR
	IF (@errorId <> 0) GOTO ERRORHANDLER
	
	COMMIT TRANSACTION @tranzName
	return

	ERRORHANDLER:
	if( @errorId != 0 )
	BEGIN
		--rollback the transaction
		ROLLBACK TRANSACTION @tranzName
		
		RAISERROR (N'Unable to set company name to %s. Error id %d',15,1, @company,@errorId);
	END


END

GO
