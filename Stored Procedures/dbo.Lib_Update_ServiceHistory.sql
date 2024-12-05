SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE  procedure [dbo].[Lib_Update_ServiceHistory]
(
      @REQUESTID   int,
      @ACCTID   int,
      @DEBTORID   int,
      @CREATIONDATE   datetime,
      @RETURNEDDATE   datetime,
      @SERVICEID   int,
      @REQUESTEDBY   varchar (256),
      @REQUESTEDPROGRAM   varchar (256),
      @PROCESSED   int,
      @XMLINFOREQUESTED   text,
      @XMLINFORETURNED   text,
      @FILENAME   varchar (2000),
      @COST   money,
      @SYSTEMYEAR   int,
      @SYSTEMMONTH   int,
      @SERVICEBATCH   float,
      @VERIFIEDBY   varchar (10),
      @VERIFIEDDATE   datetime,
      @BATCHID   uniqueidentifier,
      @PROFILEID   uniqueidentifier,
	@TYPENAME varchar(25))
as
begin


update dbo.ServiceHistory set
      ACCTID = @ACCTID,
      DEBTORID = @DEBTORID,
      CREATIONDATE = @CREATIONDATE,
      RETURNEDDATE = @RETURNEDDATE,
      SERVICEID = @SERVICEID,
      REQUESTEDBY = @REQUESTEDBY,
      REQUESTEDPROGRAM = @REQUESTEDPROGRAM,
      PROCESSED = @PROCESSED,
      XMLINFOREQUESTED = @XMLINFOREQUESTED,
      XMLINFORETURNED = @XMLINFORETURNED,
      FILENAME = @FILENAME,
      COST = @COST,
      SYSTEMYEAR = @SYSTEMYEAR,
      SYSTEMMONTH = @SYSTEMMONTH,
      SERVICEBATCH = @SERVICEBATCH,
      VERIFIEDBY = @VERIFIEDBY,
      VERIFIEDDATE = @VERIFIEDDATE,
      BATCHID = @BATCHID,
      PROFILEID = @PROFILEID,
	TYPENAME = @TYPENAME
where REQUESTID = @REQUESTID

end



GO
