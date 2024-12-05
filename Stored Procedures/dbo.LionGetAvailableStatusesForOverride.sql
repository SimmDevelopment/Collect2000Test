SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionGetAvailableStatusesForOverride    Script Date: 3/26/2007 9:52:01 AM ******/
-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 01/02/2007
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[LionGetAvailableStatusesForOverride]
AS
BEGIN
	SET NOCOUNT ON;

	Select code,description
	From LionStatusView lsv with (nolock)
	Left Join LionStatus ls with (nolock) on ls.StatusCode=lsv.code
	where ls.id is null
	order by code

END


GO
