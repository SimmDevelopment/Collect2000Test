SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [dbo].[Lib_Update_Deceased]
(
      @ID   int,
      @ACCOUNTID   int,
      @DEBTORID   int,
      @SSN   varchar (15),
      @FIRSTNAME   varchar (30),
      @LASTNAME   varchar (30),
      @STATE   varchar (3),
      @POSTALCODE   varchar (10),
      @DOB   datetime,
      @DOD   datetime,
      @MATCHCODE   varchar (5),
      @TRANSMITTEDDATE   smalldatetime,
      @CLAIMDEADLINE   datetime,
      @DATEFILED   datetime,
      @CASENUMBER   varchar (20),
      @EXECUTOR   varchar (50) = NULL,
      @EXECUTORPHONE   varchar (50)= NULL,
      @EXECUTORFAX   varchar (50)= NULL,
      @EXECUTORSTREET1   varchar (50)= NULL,
      @EXECUTORSTREET2   varchar (50)= NULL,
      @EXECUTORSTATE   varchar (3)= NULL,
      @EXECUTORCITY   varchar (100)= NULL,
      @EXECUTORZIPCODE   varchar (10)= NULL,
      @COURTCITY   varchar (50)= NULL,
      @COURTDISTRICT   varchar (200)= NULL,
      @COURTDIVISION   varchar (100)= NULL,
      @COURTPHONE   varchar (50)= NULL,
      @COURTSTREET1   varchar (50)= NULL,
      @COURTSTREET2   varchar (50)= NULL,
      @COURTSTATE   varchar (3)= NULL,
      @COURTZIPCODE   varchar (15)= NULL,
      @CTL   varchar (3)= NULL
)
as
begin


update dbo.Deceased set
      [ACCOUNTID] = @ACCOUNTID,
      [DEBTORID] = @DEBTORID,
      [SSN] = @SSN,
      [FIRSTNAME] = @FIRSTNAME,
      [LASTNAME] = @LASTNAME,
      [STATE] = @STATE,
      [POSTALCODE] = @POSTALCODE,
      [DOB] = @DOB,
      [DOD] = @DOD,
      [MATCHCODE] = @MATCHCODE,
      [TRANSMITTEDDATE] = @TRANSMITTEDDATE,
      [CLAIMDEADLINE] = @CLAIMDEADLINE,
      [DATEFILED] = @DATEFILED,
      [CASENUMBER] = @CASENUMBER,
      [EXECUTOR] = @EXECUTOR,
      [EXECUTORPHONE] = @EXECUTORPHONE,
      [EXECUTORFAX] = @EXECUTORFAX,
      [EXECUTORSTREET1] = @EXECUTORSTREET1,
      [EXECUTORSTREET2] = @EXECUTORSTREET2,
      [EXECUTORSTATE] = @EXECUTORSTATE,
      [EXECUTORCITY] = @EXECUTORCITY,
      [EXECUTORZIPCODE] = @EXECUTORZIPCODE,
      [COURTCITY] = @COURTCITY,
      [COURTDISTRICT] = @COURTDISTRICT,
      [COURTDIVISION] = @COURTDIVISION,
      [COURTPHONE] = @COURTPHONE,
      [COURTSTREET1] = @COURTSTREET1,
      [COURTSTREET2] = @COURTSTREET2,
      [COURTSTATE] = @COURTSTATE,
      [COURTZIPCODE] = @COURTZIPCODE,
      [CTL] = @CTL
where [ID] = @ID

end

GO
