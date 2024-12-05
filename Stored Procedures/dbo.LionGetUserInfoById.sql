SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionGetUserInfoById    Script Date: 3/26/2007 9:52:01 AM ******/
CREATE PROCEDURE [dbo].[LionGetUserInfoById]
(
	@ID int
)
AS
	SET NOCOUNT ON;
SELECT 
		ID,
		UserID,
		ReportRoleID,
		CustomerGroupID,
		SupervisiorEmail,
		NotifyEmail,
		FirstName,
		LastName,
		Enabled,
		LionPassword,
		CanViewNotes,
		CanViewDemographics,
		CanViewPOD,
		CanModifyDebtor
FROM dbo.LionUsers
Where ID=@ID

GO
