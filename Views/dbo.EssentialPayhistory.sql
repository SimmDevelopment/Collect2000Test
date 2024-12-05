SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[EssentialPayhistory]
AS
SELECT     TOP 100 PERCENT number, InvoicePayType AS InvPType, matched AS M, batchtype AS BatType, totalpaid AS Paid0, datepaid, Invoice, customer, 
                      InvoiceFlags AS Flags, paid1, paid2, paid3, paid4, paid5, paid6, paid7, paid8, paid9, paid10, fee1, fee2, fee3, fee4, fee5, fee6, fee7, fee8, fee9, fee10, 
                      OverPaidAmt, ForwardeeFee, entered, paymethod AS Method, UID, invoiced
FROM         dbo.payhistory
ORDER BY number, paid0, datepaid
GO
