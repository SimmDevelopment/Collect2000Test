SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE                 FUNCTION [dbo].[Custom_ShermanBalanceByBucket] (@number INT, @whichBucket INT)
RETURNS MONEY
AS BEGIN

	DECLARE @Temp MONEY;
	DECLARE @fileRundate datetime;
	SET @Temp = 0;
	SET @fileRundate = '2006-11-21 00:00:00.000'
	SELECT @Temp=
	CASE @whichBucket
		WHEN 1 THEN 
			m.current1 + ISNULL(SUM(CASE WHEN ph.BatchType IN('PU','DA','PC') THEN ph.paid1 ELSE ph.paid1*-1 END),0)
		WHEN 2 THEN 
			m.current2 + ISNULL(SUM(CASE WHEN ph.BatchType IN('PU','DA','PC') THEN ph.paid2 ELSE ph.paid2*-1 END),0)
		WHEN 3 THEN 
			m.current3 + ISNULL(SUM(CASE WHEN ph.BatchType IN('PU','DA','PC') THEN ph.paid3 ELSE ph.paid3*-1 END),0)
		WHEN 4 THEN 
			m.current4 + ISNULL(SUM(CASE WHEN ph.BatchType IN('PU','DA','PC') THEN ph.paid4 ELSE ph.paid4*-1 END),0)
		WHEN 5 THEN 
			m.current5 + ISNULL(SUM(CASE WHEN ph.BatchType IN('PU','DA','PC') THEN ph.paid5 ELSE ph.paid5*-1 END),0)
		ELSE 
			0
	END
	FROM master m WITH (NOLOCK)
	LEFT OUTER JOIN payhistory ph WITH (NOLOCK)
	ON m.number=ph.number AND
-- Commented out by KAR this was for a quick fix that occured on BAL file had timing issues
--	(ph.invoiced IS NULL OR 
--	(ph.invoiced IS NOT NULL AND CAST(CONVERT(varchar(10),ph.invoiced,20) + ' 00:00:00.000' as datetime)>=@fileRundate)) AND
--	(ph.BatchType IN('PU') OR
--	(ph.BatchType IN('PUR') AND ph.reverseofUID IS NOT NULL AND ph.reverseofuid <> 0))
	(ph.invoiced IS NULL) AND
	(ph.BatchType IN('PU') OR
	(ph.BatchType IN('PUR') AND ph.reverseofUID IS NOT NULL AND ph.reverseofuid <> 0))
	WHERE m.number=@number
	GROUP by m.number,m.current1,m.current2,m.current3,m.current4,current5
	RETURN @Temp;
END





GO
