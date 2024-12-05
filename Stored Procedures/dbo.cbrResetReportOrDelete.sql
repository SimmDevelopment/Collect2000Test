SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[cbrResetReportOrDelete] @AccountID INTEGER, @Action INTEGER, @Result VARCHAR (155) OUTPUT

--output param for displayable exceptions result to the app...  not audited is the recomendation
--This procedure is called by the Application and will update the master and debtors table columns related to CBR accountstatus and report inclusion 
--  in such a way as to allow the evaluation routine to process and disposition the account as the user wishes
--0 = unprevent undelete .... clear prevent and delete and allow to report
--1 = set for delete due to error...regardless of reported status
--2 = set for delete fraud
--3 = set for delete paid by insurance

--if account has been reported final and returned...this operation not allowed...account must be set to NOT RETURNED by app
--currently to delete a previously reported paid in full account the account must be a medical account
--or delete returns must be configured in the cbr console and the account must be in a returned state
--the initialize option is no longer required to provide the delete returned functionality for paid in fulls

AS
SET   NOCOUNT ON

	create table #result  (result varchar  (155));

	create table #pending  (AccountID int, debtorID int, racctstat varchar (2),	rcompliance varchar(2),
						rinfoind char(2), rspcomment char(2), pacctstat varchar(2), pcompliance char(2),
						pinfoind char(2), pspcomment char(2), specialnote varchar(2), fileid int,
						cbrenabled bit, portfoliotype char(1),	AccountType char(2), seq int,
						recoa char(1), pecoa char(1),	responsible bit, cbrexclude bit, cbrprevent bit,
						isdisputed bit, isdeceased bit,	statusisfraud bit, statuscbrreport bit, statuscbrdelete bit,
						pndexception varchar(5), cbrdod int, cbroverride bit, creditorclass char(2),
						qlevel int, returned datetime, portfolioindicator int, cbrParty varchar(3), OutOfStatute bit,
						MinBalException bit, StatusIsPIF bit, StatusIsSIF bit, RptDtException bit, nextReporting datetime
	);

	if not exists  (select top 1 * from cbrCustomGroup) and @AccountID is not null
		insert into #pending select x.* from dbo.cbrDataPendingDtlex (@accountid) x 
	else 
		insert into #pending select x.* from dbo.cbrDataPendingDtlex (@accountid) x inner join dbo.cbrCustomGroup c on x.AccountID = c.number
	;

		with exceptionExists as  ( select p.seq, p.pndexception, p.racctstat, p.qlevel, p.returned from #pending p where p.seq = 0 ),

				--existing as  (select 'Existing Exception on Account' as result from exceptionExists x 
				--where x.seq = 0 and x.pndexception in  ('Acctx','Dbtrx')),

		paid as  (select 'Can''t UnPrevent a Previously Paid In Full' as result from exceptionExists x 
		where x.seq = 0 and x.racctstat in  ('62','64') and @Action = 0),

		deleted  as  (select 'Can''t Delete a Previously Deleted Account or an Account that has never reported, must unprevent to allow further reporting'
		as result from exceptionExists x 
		where x.seq = 0 and x.racctstat in  ('DA','DF','') and @Action in (1,2,3)),

		returned as (select 'Account has been finalized and returned.  Must set account to not returned.'
		as result from exceptionExists x 
		where x.seq = 0 and x.racctstat in  ('DA','DF','62','64','93','97') and @Action = 0 and x.qlevel = '999' and isdate(x.returned)=1),

		[result] as (	--select result from existing where result is not null union all 
		select [result] from paid where [result] is not null union all 
		select [result] from deleted where [result] is not null union all
		select [result] from returned where [result] is not null)
				
		insert into #result select * from [result];

		set @Result = (select top 1 * from #result);
		
		if @AccountID is not null and @Result is not null begin
			RETURN (-1)
		end;
			
	--   no holds barred....let the user control

	with unPreventUnDelete as  (select p.cbrprevent , case when p.racctstat in  ('') then m.specialnote else '' end as specialnote,
								case when p.racctstat in  ('') then 'Prevent Reset' else 'Prevent and Delete Reset' end as result
								from #pending p inner join master m on p.seq=0 and  m.number=@AccountID
								where @Action = 0),

	deleteReported as  (select p.cbrprevent , 
							case 
							when @Action = 1
								then 'DA' 
							when @Action = 2
								then 'DF'
							when p.creditorclass in  ('02') and p.racctstat in  ('93','97','62','64')
							and @Action = 3
								then 'DI'						
							else m.specialnote end as specialnote,
							'Reset Prevent Set Report Delete'as result
						from #pending p inner join master m on p.seq=0 and  m.number=@AccountID
						where @Action > 0),				

	updateSet as  (select u.cbrprevent,u.specialnote,u.result from unPreventUnDelete u  
					union all  
					select d.cbrprevent,d.specialnote,d.result from deleteReported d)

	update master set cbrprevent = 0, specialnote = u.specialnote 
			output u.result into #result
			from updateSet u where number = @Accountid and u.cbrprevent is not null
	;

	update debtors set cbrexclude = 0
			from #pending p inner join debtors d on p.seq=0 and d.number=@AccountID and d.seq=0
			where d.cbrexclude=1 ;

	update master set cbrprevent = 1, specialnote = '' 
			output 'Prevent Set' into #result
			from #pending p where number = @Accountid and @Action in (1,2,3) and isnull(p.racctstat,'') = ''
	;
	
	
	if @AccountID is not null begin
		set @Result = (select top 1 * from #result)
	end
	else begin
		set @Result = cast((select count(*) from #result) as varchar(15)) + 'Account(s)...updated'
	end;

	
SET  NOCOUNT OFF;
RETURN (0);

GO
