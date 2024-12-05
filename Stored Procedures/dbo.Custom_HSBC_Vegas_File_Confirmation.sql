SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- exec custom_hsbc_vegas_file_confirmation '0001015'
-- =============================================
CREATE PROCEDURE [dbo].[Custom_HSBC_Vegas_File_Confirmation] 
	-- Add the parameters for the stored procedure here
	@customer VARCHAR(7)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT agencycode, (SELECT COUNT(*) FROM master m WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer WHERE c.customtext1 = hvm.agencycode AND m.received IN ('20100422', '20100916')) AS placedaccts,
	(SELECT SUM(original) FROM master m WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer WHERE c.customtext1 = hvm.agencycode AND m.received IN ('20100422', '20100916')) AS amountplaced,
	SUM(CASE WHEN SUBSTRING(fieldcode, 1, 2) = 'VS' THEN 0 ELSE 1 END) AS maintvol1count,
	SUM(CASE WHEN SUBSTRING(fieldcode, 1, 2) = 'VS' THEN 1 ELSE 0 END) AS maintvol2count,
	CONVERT(VARCHAR(10), transdate, 101) AS dateoffile
FROM custom_hsbc_vegas_maint hvm WITH (NOLOCK)
WHERE transdate = '20100218' AND agencycode = (SELECT TOP 1 c.customtext1 FROM master m WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer AND m.customer = @customer)
GROUP BY agencycode, transdate

END
GO
