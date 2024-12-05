SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionGetPayHistoryByUID    Script Date: 3/26/2007 9:52:01 AM ******/
CREATE PROCEDURE [dbo].[LionGetPayHistoryByUID]
(
	@UID int
)
AS
	SET NOCOUNT ON;
SELECT number, batchtype, customer, paytype, paymethod, systemmonth, systemyear, entered, checknbr, invoiced, datepaid, totalpaid, paid1, paid3, paid2, paid4, paid5, paid6, paid7, paid8, paid9, paid10, fee1, fee2, fee3, fee4, fee5, fee6, fee7, fee8, fee9, fee10, UID, Invoice, InvoiceFlags, DateTimeEntered, FeeSched,Comment FROM dbo.LionPayHistory with (nolock)
Where UID=@UID

GO
