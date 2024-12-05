SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE   PROCEDURE [dbo].[Custom_HourlySweep]

AS

/*All accts with the following status SPA - sweep to desk SPANISH 
All accts with the following status B07, B11, B13, BKY – sweep to desk BKCY 
All accts with the following status PIF and a balance between $0.00 and $0.01 – sweep to desk PIF 
All accts with the following status SIF – sweep to desk SIF 
All accts with the following status DEC – sweep to desk DECD */

SET XACT_ABORT ON

BEGIN TRAN

DECLARE @changeDesk TABLE (number int, NewDesk varchar(10))

INSERT @changeDesk
SELECT number, 'SPANISH'
FROM master
WHERE status = 'SPA' AND desk <> 'SPANISH'

INSERT @changeDesk
SELECT number, 'BKCY'
FROM master
WHERE status IN ('B07','B11','B13','BKY') AND desk <> 'BKCY'

INSERT @changeDesk
SELECT number, 'PIF'
FROM master
WHERE status = 'PIF' AND (current0 < 0 OR current0 BETWEEN .00 AND .01 or current0 = 0) AND desk <> 'PIF'

INSERT @changeDesk
SELECT number, 'SIF'
FROM master
WHERE status = 'SIF' AND desk <> 'SIF'

INSERT @changeDesk
SELECT number, 'DECD'
FROM master
WHERE status = 'DEC' AND desk <> 'DECD'

INSERT @changeDesk
SELECT number, '008'
FROM master
WHERE status IN ('CCR', 'CXL') AND desk <> '008'


INSERT INTO [dbo].[notes] ([number], [created], [UtcCreated], [user0], [action], [result], [comment])
SELECT cd.number, GETDATE(), GETUTCDATE(), 'HrlySweep', 'DESK', 'CHNG', 'Desk Changed from ' + desk + ' to ' + NewDesk
FROM @changeDesk cd INNER JOIN master m
	ON cd.number = m.number


INSERT INTO [dbo].[notes] ([number], [created], [UtcCreated], [user0], [action], [result], [comment])
SELECT cd.number, GETDATE(), GETUTCDATE(), 'HrlySweep', 'REMOVE', 'QUEUE', 'Account removed from supervisor queue'
FROM @changeDesk cd INNER JOIN SupportQueueItems 
	ON cd.number = AccountID

DECLARE @jobNumber varchar(50)
SET @jobNumber = NEWID()

INSERT INTO [dbo].[DeskChangeHistory] ([Number], [JobNumber], [OldDesk], [NewDesk], [OldQLevel], [NewQLevel], [OldQDate], 
	[NewQDate], [OldBranch], [NewBranch], [User], [DMDateStamp])
SELECT m.number, @jobNumber, [desk], NewDesk, qlevel, qlevel, qdate, CONVERT(VARCHAR(8), GETDATE(), 112), 
	m.branch, d.[Branch], 'HrlySweep', GETDATE()
FROM @changeDesk cd INNER JOIN master m
	ON cd.number = m.number INNER JOIN desk d
	ON NewDesk = d.code

DELETE SupportQueueItems
WHERE AccountID IN (SELECT number FROM @changeDesk)

UPDATE m
SET desk = NewDesk
FROM master m INNER JOIN @changeDesk cd
	ON m.number = cd.number

COMMIT
GO
