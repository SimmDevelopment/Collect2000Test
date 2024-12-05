SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [dbo].[Lib_Insert_DebtorAttorneys]
(
      @ID   int output,
      @ACCOUNTID   int,
      @DEBTORID   int,
      @NAME   varchar (50),
      @FIRM   varchar (100),
      @ADDR1   varchar (50),
      @ADDR2   varchar (50),
      @CITY   varchar (50),
      @STATE   varchar (5),
      @ZIPCODE   varchar (20),
      @PHONE   varchar (20),
      @FAX   varchar (20),
      @EMAIL   varchar (50),
      @COMMENTS   varchar (500),
      @DATECREATED   datetime,
      @DATEUPDATED   datetime
)
as
begin
insert into dbo.DebtorAttorneys
(
      [ACCOUNTID],
      [DEBTORID],
      [NAME],
      [FIRM],
      [ADDR1],
      [ADDR2],
      [CITY],
      [STATE],
      [ZIPCODE],
      [PHONE],
      [FAX],
      [EMAIL],
      [COMMENTS],
      [DATECREATED],
      [DATEUPDATED]
)
values
(
      @ACCOUNTID,
      @DEBTORID,
      @NAME,
      @FIRM,
      @ADDR1,
      @ADDR2,
      @CITY,
      @STATE,
      @ZIPCODE,
      @PHONE,
      @FAX,
      @EMAIL,
      @COMMENTS,
      @DATECREATED,
      @DATEUPDATED
)

select @ID = SCOPE_IDENTITY()

end

GO
