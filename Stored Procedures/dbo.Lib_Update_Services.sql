SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE  procedure [dbo].[Lib_Update_Services]
(
      @SERVICEID   int,
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
	  @IMPORTFILETYPE varchar(20),
	@NAME varchar(50),
	@PDTTYPE int
)
as
begin


update dbo.Services set
      DESCRIPTION = @DESCRIPTION,
      ENABLED = @ENABLED,
      EMAIL = @EMAIL,
      FTP = @FTP,
      USERCODE = @USERCODE,
      PASSWORD = @PASSWORD,
      STREET1 = @STREET1,
      STREET2 = @STREET2,
      PHONE = @PHONE,
      FAX = @FAX,
      CONTACT = @CONTACT,
      CITY = @CITY,
      STATE = @STATE,
      ZIPCODE = @ZIPCODE,
      MINBALANCE = @MINBALANCE,
      UPDATEACCOUNTS = @UPDATEACCOUNTS,
      SERVICEBATCH = @SERVICEBATCH,
      TRANSFORMATIONSCHEMA = @TRANSFORMATIONSCHEMA,
      REQUESTOBJECT = @REQUESTOBJECT,
      ALLOWDAYS = @ALLOWDAYS,
      DATASCHEMA = @DATASCHEMA,
      MANIFESTID = @MANIFESTID,
      IMPORTDEFINITION = @IMPORTDEFINITION,
	  IMPORTDATASETSCHEMA = @IMPORTDATASETSCHEMA ,
	  IMPORTMAPPINGDEFINITION =@IMPORTMAPPINGDEFINITION  ,
	IMPORTFILETYPE =@IMPORTFILETYPE ,
	[NAME] = @NAME,
	PDTTYPE = @PDTTYPE
	   
	   
where SERVICEID = @SERVICEID

end


GO
