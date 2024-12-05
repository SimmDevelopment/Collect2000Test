SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Stratitude_UpdatePortfolio]
@portfolioId int,
@name varchar(50),
@treepath varchar(900)

AS

UPDATE Portfolios
SET
portfolioname = @name,
treepath = @treepath
WHERE 
portfolioid = @portfolioid



GO
