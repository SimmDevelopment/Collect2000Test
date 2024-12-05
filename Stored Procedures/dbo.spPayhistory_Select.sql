SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






/*spPayhistory_Select*/
CREATE     PROCEDURE [dbo].[spPayhistory_Select]
	@AccountID int
AS

 /*
**Name            :spPayhistory_Select
**Function        :Retrieves all Payhistory for a single account
**Creation        :8/19/2004
**Used by         :Latitude.Payments class
**Change History  :
*/

SET NoCount On

SELECT payhistory.UID, payhistory.Entered, payhistory.BatchType, payhistory.Matched, payhistory.TotalPaid, payhistory.OverPaidAmt, payhistory.DatePaid,
	payhistory.PayMethod, payhistory.Comment, payhistory.SystemMonth, payhistory.SystemYear, payhistory.Customer, payhistory.Desk, payhistory.Checknbr,
	payhistory.Invoice, payhistory.Invoiced, payhistory.BatchNumber, payhistory.ForwardeeFee, payhistory.ReverseOfUID, payhistory.AccruedSurcharge,
	payhistory.Paid1, payhistory.Paid2, payhistory.Paid3, payhistory.Paid4, payhistory.Paid5, payhistory.Paid6, payhistory.Paid7, payhistory.Paid8, payhistory.Paid9, payhistory.Paid10,
	payhistory.Fee1, payhistory.Fee2, payhistory.Fee3, payhistory.Fee4, payhistory.Fee5, payhistory.Fee6, payhistory.Fee7, payhistory.Fee8, payhistory.Fee9, payhistory.Fee10,
	payhistory.CollectorFee, payhistory.IsCorrection, payhistory.AIMAgencyFee, payhistory.BatchPmtCreatedBy, payhistory.SubBatchType, PaymentBatches.ProcessedBy
from dbo.Payhistory with(nolock)
left outer join dbo.PaymentBatches with(nolock)
on payhistory.BatchNumber = PaymentBatches.BatchNumber
WHERE payhistory.Number = @AccountID Order by payhistory.datepaid, payhistory.Uid

Return @@Error





GO
