SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Lib_Insert_Courts]
(
      @CourtID   int output,
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


insert into dbo.Courts
(
      COURTNAME,
      COUNTY,
      ADDRESS1,
      ADDRESS2,
      CITY,
      STATE,
      ZIPCODE,
      PHONE,
      FAX,
      SALUTATION,
      CLERKFIRSTNAME,
      CLERKMIDDLENAME,
      CLERKLASTNAME,
      NOTES,
      DATECREATED,
      DATEUPDATED
)
values
(
      @COURTNAME,
      @COUNTY,
      @ADDRESS1,
      @ADDRESS2,
      @CITY,
      @STATE,
      @ZIPCODE,
      @PHONE,
      @FAX,
      @SALUTATION,
      @CLERKFIRSTNAME,
      @CLERKMIDDLENAME,
      @CLERKLASTNAME,
      @NOTES,
      @DATECREATED,
      @DATEUPDATED
)

select @CourtID = Scope_Identity()
end
GO
