SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionSelectCustomerGroupById    Script Date: 3/26/2007 9:52:01 AM ******/
CREATE PROCEDURE [dbo].[LionSelectCustomerGroupById]
(
	@ID int
)
AS
	SET NOCOUNT ON;
SELECT ID, Name, Description, DisplayOnInvoices, DisplayOnStats, LetterGroup, DateCreated, DateUpdated FROM dbo.CustomCustGroups
Where ID=@ID
GO
