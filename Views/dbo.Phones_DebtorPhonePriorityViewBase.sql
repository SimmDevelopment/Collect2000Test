SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[Phones_DebtorPhonePriorityViewBase]
AS
SELECT        dbo.Debtors.Number, dbo.Debtors.DebtorID, dbo.Phones_Types.PhoneTypeMapping, dbo.Phones_Statuses.Active, dbo.Phones_Master.OnHold, dbo.Phones_Master.PhoneNumber, CASE WHEN Phones_Statuses.Active = 1 AND
                          Phones_Master.OnHold = 0 THEN 5 WHEN Phones_Master.PhoneStatusID IS NULL AND Phones_Master.OnHold = 0 THEN 4 WHEN Phones_Statuses.Active = 1 AND 
                         Phones_Master.OnHold = 1 THEN 3 WHEN Phones_Master.PhoneStatusID IS NULL AND Phones_Master.OnHold = 1 THEN 2 WHEN Phones_Statuses.Active = 0 AND Phones_Master.OnHold = 0 THEN 1 ELSE 0 END AS Priority,
                             (SELECT        COUNT(CallAttemptID) AS Expr1
                               FROM            dbo.Phones_Attempts AS pa1
                               WHERE        (dbo.Phones_Master.MasterPhoneID = MasterPhoneID)) AS Attempts,
                             (SELECT        MAX(AttemptedDate) AS Expr1
                               FROM            dbo.Phones_Attempts AS pa2
                               WHERE        (dbo.Phones_Master.MasterPhoneID = MasterPhoneID)) AS LastAttempt, dbo.Phones_Master.MasterPhoneID, dbo.Phones_Master.DateAdded
FROM            dbo.Debtors INNER JOIN
                         dbo.Phones_Master ON dbo.Phones_Master.Number = dbo.Debtors.Number AND (dbo.Phones_Master.DebtorID IS NOT NULL AND dbo.Phones_Master.DebtorID = dbo.Debtors.DebtorID OR
                         (dbo.Phones_Master.DebtorID IS NULL OR
                         dbo.Phones_Master.DebtorID = 0) AND dbo.Debtors.Seq = 0) INNER JOIN
                         dbo.Phones_Types ON dbo.Phones_Master.PhoneTypeID = dbo.Phones_Types.PhoneTypeID LEFT OUTER JOIN
                         dbo.Phones_Statuses ON dbo.Phones_Master.PhoneStatusID = dbo.Phones_Statuses.PhoneStatusID
WHERE        (dbo.Phones_Master.NearbyContactID IS NULL) AND (dbo.Phones_Master.PhoneTypeID IN (3, 57, 58)) AND (dbo.Phones_Master.PhoneNumber NOT IN
                             (SELECT        phonenumber
                               FROM            dbo.Custom_SMSTextStop AS css WITH (NOLOCK)))
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Debtors"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 261
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Phones_Master"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 218
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Phones_Types"
            Begin Extent = 
               Top = 138
               Left = 256
               Bottom = 268
               Right = 464
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Phones_Statuses"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 400
               Right = 253
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'Phones_DebtorPhonePriorityViewBase', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Phones_DebtorPhonePriorityViewBase', NULL, NULL
GO
