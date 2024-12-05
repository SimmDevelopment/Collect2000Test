SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[UninvoicedView]
AS
SELECT     number, batchtype, customer, datepaid, totalpaid, Invoice, BatchNumber, fee10, fee9, fee8, fee7, fee6, fee5, fee4, fee3, fee2, fee1
FROM         dbo.payhistory
WHERE     (Invoice IS NULL)
GO
