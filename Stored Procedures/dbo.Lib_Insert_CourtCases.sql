SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Lib_Insert_CourtCases]
(
      @CourtCaseID   int output,
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


insert into dbo.CourtCases
(
      ACCOUNTID,
      COURTID,
      JUDGE,
      CASENUMBER,
      DATEFILED,
      JUDGEMENT,
      JUDGEMENTAMT,
      JUDGEMENTINTRATE,
      JUDGEMENTDATE,
      STATUS,
      MISCINFO1,
      MISCINFO2,
      REMARKS,
      PLAINTIFF,
      DEFENDANT,
      DATEANSWERED,
      STATUTEDEADLINE,
      COURTDATE,
      DISCOVERYCUTOFF,
      MOTIONCUTOFF,
      ARBITRATIONDATE,
      LASTSUMMARYJUDGEMENTDATE,
      JUDGEMENTINTAWARD,
      JUDGEMENTCOSTAWARD,
      JUDGEMENTOTHERAWARD,
      INTFROMDATE,
      ACCRUEDINT,
      DATECREATED,
      DATEUPDATED,
      UPDATEDBY,
      UPDATECHECKSUM,
      JUDGEMENTATTORNEYCOSTAWARD,
      AttorneyAckDate,
      ServiceDate,
      DiscoveryReplyDate,
      ServiceType,
      JudgementBook,
      JudgementPage,
      CourtRoom,
	  JudgementRecordedDate
)
values
(
      @ACCOUNTID,
      @COURTID,
      @JUDGE,
      @CASENUMBER,
      @DATEFILED,
      @JUDGEMENT,
      @JUDGEMENTAMT,
      @JUDGEMENTINTRATE,
      @JUDGEMENTDATE,
      @STATUS,
      @MISCINFO1,
      @MISCINFO2,
      @REMARKS,
      @PLAINTIFF,
      @DEFENDANT,
      @DATEANSWERED,
      @STATUTEDEADLINE,
      @COURTDATE,
      @DISCOVERYCUTOFF,
      @MOTIONCUTOFF,
      @ARBITRATIONDATE,
      @LASTSUMMARYJUDGEMENTDATE,
      @JUDGEMENTINTAWARD,
      @JUDGEMENTCOSTAWARD,
      @JUDGEMENTOTHERAWARD,
      @INTFROMDATE,
      @ACCRUEDINT,
      @DATECREATED,
      @DATEUPDATED,
      @UPDATEDBY,
      @UPDATECHECKSUM,
      @JUDGMENTATTORNEYCOSTAWARD,
      @AttorneyAckDate,
      @ServiceDate,
      @DiscoveryReplyDate,
      @ServiceType,
      @JudgementBook,
      @JudgementPage,
      @CourtRoom,
	  @JudgementRecordedDate	  
)

select @CourtCaseID = Scope_Identity()
end

GO
