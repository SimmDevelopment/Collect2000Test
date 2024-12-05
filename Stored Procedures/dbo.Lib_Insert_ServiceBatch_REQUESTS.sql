SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO





CREATE  procedure [dbo].[Lib_Insert_ServiceBatch_REQUESTS]
(
      @BATCHID   uniqueidentifier,
      @SERVICEID   int,
      @MANIFESTID   uniqueidentifier,
      @PROFILEID   uniqueidentifier,
      @PRESETID   uniqueidentifier,
      @DATEREQUESTED   datetime,
      @DATESENT   datetime,
      @DATELOADED   datetime,
      @DATEPROCESSED   datetime,
      @REQUESTEDBY   varchar (256),
      @REQUESTEDPROGRAM   varchar (256),
      @IMGREQUEST   image,
      @XMLREQUEST   ntext
)
as
begin


insert into dbo.ServiceBatch_REQUESTS
(
      [BATCHID],
      [SERVICEID],
      [MANIFESTID],
      [PROFILEID],
      [PRESETID],
      [DATEREQUESTED],
      [DATESENT],
      [DATELOADED],
      [DATEPROCESSED],
      [REQUESTEDBY],
      [REQUESTEDPROGRAM],
      [IMGREQUEST],
      [XMLREQUEST]
)
values
(
      @BATCHID,
      @SERVICEID,
      @MANIFESTID,
      @PROFILEID,
      @PRESETID,
      @DATEREQUESTED,
      @DATESENT,
      @DATELOADED,
      @DATEPROCESSED,
      @REQUESTEDBY,
      @REQUESTEDPROGRAM,
      @IMGREQUEST,
      @XMLREQUEST
)

end


GO
