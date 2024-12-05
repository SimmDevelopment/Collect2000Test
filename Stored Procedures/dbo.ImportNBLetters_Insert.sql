SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.ImportNBLetters_Insert    Script Date: 5/5/2004 4:36:55 PM ******/

CREATE PROCEDURE [dbo].[ImportNBLetters_Insert]
	@AccountID int,
	@Entered Datetime,
	@Requested Datetime,
	@LetterDesc Varchar(50),
	@LetterCode Varchar(5),
	@Seq tinyint,
	@AmtDue money,
	@Action Varchar(50),
	@Suspend tinyint,
	@PromiseType varchar(10),
	@SendRm varchar(1),
	@Ctl varchar(3)
AS
INSERT INTO ImportNBLetters (number, Entered, Requested, letterdesc, lettercode, seq, amtdue, action, suspend, promisetype, rmsent, ctl, duedate)
Values (@AccountID, @Entered, @Requested, @LetterDesc, @LetterCode, @Seq, @AmtDue, @Action, @Suspend, @PromiseType, @SendRm, @Ctl, NUll)

Return @@Error
	
GO
