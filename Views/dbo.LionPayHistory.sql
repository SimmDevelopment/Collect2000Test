SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  View dbo.LionPayHistory    Script Date: 3/26/2007 9:52:00 AM ******/
CREATE VIEW [dbo].[LionPayHistory]
AS
SELECT     number, batchtype, customer, paytype, paymethod, systemmonth, systemyear, entered, checknbr, invoiced, datepaid, totalpaid, paid1, paid3, paid2, 
                      paid4, paid5, paid6, paid7, paid8, paid9, paid10, fee1, fee2, fee3, fee4, fee5, fee6, fee7, fee8, fee9, fee10, UID, Invoice, InvoiceFlags, DateTimeEntered, 
                      FeeSched, comment
FROM         dbo.payhistory

GO
