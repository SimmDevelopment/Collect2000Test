SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   procedure [dbo].[AIM_Demographic_UpdateLatitudePhone]
(
    @debtor_number   int
    ,@file_number int
	,@phone_type tinyint
	,@new_number varchar(50)
	,@old_number varchar(50)	
	,@date_updated datetime
	,@agencyId int
	,@Record_Type varchar(4) = NULL
)
as
begin

--DECLARE VARIABLES
	declare @seq int
	declare @phoneTypeStr varchar(10)
	declare @masterNumber int,@currentAgencyId int
	select 	@seq = dv.seq
		,@masterNumber = dv.number 
		,@currentagencyid = currentlyplacedagencyid
	from 	debtors dv with (nolock)
		left outer join aim_accountreference r on dv.number = r.referencenumber
	where 	dv.debtorid = @debtor_number
	declare @agencyname varchar(100)
	select @agencyname = name from aim_agency where agencyid = @agencyid

--VALIDATE DATA
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






insert into phonehistory 
	(
		accountid
		,debtorid
		,datechanged
		,userchanged
		,phonetype
		,oldnumber
		,newnumber
		,transmitteddate
	)
	values
	(
		@masterNumber
		,@debtor_number
		,@date_updated
		,'AIM'
		,@phone_type
		,isnull(@old_number,'')
		,isnull(@new_number,'')
		,getdate()
	)

INSERT INTO Notes (number,created,user0,action,result,comment,isprivate)
VALUES (@file_number,getdate(),'AIM','+++++','+++++','Phone information has been updated from agency ' + @agencyname,0)

IF(@new_number IS NOT NULL AND @new_number <> '')
BEGIN
	--UPDATE DEBTORS RECORD
	if(@phone_type = 1)
	begin
		set @phoneTypeStr = 'Home Phone'
		update 
			debtors
		set
			homephone = @new_number
			,dateupdated = getdate()
		where
			debtorid = @debtor_number
	end
	else
	begin
		set @phoneTypeStr = 'Work Phone'
		update 
			debtors
		set
			workphone = @new_number
			,dateupdated = getdate()
		where
			debtorid = @debtor_number
	end

--UPDATE MASTER IF NEEDED
	if(@seq = 0) -- then update master
	begin
		if(@phone_type = 1)
		begin
			update 
				master
			set
				homephone = @new_number
			where
				number = @masterNumber
				
		end
		else
		begin
			update 
				master
			set
				workphone = @new_number
			where
				number = @masterNumber
				
		end
	end


	INSERT INTO Notes (number,created,user0,action,result,comment,isprivate)
	VALUES (@file_number,getdate(),'AIM','+++++','+++++',@phoneTypeStr + ' ' + @new_number + ' added',0)
END
--check for existing phones_master record
DECLARE @oldMasterPhoneID INT
SELECT @oldMasterPhoneID = MasterPhoneID
FROM Phones_Master WITH (NOLOCK)
WHERE Number = @masterNumber
AND DebtorID = @debtor_number 
AND PhoneTypeID = @phone_type
AND PhoneNumber = @old_number;

IF(@oldMasterPhoneID IS NOT NULL)
BEGIN
--get old phone status
DECLARE @PhoneStatus VARCHAR(50)
SELECT @PhoneStatus = ISNULL(ps.PhoneStatusDescription,'Unknown')
FROM Phones_Statuses ps FULL OUTER JOIN Phones_Master pm WITH (NOLOCK)
ON ps.PhoneStatusID = pm.PhoneStatusID
WHERE pm.MasterPhoneID = @oldMasterPhoneID

--LAT-10597 After adding two new columns of UpdateWhen and UpdatedBy in Phones_Master Table.

--update to bad
UPDATE Phones_Master
SET PhoneStatusID = 1,LastUpdated =GETDATE(),UpdatedBy='AIM'
WHERE Number = @masterNumber
AND DebtorID = @debtor_number 
AND PhoneTypeID = @phone_type
AND PhoneNumber = @old_number

--tell about it
INSERT INTO Notes (number,created,user0,action,result,comment,isprivate)
VALUES(@file_number,getdate(),'AIM','+++++','+++++',@phoneTypeStr + ' ' + @old_number + ' status changed from ' + @phonestatus + ' to Bad',0)

END

	
END
GO
