SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[EvaluateArrangements]
@Hold_Linked_Arrangements_Containing_Closed_Account [BIT] = 0
AS 
BEGIN
	EXEC [dbo].[EvaluateArrangementsNonLinkedAccounts] 
	EXEC [dbo].[EvaluateArrangementsLinkedAccounts] @Hold_Linked_Arrangements_Containing_Closed_Account;
END
GO
