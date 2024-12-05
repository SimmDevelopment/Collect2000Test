SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Lib_Insert_DebtorCreditCards]
(
      @ID   int output,
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
      @COLLECTORFEE   money,
      @NITDSENTDATE   datetime,
		@PROCESSSTATUS varchar(25)
)
as
begin


insert into dbo.DebtorCreditCards
(
      NUMBER,
      NAME,
      STREET1,
      STREET2,
      CITY,
      STATE,
      ZIPCODE,
      CARDNUMBER,
      EXPMONTH,
      EXPYEAR,
      CREDITCARD,
      AMOUNT,
      PRINTED,
      APPROVEDBY,
      APPROVED,
      CODE,
      DEBTORID,
      DATEENTERED,
      DEPOSITDATE,
      ONHOLDDATE,
      LETTERCODE,
      NITDSENDDATE,
      PROJECTEDFEE,
      USEPROJECTEDFEE,
      SURCHARGE,
      ISACTIVE,
      PROMISEMODE,
      COLLECTORFEE,
      NITDSENTDATE,
	PROCESSSTATUS
)
values
(
      @NUMBER,
      @NAME,
      @STREET1,
      @STREET2,
      @CITY,
      @STATE,
      @ZIPCODE,
      @CARDNUMBER,
      @EXPMONTH,
      @EXPYEAR,
      @CREDITCARD,
      @AMOUNT,
      @PRINTED,
      @APPROVEDBY,
      @APPROVED,
      @CODE,
      @DEBTORID,
      @DATEENTERED,
      @DEPOSITDATE,
      @ONHOLDDATE,
      @LETTERCODE,
      @NITDSENDDATE,
      @PROJECTEDFEE,
      @USEPROJECTEDFEE,
      @SURCHARGE,
      @ISACTIVE,
      @PROMISEMODE,
      @COLLECTORFEE,
      @NITDSENTDATE,
	@PROCESSSTATUS
)

select @ID = @@identity
end
GO
