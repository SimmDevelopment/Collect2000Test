SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_ProcessEvents]
AS
SET NOCOUNT ON;

DECLARE @ID UNIQUEIDENTIFIER;
DECLARE @AccountID INTEGER;
DECLARE @EventID UNIQUEIDENTIFIER;
DECLARE @EventName NVARCHAR(100);
DECLARE @Occurred DATETIME;
DECLARE @EventVariable SQL_VARIANT;
DECLARE @WorkFlowID UNIQUEIDENTIFIER;
DECLARE @StartingActivity UNIQUEIDENTIFIER;
DECLARE @ExecID UNIQUEIDENTIFIER;
DECLARE @InitialPriority INTEGER;
DECLARE @ActionType BIT;
DECLARE @Reentrance TINYINT;
DECLARE @WorkFlowDelay BIGINT;
DECLARE @Now DATETIME;
DECLARE @StartWorkFlow BIT;

IF NOT OBJECT_ID('tempdb..#xevent') IS NULL DROP TABLE #xevent;

create table #xevent (
		[recType] INTEGER NOT NULL ,
		[QueueID] UNIQUEIDENTIFIER NOT NULL,
		[AccountID] INTEGER NOT NULL,
		[EventID] UNIQUEIDENTIFIER NOT NULL,
		[Name] NVARCHAR(100) NOT NULL,
		[Occurred] DATETIME NOT NULL,
		[EventVariable] SQL_VARIANT NULL,
		[WorkFlowID] UNIQUEIDENTIFIER NULL,
		[StartingActivity] UNIQUEIDENTIFIER NULL,
		[InitialPriority] INTEGER NULL,
		[ActionType] BIT NULL,
		[Reentrance] TINYINT NULL,
		[WorkFlowDelay] BIGINT NULL,
		[xExecID] UNIQUEIDENTIFIER NULL ,
		[xHistoryID] UNIQUEIDENTIFIER NOT NULL DEFAULT(NEWsequentialID()),
		[xActivityID] UNIQUEIDENTIFIER NULL,
		[xEnteredDate] DATETIME NULL,
		[xAccountID] INTEGER NULL,
		[NewWFID] UNIQUEIDENTIFIER NOT NULL DEFAULT(NEWsequentialID())
		);

with xevent as (

SELECT case when [WorkFlow_EffectiveEventConfiguration].[ActionType] is not null
				AND [WorkFlow_EffectiveEventConfiguration].[ActionType]= 0 
				AND ([WorkFlow_Activities].[WorkFlowID] <> [WorkFlow_Execution].[ID]
				OR [WorkFlow_Execution].[ID] IS NULL)
			then '1'
		    when [WorkFlow_EffectiveEventConfiguration].[ActionType] is not null
		        AND [WorkFlow_Execution].[PauseCount] = 0
				AND ([WorkFlow_Activities].[WorkFlowID] <> [WorkFlow_Execution].[ID]
				OR [WorkFlow_Execution].[ID] IS NULL) 
		    then '2' 
		    --
		    when [WorkFlows].[StartingActivity] IS NOT NULL
				AND [WorkFlow_EffectiveEventConfiguration].[Reentrance]=1
				AND [WorkFlow_Activities].[WorkFlowID] = [WorkFlow_Execution].[ID]
			then '3' --set startworkflow=1
		    when [WorkFlows].[StartingActivity] IS NOT NULL
				AND [WorkFlow_EffectiveEventConfiguration].[Reentrance]=2
				AND [WorkFlow_Activities].[WorkFlowID] = [WorkFlow_Execution].[ID]
			then '4' --set startworkflow=0
		    when [WorkFlows].[StartingActivity] IS NOT NULL
				AND [WorkFlow_EffectiveEventConfiguration].[Reentrance]=3
				AND [WorkFlow_Activities].[WorkFlowID] = [WorkFlow_Execution].[ID]
				AND [WorkFlow_Execution].[PauseCount] <> 0
			then '5' --set pausecount=0 
			when [WorkFlows].[StartingActivity] IS NOT NULL 
			then '6' --set startworkflow=1
			else '0'
			
		end
		
 as RecType, 
	[WorkFlow_EventQueue].[ID] as [QueueID] ,
	[WorkFlow_EventQueue].[AccountID] as [AccountID],
	[WorkFlow_EventQueue].[EventID] as [EventID],
	[WorkFlow_Events].[Name] as [Name],
	[WorkFlow_EventQueue].[Occurred] as [Occurred],
	[WorkFlow_EventQueue].[EventVariable] as [EventVariable],
	[WorkFlow_EffectiveEventConfiguration].[WorkFlowID] as [WorkFlowID],
	[WorkFlows].[StartingActivity] as [StartingActivity],
	[WorkFlow_EffectiveEventConfiguration].[InitialPriority] as [InitialPriority],
	[WorkFlow_EffectiveEventConfiguration].[ActionType] as [ActionType],
	[WorkFlow_EffectiveEventConfiguration].[Reentrance] as [Reentrance],
	[WorkFlow_EffectiveEventConfiguration].[WorkFlowDelay] as [WorkFlowDelay],
	--NEWID() as [NewWFID],
	[WorkFlow_Execution].[ID] as [xExecID], --UNIQUEIDENTIFIER NOT NULL UNIQUE,
	--NEWID() as [xHistoryID], --UNIQUEIDENTIFIER NOT NULL DEFAULT(NEWID()),
	[WorkFlow_Execution].[ActivityID] as [xActivityID], --UNIQUEIDENTIFIER NOT NULL,
	[WorkFlow_Execution].[EnteredDate] as [xEnteredDate], --DATETIME NOT NULL,
	[WorkFlow_Execution].[AccountID] as [xAccountID] --INTEGER NOT NULL
	
FROM [dbo].[WorkFlow_EventQueue] 
INNER JOIN [dbo].[WorkFlow_Events]
ON [WorkFlow_EventQueue].[EventID] = [WorkFlow_Events].[ID]
INNER JOIN [dbo].[master] WITH (NOLOCK)
ON [WorkFlow_EventQueue].[AccountID] = [master].[number]
INNER JOIN [dbo].[WorkFlow_EffectiveEventConfiguration] WITH (NOLOCK)
ON [WorkFlow_Events].[ID] = [WorkFlow_EffectiveEventConfiguration].[EventID]
AND [master].[customer] = [WorkFlow_EffectiveEventConfiguration].[Customer]
left outer join [dbo].[WorkFlow_Execution]
on [WorkFlow_EffectiveEventConfiguration].[WorkFlowID] = [WorkFlow_Execution].[ID]
and [WorkFlow_EventQueue].[AccountID] = [WorkFlow_Execution].[AccountID] 
left outer join [dbo].[WorkFlow_Activities]
ON [WorkFlow_Execution].[ActivityID] = [WorkFlow_Activities].[ID]
LEFT OUTER JOIN [dbo].[WorkFlows]
ON [WorkFlow_EffectiveEventConfiguration].[WorkFlowID] = [WorkFlows].[ID]

)

insert into #xevent 
(
		[recType] ,
		[QueueID] ,
		[AccountID],
		[EventID] ,
		[Name] ,
		[Occurred] ,
		[EventVariable],
		[WorkFlowID] ,
		[StartingActivity] ,
		[InitialPriority] ,
		[ActionType] ,
		[Reentrance] ,
		[WorkFlowDelay],
		[xExecID] ,
		--[xHistoryID] UNIQUEIDENTIFIER NOT NULL DEFAULT(NEWsequentialID()),
		[xActivityID] ,
		[xEnteredDate] ,
		[xAccountID] 
		--[NewWFID] UNIQUEIDENTIFIER NOT NULL DEFAULT(NEWsequentialID())

)
select 		
		[recType] ,
		[QueueID] ,
		[AccountID],
		[EventID] ,
		[Name] ,
		[Occurred] ,
		[EventVariable],
		[WorkFlowID] ,
		[StartingActivity] ,
		[InitialPriority] ,
		[ActionType] ,
		[Reentrance] ,
		[WorkFlowDelay],
		[xExecID] ,
		--[xHistoryID] UNIQUEIDENTIFIER NOT NULL DEFAULT(NEWsequentialID()),
		[xActivityID] ,
		[xEnteredDate] ,
		[xAccountID] 
		--[NewWFID] UNIQUEIDENTIFIER NOT NULL DEFAULT(NEWsequentialID())

from xevent;

	

	SET @Now = GETDATE();

	
	--ActionType
	--	NULL = allow other work flows to continue executing
	--	0    = stop other work flows from executing
	--	1    = pause execution of other work flows
	
	--rectype 1

			INSERT INTO [dbo].[WorkFlow_ExecutionHistory] ([ID], [ExecID], [AccountID], [ActivityID], [Entered], [Evaluated], [NextActivityID])
			SELECT [Exec].[xHistoryID], [Exec].[xExecID], [Exec].[xAccountID], [Exec].[xActivityID], [Exec].[xEnteredDate], @Now, '00000000-0000-0000-0000-000000000000'
			FROM #xevent AS [Exec] where [Exec].rectype = '1' AND [Exec].[xExecID] IS NOT NULL;

			INSERT INTO [dbo].[WorkFlow_ExecutionHistoryComments] ([HistoryID], [AccountID], [Comment])
			SELECT [Exec].[xHistoryID], [Exec].[xAccountID], 'WorkFlow stopped by event "' + [Exec].[Name] + '"'
			FROM #xevent AS [Exec] where [Exec].rectype = '1' AND [Exec].[xExecID] IS NOT NULL;

			DELETE [dbo].[WorkFlow_Execution]
			FROM [dbo].[WorkFlow_Execution]
			INNER JOIN #xevent AS [Exec]
			ON [Exec].[xExecID] = [WorkFlow_Execution].[ID]
			where [Exec].rectype = '1';
	--rectype 2
			INSERT INTO [dbo].[WorkFlow_ExecutionHistory] ([ID], [ExecID], [AccountID], [ActivityID], [Entered], [Evaluated], [NextActivityID])
			SELECT [Exec].[xHistoryID], [Exec].[xExecID], [Exec].[xAccountID], [Exec].[xActivityID], [Exec].[xEnteredDate], @Now, [Exec].[xActivityID]
			FROM #xevent AS [Exec] where [Exec].rectype = '2' AND [Exec].[xExecID] IS NOT NULL;

			INSERT INTO [dbo].[WorkFlow_ExecutionHistoryComments] ([HistoryID], [AccountID], [Comment])
			SELECT [Exec].[xHistoryID], [Exec].[xAccountID], 'WorkFlow paused by event "' + [Exec].[Name] + '"'
			FROM #xevent AS [Exec] where [Exec].rectype = '2' AND [Exec].[xExecID] IS NOT NULL;

			UPDATE [dbo].[WorkFlow_Execution]
			SET [PauseCount] = 1
			FROM [dbo].[WorkFlow_Execution]
			INNER JOIN #xevent AS [Exec]
			ON [WorkFlow_Execution].[ID] = [Exec].[xExecID]
			where [Exec].rectype = '2';
	--------------------------------while loop


	--Reentrance
	--	0 = allow work flows to execute concurrently
	--	1 = restart work flow for account
	--	2 = do not start new work flow for account
	--	3 = resume paused work flow for account
			
	--rectype 3

				INSERT INTO [dbo].[WorkFlow_ExecutionHistory] ([ID], [ExecID], [AccountID], [ActivityID], [Entered], [Evaluated], [NextActivityID])
				SELECT [Exec].[xHistoryID], [Exec].[xExecID], [Exec].[xAccountID], [Exec].[xActivityID], [Exec].[xEnteredDate], @Now, [Exec].[xActivityID]
				FROM #xevent AS [Exec] where [Exec].rectype = '3';

				INSERT INTO [dbo].[WorkFlow_ExecutionHistoryComments] ([HistoryID], [AccountID], [Comment])
				SELECT [Exec].[xHistoryID], [Exec].[xAccountID], 'WorkFlow restarted by event "' + [Exec].[Name] + '"'
				FROM #xevent AS [Exec] where [Exec].rectype = '3';

				DELETE [dbo].[WorkFlow_Execution]
				FROM [dbo].[WorkFlow_Execution]
				INNER JOIN #xevent AS [Exec]
				ON [Exec].[xExecID] = [WorkFlow_Execution].[ID]
				where [Exec].rectype = '3';
	--rectype 4
				--ELSE IF @Reentrance = 2 BEGIN
				--	SET @StartWorkFlow = 0;
				--END;
	--rectype 5
						INSERT INTO [dbo].[WorkFlow_ExecutionHistory] ([ID], [ExecID], [AccountID], [ActivityID], [Entered], [Evaluated], [NextActivityID])
						SELECT [Exec].[xHistoryID], [Exec].[xExecID], [Exec].[xAccountID], [Exec].[xActivityID], [Exec].[xEnteredDate], @Now, [Exec].[xActivityID]
						FROM #xevent AS [Exec] where [Exec].rectype = '5';;

						INSERT INTO [dbo].[WorkFlow_ExecutionHistoryComments] ([HistoryID], [AccountID], [Comment])
						SELECT [Exec].[xHistoryID], [Exec].[xAccountID], 'WorkFlow resumed by event "' + [Exec].[Name] + '"'
						FROM #xevent AS [Exec] where [Exec].rectype = '5';

						UPDATE [dbo].[WorkFlow_Execution]
						SET [PauseCount] = 0
						FROM [dbo].[WorkFlow_Execution]
						INNER JOIN #xevent AS [Exec]
						ON [Exec].[xExecID] = [WorkFlow_Execution].[ID]
						where [Exec].rectype = '5';

	--SET @StartWorkFlow = 0;
	------------------ while + if @WorkFlowID IS NOT NULL AND @StartingActivity IS NOT NULL BEGIN
	--rectype 6
			INSERT INTO [dbo].[WorkFlow_Execution] ([ID], [AccountID], [ActivityID], [EnteredDate], [NextEvaluateDate], [LastEvaluated], [LastEvaluatedWithPriority])
			select [Exec].[NewWFID], [Exec].AccountID, [Exec].StartingActivity, GETDATE(), DATEADD(MINUTE, [Exec].WorkFlowDelay, GETDATE()), GETDATE(), p.PriorityDate
			FROM #xevent AS [Exec] 
			CROSS APPLY ( Select * FROM [dbo].[WorkFlow_GetPriorityDate](GETDATE(), [Exec].InitialPriority)) p
			where [Exec].rectype = '6';
			
			INSERT INTO [dbo].[WorkFlow_ExecutionVariables] ([ExecID], [ActivityID], [AccountID], [Name], [Variable])
			SELECT [Exec].[NewWFID], NULL, [Exec].AccountID, '(EventName)', [Exec].[Name]
			FROM #xevent AS [Exec] where [Exec].rectype = '6';

			INSERT INTO [dbo].[WorkFlow_ExecutionVariables] ([ExecID], [ActivityID], [AccountID], [Name], [Variable])
			select [Exec].[NewWFID], NULL, [Exec].AccountID, '(EventVariable)', [Exec].EventVariable
			FROM #xevent AS [Exec] where [Exec].rectype = '6'
			and [Exec].EventVariable is not null;


	----------- while loop
	INSERT INTO [dbo].[WorkFlow_EventHistory] ([EventID], [EventName], [AccountID], [Occurred], [EventVariable], [WorkFlowID], [ActionType], [Reentrance], [WorkFlowDelay])
	select [Exec].EventID, [Exec].Name, [Exec].AccountID, [Exec].Occurred, [Exec].EventVariable, [Exec].WorkFlowID, [Exec].ActionType, [Exec].Reentrance, [Exec].WorkFlowDelay
	FROM #xevent AS [Exec] --where [Exec].rectype = 

	DELETE FROM [dbo].[WorkFlow_EventQueue]
	FROM [dbo].[WorkFlow_EventQueue]
	INNER JOIN #xevent AS [Exec]
				ON [WorkFlow_EventQueue].[ID] = [Exec].[QueueID] 


	-------------- end loop
RETURN 0;
GO
