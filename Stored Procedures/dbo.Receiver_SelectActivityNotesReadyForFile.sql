SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Receiver_SelectActivityNotesReadyForFile]
@clientid int
AS
BEGIN

	DECLARE @lastFileSentDT datetime
	SELECT @lastFileSentDT = dbo.Receiver_GetLastFileDate(27,@clientid)
 
 		/*<record recordType="ANOT" dataTableName="NoteRecord" width="340" key="record_type">
			<column name="record_type" dataType="string" width="4" />
			<column name="file_number" dataType="int" width="9" />
			<column name="created_datetime" dataType="dateTime" width="14" />
			<column name="note_action" dataType="string" width="6" />
			<column name="note_result" dataType="string" width="6" />
			<column name="note_comment" dataType="string" width="300" />
			<column name="is_private" dataType="string" width ="1" />
		</record>*/


	SELECT
		  'ANOT' as record_type,
		  r.sendernumber as file_number,
		  n.[Created] as created_datetime,
		  n.[Action] as note_action,
		  n.[Result] as note_result,
		  n.[Comment] as note_comment,
		  CASE WHEN n.[IsPrivate] IN (1) Then 'Y' ELSE 'N' END as is_private
	FROM  dbo.master m WITH (NOLOCK) 
		INNER JOIN receiver_reference r WITH (NOLOCK)
		ON r.receivernumber = m.number
		INNER JOIN notes n WITH (NOLOCK) 
		ON n.number = m.number
		INNER JOIN [dbo].[Users] u WITH (NOLOCK)
		ON u.[LoginName] = n.[User0]
	WHERE
		  n.created > isnull(@lastFileSentDT,m.Received)
		  and r.clientid = @clientid
		  and m.returned is null
		  and m.qlevel < '999'
		  and n.user0 <> 'AIM'
		  and n.comment is not null
END
GO
