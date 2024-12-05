SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionInsertUserPermissionByUserId    Script Date: 3/26/2007 9:52:01 AM ******/
CREATE PROCEDURE [dbo].[LionInsertUserPermissionByUserId]
(
	@LionUserId int,
	@CanViewDebtor bit,
	@CanViewNotes bit,
	@CanViewDemographics bit,
	@CanViewPOD bit,
	@CanInsertNote bit,
	@CanSearchByName bit,
	@CanSearchByDebtorId bit,
	@CanSearchByAccount bit,
	@CanSearchBySsn bit
)
AS
BEGIN
	SET NOCOUNT OFF;
INSERT INTO [dbo].[LionUserPermissions] ([LionUserId], [CanViewDebtor], [CanViewNotes], [CanViewDemographics], [CanViewPOD], [CanInsertNote], [CanSearchByName], [CanSearchByDebtorId], [CanSearchByAccount], [CanSearchBySsn]) VALUES (@LionUserId, @CanViewDebtor, @CanViewNotes, @CanViewDemographics, @CanViewPOD, @CanInsertNote, @CanSearchByName, @CanSearchByDebtorId, @CanSearchByAccount, @CanSearchBySsn);
	
SELECT ID, LionUserId, CanViewDebtor, CanViewNotes, CanViewDemographics, CanViewPOD, CanInsertNote, CanSearchByName, CanSearchByDebtorId, CanSearchByAccount, CanSearchBySsn FROM LionUserPermissions WHERE (ID = SCOPE_IDENTITY())
END

GO
