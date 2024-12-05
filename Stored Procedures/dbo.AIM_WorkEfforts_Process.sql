SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[AIM_WorkEfforts_Process]
@file_number INT,
@action_date DATETIME,
@action_category varchar(3),
@action_code varchar(10),
@action_text  varchar(200),
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
	-- Send 15004	The account is currently not placed with this agency
	IF(@currentAgencyId IS NULL OR (@currentAgencyId <> @agencyId))
	BEGIN
		RAISERROR('15004',16,1)
		RETURN
	END
		
		
	INSERT INTO [dbo].[AIM_WorkEfforts](
	[AccountID],
	[AgencyID],
	[ActionDateTime],
	[Category],
	[Code],	
	[Description])
	SELECT
	@file_number,
	@agencyid,
	@action_date,
	@action_category,
	@action_code,
	@action_text

END
GO
