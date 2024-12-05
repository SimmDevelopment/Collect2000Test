SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   procedure [dbo].[AIM_Demographic_UpdateLatitudeAddress]
(
    @debtor_number   int
    ,@file_number int
	,@new_street1 varchar(30)
	,@new_street2 varchar(30)
	,@new_city varchar(30)
	,@new_state   varchar(3)
	,@new_zipcode   varchar(10)
    ,@old_street1 varchar(30)
	,@old_street2 varchar(30)
	,@old_city varchar(30)
	,@old_state   varchar(3)
	,@old_zipcode   varchar(10)
	,@date_updated datetime
	,@agencyId int
	,@Record_Type varchar(4) = NULL
)
as
begin

	
	declare @seq int,@currentstreet1 varchar(30),@currentstreet2 varchar(30),@currentcity varchar(30),@currentstate varchar(3),@currentzipcode varchar(10)
	declare @masterNumber int,@currentAgencyId int
	select 	@seq = dv.seq
		,@masterNumber = dv.number 
		,@currentagencyid = currentlyplacedagencyid
		,@currentstreet1 = dv.street1
		,@currentstreet2 = dv.street2
		,@currentcity = dv.city
		,@currentstate = dv.state
		,@currentzipcode = dv.zipcode
	from 	debtors dv with (nolock)
		left outer join aim_accountreference r on dv.number = r.referencenumber
	where 	dv.debtorid = @debtor_number
	declare @agencyname varchar(100)
	select @agencyname = name from aim_agency where agencyid = @agencyid
	if(@masterNumber is null)
	begin
		RAISERROR ('15001', 16, 1)
		return
	end
	if(@masterNumber <> @file_number)
	begin
		RAISERROR ('15008',16,1)
		return
	end
	if(@currentAgencyId is null or (@currentAgencyId <> @agencyId))
	begin
		raiserror ('15004', 16, 1)
		return
	end
--UPDATE DEBTOR RECORD
	update 
		debtors
	set
		street1 = @new_street1
		,street2 = @new_street2
		,city = @new_city
		,state = @new_state
		,zipcode = @new_zipcode
		,dateupdated = getdate()
	where
		debtorid = @debtor_number

--UPDATE MASTER RECORD IF NEEDED
	if(@seq = 0)
	begin
		update 
			master
		set
			street1 = @new_street1
			,street2 = @new_street2
			,city = @new_city
			,state = @new_state
			,zipcode = @new_zipcode
		where
			number = @masterNumber
	end
	
--ADD NOTES
INSERT INTO Notes (number,created,user0,action,result,comment,isprivate)
VALUES (@file_number,getdate(),'AIM','ADDR','CHNG','Address information has been updated from agency ' + @agencyname,0)
INSERT INTO Notes (number,created,user0,action,result,comment,isprivate)
VALUES (@file_number,getdate(),'AIM','ADDR','CHNG','Debtor(' + cast((@seq+1) as varchar) + ') was: ' + isnull(@currentstreet1,'') +' ' +isnull(@currentstreet2,''),0)
INSERT INTO Notes (number,created,user0,action,result,comment,isprivate)
VALUES (@file_number,getdate(),'AIM','ADDR','CHNG','                      ' + isnull(@currentcity,'') + ', ' +isnull(@currentstate,'')+' ' +isnull(@currentzipcode,''),0)

--INSERT ADDRESS HISTORY
if(@currentstreet1 <> isnull(@old_street1,'') or @currentstreet2 <> isnull(@old_street2,'') or
@currentcity <> isnull(@old_city,'') or @currentstate <> isnull(@old_state,'') or @currentzipcode <> isnull(@old_zipcode,''))
BEGIN
	insert into addresshistory
	(
		accountid
		,debtorid
		,datechanged
		,userchanged
		,oldstreet1
		,oldstreet2
		,oldcity
		,oldstate
		,oldzipcode
		,newstreet1
		,newstreet2
		,newcity
		,newstate
		,newzipcode
		,transmitteddate
	)
	 values
	(
		@masterNumber
		,@debtor_number
		,@date_updated
		,'AIM'
		,isnull(@currentstreet1,'')
		,isnull(@currentstreet2,'')
		,isnull(@currentcity,'')
		,isnull(@currentstate,'')
		,isnull(@currentzipcode,'')
		,isnull(@old_street1,'')
		,isnull(@old_street2,'')
		,isnull(@old_city,'')
		,isnull(@old_state,'')
		,isnull(@old_zipcode,'')
		,getdate()
	)	


END
insert into addresshistory
	(
		accountid
		,debtorid
		,datechanged
		,userchanged
		,oldstreet1
		,oldstreet2
		,oldcity
		,oldstate
		,oldzipcode
		,newstreet1
		,newstreet2
		,newcity
		,newstate
		,newzipcode
		,transmitteddate
	)
	 values
	(
		@masterNumber
		,@debtor_number
		,@date_updated
		,'AIM'
		,isnull(@old_street1,'')
		,isnull(@old_street2,'')
		,isnull(@old_city,'')
		,isnull(@old_state,'')
		,isnull(@old_zipcode,'')
		,isnull(@new_street1,'')
		,isnull(@new_street2,'')
		,isnull(@new_city,'')
		,isnull(@new_state,'')
		,isnull(@new_zipcode,'')
		,getdate()
	)	


end

GO
