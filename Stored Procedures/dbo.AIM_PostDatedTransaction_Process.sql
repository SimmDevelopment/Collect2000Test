SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_PostDatedTransaction_Process]
(
  	@file_number INT
	,@amount MONEY
	,@duedate DATETIME
	,@agencyId INT
	,@batchFileHistoryId INT
	
)
AS
BEGIN
DECLARE @masterNumber INT,@currentAgencyId INT
SELECT @masterNumber = Number,@currentAgencyId = AIMAgency
FROM dbo.master WITH (NOLOCK) WHERE Number = @file_number

--validate account exists and placed with this agency
IF(@masterNumber IS NULL)
BEGIN
	RAISERROR('15001',16,1)
	RETURN
END
-- Changed by KAR on 04/25/2011 SEnd 15004	The account is currently not placed with this agency
IF(@currentAgencyId IS NULL OR (@currentAgencyId <> @agencyId))
BEGIN
	RAISERROR('15004',16,1)
	RETURN
END
	
UPDATE AIM_PostDatedTransaction SET Active = 0
WHERE (AgencyID = @AgencyId OR AccountID = @file_number)
AND BatchFileHistoryId <> @batchFileHistoryId



INSERT INTO AIM_PostDatedTransaction (AccountID,Active,BatchFileHistoryID,AgencyID,Created,DueDate,Amount)
VALUES (@file_number,1,@batchFileHistoryId,@AgencyId,GETDATE(),@duedate,@amount)

INSERT INTO NOTES (Number,Created,User0,Action,Result,Comment)
VALUES (@file_number,getdate(),'AIM','AIM','AIM','Agency/Attorney has reported a post dated transaction on ' + convert(varchar(10),@duedate,101) + ' for ' + cast(@amount as varchar(9)))


END

GO
