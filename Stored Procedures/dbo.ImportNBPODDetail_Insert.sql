SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






/****** Object:  Stored Procedure dbo.ImportNBPODDetail_Insert    Script Date: 2/5/2004 4:36:56 PM ******/
CREATE PROCEDURE [dbo].[ImportNBPODDetail_Insert]
	@AccountID int,
	@InvoiceNumber varchar (25) ,
	@InvoiceDate datetime ,
	@InvoiceDetail text  ,
	@InvoiceAmount money ,
	@PaidAmt money ,
	@CurrentAmt money,
	@CustBranch varchar (10)
AS

INSERT INTO ImportNBPODDetail(Number, InvoiceNumber, InvoiceDate, InvoiceDetail, InvoiceAmount, PaidAmt, CurrentAmt, CustBranch)
VALUES(@AccountID, @InvoiceNumber, @InvoiceDate, @InvoiceDetail, @InvoiceAmount, @PaidAmt, @CurrentAmt, @CustBranch)

Return @@Error
GO
