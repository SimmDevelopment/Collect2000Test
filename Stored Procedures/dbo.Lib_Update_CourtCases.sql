SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Lib_Update_CourtCases]
(
      @COURTCASEID   int,
      @ACCOUNTID   int,
      @COURTID   int,
      @JUDGE   varchar (100),
      @CASENUMBER   varchar (50),
      @DATEFILED   datetime,
      @JUDGEMENT   bit,
      @JUDGEMENTAMT   money,
      @JUDGEMENTINTRATE   real,
      @JUDGEMENTDATE   datetime,
      @STATUS   varchar (50),
      @MISCINFO1   varchar (500),
      @MISCINFO2   varchar (500),
      @REMARKS   varchar (1000),
      @PLAINTIFF   varchar (200),
      @DEFENDANT   varchar (100),
      @DATEANSWERED   smalldatetime,
      @STATUTEDEADLINE   smalldatetime,
      @COURTDATE   datetime,
      @DISCOVERYCUTOFF   smalldatetime,
      @MOTIONCUTOFF   smalldatetime,
      @ARBITRATIONDATE   datetime,
      @LASTSUMMARYJUDGEMENTDATE   smalldatetime,
      @JUDGEMENTINTAWARD   money,
      @JUDGEMENTCOSTAWARD   money,
      @JUDGEMENTOTHERAWARD   money,
      @INTFROMDATE   smalldatetime,
      @ACCRUEDINT   money,
      @DATECREATED   datetime,
      @DATEUPDATED   datetime,
      @UPDATEDBY   int,
      @UPDATECHECKSUM   varchar (50),
      @JUDGMENTATTORNEYCOSTAWARD money,
      @AttorneyAckDate datetime = null,
      @ServiceDate datetime = null,
      @DiscoveryReplyDate datetime = null,
      @ServiceType varchar(20) = null,
      @JudgementBook varchar(20) = null,
      @JudgementPage varchar(20) = null,
      @CourtRoom varchar(15) = null,
	  @JudgementRecordedDate datetime = null
)
as
begin


update dbo.CourtCases set
      ACCOUNTID = @ACCOUNTID,
      COURTID = @COURTID,
      JUDGE = @JUDGE,
      CASENUMBER = @CASENUMBER,
      DATEFILED = @DATEFILED,
      JUDGEMENT = @JUDGEMENT,
      JUDGEMENTAMT = @JUDGEMENTAMT,
      JUDGEMENTINTRATE = @JUDGEMENTINTRATE,
      JUDGEMENTDATE = @JUDGEMENTDATE,
      STATUS = @STATUS,
      MISCINFO1 = @MISCINFO1,
      MISCINFO2 = @MISCINFO2,
      REMARKS = @REMARKS,
      PLAINTIFF = @PLAINTIFF,
      DEFENDANT = @DEFENDANT,
      DATEANSWERED = @DATEANSWERED,
      STATUTEDEADLINE = @STATUTEDEADLINE,
      COURTDATE = @COURTDATE,
      DISCOVERYCUTOFF = @DISCOVERYCUTOFF,
      MOTIONCUTOFF = @MOTIONCUTOFF,
      ARBITRATIONDATE = @ARBITRATIONDATE,
      LASTSUMMARYJUDGEMENTDATE = @LASTSUMMARYJUDGEMENTDATE,
      JUDGEMENTINTAWARD = @JUDGEMENTINTAWARD,
      JUDGEMENTCOSTAWARD = @JUDGEMENTCOSTAWARD,
      JUDGEMENTOTHERAWARD = @JUDGEMENTOTHERAWARD,
      INTFROMDATE = @INTFROMDATE,
      ACCRUEDINT = @ACCRUEDINT,
      DATECREATED = @DATECREATED,
      DATEUPDATED = @DATEUPDATED,
      UPDATEDBY = @UPDATEDBY,
      UPDATECHECKSUM = @UPDATECHECKSUM,
      JUDGEMENTATTORNEYCOSTAWARD = @JUDGMENTATTORNEYCOSTAWARD,
      AttorneyAckDate =    @AttorneyAckDate,
      ServiceDate= @ServiceDate,
      DiscoveryReplyDate= @DiscoveryReplyDate,
      ServiceType= @ServiceType,
      JudgementBook=@JudgementBook,
      JudgementPage= @JudgementPage,
      CourtRoom	=@CourtRoom,
	  JudgementRecordedDate=@JudgementRecordedDate
where COURTCASEID = @COURTCASEID

end

GO
