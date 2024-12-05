SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Denise Atkinson	
-- Create date: 5/23/2022
-- Description:	This procedure finds all records for US Bank that were in DSP status at any point since a date the user provides. 
--				It features a field that is populated if the account left DSP status during the period in question. 
-- Usage:		EXEC dbo.Custom_USBank_DSP_Accounts '2012-05-16'
-- 
-- Changes:
-- 
-- 
-- 
-- =============================================

CREATE PROCEDURE [dbo].[Custom_USBank_DSP_Accounts]
	@fromDate DATE

AS
	SELECT cast (datechanged as date) as datechanged, account, current_status, max(left_dsp) as left_dsp
	FROM 
		(
			select sh.*, m.status as current_status, m.account, m.customer as mastercustomer, c.customer, c.name,  cast(datechanged as DATE) as changedate, case when sh.OldStatus='DSP' then sh.DateChanged else null end as left_dsp
			from StatusHistory sh 
			left join master m on sh.accountid=m.number
			left join customer c on c.customer=m.customer
			where datechanged>=@fromDate
			and (oldstatus='DSP' or newstatus='DSP' or m.status='DSP' /* in case some other app besides Exchange makes the change and it isn't recorded in StatusHistory- DM 5/23/22 */)
			and c.name like 'US%BANK%'
		) a
	GROUP BY cast (datechanged as date), account, current_status
	ORDER BY datechanged, account
GO
