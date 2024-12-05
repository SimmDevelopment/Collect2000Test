SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_UpdateForwardedFees]

AS

BEGIN
UPDATE AIM_AccountTransaction
SET 
CommissionPercentage = CASE afu.FEETYPE WHEN 'Commission' THEN cast(afu.[VALUE] as float) ELSE 0 END,
FeeSchedule = CASE afu.FEETYPE WHEN 'FeeSchedule' THEN cast(afu.[VALUE] as VARCHAR(5)) ELSE NULL END
FROM #AIMFEEUPDATE afu JOIN AIM_AccountTransaction atr WITH (NOLOCK) ON afu.AccountTransactionID = atr.AccountTransactionID


UPDATE AIM_AccountReference
SET
CurrentCommissionPercentage = CASE afu.FEETYPE WHEN 'Commission' THEN cast(afu.[VALUE] as float) ELSE 0 END,
FeeSchedule = CASE afu.FEETYPE WHEN 'FeeSchedule' THEN cast(afu.[VALUE] as VARCHAR(5)) ELSE NULL END
FROM #AIMFEEUPDATE afu JOIN AIM_AccountReference ar WITH (NOLOCK) ON afu.AccountReferenceID = ar.AccountReferenceID

UPDATE Master
SET
FeeCode = CASE afu.FEETYPE WHEN 'FeeSchedule' THEN cast(afu.[VALUE] as VARCHAR(5)) ELSE NULL END
FROM #AIMFEEUPDATE afu JOIN [Master] m WITH (NOLOCK) ON m.number = afu.Number


DROP TABLE #AIMFEEUPDATE
END

GO
