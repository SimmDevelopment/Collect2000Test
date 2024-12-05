SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[sp_Custom_GenesisPostMaint]
@number int
AS
BEGIN

	DECLARE @oldStatus varchar(5)
	DECLARE @Qlevel varchar(3)
	DECLARE @closed datetime
	DECLARE @returned datetime	
	DECLARE @returnDate datetime
	DECLARE @newStatus varchar(5)
	DECLARE @statusFromGenesis varchar(10)
	DECLARE @bkyCaseNumber varchar (30)
	DECLARE @bkyCaseChapter varchar (3)
	DECLARE @bkyStatus varchar (20)
	DECLARE @bkyFileDate datetime
	DECLARE @deceasedDate datetime
	DECLARE @recallComment varchar(200)

	SET @returnDate = CAST(CONVERT(varchar(10),getdate(),20) + ' 00:00:00.000' as datetime)	
	SET @newStatus = NULL


/*RC01	General Dispute	CCR: account note should state "client recalled: general dispute"
RC02	Confirmed Bankruptcy	BKY: account note should state "client recalled: confirmed bankruptcy"
RC03	Confirmed Deceased	DEC:  account note should state "client recalled: confirmed deceased"
RC04 	Agency Recall	CCR:  account note should state "client recalled: agency recall"
RC05	Account Paid in Full	CCR:  account note should state "client recalled: account pif"
RC06	Account Settled in Full	CCR:  account note should state "client recalled:  account sif"
RC08	Client Requests Closed	CCR:  account note should state "client recalled: client requests recalled"
RC09	Incarceration	DIP:  account note shouold state "client recalled:  incarceration"
RC10	Confirmed Fraud	FRD:  account note should state "client recalled:  confirmed fraud"
RC11	Cease and Desist	CAD:  account note should state "client recalled:  cease and desist"
RC12	Closed per Regulatory Complaint	CCR:  account note should state "client recalled:  closed per regulatory complaint"
RC13	Closed Debt Management	CCR:  account note should state "client recalled:  closed debt management"
RC20	Out of Statute	CCR:  account note should state "client recalled:  out of statute"
RC21	Non Agency Recall	CCR:  account note should state "client recalled:  non agency recall"
RC22	Buyback	CCR:  account note should state " client recalled:  buyback"
RC23	Non-Closure Update	NA
RC24	Non-Closure Update	NA
RC30	Balance Transfer Update to Agencies – close account	CCR:  account note should state "client recalled: balance transfer update to agencies - close account" */

	
	-- Find needed data from the master.
	SELECT @QLevel=m.Qlevel,@closed=m.closed,@returned=m.returned,@oldStatus=m.status
	FROM master m WITH(NOLOCK)
	WHERE m.number = @number
	
	-- Need to Find record from Misc Extra.
	SELECT @statusFromGenesis = RTRIM(LTRIM(me.thedata))
	FROM miscextra me with(NOLOCK)
	WHERE me.title = 'GENSTATUPDATE' and me.number=@number
	
	SELECT @newStatus = 
	CASE 
		WHEN UPPER(@statusFromGenesis) IN  ('RC01') THEN 'CCR'
		WHEN UPPER(@statusFromGenesis) IN  ('RC02') THEN 'BKY'
		WHEN UPPER(@statusFromGenesis) IN  ('RC03') THEN 'DEC'		
		WHEN UPPER(@statusFromGenesis) IN  ('RC05') THEN 'CCR'
		WHEN UPPER(@statusFromGenesis) IN  ('RC06') THEN 'CCR'
		WHEN UPPER(@statusFromGenesis) IN  ('RC08') THEN 'CCR'		
		WHEN UPPER(@statusFromGenesis) IN  ('RC09') THEN 'DIP'				
		WHEN UPPER(@statusFromGenesis) IN  ('RC10') THEN 'FRD'						
		WHEN UPPER(@statusFromGenesis) IN  ('RC11') THEN 'CAD'						
		WHEN UPPER(@statusFromGenesis) IN  ('RC12') THEN 'CCR'
		WHEN UPPER(@statusFromGenesis) IN  ('RC13') THEN 'CCR'		
		WHEN UPPER(@statusFromGenesis) IN  ('RC20') THEN 'CCR'
		WHEN UPPER(@statusFromGenesis) IN  ('RC21') THEN 'CCR'		
		WHEN UPPER(@statusFromGenesis) IN  ('RC22') THEN 'CCR'				
		WHEN UPPER(@statusFromGenesis) IN  ('RC30') THEN 'CCR'				
	END
	SELECT @recallComment = 
	CASE 
		WHEN UPPER(@statusFromGenesis) IN  ('RC01') THEN 'Client Recalled: General Dispute'
		WHEN UPPER(@statusFromGenesis) IN  ('RC02') THEN 'Client Recalled: Confirmed Bankruptcy'
		WHEN UPPER(@statusFromGenesis) IN  ('RC03') THEN 'Client recalled: Confirmed Deceased'		
		WHEN UPPER(@statusFromGenesis) IN  ('RC05') THEN 'Client Recalled: Account PIF'
		WHEN UPPER(@statusFromGenesis) IN  ('RC06') THEN 'Client Recalled: Account SIF'
		WHEN UPPER(@statusFromGenesis) IN  ('RC08') THEN 'Client Recalled: Client Requests Recalled'		
		WHEN UPPER(@statusFromGenesis) IN  ('RC09') THEN 'Client Recalled: Incarceration'				
		WHEN UPPER(@statusFromGenesis) IN  ('RC10') THEN 'Client Recalled: Confirmed Fraud'						
		WHEN UPPER(@statusFromGenesis) IN  ('RC11') THEN 'Client Recalled: Cease and Desist'						
		WHEN UPPER(@statusFromGenesis) IN  ('RC12') THEN 'Client Recalled: Closed per Regulatory Complaint'
		WHEN UPPER(@statusFromGenesis) IN  ('RC13') THEN 'Client Recalled: Closed Debt Management'		
		WHEN UPPER(@statusFromGenesis) IN  ('RC20') THEN 'Client Recalled: Out of Statute'
		WHEN UPPER(@statusFromGenesis) IN  ('RC21') THEN 'Client Recalled: Non Agency Recall'		
		WHEN UPPER(@statusFromGenesis) IN  ('RC22') THEN 'Client Recalled: Buyback'				
		WHEN UPPER(@statusFromGenesis) IN  ('RC30') THEN 'Client Recalled: Balance Transfer Update to Agencies - Close Account'				
	END	

	-- If we were able to find a status to change to....
	IF(@newStatus IS NOT NULL) BEGIN

		-- If we differ in status create the Status history and Note showing status change..
		IF(@newStatus <> @oldStatus)BEGIN
				
			INSERT INTO StatusHistory(AccountId,DateChanged,UserName,OldStatus,NewStatus)
			SELECT @number,@returnDate,'EXG',@oldStatus,@newStatus
				
			INSERT INTO Notes(number,user0,created,action,result,comment)
			SELECT @number,'EXG',@returnDate,'+++++','+++++','Status Change | ' + @oldStatus + ' | ' + @newStatus
		END
			
		INSERT INTO Notes(number,user0,created,action,result,comment)
		SELECT @number,'EXG',@returnDate,'+++++','+++++',@recallComment + ' ' + @statusFromGenesis
	
		UPDATE master
		SET Qlevel='999', 
		closed = @returnDate,
		status = @newStatus,
		custbranch=@statusFromGenesis,
		returned = @returnDate
		WHERE number=@number
		
		-- Remove the Misc Extra Record
		DELETE FROM miscextra
		WHERE number=@number and title= 'GENSTATUPDATE'
	END 
END

GO
