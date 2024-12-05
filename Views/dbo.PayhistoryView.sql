SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Object:  View dbo.PayhistoryView    Script Date: 10/13/2002 8:40:41 PM ******/
CREATE VIEW [dbo].[PayhistoryView]
AS
SELECT     TOP 100 PERCENT UID, ReverseOfUID, number, entered, systemmonth, systemyear, batchtype, totalpaid, 
                      paid1 + paid2 + paid3 + paid4 + paid5 + paid6 + paid7 + paid8 + paid9 + paid10 AS Applied, 
                      fee1 + fee2 + fee3 + fee4 + fee5 + fee6 + fee7 + fee8 + fee9 + fee10 AS Fee, OverPaidAmt, ForwardeeFee, desk, Invoice, invoiced, InvoiceFlags, 
                      paymethod, datepaid, AccruedSurcharge, customer, matched, comment, paid10 AS AppliedSurcharge
FROM         dbo.payhistory
ORDER BY entered

GO
