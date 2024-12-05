SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[Phones_DebtorPhoneFlatList_Default]
AS

SELECT
	DialerSlot1,
	DialerSlot2,
	DialerSlot3,
	DialerSlot4,
	DialerSlot5,
	DialerSlot6,
	DialerSlot7,
	DialerSlot8,

	DialerSlot1Type = CASE WHEN DialerSlot1 <> '' THEN 'H' ELSE '' END,
	DialerSlot2Type = CASE WHEN DialerSlot2 <> '' THEN 'W' ELSE '' END,
	DialerSlot3Type = CASE WHEN DialerSlot3 <> '' THEN 'C' ELSE '' END,
	DialerSlot4Type = CASE WHEN DialerSlot4 <> '' THEN 'FX' ELSE '' END,
	DialerSlot5Type = CASE WHEN DialerSlot5 <> '' THEN 'SH' ELSE '' END,
	DialerSlot6Type = CASE WHEN DialerSlot6 <> '' THEN 'SW' ELSE '' END,
	DialerSlot7Type = CASE WHEN DialerSlot7 <> '' THEN 'O' ELSE '' END,
	DialerSlot8Type = CASE WHEN DialerSlot8 <> '' THEN 'O' ELSE '' END,
	
	Number, DebtorID, Seq

FROM
(SELECT
	DialerSlot1 =         dbo.Phones_IteratedDebtorPhonePriorityItem(Debtors.Number, Debtors.DebtorID, 0, ' ', 1),
	DialerSlot2 =         dbo.Phones_IteratedDebtorPhonePriorityItem(Debtors.Number, Debtors.DebtorID, 1, ' ', 1),
	DialerSlot3 =         dbo.Phones_IteratedDebtorPhonePriorityItem(Debtors.Number, Debtors.DebtorID, 2, ' ', 1),
	DialerSlot4 =         dbo.Phones_IteratedDebtorPhonePriorityItem(Debtors.Number, Debtors.DebtorID, 3, ' ', 1),
	DialerSlot5 =         dbo.Phones_IteratedDebtorPhonePriorityItem(Debtors.Number, Debtors.DebtorID, 4, ' ', 1),
	DialerSlot6 =         dbo.Phones_IteratedDebtorPhonePriorityItem(Debtors.Number, Debtors.DebtorID, 5, ' ', 1),
	DialerSlot7 = '',
	DialerSlot8 = '',

--	-- if the dialer never needs or uses the phone-type, then these should be removed or replaced with blanks, to help performance
--	DialerSlot1Type = dbo.Phones_IteratedDebtorPhonePriorityItemType(Debtors.Number, Debtors.DebtorID, 0, ' ', 1),
--	DialerSlot2Type = dbo.Phones_IteratedDebtorPhonePriorityItemType(Debtors.Number, Debtors.DebtorID, 1, ' ', 1),
--	DialerSlot3Type = dbo.Phones_IteratedDebtorPhonePriorityItemType(Debtors.Number, Debtors.DebtorID, 2, ' ', 1),
--	DialerSlot4Type = dbo.Phones_IteratedDebtorPhonePriorityItemType(Debtors.Number, Debtors.DebtorID, 3, ' ', 1),
--	DialerSlot5Type = dbo.Phones_IteratedDebtorPhonePriorityItemType(Debtors.Number, Debtors.DebtorID, 4, ' ', 1),
--	DialerSlot6Type = dbo.Phones_IteratedDebtorPhonePriorityItemType(Debtors.Number, Debtors.DebtorID, 5, ' ', 1),
--	DialerSlot7Type = '',
--	DialerSlot8Type = '',
	
	Debtors.Number AS Number, Debtors.DebtorID AS DebtorID, Debtors.Seq AS Seq
FROM 
	(Debtors INNER JOIN master ON Debtors.Number = master.number)
) AS Virtual1

GO
