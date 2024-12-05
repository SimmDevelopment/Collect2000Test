SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Notes_Process]
@file_number INT,
@created_datetime DATETIME,
@note_action VARCHAR(6),
@note_result VARCHAR(6),
@note_comment VARCHAR(300),
@is_private CHAR(1),
@agencyid INT
AS

BEGIN
DECLARE @masterNumber INT,@currentAgencyId INT
SELECT @masterNumber = Number,@currentAgencyId = AIMAgency
FROM dbo.master WITH (NOLOCK) WHERE Number = @file_number

--validate account exists and placed with this agency
IF(@masterNumber IS NULL)
BEGIN
	RAISERROR('15001',16,1)
	RETURN
END
-- Changed by KAR on 05/10/2011 SEnd 15004	The account is currently not placed with this agency
IF(@currentAgencyId IS NULL OR (@currentAgencyId <> @agencyId))
BEGIN
	RAISERROR('15004',16,1)
	RETURN
END
	
	
INSERT INTO dbo.Notes
(Number,
Created,
Action,
Result,
User0,
Ctl,
Comment,
IsPrivate)
SELECT
@file_number,
@created_datetime,
@note_action,
@note_result,
'AIM',
'AIM',
'Agency/Attorney [' + A.Name + '] Comment Entered: ' + @note_comment,
CASE @is_private WHEN 'T' THEN 1 ELSE 0 END
FROM AIM_Agency A  WITH (NOLOCK) WHERE A.AgencyID = @agencyId

END

GO
