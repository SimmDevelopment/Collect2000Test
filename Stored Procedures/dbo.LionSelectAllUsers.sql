SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionSelectAllUsers    Script Date: 3/26/2007 9:52:01 AM ******/
CREATE PROCEDURE [dbo].[LionSelectAllUsers]
AS
	SET NOCOUNT ON;
SELECT ID, UserID, CustomerGroupID, SupervisiorEmail, NotifyEmail, FirstName, LastName, Enabled, LionPassword FROM dbo.LionUsers
GO
