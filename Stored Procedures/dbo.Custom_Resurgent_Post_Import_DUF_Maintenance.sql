SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 11/11/2021
-- Description:	Updates Extradata fields instead of having them be overwritten
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Resurgent_Post_Import_DUF_Maintenance]
	-- Add the parameters for the stored procedure here
	@number int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--Insert statements for procedure here
update extradata
set line5 = ISNULL((select thedata from miscextra with (nolock) where number = e.number and title = 'BIU.ChargeOff.ItemizeDate'), line5)
from extradata e with (nolock)
where e.number = @number AND e.extracode = 'L1'

update extradata
set line5 = ISNULL((select thedata from miscextra with (nolock) where number = e.number and title = 'BIU.ChargeOff.ItemizeInterest'), line5)
from extradata e with (nolock)
where e.number = @number AND e.extracode = 'L2'

update extradata
set line4 = ISNULL((select thedata from miscextra with (nolock) where number = e.number and title = 'BIU.ChargeOff.ItemizeFees'), line4),
line5 = ISNULL((select thedata from miscextra with (nolock) where number = e.number and title = 'BIU.ChargeOff.ItemizePayments'), line5)
from extradata e with (nolock)
where e.number = @number AND e.extracode = 'L3'



END
GO
