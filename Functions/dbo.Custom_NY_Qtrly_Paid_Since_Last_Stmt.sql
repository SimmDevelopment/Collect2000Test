SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--  07/08/2015  Created function to calculate buckets for the New York Quarterly Statement Letter NY01

CREATE FUNCTION [dbo].[Custom_NY_Qtrly_Paid_Since_Last_Stmt] (@number INT, @whichBucket INT)
RETURNS MONEY
AS BEGIN

	DECLARE @Temp MONEY;
	DECLARE @qtr INT;
	SET @qtr = CASE when month(GETDATE()) IN (3, 4) THEN 1
					when month(GETDATE()) IN (6, 7) THEN 2
					when month(GETDATE()) IN (9, 10) THEN 3
					when month(GETDATE()) IN (12, 1) THEN 4
				end
	SET @Temp = 0;
	SELECT @Temp=
	CASE @whichBucket
		WHEN 1 THEN 
			ISNULL(SUM(CASE WHEN ph.BatchType IN('PU', 'PC') THEN ph.paid1 ELSE ph.paid1*-1 END),0)
		WHEN 2 THEN 
			ISNULL(SUM(CASE WHEN ph.BatchType IN('PU', 'PC') THEN ph.paid2 ELSE ph.paid2*-1 END),0)
		WHEN 3 THEN 
			ISNULL(SUM(CASE WHEN ph.BatchType IN('PU', 'PC') THEN ph.paid3 ELSE ph.paid3*-1 END),0)
		WHEN 4 THEN 
			ISNULL(SUM(CASE WHEN ph.BatchType IN('PU', 'PC') THEN ph.paid4 ELSE ph.paid4*-1 END),0)
		WHEN 5 THEN 
			ISNULL(SUM(CASE WHEN ph.BatchType IN('PU', 'PC') THEN ph.paid5 ELSE ph.paid5*-1 END),0)
		WHEN 6 THEN 
			ISNULL(SUM(CASE WHEN ph.BatchType IN('PU', 'PC') THEN ph.paid6 ELSE ph.paid6*-1 END),0)
		WHEN 10 THEN 
			ISNULL(SUM(CASE WHEN ph.BatchType IN('PU', 'PC') THEN ph.paid10 ELSE ph.paid10*-1 END),0)
		WHEN 12 THEN 
			ISNULL(SUM(CASE WHEN ph.BatchType IN('PU', 'PC') THEN ph.paid1 + ph.paid2 + ph.paid3 + ph.paid4 + ph.paid5 + ph.paid6 + ph.paid10 
			ELSE (ph.paid1 + ph.paid2 + ph.paid3 + ph.paid4 + ph.paid5 + ph.paid6 + ph.paid10)*-1 END),0)
		ELSE 
			0
	END
	FROM master m WITH (NOLOCK)
	LEFT OUTER JOIN payhistory ph WITH (NOLOCK)
	ON m.number=ph.number AND
	ph.BatchType LIKE ('P%') 
	WHERE m.number=@number	AND datepaid BETWEEN dbo.F_START_OF_MONTH(DATEADD(mm, -2, DATEADD(dd, -15, GETDATE()))) and DATEADD(ss, -1, dbo.F_START_OF_MONTH(DATEADD(mm, 1, DATEADD(dd, -15, GETDATE()))))
	RETURN @Temp;
END





GO
