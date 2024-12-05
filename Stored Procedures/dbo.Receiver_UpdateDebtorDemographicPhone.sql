SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  Procedure [dbo].[Receiver_UpdateDebtorDemographicPhone]
@filenumber int,
@debtornumber int,
@phonetype int,
@newnumber varchar(30),
@oldnumber varchar(30),
@datechanged datetime,
@clientid int
as
BEGIN
	DECLARE @number int
	select @number = max(receivernumber)
	from receiver_reference rr with (nolock) 
	join master m with (nolock) on rr.receivernumber = m.number
	where sendernumber= @filenumber and clientid = @clientid
	and qlevel < '999'

	DECLARE @dnumber int
	select @dnumber = max(receiverdebtorid )
	from receiver_debtorreference rd with (nolock)
	join debtors d with (nolock) on rd.receiverdebtorid = d.debtorid
	join master m with (nolock) on d.number = m.number
	where senderdebtorid = @debtornumber
	and clientid = @clientid and qlevel < '999'

	declare @phoneTypeStr varchar(10)
	SELECT @phoneTypeStr = CASE WHEN @phonetype = 1 THEN 'Home Phone' ELSE 'Work Phone' END

	-- Added by KAR on 02/27/2010 - Need to determine if Phones Master....use the software version from controlfile.
	-- Modified to remove evaluation of software version, assuming phones master always exist
	DECLARE @phoneMasterExists bit
	SET @phoneMasterExists = 1
	
	DECLARE @seq int
	SELECT @seq = seq FROM DEBTORS WHERE debtorid = @dnumber

	--select @number as masternumber,@dnumber as debtorid,@seq as seq,@softwareversion as softwareversion,
	--@phoneMasterExists as phonemasterexists
	--return 0


	--HOME PHONE
	if(@phonetype = 1)
	begin
	--UPDATE DEBTORS TABLE
		UPDATE DEBTORS
		SET
			homephone = @newnumber
		WHERE
			debtorid = @dnumber
			and homephone = @oldnumber	
		
		if(@seq = 0)
		begin
		--UPDATE MASTER TABLE
			UPDATE MASTER
			SET
				homephone = @newnumber
			WHERE
				number = @number
				and homephone = @oldnumber
		end
	end
	--WORK PHONE
	else if(@phonetype = 2)
	begin
	--UPDATE DEBTORS TABLE
		UPDATE DEBTORS
		SET
			workphone = @newnumber
		WHERE
			debtorid = @dnumber	
			and workphone = @oldnumber	
		--UPDATE MASTER TABLE
		if(@seq = 0)
		begin
		--UPDATE MASTER TABLE
			UPDATE MASTER
			SET
				workphone = @newnumber
			WHERE
				number = @number
				and workphone = @oldnumber
		end
	end


	--INSERT PHONE HISTORY RECORD

	INSERT INTO PhoneHistory
	(
		AccountID,
		DebtorID,
		DateChanged,
		UserChanged,
		Phonetype,
		OldNumber,
		NewNumber,	
		TransmittedDate
	)
	VALUES
	(
		@number,
		@dnumber,
		@datechanged,
		'AIM',
		@phonetype,
		@oldnumber,
		@newnumber,
		null
	)

	INSERT INTO Notes (number,created,user0,action,result,comment,isprivate)
	VALUES (@number,getdate(),'AIM','+++++','+++++','Phone information has been updated from client',0)

	-- Only do this if Phones Master exists
	IF(@phoneMasterExists = 1) 
	BEGIN
		--check for existing phones_master record
		DECLARE @oldMasterPhoneID INT
		SELECT @oldMasterPhoneID = MasterPhoneID
		FROM Phones_Master WITH (NOLOCK)
		WHERE Number = @number
		AND DebtorID = @dnumber 
		AND PhoneTypeID = @phonetype
		AND PhoneNumber = @oldnumber;

		IF(@oldMasterPhoneID IS NOT NULL)
		BEGIN
			--get old phone status
			DECLARE @PhoneStatus VARCHAR(50)
			SELECT @PhoneStatus = ISNULL(ps.PhoneStatusDescription,'Unknown')
			FROM Phones_Statuses ps FULL OUTER JOIN Phones_Master pm WITH (NOLOCK)
			ON ps.PhoneStatusID = pm.PhoneStatusID
			WHERE pm.MasterPhoneID = @oldMasterPhoneID

			--LAT-10597 Adding two new columns of UpdateWhen and UpdatedBy in Phones_Master Table
			--update to bad
			UPDATE Phones_Master
			SET PhoneStatusID = 1,[LastUpdated] = GETDATE(), [UpdatedBy] = 'AIM'
			WHERE Number = @number
			AND DebtorID = @dnumber 
			AND PhoneTypeID = @phonetype
			AND PhoneNumber = @oldnumber

			--tell about it
			INSERT INTO Notes (number,created,user0,action,result,comment,isprivate)
			VALUES(@number,getdate(),'AIM','+++++','+++++',@phoneTypeStr + ' ' + @oldnumber + ' status changed from ' + @phonestatus + ' to Bad',0)
		END
	END
END
GO
