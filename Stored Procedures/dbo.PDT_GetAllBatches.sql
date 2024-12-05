SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[PDT_GetAllBatches]
AS

DECLARE @Version INT
SELECT @Version = CAST(LEFT(SoftwareVersion,1) AS INT) FROM CONTROLFILE

IF(@Version < 8)
BEGIN
	SELECT
	BatchNumber as [Batch ID],
	[Created] = max(Entered),
	[Count] = count(*),
	[Total Paid] = sum(Paid0)

	FROM
	PaymentBatchItems pbi WITH (NOLOCK)  JOIN PDTTemp pdtt
	 WITH (NOLOCK) ON pdtt.BatchID = pbi.BatchNumber
	AND pbi.Comment LIKE 'PDT%' AND( (replace(pbi.comment,'PDT:CC:','')= cast(pdtt.pdtid as varchar) AND pdtt.iscreditcard = 1) OR
	(replace(pbi.comment,'PDT:NONCC:','') = cast(pdtt.pdtid as varchar) AND pdtt.iscreditcard = 0))

	GROUP BY pbi.batchnumber
END
ELSE
BEGIN
	SELECT
	BatchNumber as [Batch ID],
	[Created] = max(Entered),
	[Count] = count(*),
	[Total Paid] = sum(Paid0)

	FROM
	PaymentBatchItems pbi WITH (NOLOCK)  JOIN PDTTemp pdtt
	 WITH (NOLOCK) ON pdtt.BatchID = pbi.BatchNumber AND pdtt.pdtid = pbi.PostDateUID
	
	GROUP BY pbi.batchnumber
END

GO
