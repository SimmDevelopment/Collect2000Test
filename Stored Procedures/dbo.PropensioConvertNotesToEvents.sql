SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[PropensioConvertNotesToEvents]
@MinNoteUID INT = NULL,
@MaxNoteUID INT = NULL

AS

BEGIN


	--DECLARE @MinNoteUID INT;
	--SET @MinNoteUID = 0;
	--DECLARE @MaxNoteUID INT;
	--SET @MaxNoteUID = 616981413;

	IF (@MaxNoteUID IS NULL)
	BEGIN
		SELECT @MaxNoteUID = MAX(UID)
		FROM dbo.tmpNotesKG WITH (NOLOCK);  --TODO: Change to dbo.Notes
	END;

	IF(@MinNoteUID IS NULL)
		BEGIN
		SELECT @MinNoteUID = ISNULL(MAX(NoteUID),0)
		FROM dbo.PropensioSiteAccountEvent;
	END;
	
	IF OBJECT_ID('tempdb..#PropensioEventWorkingTable') IS NOT NULL DROP TABLE #PropensioEventWorkingTable;
	CREATE TABLE #PropensioEventWorkingTable (AccountID INT, NoteUID INT, [Action] VARCHAR(6), [Result] VARCHAR(6), Created DATETIME, Comment VARCHAR(MAX),EventID INT);

	INSERT INTO #PropensioEventWorkingTable (AccountID,NoteUID,[Action],[Result],Created,Comment)

	SELECT
	number,[UID],[action],[result],created,comment
	FROM dbo.tmpNotesKG WITH (NOLOCK)
	WHERE 
	[UID] > @MinNoteUID AND [UID] <= @MaxNoteUID 
	AND user0 = 'PayWeb';
 

	UPDATE #PropensioEventWorkingTable
	SET
	EventID =
		CASE WHEN [Action] = 'LOG' AND [Result] = 'ON' THEN
					CASE 
						WHEN Comment LIKE 'Invalid%' THEN 1
						WHEN Comment LIKE 'Consumer%' THEN 2
						WHEN Comment LIKE 'User%' THEN 3
					END
			 WHEN [Action] = 'CO' AND [Result] = 'CO' THEN
					CASE
						WHEN Comment LIKE 'Amount%' AND Comment NOT LIKE 'Amount%Auth%' THEN 4
						WHEN Comment LIKE 'Amount%Auth%' THEN 5
					END
			 WHEN [Action] IN ('PDC','PCC') AND [Result] = 'APPRV' THEN 6
		 END	 
	FROM #PropensioEventWorkingTable

	INSERT INTO dbo.PropensioSiteAccountEvent (AccountID,NoteUID,EventID,Occurred)
	SELECT AccountID,NoteUID,EventID,created
	FROM #PropensioEventWorkingTable 
	WHERE EventID IS NOT NULL;

	CREATE TABLE #EventAccounts (
	[AccountID] INTEGER NOT NULL,
	[EventVariable] SQL_VARIANT NULL
	);

	INSERT INTO #EventAccounts ([AccountID], [EventVariable])
	SELECT AccountID,NULL
	FROM #PropensioEventWorkingTable
	WHERE EventID = 1;

	IF EXISTS (SELECT * FROM #EventAccounts) 
	BEGIN
	EXEC [dbo].[WorkFlow_RaiseAccountsEventByName] @EventName = 'Propensio Invalid Login Attempt', @CreateNew = 0;
	TRUNCATE TABLE #EventAccounts;
	END;
	
	INSERT INTO #EventAccounts ([AccountID], [EventVariable])
	SELECT AccountID,NULL
	FROM #PropensioEventWorkingTable
	WHERE EventID = 2;

	IF EXISTS (SELECT * FROM #EventAccounts) 
	BEGIN
	EXEC [dbo].[WorkFlow_RaiseAccountsEventByName] @EventName = 'Propensio Consumer Login', @CreateNew = 0;
	TRUNCATE TABLE #EventAccounts;
	END;
	
	INSERT INTO #EventAccounts ([AccountID], [EventVariable])
	SELECT AccountID,NULL
	FROM #PropensioEventWorkingTable
	WHERE EventID = 3;

	IF EXISTS (SELECT * FROM #EventAccounts) 
	BEGIN
	EXEC [dbo].[WorkFlow_RaiseAccountsEventByName] @EventName = 'Propensio User Login', @CreateNew = 0;
	TRUNCATE TABLE #EventAccounts;
	END;
	
	INSERT INTO #EventAccounts ([AccountID], [EventVariable])
	SELECT AccountID,NULL
	FROM #PropensioEventWorkingTable
	WHERE EventID = 4;

	IF EXISTS (SELECT * FROM #EventAccounts) 
	BEGIN
	EXEC [dbo].[WorkFlow_RaiseAccountsEventByName] @EventName = 'Propensio Payment Failed', @CreateNew = 0;
	TRUNCATE TABLE #EventAccounts;
	END;
	
	INSERT INTO #EventAccounts ([AccountID], [EventVariable])
	SELECT AccountID,NULL
	FROM #PropensioEventWorkingTable
	WHERE EventID = 5;

	IF EXISTS (SELECT * FROM #EventAccounts) 
	BEGIN
	EXEC [dbo].[WorkFlow_RaiseAccountsEventByName] @EventName = 'Propensio Payment Processed', @CreateNew = 0;
	TRUNCATE TABLE #EventAccounts;
	END;
	
	INSERT INTO #EventAccounts ([AccountID], [EventVariable])
	SELECT AccountID,NULL
	FROM #PropensioEventWorkingTable
	WHERE EventID = 6;

	IF EXISTS (SELECT * FROM #EventAccounts) 
	BEGIN
	EXEC [dbo].[WorkFlow_RaiseAccountsEventByName] @EventName = 'Propensio Arrangement Created', @CreateNew = 0;
	TRUNCATE TABLE #EventAccounts;
	END;
END	

GO
