SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*spDesk_Select*/
CREATE PROCEDURE [dbo].[spDesk_Select]
	@Code varchar(10)
AS

Select * from Desk with(nolock) where code = @Code


Return @@Error
GO
