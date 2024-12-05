SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [dbo].[Lib_Insert_Deceased]
(
      @ID   int output,
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


insert into dbo.Deceased
(
      [ACCOUNTID],
      [DEBTORID],
      [SSN],
      [FIRSTNAME],
      [LASTNAME],
      [STATE],
      [POSTALCODE],
      [DOB],
      [DOD],
      [MATCHCODE],
      [TRANSMITTEDDATE],
      [CLAIMDEADLINE],
      [DATEFILED],
      [CASENUMBER],
      [EXECUTOR],
      [EXECUTORPHONE],
      [EXECUTORFAX],
      [EXECUTORSTREET1],
      [EXECUTORSTREET2],
      [EXECUTORSTATE],
      [EXECUTORCITY],
      [EXECUTORZIPCODE],
      [COURTCITY],
      [COURTDISTRICT],
      [COURTDIVISION],
      [COURTPHONE],
      [COURTSTREET1],
      [COURTSTREET2],
      [COURTSTATE],
      [COURTZIPCODE],
      [CTL]
)
values
(
      @ACCOUNTID,
      @DEBTORID,
      @SSN,
      @FIRSTNAME,
      @LASTNAME,
      @STATE,
      @POSTALCODE,
      @DOB,
      @DOD,
      @MATCHCODE,
      @TRANSMITTEDDATE,
      @CLAIMDEADLINE,
      @DATEFILED,
      @CASENUMBER,
      @EXECUTOR,
      @EXECUTORPHONE,
      @EXECUTORFAX,
      @EXECUTORSTREET1,
      @EXECUTORSTREET2,
      @EXECUTORSTATE,
      @EXECUTORCITY,
      @EXECUTORZIPCODE,
      @COURTCITY,
      @COURTDISTRICT,
      @COURTDIVISION,
      @COURTPHONE,
      @COURTSTREET1,
      @COURTSTREET2,
      @COURTSTATE,
      @COURTZIPCODE,
      @CTL
)

select @ID = Scope_Identity()
end

GO
