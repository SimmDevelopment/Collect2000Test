SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionGetPayHistoryByDebtorID    Script Date: 3/26/2007 9:52:01 AM ******/
CREATE PROCEDURE [dbo].[LionGetPayHistoryByDebtorID]
(
	@DebtorId int
)
AS
	SET NOCOUNT ON;
SELECT
ph.number, 
ph.batchtype, 
ph.customer, 
ph.paytype, 
ph.paymethod, 
ph.systemmonth, 
ph.systemyear, 
ph.entered, 
ph.checknbr, 
ph.invoiced, 
ph.datepaid, 
ph.totalpaid, 
ph.paid1, 
ph.paid3, 
ph.paid2, 
ph.paid4, 
ph.paid5, 
ph.paid6, 
ph.paid7, 
ph.paid8, 
ph.paid9, 
ph.paid10, 
ph.fee1, 
ph.fee2, 
ph.fee3, 
ph.fee4, 
ph.fee5, 
ph.fee6, 
ph.fee7, 
ph.fee8, 
ph.fee9, 
ph.fee10, 
ph.UID, 
ph.Invoice, 
ph.InvoiceFlags, 
ph.DateTimeEntered, 
ph.FeeSched,
ph.Comment
FROM dbo.LionPayHistory ph with (nolock)
Join Debtors d with (nolock) on d.number=ph.number
where d.DebtorId=@DebtorId

GO
