SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*dbo.sp_CbrSetStopRequest*/
CREATE     PROCEDURE [dbo].[sp_CbrSetStopRequest]
	@AccountId	INT 
-- Name:	sp_CbrSetStopRequest
-- Function:	This procedure will create a credit bureau stop request record for the
--		accountid passed as an input parameter.
-- Creation:	02/06/2003 (jcc)    
-- Change History: 
--             
AS

	--Delete any previous stop requests for this account
	DELETE FROM CbrStopRequest WHERE Number = @AccountId

	--Insert a stop request for this account
	INSERT INTO CbrStopRequest (Number, WhenCreated) VALUES (@AccountId, getdate())
GO
