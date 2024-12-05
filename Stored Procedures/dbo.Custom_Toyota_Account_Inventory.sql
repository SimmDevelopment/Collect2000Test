SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: Unknown
-- Description:	Sends all open inventory to Toyota
-- Changes:
-- 3/31/2010: BGM(Simm) Changed to pull Sif/Pif accounts that are not returned as ARX or ARY code.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Toyota_Account_Inventory]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select c.customtext1 as [Recoverer Code], m.account as [Account Number], d.firstname as [First Name], d.lastname as [Last Name],
		 m.received as [Placement Date], (m.current1 + m.current2) as [Account Balance], case when m.id1 = 'A3R' then 'A3P' when m.id1 = 'A3P' then 'A3P' when m.id1 = 'A3H' then 'A3H' when m.status = 'PIF' THEN 'ARY' when m.status = 'SIF' THEN 'ARX' else 'A30' end as [Account Status]
from master m with (Nolock) inner join customer c with (nolock) on m.customer = c.customer inner join debtors d with (Nolock) on m.number = d.number and d.seq = 0
where m.customer in (select customerid from fact with (nolock) where customgroupid = 30) and (qlevel <= '997' or (qlevel = '998' and m.status in ('sif', 'pif')))


END
GO
