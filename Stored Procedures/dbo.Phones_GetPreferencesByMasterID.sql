SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Phones_GetPreferencesByMasterID] 
@MasterID INTEGER 
  
AS  
BEGIN
SET NOCOUNT ON;  
  
	SELECT [PhonesPreferencesID],[MasterPhoneId],   
	 [SundayDoNotCall],[SundayCallWindowStart],[SundayCallWindowEnd],[SundayNoCallWindowStart],[SundayNoCallWindowEnd],  
	 [MondayDoNotCall],[MondayCallWindowStart],[MondayCallWindowEnd],[MondayNoCallWindowStart],[MondayNoCallWindowEnd],  
	 [TuesdayDoNotCall],[TuesdayCallWindowStart],[TuesdayCallWindowEnd],[TuesdayNoCallWindowStart],[TuesdayNoCallWindowEnd],  
	 [WednesdayDoNotCall],[WednesdayCallWindowStart],[WednesdayCallWindowEnd],[WednesdayNoCallWindowStart],[WednesdayNoCallWindowEnd],  
	 [ThursdayDoNotCall],[ThursdayCallWindowStart],[ThursdayCallWindowEnd],[ThursdayNoCallWindowStart],[ThursdayNoCallWindowEnd],  
	 [FridayDoNotCall],[FridayCallWindowStart],[FridayCallWindowEnd],[FridayNoCallWindowStart],[FridayNoCallWindowEnd],  
	 [SaturdayDoNotCall],[SaturdayCallWindowStart],[SaturdayCallWindowEnd],[SaturdayNoCallWindowStart],[SaturdayNoCallWindowEnd] 
	  
	FROM [dbo].[Phones_Preferences] WHERE [MasterPhoneID] = @MasterID  
END
GO
