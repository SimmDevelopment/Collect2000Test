SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*dbo.fusion_UpdateRequest*/
CREATE proc [dbo].[fusion_UpdateRequest]
	@RequestID int, @XmlInfoRequested text, @Processed int, @Filename varchar(2000)
AS
-- Name:			fusion_UpdateRequest
-- Function:		This procedure will update servicehistory record using input parms
-- Creation:		5/13/2006 jc
--					Used by Latitude Fusion.

	UPDATE [ServiceHistory]
		SET [ServiceHistory].[XmlInfoRequested] = @XmlInfoRequested,
		[ServiceHistory].[Processed] = @Processed,
		[ServiceHistory].[FileName] = @Filename
	FROM [dbo].[ServiceHistory] AS [ServiceHistory]
	WHERE [ServiceHistory].[RequestID] = @RequestID
GO
