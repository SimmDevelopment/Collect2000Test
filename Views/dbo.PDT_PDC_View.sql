SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE  VIEW [dbo].[PDT_PDC_View] AS
SELECT 
[PDC].[UID] as [ID],
[PDC].[Active] as [Active],
[Master].[number] as [Account ID],
[Master].[number] as [Number],
[Master].[account] as [Original Account Number],
[Master].[account] as [OriginalAccountNumber],
[Master].[Name] as [Name],
[Master].[Street1] as [Street1],
[Master].[Street2] as [Street2],
[Master].[City] as [City],
[Master].[State] as [State],
[Master].[Zipcode] as [Zipcode],
[Master].[Desk] as [Desk],
[Master].[Branch] as [Branch],
'' as [CreditCardName],
'' as [SecurityCode],
[PDC].[PrintedDate] as [Printed Date],
cast([PDC].[SurCharge] as decimal (9,2)) as [Surcharge],
[NSFCount] = [PDC].[NSFCount],
'' as [Cleared],
[Payment Date] = convert(datetime,[PDC].[deposit],101),
[PaymentDate] = convert(VARCHAR(10),[PDC].[deposit],101),
[Pay Method] = [PMethod].[PayMethod],
cast([PDC].[amount] as decimal(9,2)) as [Amount],
[On Hold] = CASE 
		WHEN [PDC].[onhold] is null THEN cast(0 as bit)
		ELSE cast(1 as bit)
		END,
[Description] = '',
[Check / Card Number] = [PDC].[checknbr],
[CheckCardNumber] = rtrim(ltrim([PDC].[checknbr])),
'' as [expdate],
[Status] = CASE
		WHEN [PDC].[approvedby] is not null and [PDC].[Printed] = 0 THEN 'Approved'
		WHEN [PDC].[approvedby] is not null and [PDC].[Printed] = 1 THEN 'Printed'
		WHEN [PDC].[approvedby] is null THEN 'Unapproved'
		END,
[Master].[Customer] as [Customer],

[Left8ABANumber] = substring([DebtorBankInfo].[ABANumber],1,8),

[DebtorBankInfo].[ABANumber] as [ABANumber],
[DebtorBankInfo].[BankName] as [BankName],
[DebtorBankInfo].[BankAddress] as [BankAddress],
[DebtorBankInfo].[BankCity] as [BankCity],
[DebtorBankInfo].[BankZipcode] as [BankZipcode],
[DebtorBankInfo].[AccountNumber] as [AccountNumber],
[DebtorBankInfo].[AccountType] as [AccountType]
FROM [PDC] [PDC] WITH (NOLOCK) JOIN [Master] [Master] WITH (NOLOCK) ON [Master].[Number] = [PDC].[Number] 
LEFT OUTER JOIN [DebtorBankInfo] [DebtorBankInfo] WITH (NOLOCK) ON [Master].[Number] = [DebtorBankInfo].[AcctID]
--Change left outer join above to possibly fix duplicate payments
--INNER JOIN dbo.DebtorBankInfo AS DebtorBankInfo WITH (NOLOCK) ON Master.number = DebtorBankInfo.AcctID AND pdc.seq = debtorbankinfo.DebtorID 
JOIN [PMethod] [PMethod] WITH (NOLOCK) ON [PMethod].[ID] = [PDC].[PDC_Type]

WHERE master.closed IS null
GO
