SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 

create procedure [dbo].[Lib_Update_DebtorAttorneys]
(
      @ID   int,
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
 

update dbo.DebtorAttorneys set
      [ACCOUNTID] = @ACCOUNTID,
      [DEBTORID] = @DEBTORID,
      [NAME] = @NAME,
      [FIRM] = @FIRM,
      [ADDR1] = @ADDR1,
      [ADDR2] = @ADDR2,
      [CITY] = @CITY,
      [STATE] = @STATE,
      [ZIPCODE] = @ZIPCODE,
      [PHONE] = @PHONE,
      [FAX] = @FAX,
      [EMAIL] = @EMAIL,
      [COMMENTS] = @COMMENTS,
      [DATECREATED] = @DATECREATED,
      [DATEUPDATED] = @DATEUPDATED
where [ID] = @ID

 

end

GO
