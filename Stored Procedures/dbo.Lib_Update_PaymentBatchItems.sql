SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


create procedure [dbo].[Lib_Update_PaymentBatchItems]
(
      @BATCHNUMBER   int,
      @UID   int,
      @FILENUM   int,
      @DATEPAID   datetime,
      @ENTERED   datetime,
      @PMTTYPE   int,
      @PAID0   money,
      @PAID1   money,
      @PAID2   money,
      @PAID3   money,
      @PAID4   money,
      @PAID5   money,
      @PAID6   money,
      @PAID7   money,
      @PAID8   money,
      @PAID9   money,
      @PAID10   money,
      @FEE0   money,
      @FEE1   money,
      @FEE2   money,
      @FEE3   money,
      @FEE4   money,
      @FEE5   money,
      @FEE6   money,
      @FEE7   money,
      @FEE8   money,
      @FEE9   money,
      @FEE10   money,
      @INVOICEFLAGS   char (10),
      @INVKEYCODE   int,
      @OVERPAIDAMT   money,
      @FORWARDEEFEE   money,
      @ISPIF   bit,
      @ISSETTLEMENT   bit,
      @COMMENT   varchar (30),
      @PAYMETHOD   varchar (30),
      @REVERSEOFUID   int,
      @SURCHARGE   money,
      @TAX   money,
      @COLLECTORFEE   money,
      @PAIDENTIFIER   varchar (30),
      @AIMAGENCYID   int,
      @AIMDUEAGENCY   money,
      @AIMAGENCYFEE   money
)
as
begin


update dbo.PaymentBatchItems set
      FILENUM = @FILENUM,
      DATEPAID = @DATEPAID,
      ENTERED = @ENTERED,
      PMTTYPE = @PMTTYPE,
      PAID0 = @PAID0,
      PAID1 = @PAID1,
      PAID2 = @PAID2,
      PAID3 = @PAID3,
      PAID4 = @PAID4,
      PAID5 = @PAID5,
      PAID6 = @PAID6,
      PAID7 = @PAID7,
      PAID8 = @PAID8,
      PAID9 = @PAID9,
      PAID10 = @PAID10,
      FEE0 = @FEE0,
      FEE1 = @FEE1,
      FEE2 = @FEE2,
      FEE3 = @FEE3,
      FEE4 = @FEE4,
      FEE5 = @FEE5,
      FEE6 = @FEE6,
      FEE7 = @FEE7,
      FEE8 = @FEE8,
      FEE9 = @FEE9,
      FEE10 = @FEE10,
      INVOICEFLAGS = @INVOICEFLAGS,
      INVKEYCODE = @INVKEYCODE,
      OVERPAIDAMT = @OVERPAIDAMT,
      FORWARDEEFEE = @FORWARDEEFEE,
      ISPIF = @ISPIF,
      ISSETTLEMENT = @ISSETTLEMENT,
      COMMENT = @COMMENT,
      PAYMETHOD = @PAYMETHOD,
      REVERSEOFUID = @REVERSEOFUID,
      SURCHARGE = @SURCHARGE,
      TAX = @TAX,
      COLLECTORFEE = @COLLECTORFEE,
      PAIDENTIFIER = @PAIDENTIFIER,
      AIMAGENCYID = @AIMAGENCYID,
      AIMDUEAGENCY = @AIMDUEAGENCY,
      AIMAGENCYFEE = @AIMAGENCYFEE
where UID = @UID

end

GO
