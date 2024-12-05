SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionSelectCustomerGroups    Script Date: 3/26/2007 9:52:01 AM ******/
CREATE PROCEDURE [dbo].[LionSelectCustomerGroups]
AS
	SET NOCOUNT ON;
SELECT ID, Name, Description, DisplayOnInvoices, DisplayOnStats, LetterGroup, DateCreated, DateUpdated FROM CustomCustGroups with (nolock)
GO
