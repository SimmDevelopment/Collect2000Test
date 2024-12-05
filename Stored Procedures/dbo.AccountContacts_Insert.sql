SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AccountContacts_Insert]
	@AcctID INTEGER,
	@UserID INTEGER,
	@DeskCode VARCHAR(10),
	@TheDate DATETIME,
	@TimeOn DATETIME,
	@TimeOff DATETIME,
	@Elapsed INTEGER,
	@TimeOnUtc DATETIME
AS

INSERT INTO [dbo].[AccountContacts] ([number], [UserID], [DESK], [TheDate], [TimeOn], [TimeOff], [TotalSeconds], [TimeOnUtc])
VALUES (@AcctID, @UserID, @DeskCode, @TheDate, @TimeOn, @TimeOff, @Elapsed, @TimeOnUtc);

RETURN @@ERROR;

GO
