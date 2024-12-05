SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE  FUNCTION [dbo].[fn_Custom_TotalPaidIncludingPayment] (@number INT, @UID INT)
RETURNS MONEY
AS BEGIN

	DECLARE @Temp MONEY;
	SET @Temp = 0;
	SELECT @Temp= ISNULL(SUM(CASE WHEN ph.batchtype IN ('PAR','PCR','PUR','DAR') THEN ph.totalpaid*-1 ELSE ph.totalpaid END),0)
	FROM master m WITH (NOLOCK)
	INNER JOIN payhistory ph WITH(NOLOCK)
	ON m.number=ph.number
	WHERE m.number=@number AND ph.UID <= @UID AND
	ph.BatchType IN('PA','PC','PU','PAR','PCR','PUR','DA','DAR')
	GROUP by m.number
	RETURN @Temp;
END


GO
