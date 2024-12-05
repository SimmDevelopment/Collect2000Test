SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- ====================================================
-- Author:		Custodian 
-- Create date: 08/20/2009
-- Description:	Schedule Reminder Letters for Promises
--added CASE WHEN [Promises].[Customer] IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID = 24) THEN '08' ELSE [Letter].[Code] end
--for resurgent promise letter to be requested.
--added code to request letter 09PPC for Pay Pal promise letters.
-- 3/27/2018 added code to additional area for the letter  code and not just the letter description.
-- 10/4/2018 added code to send 09US for US bank customers.
-- 02/13/2023 BGM Added code to send 09Med for Brightree customer.
-- ====================================================
CREATE PROCEDURE [dbo].[spScheduleReminderLetters] @PromiseDays INT = 10
AS
BEGIN

	BEGIN TRY
	
	SET NOCOUNT ON;

	DECLARE @today DATETIME
	SET @today = { fn CURDATE()}

	INSERT INTO [dbo].[Future]
		(number, entered, requested, action, lettercode, letterdesc, 
		amtdue, duedate, SifPmt1, SifPmt2, SifPmt3, SifPmt4, SifPmt5, SifPmt6)

	SELECT  [Promises].[AcctID], getdate(), getdate(), 'Letter', 
	CASE WHEN [Promises].[Customer] IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID = 24) THEN '08' 
		 WHEN [Promises].[Customer] IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID = 183) THEN '09PPC' 
		 WHEN [Promises].[Customer] IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID = 289) THEN '09US' 
		 WHEN [Promises].[Customer] IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID = 269) THEN '09MED' 

	ELSE [Letter].[Code] end, 
	CASE WHEN [Promises].[Customer] IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID = 24) THEN '08'
		 WHEN [Promises].[Customer] IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID = 183) THEN '09PPC' 
		 WHEN [Promises].[Customer] IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID = 289) THEN '09US' 
		 WHEN [Promises].[Customer] IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID = 269) THEN '09MED' 
		 ELSE [Letter].[Code] end 
		 + ' - ' + 
	CASE WHEN [Promises].[Customer] IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID = 269) THEN 'PTP Brightree' 
	ELSE left(ltrim(rtrim([Letter].[Description])),44) END,
		    [Promises].[Amount], [Promises].[DueDate], '', '', '', '', '', ''
		FROM [dbo].[Promises] 
		INNER JOIN [dbo].[Letter]  ON [Letter].[code] = [Promises].[LetterCode] 
		WHERE (
				(
				 ([Promises].[sendrmdate] >= @today-2 and [Promises].[sendrmdate] <= @today + 1)
				  OR	
				 ((@today < [Promises].[DueDate]-@PromiseDays +1 and @today+@PromiseDays >= [Promises].[duedate]) and [Promises].[SendRMDate] is null)
				)
				AND [Promises].[RMSentDate] IS NULL 
				AND [Promises].[Active]=1
				AND [Promises].[SendRM]=1 
				AND [Promises].[ApprovedBy]<>''
				AND ([Promises].[Suspended]=0 OR [Promises].[Suspended] IS NULL)
			  )


	INSERT INTO [dbo].[Notes] (number,ctl,created,user0,action,result,comment,seq,isprivate)
			SELECT  [Promises].[AcctID], null,getdate(), 'EOD', '+++++', '+++++', 
				'Letter: ' + CASE WHEN [Promises].[Customer] IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID = 24) THEN '08'
								  WHEN [Promises].[Customer] IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID = 183) THEN '09PPC' 
								  WHEN [Promises].[Customer] IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID = 289) THEN '09US' 
								WHEN [Promises].[Customer] IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID = 269) THEN '09MED' 
								  ELSE [Letter].[Code] end 
								  + ' - ' + 
							CASE WHEN [Promises].[Customer] IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID = 269) THEN 'PTP Brightree' 
								  ELSE [Letter].[Description] END
								  + ' Requested', null,1 
		FROM Promises 
		INNER JOIN [dbo].[Letter] ON [Letter].[code] = [Promises].[LetterCode]
		WHERE (
				(
				 ([Promises].[sendrmdate] >= @today-2 and [Promises].[sendrmdate] <= @today + 1)
				  OR	
				 ((@today < [Promises].[DueDate]-@PromiseDays +1 and @today+@PromiseDays >= [Promises].[duedate]) and [Promises].[SendRMDate] is null)
				)
				AND [Promises].[RMSentDate] IS NULL 
				AND [Promises].[Active]=1
				AND [Promises].[SendRM]=1 
				AND [Promises].[ApprovedBy]<>''
				AND ([Promises].[Suspended]=0 OR [Promises].[Suspended] IS NULL)
			  )


	UPDATE [dbo].[Promises]
		SET [Promises].[RMSentDate]=@today
		WHERE [Promises].[ID] in
		 (SELECT  [Promises].[ID]
			FROM [dbo].[Promises] 
			INNER JOIN [dbo].[Letter] ON [Letter].[code] = [Promises].[LetterCode] 
			WHERE (
					(
					 ([Promises].[sendrmdate] >= @today-2 and [Promises].[sendrmdate] <= @today + 1)
					  OR	
					 ((@today < [Promises].[DueDate]-@PromiseDays +1 and @today+@PromiseDays >= [Promises].[duedate]) and [Promises].[SendRMDate] is null)
					)
					AND [Promises].[RMSentDate] IS NULL 
					AND [Promises].[Active]=1
					AND [Promises].[SendRM]=1 
					AND [Promises].[ApprovedBy]<>''
					AND ([Promises].[Suspended]=0 OR [Promises].[Suspended] IS NULL)
				  )
	      )

	END TRY
	BEGIN CATCH
		SELECT * FROM [dbo].[fnGetErrorInfo]()
		RETURN 1
	END CATCH

END

GO
