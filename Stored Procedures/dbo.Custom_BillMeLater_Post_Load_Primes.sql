SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_BillMeLater_Post_Load_Primes]
	-- Add the parameters for the stored procedure here
	@number int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update debtors
set Email = z.email
from debtors d with (Nolock) inner join (
select number, (select thedata from miscextra with (nolock) where number = m.number and title = 'a.0.home email address') as email
from master m with (Nolock)
where m.number = @number) z on d.number = z.number and d.seq = 0

UPDATE master
SET OriginalCreditor = 'WebBank'
WHERE number = @number AND customer IN ('0002468', '0002469')

END
GO
