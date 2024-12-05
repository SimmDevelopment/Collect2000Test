SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_NewBusinessOptions_GetCustomerOptions*/
CREATE Procedure [dbo].[sp_NewBusinessOptions_GetCustomerOptions]
	@Customer varchar(10)
AS

select * from NewBusinessOptions
where  CustomerID = @Customer

GO
