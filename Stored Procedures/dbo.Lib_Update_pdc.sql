SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  procedure [dbo].[Lib_Update_pdc]
(
      @UID   int,
      @NUMBER   int,
      @CTL   char (3),
      @PDC_TYPE   int,
      @ENTERED   datetime,
      @ONHOLD   datetime,
      @PROCESSED1   datetime,
      @PROCESSEDFLAG   char (1),
      @DEPOSIT   datetime,
      @AMOUNT   money,
      @CHECKNBR   char (10),
      @SEQ   int,
      @LTRCODE   varchar (5),
      @NITD   datetime,
      @DESK   varchar (10),
      @CUSTOMER   varchar (7),
      @FILL1   char (255),
      @FILL2   char (255),
      @FILL3   char (255),
      @FILL4   char (255),
      @FILL5   char (255),
      @SURCHARGE   money,
      @PRINTED   bit,
      @PRINTEDDATE datetime,
      @APPROVEDBY   varchar (20),
      @PROMISEMODE   int,
      @PROJECTEDFEE   money,
      @USEPROJECTEDFEE   bit,
      @ACTIVE   bit,
      @COLLECTORFEE   money,
	@NSFCOUNT int,
		@PROCESSSTATUS varchar(25)
)
as
begin


update pdc set
      NUMBER = @NUMBER,
      CTL = @CTL,
      PDC_TYPE = @PDC_TYPE,
      ENTERED = @ENTERED,
      ONHOLD = @ONHOLD,
      PROCESSED1 = @PROCESSED1,
      PROCESSEDFLAG = @PROCESSEDFLAG,
      DEPOSIT = @DEPOSIT,
      AMOUNT = @AMOUNT,
      CHECKNBR = @CHECKNBR,
      SEQ = @SEQ,
      LTRCODE = @LTRCODE,
      NITD = @NITD,
      DESK = @DESK,
      CUSTOMER = @CUSTOMER,
      FILL1 = @FILL1,
      FILL2 = @FILL2,
      FILL3 = @FILL3,
      FILL4 = @FILL4,
      FILL5 = @FILL5,
      SURCHARGE = @SURCHARGE,
      PRINTED = @PRINTED,
      PRINTEDDATE = @PRINTEDDATE,
      APPROVEDBY = @APPROVEDBY,
      PROMISEMODE = @PROMISEMODE,
      PROJECTEDFEE = @PROJECTEDFEE,
      USEPROJECTEDFEE = @USEPROJECTEDFEE,
      ACTIVE = @ACTIVE,
      COLLECTORFEE = @COLLECTORFEE,
	NSFCOUNT = @NSFCOUNT,
PROCESSSTATUS = @PROCESSSTATUS
where UID = @UID

end
GO
