SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[sp_Custom_GenesisPostMassRecall]
@number int
AS
BEGIN

	DECLARE @returnDate datetime
	SET @returnDate = CAST(CONVERT(varchar(10),getdate(),20) + ' 00:00:00.000' as datetime)		
	DECLARE @oldStatus varchar(5)
	DECLARE @Qlevel varchar(3)
	
	-- Find needed data from the master.
	SELECT @oldStatus = RTRIM(LTRIM(m.status)),@Qlevel = RTRIM(LTRIM(m.qlevel))
	FROM master m WITH(NOLOCK)
	WHERE m.number = @number
	
	-- Need to determine if this account should be held by looking at payments or promises. This will generate an ExtraData Record holding the RC for the extracode, line1 is used
	-- to determine if the record has been sent, line2 will hold the date it was sent, which will be set on the upload process.
	IF (@Qlevel IN('010','012','018','019','025','820','830','840') OR 
		@oldStatus IN('PDC','PPA','PCC','HOT','STL','REF','NSF'))BEGIN
			
			-- If the Extra Data record already exist update it.
			IF EXISTS(SELECT TOP 1 number from ExtraData e WITH(NOLOCK)
					  WHERE e.number = @number AND e.extracode = 'RC')BEGIN
					UPDATE ExtraData
					SET line1 = 0
					WHERE number = @number and extracode = 'RC'
			END
			ELSE BEGIN
				INSERT INTO ExtraData
				(number,extracode,line1)
				VALUES(@number,'RC','0')
			END
			
			-- Need to Update the master to hold MASS RECALL on teh custbranch.
			UPDATE master set custbranch = 'MASS RECALL'
			WHERE number = @number			
	END
	ELSE BEGIN
										
		-- If we differ in status create the Status history and Note showing status change..
		IF('CCR' <> @oldStatus)BEGIN
			
			INSERT INTO StatusHistory(AccountId,DateChanged,UserName,OldStatus,NewStatus)
			SELECT @number,@returnDate,'EXG',@oldStatus,'CCR'
			
			INSERT INTO Notes(number,user0,created,action,result,comment)
			SELECT @number,'EXG',@returnDate,'+++++','+++++','Status Change | ' + @oldStatus + ' | CCR'
		END
		
		INSERT INTO Notes(number,user0,created,action,result,comment)
		SELECT @number,'EXG',@returnDate,'+++++','+++++','Account Returned to Genesis due to Mass Recall.'

		UPDATE master
		SET Qlevel='999', 
		closed = @returnDate,
		custbranch = 'MASS RECALL',
		status = 'CCR',
		returned = @returnDate
		WHERE number=@number
	END
END

GO
