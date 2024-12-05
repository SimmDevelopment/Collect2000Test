SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Receiver_ProcessAttorney]
@clientid int,
@debtor_number int,
@file_number int,
@attorney_name varchar(50),	
@attorney_firm varchar(100),
@attorney_street1 varchar(50),
@attorney_street2 varchar(50),
@attorney_city varchar(50),
@attorney_state varchar(5),
@attorney_zipcode varchar(20),
@attorney_phone varchar(20),
@attorney_fax varchar(20),
@attorney_notes varchar(500)
AS
BEGIN

 	DECLARE @receiverNumber INT
	SELECT @receivernumber = max(receivernumber)
	FROM receiver_reference WITH (NOLOCK) 
	WHERE sendernumber = @file_number and clientid = @clientid
	
	IF(@receivernumber is null)
	BEGIN
		RAISERROR ('15001', 16, 1)
		RETURN
	END
	
	DECLARE @dnumber int
	select @dnumber = max(receiverdebtorid )
	from receiver_debtorreference rd with (nolock)
	join debtors d with (nolock) on rd.receiverdebtorid = d.debtorid
	where senderdebtorid = @debtor_number
	and clientid = @clientid

	IF(@dnumber is null)
	BEGIN
		RAISERROR ('15001', 16, 1) -- TODO Which error to raise here?
		RETURN
	END

	DECLARE @Qlevel varchar(5)

	SELECT @QLevel = [QLevel] FROM [dbo].[Master] WITH (NOLOCK)
	WHERE [number] = @receiverNumber

	IF(@QLevel = '999') 
	BEGIN
		RAISERROR('Account has been returned, QLevel 999.',16,1)
	END


	-- Determine if we can find the debtor attorney
	DECLARE @attorneyID int
	
	SELECT @attorneyID = [ID]
	FROM [dbo].[DebtorAttorneys]
	WHERE [AccountID] = @receiverNumber AND [DebtorID] = @dnumber

	IF(@attorneyID IS NULL) 
	BEGIN

		INSERT INTO [dbo].[DebtorAttorneys]
		([AccountID],
		[DebtorID],
		[Name],
		[Firm],
		[Addr1],
		[Addr2],
		[City],
		[State],
		[Zipcode],
		[Phone],
		[Fax],
		[Email],
		[Comments])
		VALUES
		(@receivernumber,
		@dnumber,
		ISNULL(@attorney_name,''),
		ISNULL(@attorney_firm,''),
		ISNULL(@attorney_street1,''),
		ISNULL(@attorney_street2,''),
		ISNULL(@attorney_state,''),
		ISNULL(@attorney_zipcode,''),
		ISNULL(@attorney_phone,''),
		ISNULL(@attorney_fax,''),
		'',
		ISNULL(@attorney_fax,''),
		ISNULL(@attorney_notes,'')
		)
	END
	ELSE
	BEGIN
		
		-- Update the existing attorney
		UPDATE [dbo].[DebtorAttorneys]
		SET [Name] = ISNULL(@attorney_name,''),
		[Firm] = ISNULL(@attorney_firm,''),
		[Addr1] = ISNULL(@attorney_street1,''),
		[Addr2] = ISNULL(@attorney_street2,''),
		[City] = ISNULL(@attorney_city,''),
		[State] = ISNULL(@attorney_state,''),
		[Zipcode] = ISNULL(@attorney_zipcode,''),
		[Phone] = ISNULL(@attorney_phone,''),
		[Fax] = ISNULL(@attorney_fax,''),
		[Comments] = ISNULL(@attorney_notes,'')
		WHERE [ID] = @attorneyID
	END
END

GO
