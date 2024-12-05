SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*CustomFeeAdjust*/
CREATE  PROCEDURE [dbo].[CustomFeeAdjust] 
            @AccountID int,
            @Customer varchar(7),
            @Paid1 money,
            @Paid2 money,
            @Paid3 money,
            @Paid4 money,
            @Paid5 money,
            @Paid6 money,
            @Paid7 money,
            @Paid8 money,
            @Paid9 money,
            @Paid10 money,
            @batchtype varchar(3),
			@comment varchar(30),
			@IsPIF BIT,
			@IsSIF BIT,
            @Fee1 money output, 
            @Fee2 money output, 
            @Fee3 money output, 
            @Fee4 money output, 
            @Fee5 money output, 
            @Fee6 money output, 
            @Fee7 money output, 
            @Fee8 money output, 
            @Fee9 money output, 
            @Fee10 money output,
            @InvoiceFlags varchar(10) output

AS

/*This Stored procedure is called from spProcessPmtBatchItem2 and serves as a customization point*/


Return 0
GO
