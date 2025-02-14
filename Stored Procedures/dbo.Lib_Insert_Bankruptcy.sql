SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [dbo].[Lib_Insert_Bankruptcy]
(
      @BankruptcyID   int output,
      @ACCOUNTID   int,
      @DEBTORID   int,
      @CHAPTER   int,
      @DATEFILED   datetime,
      @CASENUMBER   varchar (20),
      @COURTCITY   varchar (50),
      @COURTDISTRICT   varchar (200),
      @COURTDIVISION   varchar (100),
      @COURTPHONE   varchar (50),
      @COURTSTREET1   varchar (50),
      @COURTSTREET2   varchar (50),
      @COURTSTATE   varchar (3),
      @COURTZIPCODE   varchar (15),
      @TRUSTEE   varchar (50),
      @TRUSTEESTREET1   varchar (50),
      @TRUSTEESTREET2   varchar (50),
      @TRUSTEECITY   varchar (100),
      @TRUSTEESTATE   varchar (3),
      @TRUSTEEZIPCODE   varchar (10),
      @TRUSTEEPHONE   varchar (30),
      @HAS341INFO   bit,
      @DATETIME341   datetime,
      @LOCATION341   varchar (200),
      @COMMENTS   varchar (500),
      @STATUS   varchar (100),
      @TRANSMITTEDDATE   smalldatetime,
      @CONVERTEDFROM   int = NULL,
      @DATENOTICE   datetime= NULL,
      @PROOFFILED   datetime= NULL,
      @DISCHARGEDATE   datetime= NULL,
      @DISMISSALDATE   datetime= NULL,
      @CONFIRMATIONHEARINGDATE   datetime= NULL,
      @HASASSET   bit= NULL,
      @REAFFIRM   char (1)= NULL,
      @REAFFIRMDATEFILED   datetime= NULL,
      @REAFFIRMAMOUNT   money= NULL,
      @REAFFIRMTERMS   varchar (50)= NULL,
      @VOLUNTARYDATE   datetime= NULL,
      @VOLUNTARYAMOUNT   money= NULL,
      @VOLUNTARYTERMS   varchar (50)= NULL,
      @SURRENDERDATE   datetime= NULL,
      @SURRENDERMETHOD   varchar (50)= NULL,
      @AUCTIONHOUSE   varchar (50)= NULL,
      @AUCTIONDATE   datetime= NULL,
      @AUCTIONAMOUNT   money= NULL,
      @AUCTIONFEE   money= NULL,
      @AUCTIONAMOUNTAPPLIED   money= NULL,
      @SECUREDAMOUNT   money= NULL,
      @SECUREDPERCENTAGE   smallmoney= NULL,
      @UNSECUREDAMOUNT   money= NULL,
      @UNSECUREDPERCENTAGE   smallmoney= NULL,
      @CTL   varchar (3)= NULL
)
as
begin


insert into dbo.Bankruptcy
(
      
      [ACCOUNTID],
      [DEBTORID],
      [CHAPTER],
      [DATEFILED],
      [CASENUMBER],
      [COURTCITY],
      [COURTDISTRICT],
      [COURTDIVISION],
      [COURTPHONE],
      [COURTSTREET1],
      [COURTSTREET2],
      [COURTSTATE],
      [COURTZIPCODE],
      [TRUSTEE],
      [TRUSTEESTREET1],
      [TRUSTEESTREET2],
      [TRUSTEECITY],
      [TRUSTEESTATE],
      [TRUSTEEZIPCODE],
      [TRUSTEEPHONE],
      [HAS341INFO],
      [DATETIME341],
      [LOCATION341],
      [COMMENTS],
      [STATUS],
      [TRANSMITTEDDATE],
      [CONVERTEDFROM],
      [DATENOTICE],
      [PROOFFILED],
      [DISCHARGEDATE],
      [DISMISSALDATE],
      [CONFIRMATIONHEARINGDATE],
      [HASASSET],
      [REAFFIRM],
      [REAFFIRMDATEFILED],
      [REAFFIRMAMOUNT],
      [REAFFIRMTERMS],
      [VOLUNTARYDATE],
      [VOLUNTARYAMOUNT],
      [VOLUNTARYTERMS],
      [SURRENDERDATE],
      [SURRENDERMETHOD],
      [AUCTIONHOUSE],
      [AUCTIONDATE],
      [AUCTIONAMOUNT],
      [AUCTIONFEE],
      [AUCTIONAMOUNTAPPLIED],
      [SECUREDAMOUNT],
      [SECUREDPERCENTAGE],
      [UNSECUREDAMOUNT],
      [UNSECUREDPERCENTAGE],
      [CTL]
)
values
(
      @ACCOUNTID,
      @DEBTORID,
      @CHAPTER,
      @DATEFILED,
      @CASENUMBER,
      @COURTCITY,
      @COURTDISTRICT,
      @COURTDIVISION,
      @COURTPHONE,
      @COURTSTREET1,
      @COURTSTREET2,
      @COURTSTATE,
      @COURTZIPCODE,
      @TRUSTEE,
      @TRUSTEESTREET1,
      @TRUSTEESTREET2,
      @TRUSTEECITY,
      @TRUSTEESTATE,
      @TRUSTEEZIPCODE,
      @TRUSTEEPHONE,
      @HAS341INFO,
      @DATETIME341,
      @LOCATION341,
      @COMMENTS,
      @STATUS,
      @TRANSMITTEDDATE,
      @CONVERTEDFROM,
      @DATENOTICE,
      @PROOFFILED,
      @DISCHARGEDATE,
      @DISMISSALDATE,
      @CONFIRMATIONHEARINGDATE,
      @HASASSET,
      @REAFFIRM,
      @REAFFIRMDATEFILED,
      @REAFFIRMAMOUNT,
      @REAFFIRMTERMS,
      @VOLUNTARYDATE,
      @VOLUNTARYAMOUNT,
      @VOLUNTARYTERMS,
      @SURRENDERDATE,
      @SURRENDERMETHOD,
      @AUCTIONHOUSE,
      @AUCTIONDATE,
      @AUCTIONAMOUNT,
      @AUCTIONFEE,
      @AUCTIONAMOUNTAPPLIED,
      @SECUREDAMOUNT,
      @SECUREDPERCENTAGE,
      @UNSECUREDAMOUNT,
      @UNSECUREDPERCENTAGE,
      @CTL
)

select @BankruptcyID = Scope_Identity()
end
GO
