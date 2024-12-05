SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Hyundai_Debtors_Cleanup]
	-- Add the parameters for the stored procedure here
	@number int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	delete from debtors
	where [name] = '000000000000000000000000000000' and number = @number

	delete from phones_master
	where phonenumber = '0000000000' and number = @number

	delete from debtors
	where [SSN] = '000000000' and [name] = '' and number = @number

END
GO
