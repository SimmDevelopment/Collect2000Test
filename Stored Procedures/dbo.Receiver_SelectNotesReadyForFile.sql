SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Receiver_SelectNotesReadyForFile]
@clientid int
AS
BEGIN

	DECLARE @lastFileSentDT datetime
	SELECT @lastFileSentDT = dbo.Receiver_GetLastFileDate(17,@clientid)
	
	SELECT
		  'ASTS' as record_type,
		  r.sendernumber as file_number,
		  --d.debtorid as debtor_number,
		  rd.senderdebtorid as debtor_number,
		  ISNULL(config.Status,'') as [status],
		  n.created as [note_date],
		  n.comment as [note],
		  ISNULL(config.[Notification],'') as [notification]
	FROM  dbo.master m WITH (NOLOCK) 
		INNER JOIN receiver_reference r WITH (NOLOCK)
		ON r.receivernumber = m.number
		INNER JOIN debtors d WITH (NOLOCK) 
		ON d.number = m.number and d.seq = 0
		inner join receiver_debtorreference rd WITH (NOLOCK)
		ON d.debtorid = rd.receiverdebtorid
		INNER JOIN notes n WITH (NOLOCK) 
		ON n.number = m.number
		INNER JOIN Receiver_ASTSConfig config WITH (NOLOCK) 
		ON n.Action = config.Action AND n.Result = config.Result AND config.ClientId = @clientId
		INNER JOIN CustomCustGroups cg WITH (NOLOCK)
		ON cg.ID = config.CustomGroupID
	WHERE
		  n.created > isnull(@lastFileSentDT,m.Received)
		  and r.clientid = @clientid
		  and m.returned is null
		  and m.qlevel < '999'
		  and n.user0 <> 'AIM'
		  and n.comment is not null
		  and m.customer IN(SELECT CustomerID FROM Fact WITH (NOLOCK) WHERE CustomGroupID = cg.ID)
END
GO
