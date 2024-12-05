SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Check2ACH_UpdateBatchDetail]
@updatedbi bit,
@batch int,
@sequence int,
@amount money,
@number int,
@paymentdate datetime,
@bankname varchar(50),
@payername varchar(50),
@payerstreet1 varchar(50),
@payerstreet2 varchar(50),
@payercity varchar(50),
@payerstate varchar(50),
@payerzipcode varchar(50),
@accounttype char(1)

AS
UPDATE Check2ACH_BatchDetail
SET UpdateDBI = @updatedbi,
	number = @number,
	amount = @amount,
	bankname = @bankname,
	paymentdate = @paymentdate,
	payername = @payername,
	payerstreet1 = @payerstreet1,
	payerstreet2 = @payerstreet2,
	payercity = @payercity,
	payerstate = @payerstate,
	payerzipcode = @payerzipcode,
	accounttype = @accounttype

WHERE batch = @batch AND sequence = @sequence



GO
