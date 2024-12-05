SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [dbo].[Braxtel_ContactQ_CallRestrictions](@phonenumber VARCHAR(30)) 

RETURNS @Restrictions TABLE (phonenumber varchar(30), SSN VARCHAR(15), PhoneType INT, MaxCalls INT, CurentCalls INT)
AS
BEGIN
	DECLARE @currentCalls INTEGER;
	DECLARE @maxCalls INTEGER;
	DECLARE @state VARCHAR(3);
	DECLARE @phonetype INTEGER;
	DECLARE @ssn VARCHAR(15);
	
	
	--0 based 0 = Home 1 = Work 2 = Cell 3 = Other(ie. reference or unknown)
	SET @phonetype = (SELECT TOP 1 CASE WHEN pt.PhoneTypeMapping > 2 THEN 3 ELSE pt.phonetypemapping END FROM dbo.Phones_Master pm WITH (NOLOCK) INNER JOIN dbo.Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
							WHERE pm.PhoneNumber = @phonenumber AND (phonestatusid = 2 OR PhoneStatusID IS NULL))
	
	SET @state = (SELECT TOP 1 CASE WHEN m.state = 'ny' AND m.Zipcode IN (SELECT z.ZipCode FROM dbo.Custom_NYC_Zipcodes z WITH (NOLOCK)) THEN 'NYC' 
					WHEN m.STATE = 'MA' AND m.customer <> '0001219' THEN 'MA' WHEN m.customer IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID = 24) THEN 'RHD' else 'NA' end 
					FROM dbo.Phones_Master pm WITH (NOLOCK) INNER JOIN  debtors d WITH (NOLOCK) ON pm.DebtorID = d.DebtorID
					INNER JOIN master m WITH (NOLOCK) ON d.number = m.number AND m.closed IS NULL
					WHERE pm.PhoneNumber = @phonenumber)
	SET @ssn = (SELECT TOP 1 d.ssn FROM debtors d WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON d.number = m.number WHERE debtorid IN (SELECT DebtorID FROM dbo.Phones_Master WITH (NOLOCK) WHERE phonenumber = @phonenumber) AND m.closed IS null)
			
		if @state = 'MA' 
			
			BEGIN
			
				SET @maxCalls = 2
				
				SET @currentCalls = ISNULL((select COUNT(*)
					from notes n with (Nolock) inner join master m with (Nolock) on n.number = m.number
					INNER JOIN phones_master pm WITH (NOLOCK) ON m.number = pm.number
					where m.state = 'ma' and closed is null and (n.action in (select code from dbo.action with (nolock) where WasAttempt = 1) 
					OR n.action = ('dial')) and datediff(day, dbo.date(created), dbo.date(getdate())) <= 7 and n.action <> 'DT'
					AND pm.PhoneNumber = @phonenumber
					group by pm.PhoneNumber), 0)
			END
			
		ELSE if @state = 'MA' AND @phonetype = 1
			
			BEGIN
			
				SET @maxCalls = 2
				
				SET @currentCalls = ISNULL((select COUNT(*)
					from notes n with (Nolock) inner join master m with (Nolock) on n.number = m.number
					INNER JOIN phones_master pm WITH (NOLOCK) ON m.number = pm.number
					where m.state = 'ma' and closed is null and ((n.action in (select code from dbo.action with (nolock) where WasAttempt = 1) 
					OR n.action = ('dial')) or n.result = 'ttd') and datediff(day, dbo.date(created), dbo.date(getdate())) <= 30 and action in ('te')
					AND pm.PhoneNumber = @phonenumber
					group by pm.PhoneNumber), 0)
			END	
		
		ELSE IF @state = 'NYC'
			
			BEGIN
			
				SET @maxCalls = 2
				
				SET @currentCalls = ISNULL((select COUNT(*)
					from notes n with (Nolock) inner join master m with (Nolock) on n.number = m.number
					INNER JOIN phones_master pm WITH (NOLOCK) ON m.number = pm.number
					where m.state = 'NY' AND m.Zipcode IN (SELECT ZipCode FROM dbo.Custom_NYC_Zipcodes WITH (NOLOCK)) 
					and closed is null and (n.action in (select code from dbo.action with (nolock) where WasAttempt = 1) 
					OR n.action = ('dial')) and datediff(day, dbo.date(created), dbo.date(getdate())) <= 7 and n.action <> 'DT'
					AND pm.PhoneNumber = @phonenumber
					group by pm.PhoneNumber), 0)
			
			END
			
		ELSE IF @state = 'RHD'
			
			BEGIN
			
				SET @maxCalls = 1
				
				SET @currentCalls = 0
			
			END	
		
			
				  INSERT @Restrictions
				  SELECT  TOP 1 @phonenumber, @ssn, @phonetype, ISNULL(@maxCalls, 99), ISNULL(@currentCalls, 0)   
				  
			
    RETURN
END


GO
