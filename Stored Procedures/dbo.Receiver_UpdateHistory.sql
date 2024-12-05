SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[Receiver_UpdateHistory]
	@historyId int
	,@resultId int
	,@url varchar(255)
	,@filename varchar(100)
	,@numrecords int
	,@numerrors int
	,@sumoftransaction money
	,@rawfile varchar(500)
	,@transactiondate datetime
AS




--Update Accounts to Returned for Close Files,Deceased Files and Bankruptcy Files

DECLARE @filetypeID int
DECLARE @clientID int
SELECT @filetypeId = filetypeId,@clientID = clientID FROM Receiver_History WHERE HistoryID = @historyId
--9 = Close, 10 = Banko, 11 = Deceased

 	IF(@filetypeId = 9)
	BEGIN
		DECLARE @lastFileSentDT datetime
		SELECT @lastFileSentDT = dbo.Receiver_GetLastFileDate(@filetypeId,@clientid)

		INSERT INTO Notes (number,user0,action,result,comment,created)
		SELECT m.number,'AIM','+++++','+++++','Account is returned via AIM Receiver as it has been closed in Latitude.',getdate()
		FROM

			  master m  with (nolock) join receiver_reference r with (nolock)
			  on r.receivernumber = m.number join
			  receiver_statuslookup sl  with (nolock) on m.status = sl.agencystatus and sl.clientid = @clientid
			  join status s with (nolock) on s.code = m.status
		WHERE
			  m.closed is not null
			  and m.qlevel = '998'
			  and r.clientid = @clientid
			   and ((sl.holddays IS NULL AND m.closed + isnull(s.returndays,0) <= getdate()) OR
					(sl.holddays IS NOT NULL AND m.closed + isnull(sl.holddays,0) <= getdate()))


		UPDATE Master SET 
		qlevel = '999',
		returned = getdate()
		FROM

			  master m  with (nolock) join receiver_reference r with (nolock)
			  on r.receivernumber = m.number join
			  receiver_statuslookup sl  with (nolock) on m.status = sl.agencystatus and sl.clientid = @clientid
			  join status s with (nolock) on s.code = m.status
		WHERE
			  m.closed is not null
			  and m.qlevel = '998'
			  and r.clientid = @clientid
			   and ((sl.holddays IS NULL AND m.closed + isnull(s.returndays,0) <= getdate()) OR
					(sl.holddays IS NOT NULL AND m.closed + isnull(sl.holddays,0) <= getdate()))
	END

	update
		receiver_history 
	set
		resultId = @resultId
		,fileurl = @url
		,transactiondate = getdate()--@transactiondate--getdate()
		,filename = @filename 
		,numrecords = @numrecords
		,numerrors = @numerrors
		,sumoftransaction = @sumoftransaction
		,rawfile = null
	where
		historyId = @historyId
GO
