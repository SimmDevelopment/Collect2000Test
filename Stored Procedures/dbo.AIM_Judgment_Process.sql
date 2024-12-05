SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Judgment_Process]
@file_number INT,
@HasJudgement VARCHAR(1),
@CaseNumber VARCHAR(50),
@JudgementAmt MONEY,
@JudgementIntAward MONEY,
@JudgementCostAward MONEY,
@JudgementAttorneyCostAward MONEY,
@JudgementOtherAward MONEY,
@JudgementIntRate FLOAT,
@IntFromDate DATETIME,
@AttorneyAckDate DATETIME,
@DateFiled DATETIME,
@ServiceDate DATETIME,
@JudgementDate DATETIME,
@JudgementRecordedDate DATETIME,
@DateAnswered DATETIME,
@StatuteDeadline DATETIME,
@CourtDate DATETIME,
@DiscoveryCutoff DATETIME,
@DiscoveryReplyDate DATETIME,
@MotionCutoff DATETIME,
@ArbitrationDate DATETIME,
@LastSummaryJudgementDate DATETIME,
@Status VARCHAR(50),
@ServiceType VARCHAR(20),
@MiscInfo1 VARCHAR(100),
@MiscInfo2 VARCHAR(100),
@Remarks VARCHAR(100),
@Plaintiff VARCHAR(100),
@Defendant VARCHAR(100),
@JudgementBook VARCHAR(20),
@JudgementPage VARCHAR(20),
@Judge VARCHAR(100),
@CourtRoom VARCHAR(15),
@CourtName VARCHAR(50),
@CourtCounty VARCHAR(50),
@CourtStreet1 VARCHAR(50),
@CourtStreet2 VARCHAR(50),
@CourtCity VARCHAR(50),
@CourtState VARCHAR(5),
@CourtZipcode VARCHAR(10),
@CourtPhone VARCHAR(50),
@CourtFax VARCHAR(50),
@CourtSalutation VARCHAR(50),
@CourtClerkFirstName VARCHAR(50),
@CourtClerkMiddleName VARCHAR(50),
@CourtClerkLastName VARCHAR(50),
@CourtNotes VARCHAR(250)

AS

BEGIN

	SELECT 'INSERT CODE HERE'

END

GO
