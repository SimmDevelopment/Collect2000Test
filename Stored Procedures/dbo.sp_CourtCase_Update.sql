SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*sp_CourtCase_Update*/
CREATE Procedure [dbo].[sp_CourtCase_Update]
@CourtCaseID int,
@AccountID int,
@CourtID int,
@Judge varchar(100),
@CaseNumber varchar(50),
@DateFiled datetime,
@Judgement bit,
@JudgementAmt money,
@JudgementIntRate real,
@JudgementDate datetime,
@Status varchar(50),
@MiscInfo1 varchar(500),
@MiscInfo2 varchar(500),
@Remarks varchar(1000)
AS

UPDATE CourtCases
SET
AccountID = @AccountID,
CourtID = @CourtID,
Judge = @Judge,
CaseNumber = @CaseNumber,
DateFiled = @DateFiled,
Judgement = @Judgement,
JudgementAmt = @JudgementAmt,
JudgementIntRate = @JudgementIntRate,
JudgementDate = @JudgementDate,
Status = @Status,
MiscInfo1 = @MiscInfo1,
MiscInfo2 = @MiscInfo2,
Remarks = @Remarks,
DateUpdated = GETDATE()
WHERE CourtCaseID = @CourtCaseID

GO
