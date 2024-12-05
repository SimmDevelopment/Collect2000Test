SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G. Meehan
-- Create date: 01/02/2023
-- Description:	Update extra data and contract date with the earliest charge date on the account.  Delete blank miscextra records.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_NJ_Spine_Post_Import_New_Business]
	-- Add the parameters for the stored procedure here
	@number AS INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE master
	SET ContractDate = (SELECT TOP 1 MIN(CAST(TheData AS DATE)) from MiscExtra WITH (NOLOCK) WHERE number = master.number and Title = 'ChargeDate' ORDER BY MIN(CAST(TheData AS DATE)))
	WHERE customer = 3060 AND number = @number	

	INSERT INTO extradata (number, extracode, line1, line2, line3, line4, line5)
	SELECT number, 'L1', '', '', '', '', FORMAT(m.ContractDate, 'MM/dd/yyyy')
	FROM master m WITH (NOLOCK) 
	WHERE m.customer = 3060 AND m.number = @number	

	DELETE
	FROM MiscExtra
	WHERE number = @number
	AND TheData = ''

END
GO
