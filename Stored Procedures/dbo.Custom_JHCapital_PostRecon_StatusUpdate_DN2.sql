SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_JHCapital_PostRecon_StatusUpdate_DN2]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- Removed all but first 3 columns, Data_id, Status_Code and Status_date
	

    -- Insert statements for procedure here
	SELECT zjcrf.data_id AS data_id, 
	(SELECT TOP 1 StatusCode FROM Custom_JHCapital_Status_Codes WITH (NOLOCK) WHERE DataID = zjcrf.data_id ORDER BY Statusdate DESC) AS placedetail_status, 
	dbo.date(GETDATE()) AS status_date, 
	'' AS bk_filing,
	'' AS bk_chapter,
	'' AS bk_case,
	'' AS bk_disposition,
	'' AS bk_location,
	'' AS dec_date,
	'' AS rec_date, 
	'' AS promise_due,
	'' AS promise_amount,
	'' AS keeper
	
FROM ztempJHCapitalReconFix zjcrf	WITH (NOLOCK) 



END
GO
