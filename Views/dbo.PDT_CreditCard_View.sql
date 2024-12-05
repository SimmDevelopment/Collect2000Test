SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE               VIEW [dbo].[PDT_CreditCard_View] AS
SELECT 
[DebtorCreditCards].[ID] as [ID],
[DebtorCreditCards].[IsActive] as [Active],
[Master].[number] as [Account ID],
[Master].[account] as [Original Account Number],
[Master].[State] as [Name],
[DebtorCreditCards].[Street1] as [Street1],
[DebtorCreditCards].[Street2] as [Street2],
[DebtorCreditCards].[City] as [City],
[DebtorCreditCards].[State] as [State],
[DebtorCreditCards].[Zipcode] as [Zipcode],
[Master].[Desk] as [Desk],
[Master].[Branch] as [Branch],
[DebtorCreditCards].[Name] as [CreditCardName],
[DebtorCreditCards].[Code] as [SecurityCode],
[DebtorCreditCards].[PrintedDate] as [Printed Date],
cast([DebtorCreditCards].[SurCharge] as decimal(9,2)) as [Surcharge],
[NSFCount] = [DebtorCreditCards].[NSFCount],
'' as [Cleared],
[Payment Date] = convert(datetime,[DebtorCreditCards].[DepositDate],101),
[Pay Method] = 'CREDIT CARD',
cast(([DebtorCreditCards].[amount] + [DebtorCreditCards].[surcharge]) as decimal(9,2)) as [Amount],
[On Hold] = CASE 
		WHEN [DebtorCreditCards].[onholddate] is null THEN cast(0 as bit)
		ELSE cast(1 as bit)
		END,
[Description] = [CreditCardTypes].[Description],
[Check / Card Number] = [DebtorCreditCards].[CardNumber],
[CheckCardNumber] = ltrim(rtrim([DebtorCreditCards].[CardNumber])),
[DebtorCreditCards].[expmonth] + [DebtorCreditCards].[expyear] as [expdate],
[Status] = CASE
		WHEN [DebtorCreditCards].[approvedby] is not null and [DebtorCreditCards].[Printed] in ('0', 'N') THEN 'Approved'
		WHEN [DebtorCreditCards].[approvedby] is not null and [DebtorCreditCards].[Printed] in ('1', 'Y') THEN 'Printed'
		WHEN [DebtorCreditCards].[approvedby] is null THEN 'Unapproved'
		END,
[Master].[Customer] as [Customer]

FROM [DebtorCreditCards] [DebtorCreditCards] WITH (NOLOCK) JOIN [Master] [Master] WITH (NOLOCK) ON [Master].[Number] = [DebtorCreditCards].[Number] and [DebtorCreditCards].[IsActive] = 1
JOIN [CreditCardTypes] [CreditCardTypes] WITH (NOLOCK) ON [CreditCardTypes].[Code] = [DebtorCreditCards].[CreditCard]



GO
