SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  procedure [dbo].[Lib_Insert_ServiceHistory]
(
      @RequestID   int output,
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
	@TYPENAME varchar(25)
)
as
begin


insert into dbo.ServiceHistory
(
      ACCTID,
      DEBTORID,
      CREATIONDATE,
      RETURNEDDATE,
      SERVICEID,
      REQUESTEDBY,
      REQUESTEDPROGRAM,
      PROCESSED,
      XMLINFOREQUESTED,
      XMLINFORETURNED,
      FILENAME,
      COST,
      SYSTEMYEAR,
      SYSTEMMONTH,
      SERVICEBATCH,
      VERIFIEDBY,
      VERIFIEDDATE,
      BATCHID,
      PROFILEID,
	TYPENAME
)
values
(
      @ACCTID,
      @DEBTORID,
      @CREATIONDATE,
      @RETURNEDDATE,
      @SERVICEID,
      @REQUESTEDBY,
      @REQUESTEDPROGRAM,
      @PROCESSED,
      @XMLINFOREQUESTED,
      @XMLINFORETURNED,
      @FILENAME,
      @COST,
      @SYSTEMYEAR,
      @SYSTEMMONTH,
      @SERVICEBATCH,
      @VERIFIEDBY,
      @VERIFIEDDATE,
      @BATCHID,
      @PROFILEID,
	@TYPENAME
)

select @RequestID = @@identity
end
GO
