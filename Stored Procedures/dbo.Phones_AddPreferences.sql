SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Phones_AddPreferences]    
@PhonesPreferencesID INTEGER,    
@MasterPhoneID INTEGER,    
@SundayDoNotCall BIT = NULL,    
@SundayCallWindowStart NVARCHAR(10) = NULL,    
@SundayCallWindowEnd NVARCHAR(10) = NULL,    
@SundayNoCallWindowStart NVARCHAR(10) = NULL,    
@SundayNoCallWindowEnd NVARCHAR(10) = NULL,    
@MondayDoNotCall BIT = NULL,    
@MondayCallWindowStart NVARCHAR(10) = NULL,    
@MondayCallWindowEnd NVARCHAR(10) = NULL,    
@MondayNoCallWindowStart NVARCHAR(10) = NULL,    
@MondayNoCallWindowEnd NVARCHAR(10) = NULL,    
@TuesdayDoNotCall BIT = NULL,    
@TuesdayCallWindowStart NVARCHAR(10) = NULL,    
@TuesdayCallWindowEnd NVARCHAR(10) = NULL,    
@TuesdayNoCallWindowStart NVARCHAR(10) = NULL,    
@TuesdayNoCallWindowEnd NVARCHAR(10) = NULL,    
@WednesdayDoNotCall BIT = NULL,    
@WednesdayCallWindowStart NVARCHAR(10) = NULL,    
@WednesdayCallWindowEnd NVARCHAR(10) = NULL,    
@WednesdayNoCallWindowStart NVARCHAR(10) = NULL,    
@WednesdayNoCallWindowEnd NVARCHAR(10) = NULL,    
@ThursdayDoNotCall BIT = NULL,    
@ThursdayCallWindowStart NVARCHAR(10) = NULL,    
@ThursdayCallWindowEnd NVARCHAR(10) = NULL,    
@ThursdayNoCallWindowStart NVARCHAR(10) = NULL,    
@ThursdayNoCallWindowEnd NVARCHAR(10) = NULL,    
@FridayDoNotCall BIT = NULL,    
@FridayCallWindowStart NVARCHAR(10) = NULL,    
@FridayCallWindowEnd NVARCHAR(10) = NULL,    
@FridayNoCallWindowStart NVARCHAR(10) = NULL,    
@FridayNoCallWindowEnd NVARCHAR(10) = NULL,    
@SaturdayDoNotCall BIT = NULL,    
@SaturdayCallWindowStart NVARCHAR(10) = NULL,    
@SaturdayCallWindowEnd NVARCHAR(10) = NULL,    
@SaturdayNoCallWindowStart NVARCHAR(10) = NULL,    
@SaturdayNoCallWindowEnd NVARCHAR(10) = NULL,   
@ApplyPreferences BIT = NULL,  
@PhoneTypeID INTEGER,  
@DebtorID INTEGER  ,
@UserName Varchar(30) =''
AS
BEGIN
SET NOCOUNT ON; 

	WITH Inputs AS (
	SELECT 'SundayDoNotCall' Pref, @SundayDoNotCall PrefValue
	UNION ALL
	SELECT 'SundayCallWindowStart',@SundayCallWindowStart
	UNION ALL
	SELECT 'SundayCallWindowEnd',@SundayCallWindowEnd
	UNION ALL
	Select 'SundayNoCallWindowStart' , @SundayNoCallWindowStart
	UNION ALL
	Select 'SundayNoCallWindowEnd', @SundayNoCallWindowEnd
	UNION ALL
	Select 'MondayDoNotCall' , @MondayDoNotCall
	UNION ALL
	Select 'MondayCallWindowStart ', @MondayCallWindowStart
	UNION ALL
	Select 'MondayCallWindowEnd' ,@MondayCallWindowEnd
	UNION ALL
	Select 'MondayNoCallWindowStart' , @MondayNoCallWindowStart
	UNION ALL
	Select 'MondayNoCallWindowEnd' , @MondayNoCallWindowEnd
	UNION ALL
	Select 'TuesdayDoNotCall' , @TuesdayDoNotCall
	UNION ALL
	Select 'TuesdayCallWindowStart' , @TuesdayCallWindowStart
	UNION ALL
	Select 'TuesdayCallWindowEnd' , @TuesdayCallWindowEnd
	UNION ALL
	Select 'TuesdayNoCallWindowStart' , @TuesdayNoCallWindowStart
	UNION ALL
	Select 'TuesdayNoCallWindowEnd' , @TuesdayNoCallWindowEnd
	UNION ALL
	Select 'WednesdayDoNotCall' , @WednesdayDoNotCall
	UNION ALL
	Select 'WednesdayCallWindowStart' , @WednesdayCallWindowStart
	UNION ALL
	Select 'WednesdayCallWindowEnd' , @WednesdayCallWindowEnd
	UNION ALL
	Select 'WednesdayNoCallWindowStart' , @WednesdayNoCallWindowStart
	UNION ALL
	Select 'WednesdayNoCallWindowEnd' , @WednesdayNoCallWindowEnd
	UNION ALL
	Select 'ThursdayDoNotCall' , @ThursdayDoNotCall
	UNION ALL
	Select 'ThursdayCallWindowStart' , @ThursdayCallWindowStart
	UNION ALL
	Select 'ThursdayCallWindowEnd' , @ThursdayCallWindowEnd
	UNION ALL
	Select 'ThursdayNoCallWindowStart' , @ThursdayNoCallWindowStart
	UNION ALL
	Select 'ThursdayNoCallWindowEnd' ,@ThursdayNoCallWindowEnd
	UNION ALL
	Select 'FridayDoNotCall' , @FridayDoNotCall
	UNION ALL
	Select 'FridayCallWindowStart' , @FridayCallWindowStart
	UNION ALL
	Select 'FridayCallWindowEnd' , @FridayCallWindowEnd
	UNION ALL
	Select 'FridayNoCallWindowStart' , @FridayNoCallWindowStart
	UNION ALL
	Select 'FridayNoCallWindowEnd' , @FridayNoCallWindowEnd
	UNION ALL
	Select 'SaturdayDoNotCall' , @SaturdayDoNotCall
	UNION ALL
	Select 'SaturdayCallWindowStart' , @SaturdayCallWindowStart
	UNION ALL
	Select 'SaturdayCallWindowEnd' , @SaturdayCallWindowEnd
	UNION ALL
	Select 'SaturdayNoCallWindowStart' , @SaturdayNoCallWindowStart
	UNION ALL
	Select 'SaturdayNoCallWindowEnd' , @SaturdayNoCallWindowEnd
	), Data AS (
	select u.pref, u.prefvalue from (select * from Phones_Preferences WITH (NOLOCK) where MasterPhoneId=@MasterPhoneId) pp
	unpivot
	(
	pref
	for prefvalue in (SundayCallWindowStart, 
	SundayCallWindowEnd, 
	SundayNoCallWindowStart, 
	SundayNoCallWindowEnd, 
	MondayCallWindowStart, 
	MondayCallWindowEnd, 
	MondayNoCallWindowStart, 
	MondayNoCallWindowEnd, 
	TuesdayCallWindowStart, 
	TuesdayCallWindowEnd, 
	TuesdayNoCallWindowStart, 
	TuesdayNoCallWindowEnd, 
	WednesdayCallWindowStart,
	WednesdayCallWindowEnd, 
	WednesdayNoCallWindowStart, 
	WednesdayNoCallWindowEnd, 
	ThursdayCallWindowStart, 
	ThursdayCallWindowEnd, 
	ThursdayNoCallWindowStart, 
	ThursdayNoCallWindowEnd, 
	FridayCallWindowStart, 
	FridayCallWindowEnd, 
	FridayNoCallWindowStart, 
	FridayNoCallWindowEnd, 
	SaturdayCallWindowStart, 
	SaturdayCallWindowEnd, 
	SaturdayNoCallWindowStart, 
	SaturdayNoCallWindowEnd)
	)u
	union
	select pref, prefvalue from (
	select pp.SundayDoNotCall,
	pp.MondayDoNotCall ,
	pp.TuesdayDoNotCall ,
	pp.WednesdayDoNotCall ,
	pp.ThursdayDoNotCall ,
	pp.FridayDoNotCall ,
	pp.SaturdayDoNotCall
	from Phones_Preferences pp WITH (NOLOCK) where pp.MasterPhoneId=@MasterPhoneID)pv
	unpivot
	(
	pref
	for prefvalue in (SundayDoNotCall, MondayDoNotCall ,
	TuesdayDoNotCall ,
	WednesdayDoNotCall ,
	ThursdayDoNotCall ,
	FridayDoNotCall ,
	SaturdayDoNotCall)
	)u
	)
	SELECT i.Pref, i.PrefValue NewValue, d.pref OldValue, case when d.pref is null then 'Insert' else 'Update' end as ActionPerformed
	into #tempPhonePreferences
	from Inputs i WITH (NOLOCK)
	left join Data d WITH (NOLOCK) on i.Pref = d.prefvalue
	where i.prefvalue != d.pref  
     
	IF( @ApplyPreferences = 1)
	BEGIN  
		UPDATE pp SET     
			[SundayDoNotCall] = @SundayDoNotCall,[SundayCallWindowStart] = @SundayCallWindowStart,[SundayCallWindowEnd] = @SundayCallWindowEnd,[SundayNoCallWindowStart] = @SundayNoCallWindowStart,[SundayNoCallWindowEnd] = @SundayNoCallWindowEnd,    
			[MondayDoNotCall] = @MondayDoNotCall,[MondayCallWindowStart] = @MondayCallWindowStart,[MondayCallWindowEnd] = @MondayCallWindowEnd,[MondayNoCallWindowStart] = @MondayNoCallWindowStart,[MondayNoCallWindowEnd] = @MondayNoCallWindowEnd,    
			[TuesdayDoNotCall] = @TuesdayDoNotCall,[TuesdayCallWindowStart] = @TuesdayCallWindowStart,[TuesdayCallWindowEnd] = @TuesdayCallWindowEnd,[TuesdayNoCallWindowStart]= @TuesdayNoCallWindowStart,[TuesdayNoCallWindowEnd] = @TuesdayNoCallWindowEnd,    
			[WednesdayDoNotCall] = @WednesdayDoNotCall,[WednesdayCallWindowStart] = @WednesdayCallWindowStart,[WednesdayCallWindowEnd] = @WednesdayCallWindowEnd,[WednesdayNoCallWindowStart] = @WednesdayNoCallWindowStart,
			[WednesdayNoCallWindowEnd] = @WednesdayNoCallWindowEnd,    
			[ThursdayDoNotCall] = @ThursdayDoNotCall,[ThursdayCallWindowStart] = @ThursdayCallWindowStart,[ThursdayCallWindowEnd] = @ThursdayCallWindowEnd,[ThursdayNoCallWindowStart] = @ThursdayNoCallWindowStart,
			[ThursdayNoCallWindowEnd] = @ThursdayNoCallWindowEnd,    
			[FridayDoNotCall] = @FridayDoNotCall,[FridayCallWindowStart] = @FridayCallWindowStart,[FridayCallWindowEnd] = @FridayCallWindowEnd,[FridayNoCallWindowStart] = @FridayNoCallWindowStart,[FridayNoCallWindowEnd] = @FridayNoCallWindowEnd,    
			[SaturdayDoNotCall] = @SaturdayDoNotCall,[SaturdayCallWindowStart] = @SaturdayCallWindowStart,[SaturdayCallWindowEnd] = @SaturdayCallWindowEnd,[SaturdayNoCallWindowStart] = @SaturdayNoCallWindowStart,
			[SaturdayNoCallWindowEnd] = @SaturdayNoCallWindowEnd   
		FROM [Phones_Preferences] pp WITH (NOLOCK)
			INNER JOIN Phones_Master pm WITH (NOLOCK) ON pm.MasterPhoneID = pp.MasterPhoneId
		WHERE pm.PhoneStatusID = 2 and pm.PhoneTypeID = @PhoneTypeID and pm.DebtorID = @DebtorID 
		
		INSERT INTO [dbo].[Phones_Preferences]     
			(    
			[MasterPhoneId],     
			[SundayDoNotCall],[SundayCallWindowStart],[SundayCallWindowEnd],[SundayNoCallWindowStart],[SundayNoCallWindowEnd],    
			[MondayDoNotCall],[MondayCallWindowStart],[MondayCallWindowEnd],[MondayNoCallWindowStart],[MondayNoCallWindowEnd],    
			[TuesdayDoNotCall],[TuesdayCallWindowStart],[TuesdayCallWindowEnd],[TuesdayNoCallWindowStart],[TuesdayNoCallWindowEnd],    
			[WednesdayDoNotCall],[WednesdayCallWindowStart],[WednesdayCallWindowEnd],[WednesdayNoCallWindowStart],[WednesdayNoCallWindowEnd],    
			[ThursdayDoNotCall],[ThursdayCallWindowStart],[ThursdayCallWindowEnd],[ThursdayNoCallWindowStart],[ThursdayNoCallWindowEnd],    
			[FridayDoNotCall],[FridayCallWindowStart],[FridayCallWindowEnd],[FridayNoCallWindowStart],[FridayNoCallWindowEnd],    
			[SaturdayDoNotCall],[SaturdayCallWindowStart],[SaturdayCallWindowEnd],[SaturdayNoCallWindowStart],[SaturdayNoCallWindowEnd]    
			)    
         
		SELECT pm.MasterPhoneID,    
			@SundayDoNotCall,@SundayCallWindowStart,@SundayCallWindowEnd,@SundayNoCallWindowStart,@SundayNoCallWindowEnd,    
			@MondayDoNotCall,@MondayCallWindowStart,@MondayCallWindowEnd,@MondayNoCallWindowStart,@MondayNoCallWindowEnd,    
			@TuesdayDoNotCall,@TuesdayCallWindowStart,@TuesdayCallWindowEnd,@TuesdayNoCallWindowStart,@TuesdayNoCallWindowEnd,    
			@WednesdayDoNotCall,@WednesdayCallWindowStart,@WednesdayCallWindowEnd,@WednesdayNoCallWindowStart,@WednesdayNoCallWindowEnd,    
			@ThursdayDoNotCall,@ThursdayCallWindowStart,@ThursdayCallWindowEnd,@ThursdayNoCallWindowStart,@ThursdayNoCallWindowEnd,    
			@FridayDoNotCall,@FridayCallWindowStart,@FridayCallWindowEnd,@FridayNoCallWindowStart,@FridayNoCallWindowEnd,    
			@SaturdayDoNotCall,@SaturdayCallWindowStart,@SaturdayCallWindowEnd,@SaturdayNoCallWindowStart,@SaturdayNoCallWindowEnd    
		FROM Phones_Master pm WITH (NOLOCK)
		WHERE pm.PhoneStatusID = 2 and pm.PhoneTypeID = @PhoneTypeID and pm.DebtorID = @DebtorID AND
			pm.MasterPhoneID NOT IN (SELECT MasterPhoneID FROM Phones_Preferences WITH (NOLOCK))
	END  
	ELSE 
	BEGIN  
		IF(@PhonesPreferencesID > 0)       
		BEGIN   
			UPDATE [Phones_Preferences] SET [MasterPhoneID] = @MasterPhoneID,    
			[SundayDoNotCall] = @SundayDoNotCall,[SundayCallWindowStart] = @SundayCallWindowStart,[SundayCallWindowEnd] = @SundayCallWindowEnd,[SundayNoCallWindowStart] = @SundayNoCallWindowStart,[SundayNoCallWindowEnd] = @SundayNoCallWindowEnd,    
			[MondayDoNotCall] = @MondayDoNotCall,[MondayCallWindowStart] = @MondayCallWindowStart,[MondayCallWindowEnd] = @MondayCallWindowEnd,[MondayNoCallWindowStart] = @MondayNoCallWindowStart,[MondayNoCallWindowEnd] = @MondayNoCallWindowEnd,    
			[TuesdayDoNotCall] = @TuesdayDoNotCall,[TuesdayCallWindowStart] = @TuesdayCallWindowStart,[TuesdayCallWindowEnd] = @TuesdayCallWindowEnd,[TuesdayNoCallWindowStart]= @TuesdayNoCallWindowStart,[TuesdayNoCallWindowEnd] = @TuesdayNoCallWindowEnd,   
			[WednesdayDoNotCall] = @WednesdayDoNotCall,[WednesdayCallWindowStart] = @WednesdayCallWindowStart,[WednesdayCallWindowEnd] = @WednesdayCallWindowEnd,[WednesdayNoCallWindowStart] = @WednesdayNoCallWindowStart,
			[WednesdayNoCallWindowEnd] = @WednesdayNoCallWindowEnd,    
			[ThursdayDoNotCall] = @ThursdayDoNotCall,[ThursdayCallWindowStart] = @ThursdayCallWindowStart,[ThursdayCallWindowEnd] = @ThursdayCallWindowEnd,
			[ThursdayNoCallWindowStart] = @ThursdayNoCallWindowStart,[ThursdayNoCallWindowEnd] = @ThursdayNoCallWindowEnd,    
			[FridayDoNotCall] = @FridayDoNotCall,[FridayCallWindowStart] = @FridayCallWindowStart,[FridayCallWindowEnd] = @FridayCallWindowEnd,[FridayNoCallWindowStart] = @FridayNoCallWindowStart,[FridayNoCallWindowEnd] = @FridayNoCallWindowEnd,    
			[SaturdayDoNotCall] = @SaturdayDoNotCall,[SaturdayCallWindowStart] = @SaturdayCallWindowStart,[SaturdayCallWindowEnd] = @SaturdayCallWindowEnd,[SaturdayNoCallWindowStart] = @SaturdayNoCallWindowStart,
			[SaturdayNoCallWindowEnd] = @SaturdayNoCallWindowEnd
			WHERE [PhonesPreferencesID] = @PhonesPreferencesID;
		END        
		ELSE        
		BEGIN  
			DECLARE @Count INTEGER;
			SET @Count = (SELECT COUNT(*) FROM Phones_Preferences WITH (NOLOCK) WHERE [MasterPhoneID] = @MasterPhoneID);
			IF(@Count > 0)  
				BEGIN
					UPDATE [Phones_Preferences] SET       
				   [SundayDoNotCall] = @SundayDoNotCall,[SundayCallWindowStart] = @SundayCallWindowStart,[SundayCallWindowEnd] = @SundayCallWindowEnd,  
				   [SundayNoCallWindowStart] = @SundayNoCallWindowStart,[SundayNoCallWindowEnd] = @SundayNoCallWindowEnd,      
				   [MondayDoNotCall] = @MondayDoNotCall,[MondayCallWindowStart] = @MondayCallWindowStart,[MondayCallWindowEnd] = @MondayCallWindowEnd,  
				   [MondayNoCallWindowStart] = @MondayNoCallWindowStart,[MondayNoCallWindowEnd] = @MondayNoCallWindowEnd,      
				   [TuesdayDoNotCall] = @TuesdayDoNotCall,[TuesdayCallWindowStart] = @TuesdayCallWindowStart,[TuesdayCallWindowEnd] = @TuesdayCallWindowEnd,  
				   [TuesdayNoCallWindowStart]= @TuesdayNoCallWindowStart,[TuesdayNoCallWindowEnd] = @TuesdayNoCallWindowEnd,     
				   [WednesdayDoNotCall] = @WednesdayDoNotCall,[WednesdayCallWindowStart] = @WednesdayCallWindowStart,[WednesdayCallWindowEnd] = @WednesdayCallWindowEnd,  
				   [WednesdayNoCallWindowStart] = @WednesdayNoCallWindowStart,[WednesdayNoCallWindowEnd] = @WednesdayNoCallWindowEnd,      
				   [ThursdayDoNotCall] = @ThursdayDoNotCall,[ThursdayCallWindowStart] = @ThursdayCallWindowStart,[ThursdayCallWindowEnd] = @ThursdayCallWindowEnd,  
				   [ThursdayNoCallWindowStart] = @ThursdayNoCallWindowStart,[ThursdayNoCallWindowEnd] = @ThursdayNoCallWindowEnd,      
				   [FridayDoNotCall] = @FridayDoNotCall,[FridayCallWindowStart] = @FridayCallWindowStart,[FridayCallWindowEnd] = @FridayCallWindowEnd,  
				   [FridayNoCallWindowStart] = @FridayNoCallWindowStart,[FridayNoCallWindowEnd] = @FridayNoCallWindowEnd,      
				   [SaturdayDoNotCall] = @SaturdayDoNotCall,[SaturdayCallWindowStart] = @SaturdayCallWindowStart,[SaturdayCallWindowEnd] = @SaturdayCallWindowEnd,  
				   [SaturdayNoCallWindowStart] = @SaturdayNoCallWindowStart,[SaturdayNoCallWindowEnd] = @SaturdayNoCallWindowEnd  
				   WHERE [MasterPhoneID] = @MasterPhoneID;
				END
			ELSE
				BEGIN  
					INSERT INTO [dbo].[Phones_Preferences]     
					(    
						[MasterPhoneId],     
						[SundayDoNotCall],[SundayCallWindowStart],[SundayCallWindowEnd],[SundayNoCallWindowStart],[SundayNoCallWindowEnd],    
						[MondayDoNotCall],[MondayCallWindowStart],[MondayCallWindowEnd],[MondayNoCallWindowStart],[MondayNoCallWindowEnd],    
						[TuesdayDoNotCall],[TuesdayCallWindowStart],[TuesdayCallWindowEnd],[TuesdayNoCallWindowStart],[TuesdayNoCallWindowEnd],    
						[WednesdayDoNotCall],[WednesdayCallWindowStart],[WednesdayCallWindowEnd],[WednesdayNoCallWindowStart],[WednesdayNoCallWindowEnd],    
						[ThursdayDoNotCall],[ThursdayCallWindowStart],[ThursdayCallWindowEnd],[ThursdayNoCallWindowStart],[ThursdayNoCallWindowEnd],    
						[FridayDoNotCall],[FridayCallWindowStart],[FridayCallWindowEnd],[FridayNoCallWindowStart],[FridayNoCallWindowEnd],    
						[SaturdayDoNotCall],[SaturdayCallWindowStart],[SaturdayCallWindowEnd],[SaturdayNoCallWindowStart],[SaturdayNoCallWindowEnd]    
					)          
					VALUES   
					(    
						@MasterPhoneID,    
						@SundayDoNotCall,@SundayCallWindowStart,@SundayCallWindowEnd,@SundayNoCallWindowStart,@SundayNoCallWindowEnd,    
						@MondayDoNotCall,@MondayCallWindowStart,@MondayCallWindowEnd,@MondayNoCallWindowStart,@MondayNoCallWindowEnd,    
						@TuesdayDoNotCall,@TuesdayCallWindowStart,@TuesdayCallWindowEnd,@TuesdayNoCallWindowStart,@TuesdayNoCallWindowEnd,    
						@WednesdayDoNotCall,@WednesdayCallWindowStart,@WednesdayCallWindowEnd,@WednesdayNoCallWindowStart,@WednesdayNoCallWindowEnd,    
						@ThursdayDoNotCall,@ThursdayCallWindowStart,@ThursdayCallWindowEnd,@ThursdayNoCallWindowStart,@ThursdayNoCallWindowEnd,    
						@FridayDoNotCall,@FridayCallWindowStart,@FridayCallWindowEnd,@FridayNoCallWindowStart,@FridayNoCallWindowEnd,    
						@SaturdayDoNotCall,@SaturdayCallWindowStart,@SaturdayCallWindowEnd,@SaturdayNoCallWindowStart,@SaturdayNoCallWindowEnd     
					);   
				END 
		END    
	END

	DECLARE @Number VARCHAR(10), @DebtorName VARCHAR(50), @PhoneNumber VARCHAR(20);
	SELECT @Number = Number, @DebtorName = Name FROM Debtors WITH (NOLOCK) WHERE DebtorID = @DebtorId;
	SELECT @PhoneNumber = PhoneNumber FROM [dbo].[Phones_Master] WITH (NOLOCK) WHERE MasterPhoneID = @MasterPhoneID;
	--INSERT notes VALUES(@Number, null, GETDATE(),@UserName, '+++++', '+++++', 'Debtor '+@DebtorName+' Phone '+@PhoneNumber+' preferred/restricted call windows changed', NULL, NULL, GETUTCDATE()) 
	INSERT notes
	select @Number ,null,GETDATE(),@username, '+++++', '+++++','Debtor '+@DebtorName+' Phone '+@PhoneNumber+' call preferences changed for '+tmp.pref +' from '+Cast(tmp.oldvalue as varchar) +' to '+cast(tmp.newvalue as varchar), NULL, NULL, GETUTCDATE()
	from #tempphonepreferences tmp   
	
	DECLARE @LinkedAccounts TABLE (
		[AccountID] [INT] NOT NULL,
		[Linked] [BIT] NOT NULL
	)

	INSERT INTO @LinkedAccounts ([AccountId], [Linked])
	SELECT [AccountID], [Linked] FROM [dbo].[fnGetLinkedAccounts](@Number, NULL)

	IF EXISTS (SELECT 1 FROM @LinkedAccounts WHERE AccountID <> @Number)
	BEGIN
		DECLARE @PhoneMasters TABLE (
			[MasterPhoneId] [INT] NOT NULL,
			[PhoneNumber] [VARCHAR](30) NOT NULL,
			[DebtorName] [VARCHAR](300) NULL,
			[Number] [INT] NOT NULL
		)

		IF(@ApplyPreferences = 1)
		BEGIN
			INSERT INTO @PhoneMasters ([MasterPhoneId], [PhoneNumber], [Number], [DebtorName])
			SELECT pm.[MasterPhoneID], pm.[PhoneNumber], jd.[AccountID], d.[Name]
			FROM [dbo].[Phones_Master] pm WITH (NOLOCK)
				INNER JOIN @LinkedAccounts jd
					ON pm.[Number] = jd.[AccountID]
				INNER JOIN [dbo].[Debtors] d WITH (NOLOCK)
					ON pm.DebtorID = d.DebtorID
			WHERE pm.[PhoneStatusID] = 2
				AND pm.[PhoneTypeID] = @PhoneTypeID
				AND jd.AccountID <> @Number
				AND NOT EXISTS (SELECT 1 FROM [dbo].[Phones_Preferences] pp WITH (NOLOCK) WHERE pp.[MasterPhoneId] = pm.[MasterPhoneId])
		END
		ELSE
		BEGIN
			INSERT INTO @PhoneMasters ([MasterPhoneId], [PhoneNumber], [Number], [DebtorName])
			SELECT pm.[MasterPhoneID], pm.[PhoneNumber], jd.[AccountID], d.[Name]
			FROM [dbo].[Phones_Master] pm WITH (NOLOCK)
				INNER JOIN @LinkedAccounts jd
					ON pm.[Number] = jd.[AccountID]
				INNER JOIN [dbo].[Debtors] d WITH (NOLOCK)
					ON pm.DebtorID = d.DebtorID
			WHERE pm.[PhoneNumber] = @PhoneNumber
				AND pm.[PhoneTypeID] = @PhoneTypeID
				AND jd.AccountID <> @Number
				AND NOT EXISTS (SELECT 1 FROM [dbo].[Phones_Preferences] pp WITH (NOLOCK) WHERE pp.[MasterPhoneId] = pm.[MasterPhoneId])
		END

		IF EXISTS (SELECT 1 FROM @PhoneMasters pm)
		BEGIN
			INSERT INTO [dbo].[Phones_Preferences]     
			(    
				[MasterPhoneId],     
				[SundayDoNotCall],[SundayCallWindowStart],[SundayCallWindowEnd],[SundayNoCallWindowStart],[SundayNoCallWindowEnd],    
				[MondayDoNotCall],[MondayCallWindowStart],[MondayCallWindowEnd],[MondayNoCallWindowStart],[MondayNoCallWindowEnd],    
				[TuesdayDoNotCall],[TuesdayCallWindowStart],[TuesdayCallWindowEnd],[TuesdayNoCallWindowStart],[TuesdayNoCallWindowEnd],    
				[WednesdayDoNotCall],[WednesdayCallWindowStart],[WednesdayCallWindowEnd],[WednesdayNoCallWindowStart],[WednesdayNoCallWindowEnd],    
				[ThursdayDoNotCall],[ThursdayCallWindowStart],[ThursdayCallWindowEnd],[ThursdayNoCallWindowStart],[ThursdayNoCallWindowEnd],    
				[FridayDoNotCall],[FridayCallWindowStart],[FridayCallWindowEnd],[FridayNoCallWindowStart],[FridayNoCallWindowEnd],    
				[SaturdayDoNotCall],[SaturdayCallWindowStart],[SaturdayCallWindowEnd],[SaturdayNoCallWindowStart],[SaturdayNoCallWindowEnd]    
			)          
			SELECT   
				pm.[MasterPhoneId],    
				@SundayDoNotCall,@SundayCallWindowStart,@SundayCallWindowEnd,@SundayNoCallWindowStart,@SundayNoCallWindowEnd,    
				@MondayDoNotCall,@MondayCallWindowStart,@MondayCallWindowEnd,@MondayNoCallWindowStart,@MondayNoCallWindowEnd,    
				@TuesdayDoNotCall,@TuesdayCallWindowStart,@TuesdayCallWindowEnd,@TuesdayNoCallWindowStart,@TuesdayNoCallWindowEnd,    
				@WednesdayDoNotCall,@WednesdayCallWindowStart,@WednesdayCallWindowEnd,@WednesdayNoCallWindowStart,@WednesdayNoCallWindowEnd,    
				@ThursdayDoNotCall,@ThursdayCallWindowStart,@ThursdayCallWindowEnd,@ThursdayNoCallWindowStart,@ThursdayNoCallWindowEnd,    
				@FridayDoNotCall,@FridayCallWindowStart,@FridayCallWindowEnd,@FridayNoCallWindowStart,@FridayNoCallWindowEnd,    
				@SaturdayDoNotCall,@SaturdayCallWindowStart,@SaturdayCallWindowEnd,@SaturdayNoCallWindowStart,@SaturdayNoCallWindowEnd    
			FROM @PhoneMasters pm;

			INSERT notes 
			SELECT [Number], null, GETDATE(), '', '+++++', '+++++', 'Debtor '+ [DebtorName] +' Phone '+ [PhoneNumber] +' preferred/restricted call windows changed', NULL, NULL, GETDATE() 
			FROM @PhoneMasters
		END 
	END
END
GO
