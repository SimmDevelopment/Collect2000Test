SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE               procedure [dbo].[Custom_SelectAccounts]
@startdate  datetime,
@stopdate datetime,
@customers text
AS

declare @accounts table(number int,dateChanged datetime)

insert  into @accounts
select 	accountid,datechanged
from 	addresshistory
join	master with (nolock) on accountid = number
where	datechanged between @startdate and @stopdate

insert  into @accounts
select 	accountid,datechanged
from 	phonehistory
join	master with (nolock) on accountid = number
where	datechanged between @startdate and @stopdate


insert 	into @accounts
select	p.number,entered
from 	payhistory p
join 	master m with (nolock) on m.number = p.number
where	datetimeentered between @startdate and @stopdate
		and (p.ctl <> 'API' or p.ctl is null)

insert 	into @accounts
select	n.number,created
from 	notes n with (nolock)
join 	master m with (nolock) on m.number = n.number
where	created between @startdate and @stopdate
		and (n.ctl not in ('EXG','DMI', 'API') or n.ctl is null)
insert 	into @accounts
select	c.number,activitydate
from 	cbrhistory c
join 	master m with (nolock) on m.number = c.number
where	activitydate between @startdate and @stopdate

declare @distinctaccounts table(number int,dateChanged datetime)
insert 	into @distinctaccounts
select	number,max(dateChanged) from @accounts group by number--,dateChanged

select	m.number,customer,account,name,street1,street2,city,state,zipcode,status,
	CreatedByAPI = case when ctl in ('EXG','API') then 'true' else 'false' end,
	desk,received,other,homephone,workphone,ssn,dob,current1,current2,current3,
	current4,current5,current6,current7,current8,current9,current10,contractdate,
	clidlc,clidlp,chargeoffdate,lastpaid,bpdate,feeschedule,delinquencydate,lastpaidamt,
	interestrate,lastinterest,userdate1,userdate2,userdate3,id1,id2,score,status,
	originalcreditor,qlevel,custdivision,custbranch,custdistrict,feecode,d.dateChanged
from	master m with (nolock)
join	@distinctaccounts d on d.number = m.number
order by m.number

select	m.number,seq,debtorid,name,street1,street2,city,state,zipcode,
	ssn,homephone,workphone,jobname,jobaddr1,jobaddr2,jobcsz,spouse,
	spousehomephone,spouseworkphone,spousejobname,spousejobaddr1,
	spousejobaddr2,spousejobcsz,language,dlnum,dob,relationship,d.dateChanged
from	debtors m with (nolock)
join	@distinctaccounts d on d.number = m.number

-- select 	AccountID as number, DebtorID, DateChanged, UserChanged, OldStreet1, OldStreet2, 
-- 	OldCity, OldState, OldZipcode, NewStreet1, NewStreet2, NewCity, NewState, 
-- 	NewZipcode, TransmittedDate
-- from 	addresshistory m
-- join	@distinctaccounts d on d.number = m.accountid
-- 
-- select 	AccountID as number, DebtorID, DateChanged, UserChanged, Phonetype, OldNumber, 
-- 	NewNumber, TransmittedDate
-- from 	phonehistory m
-- join	@distinctaccounts d on d.number = m.accountid

select	m.Number, Title, TheData, ID,d.dateChanged
from 	miscextra m with (nolock)
join	@distinctaccounts d on d.number = m.number

select	m.number, ctl, extracode, line1, line2, line3, line4, line5
from 	extradata m with (nolock)
join	@distinctaccounts d on d.number = m.number

select	m.number,
	totalpaid as [amount],
	entered as [paymentdate],
	batchtype as [paymenttype],
	0 as [adjustmentbucket],
	paidentifier as [paymentid],
	comment as [comments],
	ctl as [ctl],
	 Seq, batchtype, matched, customer, sortdata, paytype, paymethod, 
	systemmonth, systemyear, entered, desk, checknbr, invoiced, InvoiceSort, 
	InvoiceType, InvoicePayType, comment, datepaid, totalpaid, paid1, paid2, 
	paid3, paid4, paid5, paid6, paid7, paid8, paid9, paid10, fee1, fee2, fee3, 
	fee4, fee5, fee6, fee7, fee8, fee9, fee10, balance, balance1, balance3, 
	balance4, balance5, balance6, balance7, balance8, balance9, balance10, 
	balance2, BatchNumber, UID, Invoice, InvoiceFlags, OverPaidAmt, ForwardeeFee, 
	ReverseOfUID, AccruedSurcharge, TransCost, Tax, AttorneyID, CollectorFee, 
	PAIdentifier, AIMAgencyId, AIMDueAgency, AIMAgencyFee,d.dateChanged
from 	payhistory m
join	@distinctaccounts d on d.number = m.number
where m.ctl <> 'API' or m.ctl is null
and datetimeentered between @startdate and @stopdate


select	m.number, ctl, created, user0, action, result, comment, Seq, IsPrivate,d.dateChanged
from 	notes m with (nolock)
join	@distinctaccounts d on d.number = m.number
where (m.ctl not in ('EXG','DMI', 'API') or m.ctl is null)
and created between @startdate and @stopdate


select	m.number, hotnote,d.dateChanged
from 	hotnotes m with (nolock)
join	@distinctaccounts d on d.number = m.number

select	m.Number, Seq, NoteDate, NoteText,d.dateChanged
from 	customernotes m with (nolock)
join	@distinctaccounts d on d.number = m.number

select	m.BankruptcyID, AccountID, DebtorID, Chapter, DateFiled, CaseNumber, 
	CourtCity, CourtDistrict, CourtDivision, CourtPhone, CourtStreet1, 
	CourtStreet2, CourtState, CourtZipcode, Trustee, TrusteeStreet1, 
	TrusteeStreet2, TrusteeCity, TrusteeState, TrusteeZipcode, TrusteePhone, 
	Has341Info, DateTime341, Location341, Comments, Status, TransmittedDate,d.dateChanged
from 	bankruptcy m with (nolock)
join	@distinctaccounts d on d.number = m.AccountID

select	m.AccountID, PaymentHistory, CurrentMinDue, CurrentDue, Current30, 
	Current60, Current90, Current120, Current150, Current180, StatementMinDue, 
	StatementDue, Statement30, Statement60, Statement90, Statement120, 
	Statement150, Statement180, PromoIndicator, PromoExpDate, SubStatuses, 
	InterestRate, FixedInterestFlag, FixedMinPayment, MultipleAccounts, 
	AROwner, PlanCode, ProviderType, LateFeeFlag, LateFeeAccessed, ForceCBFlag, 
	MailToCoApp, FirstPaymentDefault, CycleCode, CyclePreviousBegin, 
	CyclePreviousDue, CyclePreviousLate, CyclePreviousEnd, CycleCurrentBegin, 
	CycleCurrentDue, CycleCurrentLate, CycleCurrentEnd, CycleNextBegin, 
	CycleNextDue, CycleNextLate, CycleNextEnd, EFT, MultipleProviders,d.dateChanged
from 	earlystagedata m with (nolock)
join	@distinctaccounts d on d.number = m.AccountID

select	m.number,activitydate,activitytype,balance,d.dateChanged
from 	cbrhistory m
join	@distinctaccounts d on d.number = m.number
where activitydate  between @startdate and @stopdate












GO
