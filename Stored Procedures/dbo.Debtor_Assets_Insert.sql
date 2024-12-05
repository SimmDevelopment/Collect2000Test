SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  PROCEDURE [dbo].[Debtor_Assets_Insert]
			@AccountID int,
			@DebtorID int,
			@Name varchar(50),
			@AssetType tinyint,
			@Description varchar(4000),
			@CurrentValue money,
			@LienAmount money,
			@ValueVerified bit,
			@LienVerified bit,
			@loginName varchar(10),
			@ReturnID int Output
		AS 

		 /*
		**Name		:Debtor_Assets_Insert
		**Function	:Inserts a record into the Debtor_Assets table
		**Creation	:mr 3/3/2004 for version 4.0.23
		**Used by 	:Latitude.exe Asset class
		**Change History:
		*/

		DECLARE @currentDate datetime
		SELECT @currentdate = getdate()



		INSERT INTO Debtor_Assets(AccountID, DebtorID, Name, AssetType, Description, CurrentValue, LienAmount, ValueVerified, LienVerified,Created,Modified,CreatedBy,ModifiedBy)
		VALUES (@AccountID, @DebtorID, @Name, @AssetType, @Description, @CurrentValue, @LienAmount, @ValueVerified, @LienVerified,@currentDate,@currentDate,@loginName,@loginName)


		IF @@Error = 0 BEGIN
			Select @ReturnID = SCOPE_IDENTITY()
			Return 0
		END

		Return @@Error

GO
