SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*spCourtCase_Update*/
CREATE     PROCEDURE [dbo].[spCourtCase_Update]
	@CourtCaseID int,
	@CourtID int,
	@Judge varchar (100),
	@CaseNumber varchar(50),
	@DateFiled datetime,
	@Judgement bit,
	@JudgementAmt money,
	@JudgementIntRate real,
	@JudgementDate datetime,
	@MiscInfo1 varchar (500),
	@MiscInfo2 varchar (500),
	@Status varchar (50),
	@Remarks varchar (500),
	@Plaintiff varchar(200),
	@Defendant varchar(100),
	@DateAnswered smalldatetime,
	@StatuteDeadline smalldatetime,
	@CourtDate datetime,
	@DiscoveryCutoff smalldatetime,
	@MotionCutoff smalldatetime,
	@ArbitrationDate datetime,
	@LastSummaryJudgementDate smalldatetime,
	@JudgementIntAward money,
	@JudgementCostAward money,
	@JudgementOtherAward money,
	@IntFromDate smalldatetime,
	@CourtRoom VARCHAR(10),
	@ServiceDate DATETIME,
	@ServiceType VARCHAR(20),
	@DiscoveryReplyDate DATETIME,
	@JudgementAttorneyCostAward MONEY,
	@GarnishmentCourtID INTEGER,
	@JudgementCourtID INTEGER,
	@JudgementRecordedDate DATETIME,
	@JudgementBook VARCHAR(20),
	@JudgementPage VARCHAR(20),
	@AttorneyAccountID VARCHAR(50),
	@AttorneyAckDate DATETIME,
	@UpdatedBy int,
	@UpdateChecksum varchar(10) output

AS
Declare @NewChecksum varchar(10)

Select @NewChecksum = UpdateChecksum from CourtCases where CourtCaseID = @CourtCaseID

IF @NewChecksum = @UpdateChecksum BEGIN
	SET @UpdateChecksum = Checksum(GetDate())
	UPDATE CourtCases Set 
		CourtID=@CourtID, 
		Judge=@Judge, 
		CaseNumber=@CaseNumber, 
		DateFiled=@DateFiled, 
		Judgement=@Judgement,
		JudgementAmt=@JudgementAmt, 
		JudgementIntRate=@JudgementIntRate, 
		JudgementDate=@JudgementDate, 
		Status=@Status, 
		MiscInfo1=@MiscInfo1,
		MiscInfo2=@MiscInfo2, 
		Remarks=@Remarks,
		Plaintiff=@Plaintiff,
		Defendant=@Defendant,
		DateAnswered=@DateAnswered,
		StatuteDeadline=@StatuteDeadline,
		CourtDate=@CourtDate,
		DiscoveryCutoff=@DiscoveryCutoff,
		MotionCutoff=@MotionCutoff,
		ArbitrationDate=@ArbitrationDate,
		LastSummaryJudgementDate=@LastSummaryJudgementDate,
		JudgementIntAward=@JudgementIntAward,
		JudgementCostAward=@JudgementCostAward,
		JudgementOtherAward=@JudgementOtherAward,
		IntFromDate=@IntFromDate,
		CourtRoom = @CourtRoom,
		ServiceDate = @ServiceDate,
		ServiceType = @ServiceType,
		DiscoveryReplyDate = @DiscoveryReplyDate,
		JudgementAttorneyCostAward = @JudgementAttorneyCostAward,
		GarnishmentCourtID = @GarnishmentCourtID,
		JudgementCourtID = @JudgementCourtID,
		JudgementRecordedDate = @JudgementRecordedDate,
		JudgementBook = @JudgementBook,
		JudgementPage = @JudgementPage,
		AttorneyAccountID = @AttorneyAccountID,
		AttorneyAckDate = @AttorneyAckDate,
		UpdatedBy=@UpdatedBy,
		DateUpdated = GETDATE(),
		UpdateChecksum=@UpdateChecksum
	WHERE CourtCaseID = @CourtCaseID

	Return @@Error
END
ELSE
	Return -1  -- The record has been updated since we read it

GO
