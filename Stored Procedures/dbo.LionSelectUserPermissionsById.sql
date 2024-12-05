SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionSelectUserPermissionsById    Script Date: 3/26/2007 9:52:01 AM ******/
CREATE PROCEDURE [dbo].[LionSelectUserPermissionsById]
(
	@ID int
)
AS
	SET NOCOUNT ON;
SELECT ID, LionUserId, CanViewDebtor, CanViewNotes, CanViewDemographics, CanViewPOD, CanInsertNote, CanSearchByName, CanSearchByDebtorId, CanSearchByAccount, CanSearchBySsn FROM dbo.LionUserPermissions
Where ID=@ID
GO
