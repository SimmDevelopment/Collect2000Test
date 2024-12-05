SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[fusion_SurePlacement_SelectPhones] 
	-- Add the parameters for the stored procedure here
	-- if both min and max = 1 then only workphones
	-- if both min and max = 2 then only homephones
	-- if min = 1 and max = 2 then top 3 most recent of both
	@DebtorId int,
	@PhoneTypeMin int = 1,
	@PhoneTypeMax int = 1
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @tmp TABLE(
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DebtorId] [int] NOT NULL,
	[phone] [varchar] (15) NULL,
	[date] [datetime] NULL)


	IF(@PhoneTypeMax = 1)
	BEGIN
		INSERT INTO @tmp (DebtorId, phone, date)
		SELECT @DebtorId,d.HomePhone,d.DateUpdated
		FROM Debtors d with (nolock)
		WHERE d.DebtorId=@DebtorId
	END
	
	IF(@PhoneTypeMin = 2)
	BEGIN
		INSERT INTO @tmp (DebtorId, phone, date)
		SELECT @DebtorId,d.WorkPhone,d.DateUpdated
		FROM Debtors d with (nolock)
		WHERE d.DebtorId=@DebtorId
	END
	
	IF(@PhoneTypeMax = 1)
	BEGIN
		INSERT INTO @tmp (DebtorId, phone, date)
		SELECT DebtorId,dbo.StripNonDigits(NewNumber),DateChanged
		FROM PhoneHistory WITH (nolock)
		WHERE DebtorId=@DebtorID
		and PhoneType = 1
		UNION
		SELECT DebtorId,dbo.StripNonDigits(OldNumber),DateChanged
		FROM PhoneHistory WITH (nolock)
		WHERE DebtorId=@DebtorID
		and PhoneType = 1
		ORDER BY DateChanged DESC
	END
	
	IF(@PhoneTypeMin = 2)
	BEGIN
		INSERT INTO @tmp (DebtorId, phone, date)
		SELECT DebtorId,dbo.StripNonDigits(NewNumber),DateChanged
		FROM PhoneHistory WITH (nolock)
		WHERE DebtorId=@DebtorID
		and PhoneType = 2
		UNION
		SELECT DebtorId,dbo.StripNonDigits(OldNumber),DateChanged
		FROM PhoneHistory WITH (nolock)
		WHERE DebtorId=@DebtorID
		and PhoneType = 2
		ORDER BY DateChanged DESC
	END
	SELECT DISTINCT TOP 3
		max(ID) as ID,
		DebtorId,
		max(ID) AS PhoneType,
		dbo.StripNonDigits(phone) AS NewNumber,
		max(date) AS DateChanged
	FROM @tmp
	WHERE phone IS NOT NULL
	AND LEN(dbo.StripNonDigits(phone))>=7
	AND phone NOT IN 
	(
		select * from InvalidPhone with (nolock) 
	)
	GROUP BY dbo.StripNonDigits(phone),DebtorID
	ORDER BY dbo.StripNonDigits(phone),DebtorID
END
GO
