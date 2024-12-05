SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[PaymentView1]
AS
SELECT     number, batchtype, matched, paymethod, entered, desk, comment, totalpaid, 
                      SUM(paid1 + paid2 + paid3 + paid4 + paid5 + paid6 + paid7 + paid8 + paid9 + paid10) AS AmtApplied, 
                      SUM(fee1 + fee2 + fee3 + fee4 + fee5 + fee6 + fee7 + fee8 + fee9 + fee10) AS TotalFee, OverPaidAmt, ForwardeeFee, UID
FROM         dbo.payhistory
GROUP BY number, batchtype, matched, paymethod, entered, desk, comment, totalpaid, OverPaidAmt, ForwardeeFee, UID
GO
