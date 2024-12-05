SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  Procedure [dbo].[Receiver_UpdateDebtorDemographicAddress]

@filenumber int,
@debtornumber int,
@newstreet1 varchar(30),
@newstreet2 varchar(30),
@newcity varchar(20),
@newstate varchar(3),
@newzip varchar(10),
@oldstreet1 varchar(30),
@oldstreet2 varchar(30),
@oldcity varchar(20),
@oldstate varchar(3),
@oldzip varchar(10),
@datechanged datetime,
@clientid int

as

DECLARE @number int
select @number = max(receivernumber)
from receiver_reference rr with (nolock) 
join master m with (nolock) on rr.receivernumber = m.number
where sendernumber= @filenumber and clientid = @clientid

IF(@number is null)
BEGIN
	RAISERROR ('15001', 16, 1)
	RETURN
END

DECLARE @dnumber int
select @dnumber = max(receiverdebtorid )
from receiver_debtorreference rd with (nolock)
join debtors d with (nolock) on rd.receiverdebtorid = d.debtorid
join master m with (nolock) on d.number = m.number
where senderdebtorid = @debtornumber
and clientid = @clientid

IF(@dnumber is null)
BEGIN
	RAISERROR ('15001', 16, 1) -- TODO Which error to raise here?
	RETURN
END


DECLARE @Qlevel varchar(5)

SELECT @QLevel = [QLevel] FROM [dbo].[Master] WITH (NOLOCK)
WHERE [number] = @number

IF(@QLevel = '999') 
BEGIN
	RAISERROR('Account has been returned, QLevel 999.',16,1)
	RETURN
END


--UPDATE DEBTOR TABLE
UPDATE DEBTORS
SET
	street1 = @newstreet1,
	street2 = @newstreet2,
	city = @newcity,
	state = @newstate,
	zipcode = @newzip
WHERE
	debtorid = @dnumber

--CHECK TO SEE IF THIS DEBTOR IS PRIMARY DEBTOR , IF SO UPDATE MASTER
DECLARE @seq int
SELECT @seq = seq FROM DEBTORS WHERE debtorid = @dnumber

if(@seq = 0)
begin
	UPDATE MASTER
SET
	street1 = @newstreet1,
	street2 = @newstreet2,
	city = @newcity,
	state = @newstate,
	zipcode = @newzip
WHERE
	number = @number

end

--INSERT ADDRESS HISTORY RECORD
INSERT INTO AddressHistory
(
	AccountID,
	DebtorID,
	DateChanged,
	UserChanged,
	OldStreet1,
	OldStreet2,
	OldCity,
	OldState,
	OldZipcode,
	NewStreet1,
	NewStreet2,
	NewCity,
	NewState,
	NewZipcode,
	TransmittedDate
)
	VALUES
(
	@number,
	@dnumber,
	@datechanged,
	'AIM',
	@oldstreet1,
	@oldstreet2,
	@oldcity,
	@oldstate,
	@oldzip,
	@newstreet1,
	@newstreet2,
	@newcity,
	@newstate,
	@newzip,
	null
)

INSERT INTO NOTES(number,ctl,created,user0,action,result,comment,seq) VALUES (@number,null,getdate(),'AIM','+++++','+++++','Address has been changed per client demographic data',null)

-- Added by KAR on 05/06/2010
INSERT INTO NOTES([number],[created],[user0],[action],[result],[Comment])
SELECT	@Number,	
	GETDATE(),
	'AIM',
	'ADDR',
	'CHNG',
	'Debtor(' + Cast(@seq+1 as varchar(2)) +') was: ' + ISNULL(@OldStreet1,'') +'   ' + ISNULL(@OldStreet2,'')

INSERT INTO NOTES([number],[created],[user0],[action],[result],[Comment])
SELECT	@Number,	
	GETDATE(),
	'AIM',
	'ADDR',
	'CHNG',
	'                   ' + ISNULL(@OldCity,'') +',' + ISNULL(@OldState,'') + ',' + ISNULL(@oldzip,'')


GO
