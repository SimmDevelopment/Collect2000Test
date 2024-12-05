SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [dbo].[fusion_UpdateRequestToRequested]
	@RequestID int , @XmlInfoRequested text,  @Filename varchar(2000)
AS
-- Name:			[fusion_UpdateRequestToRequested]
-- Function:		This procedure will update servicehistory record for outside service
--					after fusion processed the request
-- Creation:		9/28/2007 kmg
--			Used by Latitude Fusion.


	UPDATE ServiceHistory
	SET	RequestedDate = getdate(),
		Processed = 2,
		XmlInfoRequested = @XmlInfoRequested,
		[FileName] = @Filename
	WHERE RequestID = @RequestID


	INSERT INTO notes(number,created,user0,action,result,comment)
	SELECT sh.AcctID,getdate(),'FUSION','SEND','SEND',
	RTRIM(LTRIM(s.description)) + ' data ordered on ' + convert(varchar(10),getdate(),101) +
	'. Current Balance  = ' + RTRIM(LTRIM(cast(round(current0,2) as varchar)))
	FROM servicehistory sh (nolock)
	INNER JOIN services s (nolock)
	ON s.serviceid = sh.serviceid
	INNER JOIN master m (nolock)
	ON sh.Acctid = m.number
	WHERE sh.RequestId = @RequestID
	
GO
