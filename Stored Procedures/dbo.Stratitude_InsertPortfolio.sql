SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Stratitude_InsertPortfolio]
@userid int
AS

DECLARE @portfolioId int
INSERT INTO Portfolios(created,userid,treepath)
VALUES(getdate(),@userid,newid())

SELECT @portfolioId = @@identity
SELECT @portfolioId



GO
