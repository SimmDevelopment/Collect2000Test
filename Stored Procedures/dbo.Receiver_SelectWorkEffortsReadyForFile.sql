SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Receiver_SelectWorkEffortsReadyForFile]
@clientid int
AS
BEGIN

	DECLARE @lastFileSentDT datetime
	SELECT @lastFileSentDT = dbo.Receiver_GetLastFileDate(28,@clientid)
 
 		/*<record recordType="AWEF" dataTableName="NoteRecord" width="241" key="record_type">
			<column name="record_type" dataType="string" width="4" />
			<column name="file_number" dataType="int" width="10" />
			<column name="action_date" dataType="dateTime" width="14" />
			<column name="action_category" dataType="string" width="3" />
			<column name="action_code" dataType="string" width="10" />
			<column name="action_text" dataType="string" width="200" />
		</record>*/

	-- Gather Letters
	SELECT
		'AWEF' as record_type,
		r.sendernumber as file_number,
		lr.[DateRequested] as action_date,
		c.[ActionCategory] as action_category,
		c.[ActionCode] as action_code,
		c.[ActionText] as action_text
	FROM  dbo.master m WITH (NOLOCK) 
	INNER JOIN dbo.receiver_reference r WITH (NOLOCK)
	ON r.receivernumber = m.number
	INNER JOIN dbo.letterrequest lr WITH (NOLOCK) 
	ON m.number = lr.AccountID
	INNER JOIN dbo.letter l WITH (NOLOCK)
	ON l.LetterID = lr.LetterID
	INNER JOIN [dbo].[Receiver_LetterRequestsWorkEffortConfig] c WITH (NOLOCK)
	ON c.[LetterCode] = l.[code]

	WHERE
		  lr.DateRequested > isnull(@lastFileSentDT,m.Received)
		  and r.clientid = @clientid
		  and m.returned is null
		  and m.qlevel < '999'
		  and c.[ClientID] = @clientId

	UNION ALL 
	
	-- Gather Notes
	SELECT
		'AWEF' as record_type,
		r.sendernumber as file_number,
		n.[created] as action_date,
		c.[ActionCategory] as action_category,
		c.[ActionCode] as action_code,
		CASE WHEN ISNULL(RTRIM(LTRIM(c.[ActionText])),'') IN ('') THEN CAST(n.[Comment] as varchar(200)) ELSE c.[ActionText] END as action_text
	FROM  dbo.master m WITH (NOLOCK) 
	INNER JOIN dbo.receiver_reference r WITH (NOLOCK)
	ON r.receivernumber = m.number
	INNER JOIN dbo.Notes n WITH (NOLOCK) 
	ON n.number = m.number
	INNER JOIN [dbo].[Receiver_NotesWorkEffortConfig] c WITH (NOLOCK)
	ON c.[action] = n.[action] AND c.[result] = n.[result]

	WHERE
		  n.[created] > isnull(@lastFileSentDT,m.Received)
		  and r.clientid = @clientid
		  and m.returned is null
		  and m.qlevel < '999'
		  and c.[ClientID] = @clientId
		  

	UNION ALL 
	
	-- Gather Notes
	SELECT
		'AWEF' as record_type,
		r.sendernumber as file_number,
		n.[created] as action_date,
		c.[ActionCategory] as action_category,
		c.[ActionCode] as action_code,
		CASE WHEN ISNULL(RTRIM(LTRIM(c.[ActionText])),'') IN ('') THEN CAST(n.[Comment] as varchar(200)) ELSE c.[ActionText] END as action_text
	FROM  dbo.master m WITH (NOLOCK) 
	INNER JOIN dbo.receiver_reference r WITH (NOLOCK)
	ON r.receivernumber = m.number
	INNER JOIN dbo.Notes n WITH (NOLOCK) 
	ON n.number = m.number
	INNER JOIN [dbo].[Receiver_NotesWorkEffortConfig] c WITH (NOLOCK)
	ON RTRIM(LTRIM(ISNULL(c.[result],''))) = '' AND c.[action] = n.[action]

	WHERE
		  n.[created] > isnull(@lastFileSentDT,m.Received)
		  and r.clientid = @clientid
		  and m.returned is null
		  and m.qlevel < '999'
		  and c.[ClientID] = @clientId

		  
	UNION ALL 
	
	-- Gather Notes
	SELECT
		'AWEF' as record_type,
		r.sendernumber as file_number,
		n.[created] as action_date,
		c.[ActionCategory] as action_category,
		c.[ActionCode] as action_code,
		CASE WHEN ISNULL(RTRIM(LTRIM(c.[ActionText])),'') IN ('') THEN CAST(n.[Comment] as varchar(200)) ELSE c.[ActionText] END as action_text
	FROM  dbo.master m WITH (NOLOCK) 
	INNER JOIN dbo.receiver_reference r WITH (NOLOCK)
	ON r.receivernumber = m.number
	INNER JOIN dbo.Notes n WITH (NOLOCK) 
	ON n.number = m.number
	INNER JOIN [dbo].[Receiver_NotesWorkEffortConfig] c WITH (NOLOCK)
	ON RTRIM(LTRIM(ISNULL(c.[action],''))) = '' AND c.[result] = n.[result]

	WHERE
		  n.[created] > isnull(@lastFileSentDT,m.Received)
		  and r.clientid = @clientid
		  and m.returned is null
		  and m.qlevel < '999'
		  and c.[ClientID] = @clientId
		  
END
GO
