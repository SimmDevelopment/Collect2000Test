SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.spls_FormatRequest    Script Date: 12/21/2005 4:22:08 PM ******/

/*dbo.spls_FormatRequest*/
CREATE proc [dbo].[spls_FormatRequest]
	@RequestID int, @XmlInfoRequested ntext
AS
-- Name:		spls_FormatRequest
-- Function:		This procedure will update servicehistory record using input parm @XmlInfoRequested
-- Creation:		10/5/2004 jc
--			Used by Latitude Scheduler.

	update ServiceHistory set XmlInfoRequested = @XmlInfoRequested 
	where RequestID = @RequestID


GO
