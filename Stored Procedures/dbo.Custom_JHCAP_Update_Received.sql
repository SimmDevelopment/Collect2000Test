SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- Changes:		09/23/2021 BGM added to only insert TUscore value if it already does not exist.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_JHCAP_Update_Received]
	-- Add the parameters for the stored procedure here
	@number INT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	

    -- Insert statements for procedure here
update master
set OriginalCreditor = 'WebBank Avant'
FROM master m WITH (NOLOCK)
where number = @number AND customer = '0001700'

update extradata 
SET line1 = '222 N. LaSalle St. Suite 1700', line2 = 'Chicago, Illinois 60601'
WHERE @number IN (SELECT number
FROM master m WITH (NOLOCK)
WHERE customer IN ('0001700') AND @number = number)

INSERT INTO TUScores
        ( Number, Score )
SELECT @number, thedata 
FROM miscextra WITH (NOLOCK)
WHERE number = @number AND title = 'acc.0.data_score'
AND @number NOT IN (SELECT number FROM tuscores WHERE number = @number)



END
GO
