SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[EvaluateArrangementsPlacePaymentsOnHold]
@Hold_For_Arrangements_Containing_Closed_Accounts [BIT] = 0
AS 
BEGIN
	SET NOCOUNT ON;

		-- Update the arrangements flag
		UPDATE [dbo].[Arrangements]
			SET [ReviewFlag] = AA.ReviewFlag
			FROM [dbo].[Arrangements] A
			JOIN (SELECT
					[ArrangementId],
					[ReviewFlag] = CASE WHEN @Hold_For_Arrangements_Containing_Closed_Accounts = 1 AND MIN (REPLACE(A.Qlevel,'?',4)) < 998 AND MAX(REPLACE(A.Qlevel,'?',4)) >= 998 THEN  'Inactive Account' ELSE NULL END
					FROM [dbo].[AccountAndArrangementIds] A
					GROUP BY A.ArrangementID ) AS AA
		ON A.ID = AA.ArrangementId
		WHERE AA.ReviewFlag IS NOT NULL
		-- Suspend Promises
		UPDATE [dbo].[Promises]
		SET
		[Active] = AA.Active,
		[Suspended] = AA.Suspended
		FROM
		[dbo].[Promises] p
		JOIN (	SELECT
					[ArrangementId],
					[Active] = CASE WHEN MIN(REPLACE(A.Qlevel,'?',4)) >= 998 THEN 0 ELSE 1 END,
					[Suspended] = CASE WHEN @Hold_For_Arrangements_Containing_Closed_Accounts = 1 AND MIN (REPLACE(A.Qlevel,'?',4)) < 998 AND MAX(REPLACE(A.Qlevel,'?',4)) >= 998 THEN 1 ELSE 0 END
					FROM [dbo].[AccountAndArrangementIds] A
					GROUP BY A.ArrangementID ) AS AA
		ON p.ArrangementID = AA.ArrangementId
		WHERE (p.Active = 1 AND AA.Active = 0) OR (p.Suspended = 0 AND  AA.Suspended = 1)


		-- Place PDCs on Hold
		UPDATE [dbo].[pdc]
		SET
		[Active] = AA.Active,
		[OnHold] = AA.OnHold
		FROM
		[dbo].[pdc] p
		JOIN (	SELECT
					[ArrangementId],
					[Active] = CASE WHEN MIN(REPLACE(A.Qlevel,'?',4)) >= 998 THEN 0 ELSE 1 END,
					[OnHold] = CASE WHEN @Hold_For_Arrangements_Containing_Closed_Accounts = 1 AND MIN (REPLACE(A.Qlevel,'?',4)) < 998 AND MAX(REPLACE(A.Qlevel,'?',4)) >= 998 THEN CAST({ fn CURDATE() } AS DATETIME) ELSE NULL END
					FROM [dbo].[AccountAndArrangementIds] A
					GROUP BY A.ArrangementID ) AS AA
		ON p.ArrangementID = AA.ArrangementId
		WHERE (p.Active = 1 AND AA.Active = 0) OR (AA.OnHold IS NOT NULL AND p.onhold IS NULL)
		
		
		-- Place Credit Cards on Hold
		UPDATE [dbo].[DebtorCreditCards]
		SET
		[IsActive] = AA.IsActive,
		[OnHoldDate] = AA.OnHoldDate
		FROM
		[dbo].[DebtorCreditCards] d
		JOIN (	SELECT
					[ArrangementId],
					[IsActive] = CASE WHEN MIN(A.Qlevel) >= 998 AND MAX(A.Qlevel) >= 998 THEN 0 ELSE 1 END,
					[OnHoldDate] = CASE WHEN @Hold_For_Arrangements_Containing_Closed_Accounts = 1 AND MIN (REPLACE(A.Qlevel,'?',4)) < 998 AND MAX(REPLACE(A.Qlevel,'?',4)) >= 998 THEN CAST({ fn CURDATE() } AS DATETIME) ELSE NULL END
					FROM [dbo].[AccountAndArrangementIds] A
					GROUP BY A.ArrangementID ) AS AA
		ON d.ArrangementID = AA.ArrangementId
		WHERE (d.IsActive = 1 AND AA.IsActive = 0) OR (AA.OnHoldDate IS NOT NULL AND d.OnHoldDate IS NULL)
			
		INSERT INTO dbo.Notes
		(number,user0,action,result,created,comment)
		SELECT DISTINCT
		A.AccountId,
		'SYS',
		'+++++',
		'+++++',
		GETDATE(),
		comment = CASE AA.Action WHEN 0  THEN 'Arrangement Removed - All Accounts are Closed'  WHEN 1 THEN 'Arrangement Put on Hold - Some Accounts in the Arrangement are now Closed' END
		FROM AccountAndArrangementIds A
		JOIN (	SELECT
					[ArrangementId],
					[Action] = CASE WHEN MIN(A.Qlevel) >= 998 AND MAX(A.Qlevel) >= 998 THEN 0 
									WHEN @Hold_For_Arrangements_Containing_Closed_Accounts = 1 AND MIN (REPLACE(A.Qlevel,'?',4)) < 998 AND MAX(REPLACE(A.Qlevel,'?',4)) >= 998 THEN 1 ELSE NULL 
									END
					FROM [dbo].[AccountAndArrangementIds] A
					GROUP BY A.ArrangementID ) AS AA
		ON A.ArrangementId = AA.ArrangementId
		WHERE AA.Action IS NOT NULL

END
GO
