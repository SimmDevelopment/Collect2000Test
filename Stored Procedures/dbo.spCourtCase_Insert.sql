SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







/*spCourtCase_Insert*/
CREATE      PROCEDURE [dbo].[spCourtCase_Insert]
	@AccountID int,
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
	@Remarks varchar (1000),
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
	@UpdateChecksum varchar output,
	@ReturnID int output
 AS
	Declare @Error int
	
	SET @UpdateChecksum = Checksum(GetDate())

	INSERT INTO CourtCases (AccountID, CourtID, Judge, CaseNumber, DateFiled, Judgement, JudgementAmt,
	JudgementIntRate, JudgementDate, Status, MiscInfo1, MiscInfo2, Remarks, Plaintiff, Defendant,
	DateAnswered, StatuteDeadline, CourtDate, DiscoveryCutoff, MotionCutoff, ArbitrationDate,
	LastSummaryJudgementDate, JudgementIntAward, JudgementCostAward, JudgementOtherAward, IntFromDate,
	CourtRoom, ServiceDate, ServiceType, DiscoveryReplyDate, JudgementAttorneyCostAward,
	GarnishmentCourtID, JudgementCourtID, JudgementRecordedDate, JudgementBook, JudgementPage, AttorneyAccountID, AttorneyAckDate, UpdatedBy, UpdateChecksum)
	VALUES (@AccountID, @CourtID, @Judge, @CaseNumber, @DateFiled, @Judgement, @JudgementAmt,
	@JudgementIntRate, @JudgementDate, @Status,@MiscInfo1, @MiscInfo2, @Remarks, @Plaintiff, @Defendant,
	@DateAnswered, @StatuteDeadline, @CourtDate, @DiscoveryCutoff, @MotionCutoff, @ArbitrationDate,
	@LastSummaryJudgementDate, @JudgementIntAward, @JudgementCostAward, @JudgementOtherAward, @IntFromDate,
	@CourtRoom, @ServiceDate, @ServiceType, @DiscoveryReplyDate, @JudgementAttorneyCostAward,
	@GarnishmentCourtID, @JudgementCourtID, @JudgementRecordedDate, @JudgementBook, @JudgementPage,	@AttorneyAccountID, @AttorneyAckDate, @UpdatedBy, @UpdateChecksum)
	
	Set @Error = @@Error
	IF @Error = 0 
		Select @ReturnID = SCOPE_IDENTITY()
	Return @Error






GO
