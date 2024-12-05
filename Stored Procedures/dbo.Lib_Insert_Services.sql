SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE  procedure [dbo].[Lib_Insert_Services]
(
      @ServiceId   int output,
      @DESCRIPTION   varchar (50),
      @ENABLED   bit,
      @EMAIL   varchar (50),
      @FTP   varchar (250),
      @USERCODE   varchar (20),
      @PASSWORD   varchar (20),
      @STREET1   varchar (30),
      @STREET2   varchar (30),
      @PHONE   varchar (15),
      @FAX   varchar (15),
      @CONTACT   varchar (30),
      @CITY   varchar (20),
      @STATE   varchar (2),
      @ZIPCODE   varchar (10),
      @MINBALANCE   money,
      @UPDATEACCOUNTS   bit,
      @SERVICEBATCH   int,
      @TRANSFORMATIONSCHEMA   text,
      @REQUESTOBJECT   varchar (50),
      @ALLOWDAYS   int,
      @DATASCHEMA   text,
      @MANIFESTID   uniqueidentifier,
	  @IMPORTDEFINITION text,
	  @IMPORTDATASETSCHEMA text,
	  @IMPORTMAPPINGDEFINITION text,
	@IMPORTFILETYPE varchar(15),
	@NAME varchar(50),
	@PDTTYPE int
)
as
begin

SET IDENTITY_INSERT Services on
insert into dbo.Services
(
      SERVICEID,
      DESCRIPTION,
      ENABLED,
      EMAIL,
      FTP,
      USERCODE,
      PASSWORD,
      STREET1,
      STREET2,
      PHONE,
      FAX,
      CONTACT,
      CITY,
      STATE,
      ZIPCODE,
      MINBALANCE,
      UPDATEACCOUNTS,
      SERVICEBATCH,
      TRANSFORMATIONSCHEMA,
      REQUESTOBJECT,
      ALLOWDAYS,
      DATASCHEMA,
      MANIFESTID,
	  IMPORTDEFINITION,
	  IMPORTDATASETSCHEMA,
	  IMPORTMAPPINGDEFINITION,
IMPORTFILETYPE ,
[NAME],
PDTTYPE
)
values
(
		@SERVICEID,
      @DESCRIPTION,
      @ENABLED,
      @EMAIL,
      @FTP,
      @USERCODE,
      @PASSWORD,
      @STREET1,
      @STREET2,
      @PHONE,
      @FAX,
      @CONTACT,
      @CITY,
      @STATE,
      @ZIPCODE,
      @MINBALANCE,
      @UPDATEACCOUNTS,
      @SERVICEBATCH,
      @TRANSFORMATIONSCHEMA,
      @REQUESTOBJECT,
      @ALLOWDAYS,
      @DATASCHEMA,
      @MANIFESTID,
      @IMPORTDEFINITION,
	  @IMPORTDATASETSCHEMA,
	  @IMPORTMAPPINGDEFINITION,
@IMPORTFILETYPE ,
@NAME,
@PDTTYPE
)
SET IDENTITY_INSERT Services off
select @ServiceId = @@identity
end

GO
