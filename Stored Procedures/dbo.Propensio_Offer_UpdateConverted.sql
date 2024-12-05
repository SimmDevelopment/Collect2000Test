SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Ryan Mack
-- Create date: 2017-07-12
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Propensio_Offer_UpdateConverted] 
	@id UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE SettlementOffers 
	SET UtcConverted = GETUTCDATE()
	WHERE Id = @id 
END

GO
