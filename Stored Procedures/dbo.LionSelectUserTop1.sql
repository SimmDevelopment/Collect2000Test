SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionSelectUserTop1    Script Date: 3/26/2007 9:52:01 AM ******/
-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 01/09/2007
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[LionSelectUserTop1]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT top 1    ID, UserID,ReportRoleID, CustomerGroupID, SupervisiorEmail, NotifyEmail, FirstName, LastName, Enabled, LionPassword, CanViewNotes, CanViewDemographics, 
                      CanViewPOD, CanModifyDebtor
	FROM         LionUsers with (nolock)

END

GO
