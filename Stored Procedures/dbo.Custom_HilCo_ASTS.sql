SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_HilCo_ASTS]
	-- Add the parameters for the stored procedure here
@customer varchar(10)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

select 'ASTS' as Record_Type, senderdebtorid as debtor_number, sendernumber as file_number, m.status as [Status], '' as Note, '' as note_date, '' as [notification]
from master m with (Nolock) inner join debtors d with (nolock) on m.number = d.number and d.seq = 0 inner join receiver_debtorreference rd with (Nolock) on d.debtorid = rd.receiverdebtorid inner join receiver_reference rr with (Nolock) on m.number = rr.receivernumber
where m.status = 'dsp' and m.customer = @customer

END
GO
