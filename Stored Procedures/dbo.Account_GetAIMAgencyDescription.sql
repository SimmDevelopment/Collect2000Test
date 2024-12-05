SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Account_GetAIMAgencyDescription] @AccountID INTEGER, @Description VARCHAR(250) OUTPUT
AS
SET NOCOUNT ON;
DECLARE @AgencyID INTEGER;

SELECT @AgencyID = [master].[AIMAgency]
FROM [dbo].[master]
WHERE [master].[number] = @AccountID;

IF EXISTS (SELECT * FROM [dbo].[sysobjects] WHERE [id] = OBJECT_ID(N'[dbo].[AIM_Agency]') AND OBJECTPROPERTY([id], N'IsUserTable') = 1) BEGIN
	IF EXISTS (SELECT * FROM [dbo].[AIM_Agency] WHERE [AIM_Agency].[AgencyID] = @AgencyID) BEGIN
		SELECT @Description = 'Agency Name: ' + ISNULL([AIM_Agency].[Name], '') + CHAR(13) + CHAR(10) +
			'Contact Name: ' + ISNULL([AIM_Agency].[ContactName], '') + CHAR(13) + CHAR(10) + 
			'Phone: ' + ISNULL([AIM_Agency].[Phone], '')
		FROM [dbo].[AIM_Agency]
		WHERE [AIM_Agency].[AgencyID] = @AgencyID;
		RETURN 0;
	END;
END;
SET @Description = 'No description available.';
RETURN 0;

GO
