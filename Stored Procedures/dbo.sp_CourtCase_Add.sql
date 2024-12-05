SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





/*sp_CourtCase_Add*/
CREATE  Procedure [dbo].[sp_CourtCase_Add]
@CourtCaseID int OUTPUT,
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

INSERT INTO CourtCases
(
AccountID,
CourtID,
Judge,
CaseNumber,
DateFiled,
Judgement,
JudgementAmt,
JudgementIntRate,
JudgementDate,
Status,
MiscInfo1,
MiscInfo2,
Remarks
)
VALUES
(
@AccountID,
@CourtID,
@Judge,
@CaseNumber,
@DateFiled,
@Judgement,
@JudgementAmt,
@JudgementIntRate,
@JudgementDate,
@Status,
@MiscInfo1,
@MiscInfo2,
@Remarks
)

SET @CourtCaseID = SCOPE_IDENTITY()



GO
