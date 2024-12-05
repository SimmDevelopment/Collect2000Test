SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[Phones_DebtorPhoneFlatList]
AS
 
SELECT
[Debtors].[Number] as [Number], 
[Debtors].[DebtorID] as [DebtorID], 
[Debtors].[Seq] as [Seq], 
dbo.Phones_IteratedDebtorPhonePriorityItem([Debtors].[Number], [Debtors].[DebtorID], 0, ' ', 1) as [HomePhone], 
dbo.Phones_IteratedDebtorPhonePriorityItem([Debtors].[Number], [Debtors].[DebtorID], 1, ' ', 1) as [WorkPhone], 
dbo.Phones_IteratedDebtorPhonePriorityItem([Debtors].[Number], [Debtors].[DebtorID], 2, ' ', 1) as [Pager], 
'' as [Fax], 
'' as [SpouseHomePhone], 
'' as [SpouseWorkPhone], 
dbo.Phones_IteratedDebtorPhonePriorityItem([Debtors].[Number], [Debtors].[DebtorID], 7, ' ', 1) as [OtherPhone1], 
dbo.Phones_IteratedDebtorPhonePriorityItem([Debtors].[Number], [Debtors].[DebtorID], 7, ' ', 1) as [OtherPhone2], 
dbo.Phones_IteratedDebtorPhonePriorityItem([Debtors].[Number], [Debtors].[DebtorID], 6, ' ', 1) as [OtherPhone3], 
'H' as [OtherPhone1Type], 
'H' as [OtherPhone2Type], 
'H' as [OtherPhone3Type]

FROM 
([Debtors] INNER JOIN [master] ON [Debtors].[Number] = [master].[number])

/*    ListBuilderCondition = 'DEFAULT',
    Phones_DebtorPhoneFlatList_Default.Number,
    Phones_DebtorPhoneFlatList_Default.DebtorID,
    Phones_DebtorPhoneFlatList_Default.Seq,
    
    HomePhone =       CASE WHEN DialerSlot1Type = 'H'  THEN DialerSlot1 ELSE '' END,
    WorkPhone =       CASE WHEN DialerSlot2Type = 'W'  THEN DialerSlot2 ELSE '' END,
    Pager =           CASE WHEN DialerSlot3Type = 'C'  THEN DialerSlot3 ELSE '' END,
    Fax =             CASE WHEN DialerSlot4Type = 'FX' THEN DialerSlot4 ELSE '' END,
    SpouseHomePhone = CASE WHEN DialerSlot5Type = 'SH' THEN DialerSlot5 ELSE '' END,
    SpouseWorkPhone = CASE WHEN DialerSlot6Type = 'SW' THEN DialerSlot6 ELSE '' END,
    
    OtherPhone1 =     CASE WHEN DialerSlot4Type = 'FX' THEN DialerSlot4 ELSE '' END,
    OtherPhone2 =     CASE WHEN DialerSlot5Type = 'SH' THEN DialerSlot5 ELSE '' END,
    OtherPhone3 =     CASE WHEN DialerSlot6Type = 'SW' THEN DialerSlot6 ELSE '' END,
    OtherPhone1Type = CASE WHEN DialerSlot4Type = 'FX' THEN DialerSlot4Type ELSE '' END,
    OtherPhone2Type = CASE WHEN DialerSlot5Type = 'SH' THEN DialerSlot5Type ELSE '' END,
    OtherPhone3Type = CASE WHEN DialerSlot6Type = 'SW' THEN DialerSlot6Type ELSE '' END
    
FROM Phones_DebtorPhoneFlatList_Default

*/
GO
