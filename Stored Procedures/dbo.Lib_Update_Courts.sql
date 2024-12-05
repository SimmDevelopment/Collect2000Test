SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Lib_Update_Courts]
(
      @COURTID   int,
      @COURTNAME   varchar (50),
      @COUNTY   varchar (50),
      @ADDRESS1   varchar (50),
      @ADDRESS2   varchar (50),
      @CITY   varchar (50),
      @STATE   varchar (5),
      @ZIPCODE   varchar (10),
      @PHONE   varchar (50),
      @FAX   varchar (50),
      @SALUTATION   varchar (50),
      @CLERKFIRSTNAME   varchar (50),
      @CLERKMIDDLENAME   varchar (50),
      @CLERKLASTNAME   varchar (50),
      @NOTES   varchar (1000),
      @DATECREATED   datetime,
      @DATEUPDATED   datetime
)
as
begin


update dbo.Courts set
      COURTNAME = @COURTNAME,
      COUNTY = @COUNTY,
      ADDRESS1 = @ADDRESS1,
      ADDRESS2 = @ADDRESS2,
      CITY = @CITY,
      STATE = @STATE,
      ZIPCODE = @ZIPCODE,
      PHONE = @PHONE,
      FAX = @FAX,
      SALUTATION = @SALUTATION,
      CLERKFIRSTNAME = @CLERKFIRSTNAME,
      CLERKMIDDLENAME = @CLERKMIDDLENAME,
      CLERKLASTNAME = @CLERKLASTNAME,
      NOTES = @NOTES,
      DATECREATED = @DATECREATED,
      DATEUPDATED = @DATEUPDATED
where COURTID = @COURTID

end
GO
