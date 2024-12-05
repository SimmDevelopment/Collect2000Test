SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_JHCapital_Commission_Rate_Recon_DN2] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.id1 as Data_ID, (select top 1 thedata from miscextra with (nolock) where number = m.number and title = 'Acc.0.remit_rate') as [JH Remit_Rate], Fee1 as [Agency Remit_Rate], CASE WHEN (select top 1 thedata from miscextra with (nolock) where number = m.number and title = 'Acc.0.remit_rate') = Fee1 then 'TRUE' else 'FALSE' End as [Match]
	FROM master m with(nolock) INNER JOIN Customer c with (nolock) on m.customer = c.customer INNER JOIN FeeScheduleDetails f WITH (NOLOCK)  ON c.FeeSchedule = f.Code
	WHERE m.customer IN ('0001704','0001706','0001728','0001793','0001794','0001795','0001796','0001805')
	And closed is null and id2 not in ('AllGate','ARS-JMET')
END
GO
