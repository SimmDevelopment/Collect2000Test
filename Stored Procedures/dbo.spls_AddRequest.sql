SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/****** Object:  Stored Procedure dbo.spls_AddRequest    Script Date: 12/21/2005 4:22:07 PM ******/

/*dbo.spls_AddRequest*/
CREATE  proc [dbo].[spls_AddRequest]
	@RequestID int output, @DebtorID int, @ServiceID int, @BatchID uniqueidentifier, 
	@ProfileID uniqueidentifier, @RequestedBy varchar(256), @RequestedProgram varchar(256)
AS
-- Name:		spls_AddRequest
-- Function:		This procedure will insert servicehistory record for outside service
--			This sp was derived from AddServiceHistoryRequest created by jh
-- Creation:		05/25/2004 jc
--			Used by Latitude Scheduler.
-- Change History:	10/1/2004 jc added new input parm to support new column
--			in servicehistory table (BatchID)
--			10/5/2004 jc changed from one add request sp to this insert request
--			spls_AddRequest which now returns the RequestID as an output parm.
--			The returned requestid is then used to format the request using new
--			sp spls_FormatRequest
-- 			10/11/2004 jc added new input parm to support new column
--			in servicehistory table (ProductID)

	declare @SystemMonth int, @SystemYear int, @Number int
	select @SystemMonth=CurrentMonth,@SystemYear=CurrentYear from ControlFile
	set @Number = (select number from debtors where debtorid=@debtorid)

	insert into ServiceHistory (AcctId, DebtorId, CreationDate, RequestedBy, RequestedProgram, 
		ServiceId, SystemYear, SystemMonth, Processed, BatchID, ProfileID)
	values (@Number, @DebtorId, getdate(), @RequestedBy, @RequestedProgram, 
		@ServiceId, @SystemYear, @SystemMonth, 0, @BatchID, @ProfileID)

	set @RequestID = SCOPE_IDENTITY()



GO
