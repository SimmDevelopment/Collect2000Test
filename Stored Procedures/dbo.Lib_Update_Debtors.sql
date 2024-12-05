SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Lib_Update_Debtors]
(
      @NUMBER   int,
      @SEQ   int,
      @NAME   varchar (60),
      @STREET1   varchar (30),
      @STREET2   varchar (30),
      @CITY   varchar (30),
      @STATE   varchar (3),
      @ZIPCODE   varchar (10),
      @HOMEPHONE   varchar (30),
      @WORKPHONE   varchar (30),
      @SSN   varchar (15),
      @MR   varchar (1),
      @OTHERNAME   varchar (30),
      @DOB   datetime,
      @JOBNAME   varchar (50),
      @JOBADDR1   varchar (50),
      @JOBADDR2   varchar (50),
      @JOBCSZ   varchar (50),
      @JOBMEMO   text,
      @RELATIONSHIP   varchar (20),
      @SPOUSE   varchar (50),
      @SPOUSEJOBNAME   varchar (50),
      @SPOUSEJOBADDR1   varchar (50),
      @SPOUSEJOBADDR2   varchar (50),
      @SPOUSEJOBCSZ   varchar (50),
      @SPOUSEJOBMEMO   text,
      @SPOUSEHOMEPHONE   varchar (20),
      @SPOUSEWORKPHONE   varchar (20),
      @SPOUSERESPONSIBLE   varchar (1),
      @PAGER   varchar (20),
      @OTHERPHONE1   varchar (20),
      @OTHERPHONETYPE   varchar (15),
      @OTHERPHONE2   varchar (20),
      @OTHERPHONE2TYPE   varchar (15),
      @OTHERPHONE3   varchar (20),
      @OTHERPHONE3TYPE   varchar (15),
      @DEBTORMEMO   text,
      @LANGUAGE   varchar (30),
      @DLNUM   varchar (50),
      @FAX   varchar (50),
      @EMAIL   varchar (50),
      @DEBTORID   int,
      @DATECREATED   datetime,
      @DATEUPDATED   datetime,
      @COUNTRY   varchar (50),
      @RESPONSIBLE bit,
      @FIRSTNAME varchar(50),
      @MIDDLENAME varchar(50),
      @LASTNAME varchar(50),
      @USPSKEYLINE VARCHAR(16),
      @ISHOMEOWNER bit,
	  @EARLYTIMEZONE   int,
      @LATETIMEZONE   int,
      @BUSINESSNAME   varchar (50),
      @PREFIX   varchar (50),
      @GENDER   char (1),
      @OBSERVESDST   bit,
      @REGIONCODE   char (2),
      @COUNTY   varchar (50),
      @TIMEZONEOVERRIDE   bit,
	  @SUFFIX   varchar (50),
      @ISBUSINESS   bit,
      @ISPARSED   bit,
      @CBREXCEPTION   smallint,
      @CBREXCLUDE   bit,
	  @ISAUTHORIZEDACCOUNTUSER bit = null,
	  @CONTACTMETHOD varchar(10)
)
as
begin


update dbo.Debtors set
      SEQ = @SEQ,
      NAME = @NAME,
      STREET1 = @STREET1,
      STREET2 = @STREET2,
      CITY = @CITY,
      STATE = @STATE,
      ZIPCODE = @ZIPCODE,
      HOMEPHONE = dbo.stripnondigits(@HOMEPHONE),
      WORKPHONE = dbo.stripnondigits(@WORKPHONE),
      SSN = @SSN,
      MR = @MR,
      OTHERNAME = @OTHERNAME,
      DOB = @DOB,
      JOBNAME = @JOBNAME,
      JOBADDR1 = @JOBADDR1,
      JOBADDR2 = @JOBADDR2,
      JOBCSZ = @JOBCSZ,
      JOBMEMO = @JOBMEMO,
      RELATIONSHIP = @RELATIONSHIP,
      SPOUSE = @SPOUSE,
      SPOUSEJOBNAME = @SPOUSEJOBNAME,
      SPOUSEJOBADDR1 = @SPOUSEJOBADDR1,
      SPOUSEJOBADDR2 = @SPOUSEJOBADDR2,
      SPOUSEJOBCSZ = @SPOUSEJOBCSZ,
      SPOUSEJOBMEMO = @SPOUSEJOBMEMO,
      SPOUSEHOMEPHONE = @SPOUSEHOMEPHONE,
      SPOUSEWORKPHONE = @SPOUSEWORKPHONE,
      SPOUSERESPONSIBLE = @SPOUSERESPONSIBLE,
      PAGER = @PAGER,
      OTHERPHONE1 = @OTHERPHONE1,
      OTHERPHONETYPE = @OTHERPHONETYPE,
      OTHERPHONE2 = @OTHERPHONE2,
      OTHERPHONE2TYPE = @OTHERPHONE2TYPE,
      OTHERPHONE3 = @OTHERPHONE3,
      OTHERPHONE3TYPE = @OTHERPHONE3TYPE,
      DEBTORMEMO = @DEBTORMEMO,
      LANGUAGE = @LANGUAGE,
      DLNUM = @DLNUM,
      FAX = @FAX,
      EMAIL = @EMAIL,
      DATECREATED = @DATECREATED,
      DATEUPDATED = @DATEUPDATED,
      COUNTRY = @COUNTRY,
      RESPONSIBLE = @RESPONSIBLE,
      FIRSTNAME = @FIRSTNAME,
      MIDDLENAME = @MIDDLENAME,
      LASTNAME = @LASTNAME,
      USPSKEYLINE = @USPSKEYLINE,
      ISHOMEOWNER = @ISHOMEOWNER,
	  SUFFIX = @SUFFIX,
      ISBUSINESS = @ISBUSINESS,
      ISPARSED = @ISPARSED,
      CBREXCEPTION = @CBREXCEPTION,
      CBREXCLUDE = @CBREXCLUDE,
      EARLYTIMEZONE = @EARLYTIMEZONE,
      LATETIMEZONE = @LATETIMEZONE,
      BUSINESSNAME = @BUSINESSNAME,
      PREFIX = @PREFIX,
      GENDER = @GENDER,
      OBSERVESDST = @OBSERVESDST,
      REGIONCODE = @REGIONCODE,
      COUNTY = @COUNTY,
      TIMEZONEOVERRIDE = @TIMEZONEOVERRIDE,
	  ISAUTHORIZEDACCOUNTUSER = @ISAUTHORIZEDACCOUNTUSER,
	  CONTACTMETHOD = @CONTACTMETHOD
where Debtorid = @debtorid

end
GO