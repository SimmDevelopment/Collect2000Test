SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
 
 
create procedure [dbo].[Lib_Update_DebtorBankInfo]
(
      @ACCTID   int,
      @DEBTORID   int,
      @ABANUMBER   varchar (10),
      @ACCOUNTNUMBER   varchar (20),
      @ACCOUNTNAME   varchar (50),
      @ACCOUNTADDRESS1   varchar (50),
      @ACCOUNTADDRESS2   varchar (50),
      @ACCOUNTCITY   varchar (50),
      @ACCOUNTSTATE   varchar (10),
      @ACCOUNTZIPCODE   varchar (50),
      @ACCOUNTVERIFIED   bit,
      @LASTCHECKNUMBER   int,
      @BANKNAME   varchar (50),
      @BANKADDRESS   varchar (50),
      @BANKCITY   varchar (50),
      @BANKSTATE   varchar (10),
      @BANKZIPCODE   varchar (10),
      @BANKPHONE   varchar (20),
      @ACCOUNTTYPE   char (1)
)
as
begin
 
 
update dbo.DebtorBankInfo set
      DEBTORID = @DEBTORID,
      ABANUMBER = @ABANUMBER,
      ACCOUNTNUMBER = @ACCOUNTNUMBER,
      ACCOUNTNAME = @ACCOUNTNAME,
      ACCOUNTADDRESS1 = @ACCOUNTADDRESS1,
      ACCOUNTADDRESS2 = @ACCOUNTADDRESS2,
      ACCOUNTCITY = @ACCOUNTCITY,
      ACCOUNTSTATE = @ACCOUNTSTATE,
      ACCOUNTZIPCODE = @ACCOUNTZIPCODE,
      ACCOUNTVERIFIED = @ACCOUNTVERIFIED,
      LASTCHECKNUMBER = @LASTCHECKNUMBER,
      BANKNAME = @BANKNAME,
      BANKADDRESS = @BANKADDRESS,
      BANKCITY = @BANKCITY,
      BANKSTATE = @BANKSTATE,
      BANKZIPCODE = @BANKZIPCODE,
      BANKPHONE = @BANKPHONE,
      ACCOUNTTYPE = @ACCOUNTTYPE
where ACCTID = @ACCTID
 
end
 
GO
