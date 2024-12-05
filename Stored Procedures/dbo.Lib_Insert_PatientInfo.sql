SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  procedure [dbo].[Lib_Insert_PatientInfo]
(
      @ACCOUNTID   int,
      @NAME   varchar (75),
      @STREET1   varchar (50),
      @STREET2   varchar (50),
      @CITY   varchar (35),
      @STATE   varchar (5),
      @ZIPCODE   varchar (15),
      @COUNTRY   varchar (25),
      @PHONE   varchar (20),
      @SSN   varchar (15),
      @SEX   char (1),
      @AGE   int,
      @DOB   datetime,
      @MARITALSTATUS   char (1),
      @EMPLOYERNAME   varchar (75),
      @WORKPHONE   varchar (20),
      @PATIENTRECNUMBER   varchar (30),
      @GUARANTORRECNUMBER   varchar (30),
      @ADMISSIONDATE   datetime,
      @SERVICEDATE   datetime,
      @DISCHARGEDATE   datetime,
      @FACILITYNAME   varchar (75),
      @FACILITYSTREET1   varchar (50),
      @FACILITYSTREET2   varchar (50),
      @FACILITYCITY   varchar (35),
      @FACILITYSTATE   varchar (5),
      @FACILITYZIPCODE   varchar (15),
      @FACILITYCOUNTRY   varchar (25),
      @FACILITYPHONE   varchar (20),
      @FACILITYFAX   varchar (20),
      @DOCTORNAME   varchar (75),
      @DOCTORPHONE   varchar (20),
      @DOCTORFAX   varchar (20),
      @KINNAME   varchar (75),
      @KINSTREET1   varchar (50),
      @KINSTREET2   varchar (50),
      @KINCITY   varchar (35),
      @KINSTATE   varchar (5),
      @KINZIPCODE   varchar (15),
      @KINCOUNTRY   varchar (25),
      @KINPHONE   varchar (20),
     -- @HARDCOPY   image
      @ACCIDENTDATE  DATETIME = NULL,
      @ACCIDENTTYPE  VARCHAR(25) = NULL,
      @ATTENDINGDOCTORCODE  VARCHAR(5) = NULL,
      @ATTENDINGDOCTORFAX  VARCHAR(20) = NULL,
      @ATTENDINGDOCTORNAME  VARCHAR(75) = NULL,
      @ATTENDINGDOCTORPHONE      VARCHAR(20) = NULL,
      @DIAGNOSISCODE1  VARCHAR(25) = NULL,
      @DIAGNOSISCODE2  VARCHAR(25) = NULL,
      @DIAGNOSISCODE3  VARCHAR(25) = NULL,
      @DOCTORCODE  VARCHAR(5) = NULL,
      @FINANCIALCLASS  VARCHAR(25) = NULL,
      @IMPORTPROCEDURES    VARCHAR(25) = NULL,
      @LOCATIONCODE  VARCHAR(25) = NULL,
      @MODIFIER      VARCHAR(25) = NULL,
      @PATIENTRELATIONTOGUARANTOR VARCHAR(25) = NULL,
      @PATIENTRELATIONTOGUARANTORADDITIONALINFO    VARCHAR(50) = NULL,
      @PATIENTTYPE   VARCHAR(25) = NULL,
      @PLACEOFSERVICECODE  VARCHAR(25) = NULL,
      @PROCEDURECODE  VARCHAR(25) = NULL,
      @SERVICINGPROVIDERCODE  VARCHAR(25) = NULL
)
as
begin

	if  exists(select * from sysobjects o join syscolumns c on c.id = o.id where o.name = 'PatientInfo' and o.xtype = 'U' and c.name = 'SERVICINGPROVIDERCODE')
	BEGIN

	insert into dbo.PatientInfo
	(
		  ACCOUNTID,
		  NAME,
		  STREET1,
		  STREET2,
		  CITY,
		  STATE,
		  ZIPCODE,
		  COUNTRY,
		  PHONE,
		  SSN,
		  SEX,
		  AGE,
		  DOB,
		  MARITALSTATUS,
		  EMPLOYERNAME,
		  WORKPHONE,
		  PATIENTRECNUMBER,
		  GUARANTORRECNUMBER,
		  ADMISSIONDATE,
		  SERVICEDATE,
		  DISCHARGEDATE,
		  FACILITYNAME,
		  FACILITYSTREET1,
		  FACILITYSTREET2,
		  FACILITYCITY,
		  FACILITYSTATE,
		  FACILITYZIPCODE,
		  FACILITYCOUNTRY,
		  FACILITYPHONE,
		  FACILITYFAX,
		  DOCTORNAME,
		  DOCTORPHONE,
		  DOCTORFAX,
		  KINNAME,
		  KINSTREET1,
		  KINSTREET2,
		  KINCITY,
		  KINSTATE,
		  KINZIPCODE,
		  KINCOUNTRY,
		  KINPHONE,
		 -- "HARDCOPY"
		  ACCIDENTDATE,
		  ACCIDENTTYPE,
		  ATTENDINGDOCTORCODE,
		  ATTENDINGDOCTORFAX,
		  ATTENDINGDOCTORNAME,
		  ATTENDINGDOCTORPHONE,
		  DIAGNOSISCODE1,
		  DIAGNOSISCODE2,
		  DIAGNOSISCODE3,
		  DOCTORCODE,
		  FINANCIALCLASS,
		  IMPORTPROCEDURES,
		  LOCATIONCODE,
		  MODIFIER,
		  PATIENTRELATIONTOGUARANTOR,
		  PATIENTRELATIONTOGUARANTORADDITIONALINFO,
		  PATIENTTYPE,
		  PLACEOFSERVICECODE,
		  PROCEDURECODE,
		  SERVICINGPROVIDERCODE
	)
	values
	(
		  @ACCOUNTID,
		  @NAME,
		  @STREET1,
		  @STREET2,
		  @CITY,
		  @STATE,
		  @ZIPCODE,
		  @COUNTRY,
		  @PHONE,
		  @SSN,
		  @SEX,
		  @AGE,
		  @DOB,
		  @MARITALSTATUS,
		  @EMPLOYERNAME,
		  @WORKPHONE,
		  @PATIENTRECNUMBER,
		  @GUARANTORRECNUMBER,
		  @ADMISSIONDATE,
		  @SERVICEDATE,
		  @DISCHARGEDATE,
		  @FACILITYNAME,
		  @FACILITYSTREET1,
		  @FACILITYSTREET2,
		  @FACILITYCITY,
		  @FACILITYSTATE,
		  @FACILITYZIPCODE,
		  @FACILITYCOUNTRY,
		  @FACILITYPHONE,
		  @FACILITYFAX,
		  @DOCTORNAME,
		  @DOCTORPHONE,
		  @DOCTORFAX,
		  @KINNAME,
		  @KINSTREET1,
		  @KINSTREET2,
		  @KINCITY,
		  @KINSTATE,
		  @KINZIPCODE,
		  @KINCOUNTRY,
		  @KINPHONE,
	   --   @HARDCOPY
		  @ACCIDENTDATE,
		  @ACCIDENTTYPE,
		  @ATTENDINGDOCTORCODE,
		  @ATTENDINGDOCTORFAX,
		  @ATTENDINGDOCTORNAME,
		  @ATTENDINGDOCTORPHONE,
		  @DIAGNOSISCODE1,
		  @DIAGNOSISCODE2,
		  @DIAGNOSISCODE3,
		  @DOCTORCODE,
		  @FINANCIALCLASS,
		  @IMPORTPROCEDURES,
		  @LOCATIONCODE,
		  @MODIFIER,
		  @PATIENTRELATIONTOGUARANTOR,
		  @PATIENTRELATIONTOGUARANTORADDITIONALINFO,
		  @PATIENTTYPE,
		  @PLACEOFSERVICECODE,
		  @PROCEDURECODE,
		  @SERVICINGPROVIDERCODE
	)
	END
	ELSE
	BEGIN
	insert into dbo.PatientInfo
	(
		  ACCOUNTID,
		  NAME,
		  STREET1,
		  STREET2,
		  CITY,
		  STATE,
		  ZIPCODE,
		  COUNTRY,
		  PHONE,
		  SSN,
		  SEX,
		  AGE,
		  DOB,
		  MARITALSTATUS,
		  EMPLOYERNAME,
		  WORKPHONE,
		  PATIENTRECNUMBER,
		  GUARANTORRECNUMBER,
		  ADMISSIONDATE,
		  SERVICEDATE,
		  DISCHARGEDATE,
		  FACILITYNAME,
		  FACILITYSTREET1,
		  FACILITYSTREET2,
		  FACILITYCITY,
		  FACILITYSTATE,
		  FACILITYZIPCODE,
		  FACILITYCOUNTRY,
		  FACILITYPHONE,
		  FACILITYFAX,
		  DOCTORNAME,
		  DOCTORPHONE,
		  DOCTORFAX,
		  KINNAME,
		  KINSTREET1,
		  KINSTREET2,
		  KINCITY,
		  KINSTATE,
		  KINZIPCODE,
		  KINCOUNTRY,
		  KINPHONE
	)
	values
	(
		  @ACCOUNTID,
		  @NAME,
		  @STREET1,
		  @STREET2,
		  @CITY,
		  @STATE,
		  @ZIPCODE,
		  @COUNTRY,
		  @PHONE,
		  @SSN,
		  @SEX,
		  @AGE,
		  @DOB,
		  @MARITALSTATUS,
		  @EMPLOYERNAME,
		  @WORKPHONE,
		  @PATIENTRECNUMBER,
		  @GUARANTORRECNUMBER,
		  @ADMISSIONDATE,
		  @SERVICEDATE,
		  @DISCHARGEDATE,
		  @FACILITYNAME,
		  @FACILITYSTREET1,
		  @FACILITYSTREET2,
		  @FACILITYCITY,
		  @FACILITYSTATE,
		  @FACILITYZIPCODE,
		  @FACILITYCOUNTRY,
		  @FACILITYPHONE,
		  @FACILITYFAX,
		  @DOCTORNAME,
		  @DOCTORPHONE,
		  @DOCTORFAX,
		  @KINNAME,
		  @KINSTREET1,
		  @KINSTREET2,
		  @KINCITY,
		  @KINSTATE,
		  @KINZIPCODE,
		  @KINCOUNTRY,
		  @KINPHONE
	)	
	
	END
end

GO