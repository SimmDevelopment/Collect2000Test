SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Attunely_Staging_Debts]
	@FromDate DATETIME
AS
BEGIN
	SET NOCOUNT ON; 
	DECLARE @Updated BIT = 0

	UPDATE Attunely_Debts
	SET [Status] = m.status
           ,[Balance_CurrentCents] = m.current0 * 100
           ,[Balance_PrincipalCents] = m.current1 * 100
           ,[Originator_Key] = c.customer
           ,[Originator_CreditorName] = RTRIM(c.Name)
           ,[Timeline_OriginationTime] = m.clidlc
           ,[Timeline_DelinquencyTime] = m.Delinquencydate
           ,[Timeline_ChargeoffTime] = m.ChargeOffDate
           ,[Timeline_AcquisitionTime] = m.received
           ,[Timeline_RecallTime] = m.returned
           ,[AgentKey] = (SELECT TOP 1 u.LoginName FROM users u WHERE u.DeskCode = m.desk order by u.Active DESC)
           ,[RecordTime] = GETUTCDATE()
	FROM Attunely_Debts d
		INNER JOIN Attunely_AccountStubs a 
			ON d.AccountKey = a.AccountKey
		INNER JOIN master m 
			ON m.number = a.AccountKey
		INNER JOIN customer c
			ON m.customer = c.customer
	WHERE d.[Status] NOT LIKE m.status
           OR [Balance_CurrentCents] <> m.current0 * 100
           OR [Balance_PrincipalCents] <> m.current1 * 100
           OR [Originator_Key] NOT LIKE c.customer
           OR [Originator_CreditorName] NOT LIKE RTRIM(c.Name)
           OR [Timeline_OriginationTime] <> m.clidlc
           OR [Timeline_DelinquencyTime] <> m.Delinquencydate
           OR [Timeline_ChargeoffTime] <> m.ChargeOffDate
           OR [Timeline_AcquisitionTime] <> m.received
           OR [Timeline_RecallTime] <> m.returned
           OR d.[AgentKey] NOT LIKE (SELECT TOP 1 u.LoginName FROM users u WHERE u.DeskCode = m.desk order by u.Active DESC)
	
	IF @@ROWCOUNT > 0 SET @Updated = 1

	INSERT INTO [dbo].[Attunely_Debts]
           ([AccountKey]
           ,[DebtKey]
           ,[Status]
           ,[Balance_CurrentCents]
           ,[Balance_PrincipalCents]
           ,[Balance_PrepaymentCents]
           ,[Originator_Key]
           ,[Originator_CreditorName]
           ,[Originator_Reference]
           ,[Timeline_OriginationTime]
           ,[Timeline_DelinquencyTime]
           ,[Timeline_ChargeoffTime]
           ,[Timeline_AcquisitionTime]
           ,[Timeline_RecallTime]
           ,[Description]
           ,[AgentKey]
           ,[RecordTime])
	SELECT DISTINCT
		a.AccountKey,
		a.AccountKey,
		m.status,
		m.current0 * 100,
		m.current1 * 100,
		0,
		c.customer,
		RTRIM(c.Name),
		null,
		m.clidlc,
		m.Delinquencydate,
		m.ChargeOffDate,
		m.received,
		m.returned,
		null,
		(SELECT TOP 1 u.LoginName FROM users u WHERE u.DeskCode = m.desk order by u.Active DESC),
		GETUTCDATE()
	FROM Attunely_AccountStubs a
		LEFT OUTER JOIN Attunely_Debts d 
			ON a.AccountKey = d.AccountKey 
		INNER JOIN master m 
			ON m.number = a.AccountKey
		INNER JOIN customer c
			ON m.customer = c.customer
	WHERE d.AccountKey IS NULL
	
	IF @@ROWCOUNT > 0 SET @Updated = 1
	SELECT @Updated

END
GO
