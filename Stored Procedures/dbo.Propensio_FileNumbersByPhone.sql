SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Mike Bean - Divinity
-- Create date: 2/9/2023
-- Description:	Returns list of possible filenumbers when supplied a phone number
-- =============================================
CREATE PROCEDURE [dbo].[Propensio_FileNumbersByPhone] 
	@phone varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		Select cast(number as varchar)
		from Phones_Master with (noLock) 
		where PhoneNumber = @phone
END
GO
