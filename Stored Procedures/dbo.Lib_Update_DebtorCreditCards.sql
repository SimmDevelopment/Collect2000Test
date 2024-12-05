SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   procedure [dbo].[Lib_Update_DebtorCreditCards]
(
      @NUMBER   int,
      @NAME   varchar (30),
      @STREET1   varchar (30),
      @STREET2   varchar (30),
      @CITY   varchar (25),
      @STATE   varchar (3),
      @ZIPCODE   varchar (10),
      @CARDNUMBER   varchar (30),
      @EXPMONTH   varchar (2),
      @EXPYEAR   varchar (2),
      @CREDITCARD   varchar (4),
      @AMOUNT   money,
      @PRINTED   varchar (1),
      @PRINTEDDATE datetime,
      @APPROVEDBY   varchar (10),
      @APPROVED   datetime,
      @CODE   varchar (10),
      @DEBTORID   int,
      @DATEENTERED   smalldatetime,
      @DEPOSITDATE   smalldatetime,
      @ONHOLDDATE   smalldatetime,
      @LETTERCODE   varchar (5),
      @NITDSENDDATE   smalldatetime,
      @PROJECTEDFEE   money,
      @USEPROJECTEDFEE   bit,
      @SURCHARGE   money,
      @ISACTIVE   bit,
      @PROMISEMODE   int,
      @ID   int,
      @COLLECTORFEE   money,
      @NITDSENTDATE   datetime,
	@NSFCOUNT int,
		@PROCESSSTATUS varchar(25)
)
as
begin


update dbo.DebtorCreditCards set
      NAME = @NAME,
      STREET1 = @STREET1,
      STREET2 = @STREET2,
      CITY = @CITY,
      STATE = @STATE,
      ZIPCODE = @ZIPCODE,
      CARDNUMBER = @CARDNUMBER,
      EXPMONTH = @EXPMONTH,
      EXPYEAR = @EXPYEAR,
      CREDITCARD = @CREDITCARD,
      AMOUNT = @AMOUNT,
      PRINTED = @PRINTED,
      PRINTEDDATE = @PRINTEDDATE,
      APPROVEDBY = @APPROVEDBY,
      APPROVED = @APPROVED,
      CODE = @CODE,
      DEBTORID = @DEBTORID,
      DATEENTERED = @DATEENTERED,
      DEPOSITDATE = @DEPOSITDATE,
      ONHOLDDATE = @ONHOLDDATE,
      LETTERCODE = @LETTERCODE,
      NITDSENDDATE = @NITDSENDDATE,
      PROJECTEDFEE = @PROJECTEDFEE,
      USEPROJECTEDFEE = @USEPROJECTEDFEE,
      SURCHARGE = @SURCHARGE,
      ISACTIVE = @ISACTIVE,
      PROMISEMODE = @PROMISEMODE,
     -- ID = @ID,
      COLLECTORFEE = @COLLECTORFEE,
      NITDSENTDATE = @NITDSENTDATE,
	NSFCOUNT = @NSFCOUNT,
	PROCESSSTATUS = @PROCESSSTATUS
where  ID = @ID

end
GO
