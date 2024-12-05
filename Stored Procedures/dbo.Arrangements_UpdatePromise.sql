SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_UpdatePromise]
	@ID INTEGER,
	@DueDate DATETIME,
	@Amount MONEY,
	@Desk VARCHAR(10),
	@Customer VARCHAR(7),
	@SendRM BIT, -- ignored
	@LetterCode VARCHAR(5), -- ignored, the arrangements panel does not have good access to the loaded letter code, leave arg in for incidental compatibility
	@SendRMDate DATETIME, -- ignored
	@Suspended BIT,
	@ApprovedBy VARCHAR(10)
AS
SET NOCOUNT ON;

UPDATE [dbo].[Promises]
SET [DueDate] = @DueDate,
	[Amount] = @Amount,
	[Desk] = COALESCE(@Desk, [Desk]),
	[Customer] = COALESCE(@Customer, [Customer]),
--	[SendRM] = @SendRM, -- ignored
--	[LetterCode] = @LetterCode, -- ignored
--	[SendRMDate] = @SendRMDate, -- ignored
	[Suspended] = @Suspended,
	[ApprovedBy] = @ApprovedBy
WHERE [ID] = @ID;

RETURN 0;
GO
