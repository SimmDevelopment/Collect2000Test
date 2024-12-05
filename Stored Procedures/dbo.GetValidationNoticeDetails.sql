SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetValidationNoticeDetails]
	@DebtorID int
AS
SET NOCOUNT ON;
DECLARE @Configured BIT;
DECLARE @AccountID INT;
DECLARE @PolicySetting NVARCHAR(MAX);
SELECT @AccountID= AccountID FROM ValidationNotice WHERE DebtorID = @DebtorID

EXEC [dbo].[GetValidationnoticePolicysettings]
		@AccountID = @AccountID,
		@Configured = @Configured OUTPUT,
		@PolicySetting = @PolicySetting OUTPUT

if(@Configured =1)
	Begin
		SELECT TOP 1 * FROM ValidationNotice WHERE DebtorID = @DebtorID ORDER BY NoticeID DESC;
	End

Return @@Error
GO
