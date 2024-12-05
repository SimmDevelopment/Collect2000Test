SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*CREATE      PROCEDURE sp_Customer_Search*/
CREATE      PROCEDURE [dbo].[sp_Customer_Search]
@Code varchar (7),
@Name varchar (30),
@AlphaCode varchar (50)
AS
	SELECT *
		FROM Customer
		WHERE (customer Like @Code + '%')
			And (LTRIM(Name) Like '%' + @Name + '%')
			And (isnull(AlphaCode,'') Like @AlphaCode + '%')
		ORDER BY Name
GO
