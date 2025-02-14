SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionGetUserByUserId    Script Date: 3/26/2007 9:52:01 AM ******/
CREATE PROCEDURE [dbo].[LionGetUserByUserId]
(
	@ID int
)
AS
	SET NOCOUNT ON;
SELECT	
		lu.ID,
		lu.UserID,
		lu.ReportRoleId,
		lu.CustomerGroupID,
		lu.SupervisiorEmail,
		lu.NotifyEmail,
		lu.FirstName,
		lu.LastName,
		lu.Enabled,
		lu.LionPassword,
		lu.CanViewNotes,
		lu.CanViewDemographics,
		lu.CanViewPOD,
		lu.CanModifyDebtor
FROM LionUsers lu
Join Users u on u.Id=lu.UserID
Where u.ID=@ID



GO
