SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionGetAuditActionByUid    Script Date: 3/26/2007 9:52:00 AM ******/
-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 12/27/2006
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[LionGetAuditActionByUid]
	-- Add the parameters for the stored procedure here
	@uid uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON;

	Select	 ID, Uid, Description 
	From LionAuditActions
	Where Uid=@uid


END

GO
