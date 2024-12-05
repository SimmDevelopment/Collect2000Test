SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Lib_Update_MasterByQueryToolExport]
@BatchHistoryID INT,
@RecordID uniqueidentifier,
@CloseAccounts bit,
@ReturnAccounts bit,
@ChangeStatus bit,
@ChangeDesk bit,
@StatusCode varchar(5),
@DeskCode varchar(10)
AS
BEGIN

	CREATE TABLE #Exchange_QueryToolExports_RecordUpdates
	([ID] [int] IDENTITY(1,1), [AccountID] [Int]) 
	CREATE  INDEX [ix_Exchange_QueryToolExports_RecordUpdates] ON [dbo].[#Exchange_QueryToolExports_RecordUpdates]([AccountID])
	DECLARE @maxID INT
	DECLARE @currentRow INT
	DECLARE @sqlBatchSize INT
	DECLARE @rowCount INT
	DECLARE @runDate DateTime
	DECLARE @branch varchar(5)
	SET @sqlBatchSize = 250
	SET @runDate = getdate()

	select @branch = branch from desk (nolock) 
	where code = @DeskCode 
	AND ISNULL(RTRIM(LTRIM(@DeskCode)),'') <> '' AND @ChangeDesk = 1
	
	-- INSERT RECORDS FOR THE UPDATE
	INSERT INTO #Exchange_QueryToolExports_RecordUpdates([AccountID])
	SELECT [dbo].[Exchange_ExportDetail].[AccountID]
	FROM [dbo].[Exchange_ExportDetail] WITH(NOLOCK)
	WHERE [dbo].[Exchange_ExportDetail].[ExportDetailRecordID] = @RecordID AND
	[dbo].[Exchange_ExportDetail].[ExportHistoryID] = @BatchHistoryID
	GROUP BY [dbo].[Exchange_ExportDetail].[AccountID]

	-- Now we can do the updates
	select @maxID= max(ID) from #Exchange_QueryToolExports_RecordUpdates
	select @currentrow = 1 
	
	select @rowCount = case when @sqlBatchSize<=@maxID then @sqlBatchSize else @maxID end
	
	WHILE @rowCount <= @maxID BEGIN
	
		IF(@CloseAccounts = 1 OR @ReturnAccounts = 1 OR @ChangeStatus = 1) BEGIN
			
			IF(@CloseAccounts = 1) BEGIN

				-- Will need to create a Note and a Status History Record
				INSERT INTO [dbo].[StatusHistory] ([AccountID],[DateChanged],[UserName],[OldStatus],[NewStatus])
				SELECT [dbo].[master].[number],@runDate,'Exchange',[dbo].[master].[status],@StatusCode
				FROM #Exchange_QueryToolExports_RecordUpdates
				INNER JOIN [dbo].[master] WITH(NOLOCK)
					ON #Exchange_QueryToolExports_RecordUpdates.[AccountID] = [dbo].[master].[number]
				WHERE #Exchange_QueryToolExports_RecordUpdates.ID between @currentRow and @rowCount
				AND ISNULL(RTRIM(LTRIM(@StatusCode)),'') != '' AND ISNULL(RTRIM(LTRIM(@StatusCode)),'') <> [dbo].[master].[status]
				AND @ChangeStatus = 1

				INSERT INTO [dbo].[Notes] ([number],[ctl],[created],[user0],[action],[result],[comment],[seq])
				SELECT [dbo].[master].[number], null, @runDate,'Exchange','+++++','+++++','Status has changed (Old Status = ' + [dbo].[master].[status] + ') (New Status = ' + @StatusCode + ')',null
				FROM #Exchange_QueryToolExports_RecordUpdates
				INNER JOIN [dbo].[master] WITH(NOLOCK)
					ON #Exchange_QueryToolExports_RecordUpdates.[AccountID] = [dbo].[master].[number]
				WHERE #Exchange_QueryToolExports_RecordUpdates.ID between @currentRow and @rowCount
				AND ISNULL(RTRIM(LTRIM(@StatusCode)),'') != '' AND ISNULL(RTRIM(LTRIM(@StatusCode)),'') <> [dbo].[master].[status]
				AND @ChangeStatus = 1

				UPDATE  [dbo].[master]
				SET Qlevel = '998',
				[Closed] = @runDate,
				[Status] = CASE WHEN @ChangeStatus = 1 AND ISNULL(RTRIM(LTRIM(@StatusCode)),'') != '' AND ISNULL(RTRIM(LTRIM(@StatusCode)),'') <> [dbo].[master].[status] THEN @StatusCode ELSE [status] END 
				FROM #Exchange_QueryToolExports_RecordUpdates
				INNER JOIN [dbo].[master] WITH(NOLOCK)
					ON #Exchange_QueryToolExports_RecordUpdates.[AccountID] = [dbo].[master].[number]
				WHERE #Exchange_QueryToolExports_RecordUpdates.ID between @currentRow and @rowCount
			END
			
			IF(@ReturnAccounts = 1) BEGIN
			
				-- Will need to create a Note and a Status History Record
				INSERT INTO [dbo].[StatusHistory] ([AccountID],[DateChanged],[UserName],[OldStatus],[NewStatus])
				SELECT [dbo].[master].[number],@runDate,'Exchange',[dbo].[master].[status],@StatusCode
				FROM #Exchange_QueryToolExports_RecordUpdates
				INNER JOIN [dbo].[master] WITH(NOLOCK)
					ON #Exchange_QueryToolExports_RecordUpdates.[AccountID] = [dbo].[master].[number]
				WHERE #Exchange_QueryToolExports_RecordUpdates.ID between @currentRow and @rowCount
				AND ISNULL(RTRIM(LTRIM(@StatusCode)),'') != '' AND ISNULL(RTRIM(LTRIM(@StatusCode)),'') <> [dbo].[master].[status]
				AND @ChangeStatus = 1

				INSERT INTO [dbo].[Notes] ([number],[ctl],[created],[user0],[action],[result],[comment],[seq])
				SELECT [dbo].[master].[number], null, @runDate,'Exchange','+++++','+++++','Status has changed (Old Status = ' + [dbo].[master].[status] + ') (New Status = ' + @StatusCode + ')',null
				FROM #Exchange_QueryToolExports_RecordUpdates
				INNER JOIN [dbo].[master] WITH(NOLOCK)
					ON #Exchange_QueryToolExports_RecordUpdates.[AccountID] = [dbo].[master].[number]
				WHERE #Exchange_QueryToolExports_RecordUpdates.ID between @currentRow and @rowCount
				AND ISNULL(RTRIM(LTRIM(@StatusCode)),'') != '' AND ISNULL(RTRIM(LTRIM(@StatusCode)),'') <> [dbo].[master].[status]
				AND @ChangeStatus = 1

				UPDATE  [dbo].[master]
				SET Qlevel = '999', 
				[Closed] = CASE WHEN [Closed] IS NULL THEN @runDate ELSE [Closed] END,
				[Returned] = @runDate,
				[Status] = CASE WHEN @ChangeStatus = 1 AND ISNULL(RTRIM(LTRIM(@StatusCode)),'') != '' AND ISNULL(RTRIM(LTRIM(@StatusCode)),'') <> [dbo].[master].[status] THEN @StatusCode ELSE [status] END 
				FROM #Exchange_QueryToolExports_RecordUpdates
				INNER JOIN [dbo].[master] WITH(NOLOCK)
					ON #Exchange_QueryToolExports_RecordUpdates.[AccountID] = [dbo].[master].[number]
				WHERE #Exchange_QueryToolExports_RecordUpdates.ID between @currentRow and @rowCount
			
			END
			
			IF(@ChangeStatus = 1 AND @CloseAccounts = 0 AND @ReturnAccounts = 0) BEGIN
			
				-- Will need to create a Note and a Status History Record
				INSERT INTO [dbo].[StatusHistory] ([AccountID],[DateChanged],[UserName],[OldStatus],[NewStatus])
				SELECT [dbo].[master].[number],@runDate,'Exchange',[dbo].[master].[status],@StatusCode
				FROM #Exchange_QueryToolExports_RecordUpdates
				INNER JOIN [dbo].[master] WITH(NOLOCK)
					ON #Exchange_QueryToolExports_RecordUpdates.[AccountID] = [dbo].[master].[number]
				WHERE #Exchange_QueryToolExports_RecordUpdates.ID between @currentRow and @rowCount
				AND ISNULL(RTRIM(LTRIM(@StatusCode)),'') != '' AND ISNULL(RTRIM(LTRIM(@StatusCode)),'') <> [dbo].[master].[status]
				AND @ChangeStatus = 1

				INSERT INTO [dbo].[Notes] ([number],[ctl],[created],[user0],[action],[result],[comment],[seq])
				SELECT [dbo].[master].[number], null, @runDate,'Exchange','+++++','+++++','Status has changed (Old Status = ' + [dbo].[master].[status] + ') (New Status = ' + @StatusCode + ')',null
				FROM #Exchange_QueryToolExports_RecordUpdates
				INNER JOIN [dbo].[master] WITH(NOLOCK)
					ON #Exchange_QueryToolExports_RecordUpdates.[AccountID] = [dbo].[master].[number]
				WHERE #Exchange_QueryToolExports_RecordUpdates.ID between @currentRow and @rowCount
				AND ISNULL(RTRIM(LTRIM(@StatusCode)),'') != '' AND ISNULL(RTRIM(LTRIM(@StatusCode)),'') <> [dbo].[master].[status]
				AND @ChangeStatus = 1

				UPDATE  [dbo].[master]
				SET [Status] = @StatusCode
				FROM #Exchange_QueryToolExports_RecordUpdates
				INNER JOIN [dbo].[master] WITH(NOLOCK)
					ON #Exchange_QueryToolExports_RecordUpdates.[AccountID] = [dbo].[master].[number]
				WHERE #Exchange_QueryToolExports_RecordUpdates.ID between @currentRow and @rowCount			
				AND ISNULL(RTRIM(LTRIM(@StatusCode)),'') != '' AND ISNULL(RTRIM(LTRIM(@StatusCode)),'') <> [dbo].[master].[status]
			END
		END
		
		IF(@ChangeDesk = 1) BEGIN
			-- A Note showing desk change?
			INSERT INTO [dbo].[Notes]([Number],[Created],[User0],[Action],[Result],[Comment])
			SELECT [dbo].[Master].[Number],@runDate,'Exchange','DESK','CHNG','Desk Changed from ' + ISNULL([dbo].[Master].[Desk],'') + ' to ' +  @DeskCode
			FROM #Exchange_QueryToolExports_RecordUpdates
			INNER JOIN [dbo].[master] WITH(NOLOCK)
				ON #Exchange_QueryToolExports_RecordUpdates.[AccountID] = [dbo].[master].[number]
			WHERE #Exchange_QueryToolExports_RecordUpdates.ID between @currentRow and @rowCount
			AND ISNULL(RTRIM(LTRIM(@DeskCode)),'') != '' AND ISNULL(RTRIM(LTRIM(@DeskCode)),'') <> [dbo].[master].[desk]
			
			UPDATE  [dbo].[master]
			SET desk = @DeskCode,
			branch = CASE WHEN @branch != '' THEN @branch ELSE [branch] END
			FROM #Exchange_QueryToolExports_RecordUpdates
			INNER JOIN [dbo].[master] WITH(NOLOCK)
				ON #Exchange_QueryToolExports_RecordUpdates.[AccountID] = [dbo].[master].[number]
			WHERE #Exchange_QueryToolExports_RecordUpdates.ID between @currentRow and @rowCount
			AND ISNULL(RTRIM(LTRIM(@DeskCode)),'') != '' AND ISNULL(RTRIM(LTRIM(@DeskCode)),'') <> [dbo].[master].[desk]
		END 
			
		-- Update counters for our next row of updates.
		SELECT @currentRow = @rowCount + 1
		SELECT @rowCount= 
			CASE 
				WHEN @rowCount + @sqlBatchSize <@maxID  then @rowCount + @sqlBatchSize
				WHEN @rowCount = @maxID then @maxID+1 
				ELSE @maxid 
			END
	END
END

GO
