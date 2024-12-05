SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Lib_Insert_pdc]
(
      @UID   int output,
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
      @APPROVEDBY   varchar (20),
      @PROMISEMODE   int,
      @PROJECTEDFEE   money,
      @USEPROJECTEDFEE   bit,
      @ACTIVE   bit,
      @COLLECTORFEE   money,
		@PROCESSSTATUS varchar(25)
)
as
begin


insert into dbo.pdc
(
      NUMBER,
      CTL,
      PDC_TYPE,
      ENTERED,
      ONHOLD,
      PROCESSED1,
      PROCESSEDFLAG,
      DEPOSIT,
      AMOUNT,
      CHECKNBR,
      SEQ,
      LTRCODE,
      NITD,
      DESK,
      CUSTOMER,
      FILL1,
      FILL2,
      FILL3,
      FILL4,
      FILL5,
      SURCHARGE,
      PRINTED,
      APPROVEDBY,
      PROMISEMODE,
      PROJECTEDFEE,
      USEPROJECTEDFEE,
      ACTIVE,
      COLLECTORFEE,
	PROCESSSTATUS
)
values
(
      @NUMBER,
      @CTL,
      @PDC_TYPE,
      @ENTERED,
      @ONHOLD,
      @PROCESSED1,
      @PROCESSEDFLAG,
      @DEPOSIT,
      @AMOUNT,
      @CHECKNBR,
      @SEQ,
      @LTRCODE,
      @NITD,
      @DESK,
      @CUSTOMER,
      @FILL1,
      @FILL2,
      @FILL3,
      @FILL4,
      @FILL5,
      @SURCHARGE,
      @PRINTED,
      @APPROVEDBY,
      @PROMISEMODE,
      @PROJECTEDFEE,
      @USEPROJECTEDFEE,
      @ACTIVE,
      @COLLECTORFEE,
	@PROCESSSTATUS
)

select @UID = @@identity
end
GO
