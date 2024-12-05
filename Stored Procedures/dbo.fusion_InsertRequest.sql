SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*dbo.fusion_InsertRequest*/
CREATE proc [dbo].[fusion_InsertRequest]
	@RequestID int output, @DebtorID int, @ServiceID int, @BatchID uniqueidentifier, 
	@ProfileID uniqueidentifier, @RequestedBy varchar(256), @RequestedProgram varchar(256)
AS
-- Name:			fusion_InsertRequest
-- Function:		This procedure will insert servicehistory record for outside service
-- Creation:		5/13/2006 jc
--			Used by Latitude Fusion.

	DECLARE @SystemMonth int, @SystemYear int, @Number int

	SELECT @SystemMonth = [ControlFile].[CurrentMonth], @SystemYear = [ControlFile].[CurrentYear] 
	FROM [dbo].[ControlFile] AS [ControlFile] WITH(NOLOCK)

	SELECT @Number = number FROM [dbo].[debtors] AS [debtors] WITH(NOLOCK)
	WHERE [debtors].[debtorid] = @DebtorID

	INSERT INTO ServiceHistory (AcctId, DebtorId, CreationDate, RequestedBy, RequestedProgram, 
		ServiceId, SystemYear, SystemMonth, Processed, BatchID, ProfileID)
	VALUES (@Number, @DebtorID, getdate(), @RequestedBy, @RequestedProgram, 
		@ServiceID, @SystemYear, @SystemMonth, 0, @BatchID, @ProfileID)

	SET @RequestID = @@identity
GO
