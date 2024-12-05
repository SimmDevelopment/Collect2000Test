SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Probate_Panel] 
	-- Add the parameters for the stored procedure here
	@number int,
  @userid   int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
select ID, Case when [cmty prop] = 'CP' then 'YES' else 'NO' end as [CMTY PROP], 
	ISNULL(cp.court, 'NOT ENTERED') AS court, cp.Street1, cp.Street2, cp.City, cp.state, cp.zipcode,
	cp.county, cp.address, cp.TELEPHONE, upper(cp.action) as [Action], cp.Email, 
	cp.website, cp.notes, cp.[claim fee], cp.[search fee], cp.[covered areas]
	from debtors d with (nolock) inner join custom_probate_court_info cp with (Nolock) on d.county = cp.county and d.state = cp.state
	where d.number = @number and d.seq = 0
	
	SELECT RoleID
	FROM users WITH (NOLOCK)
	WHERE id = @userid

END


GO
