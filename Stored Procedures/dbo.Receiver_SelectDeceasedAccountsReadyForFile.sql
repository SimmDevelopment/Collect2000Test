SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Receiver_SelectDeceasedAccountsReadyForFile]
@clientid int
as
BEGIN
	DECLARE @lastFileSentDT datetime
	select @lastFileSentDT = dbo.Receiver_GetLastFileDate(11,@clientid)
	--DECLARE TEMP TABLE
	DECLARE  @tempDeceased TABLE(
		[ID] [int] NOT NULL 
	) 
	--INSERT DATA INTO TEMP
	INSERT INTO @tempDeceased (ID)
	SELECT
		ID
	FROM
		deceased d with (nolock) join receiver_debtorreference rd with (nolock) on d.debtorid = rd.receiverdebtorid
		join master m with (nolock) on m.number = d.accountid
		INNER JOIN debtors de WITH (NOLOCK) ON m.number = de.number
		join receiver_reference rr with (nolock) on rr.receivernumber = m.number
	WHERE
		(d.transmitteddate = '1900-01-01 00:00:00' or d.transmitteddate is null)
		 and rr.clientid = @clientid and dod is not null and dod <> '1900-01-01 00:00:00'
		 --added to only pull for primary debtors
		 AND de.seq = 0
		 and m.qlevel < '999' AND (d.ctl != 'AIM' OR d.ctl IS NULL) AND m.customer NOT IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID IN (99, 175))


	DECLARE @AIMClientVersion varchar(10)
	DECLARE @UseNewSchema bit
	
	SELECT @AIMClientVersion = [AIMClientVersion]
	FROM Receiver_Client WHERE ClientID = @clientid
	
	IF(RTRIM(LTRIM(@AIMClientVersion)) = '8.3.*' OR RTRIM(LTRIM(@AIMClientVersion)) = '10.7')
	BEGIN
		SET @UseNewSchema = 1
	END
	ELSE
	BEGIN
		SET @UseNewSchema = 0
	END


	--UPDATE DECEASED TABLE
	UPDATE Deceased
	SET transmitteddate = getdate()
	FROM deceased d join @tempDeceased t
	on t.id = d.id

	--UPDATE MASTER TABLE AS RETURNED
	UPDATE Master
	SET
		status = 'DEC',
		returned = getdate(),
		qlevel = '999',
		closed = isnull(closed,getdate())
	FROM 
		deceased d with (nolock) join receiver_debtorreference rd with (nolock) on d.debtorid = rd.receiverdebtorid
		join debtors db with (nolock) on db.debtorid = rd.receiverdebtorid
		join master m with (nolock) on m.number = d.accountid
		join receiver_reference rr with (nolock) on rr.receivernumber = m.number
		join @tempDeceased t on d.id = t.id AND m.customer NOT IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID IN (99, 175))


	INSERT INTO NOTES (number,user0,action,result,comment,created)
	SELECT d.accountid,'AIM','+++++','+++++','Deceased info was entered.  Account will be returned via AIM Receiver and Status updated to DEC.',getdate()
	FROM deceased d with (nolock) join @tempDeceased t on d.id = t.id

	--SELECT DATA
	IF(@UseNewSchema = 0)
	BEGIN
		SELECT
			'ADEC' as record_type,
			rd.senderdebtorid as debtor_number,
			rr.sendernumber as file_number,
			db.ssn as ssn,
			substring(db.name,charindex(',',db.name,0)+2,len(db.name)-charindex(',',db.name,0)) as first_name,
			substring(db.name,0,charindex(',',db.name,0))  as last_name,
			d.state as state,
			d.postalcode as postal_code,
			d.dob as date_of_birth,
			d.dod date_of_death,
			d.matchcode as match_code,
			d.transmitteddate as transmit_date
		FROM
			deceased d with (nolock) join receiver_debtorreference rd with (nolock) on d.debtorid = rd.receiverdebtorid
			join debtors db with (nolock) on db.debtorid = rd.receiverdebtorid
			join master m with (nolock) on m.number = d.accountid
			join receiver_reference rr with (nolock) on rr.receivernumber = m.number
			join @tempDeceased t  on d.id = t.id AND m.customer NOT IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID IN (99, 175))

	END
	-- Otherwise we are sending more columns
	ELSE
	BEGIN
	
		SELECT
			'ADEC' as record_type,
			rd.senderdebtorid as debtor_number,
			rr.sendernumber as file_number,
			db.ssn as ssn,
			substring(db.name,charindex(',',db.name,0)+2,len(db.name)-charindex(',',db.name,0)) as first_name,
			substring(db.name,0,charindex(',',db.name,0))  as last_name,
			d.state as state,
			d.postalcode as postal_code,
			d.dob as date_of_birth,
			d.dod date_of_death,
			d.matchcode as match_code,
			d.transmitteddate as transmit_date,
			-- New added by KAR on 04/29/2010
			d.[ClaimDeadline] as claim_deadline_date,--<column name="claim_deadline_date" dataType="dateTime" width="8" />
			d.[DateFiled] as filed_date,--<column name="filed_date" dataType="dateTime" width="8" />
			d.[CaseNumber] as case_number,--<column name="case_number" dataType="string" width="20" />
			d.[Executor] as executor,--<column name="executor" dataType="string" width="50" />
			d.[ExecutorPhone] as executor_phone,--<column name="executor_phone" dataType="string" width="50" />
			d.[ExecutorFax] as executor_fax,--<column name="executor_fax" dataType="string" width="50" />
			d.[ExecutorStreet1] as executor_street1,--<column name="executor_street1" dataType="string" width="50" />
			d.[ExecutorStreet2] as executor_street2,--<column name="executor_street2" dataType="string" width="50" />
			d.[ExecutorState] as executor_state,--<column name="executor_state" dataType="string" width="3" />
			d.[ExecutorCity] as executor_city,--<column name="executor_city" dataType="string" width="100" />
			d.[ExecutorZipcode] as executor_zipcode,--<column name="executor_zipcode" dataType="string" width="10" />
			d.[CourtCity] as court_city,--<column name="court_city" dataType="string" width="50" />
			d.[CourtDistrict] as court_district,--<column name="court_district" dataType="string" width="200" />
			d.[CourtDivision] as court_division,--<column name="court_division" dataType="string" width="100" />
			d.[CourtPhone] as court_phone,--<column name="court_phone" dataType="string" width="50" />
			d.[CourtStreet1] as court_street1,--<column name="court_street1" dataType="string" width="50" />
			d.[CourtStreet2] as court_street2,--<column name="court_street2" dataType="string" width="50" />
			d.[CourtState] as court_state,--<column name="court_state" dataType="string" width="3" />
			d.[CourtZipcode] as court_zipcode--<column name="court_zipcode" dataType="string" width="15" />

		FROM
			deceased d with (nolock) join receiver_debtorreference rd with (nolock) on d.debtorid = rd.receiverdebtorid
			join debtors db with (nolock) on db.debtorid = rd.receiverdebtorid
			join master m with (nolock) on m.number = d.accountid
			join receiver_reference rr with (nolock) on rr.receivernumber = m.number
			join @tempDeceased t  on d.id = t.id	AND m.customer NOT IN (SELECT c.customer FROM Customer c WITH (NOLOCK)  WHERE cob = 'PROB - PROBATE')
	
	END
END


GO
