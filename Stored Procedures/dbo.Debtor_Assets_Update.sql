SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Debtor_Assets_Update]
			@ID int,
			@Name varchar(50),
			@AssetType tinyint,
			@Description varchar(4000),
			@CurrentValue money,
			@LienAmount money,
			@ValueVerified bit,
			@LienVerified bit,
			@ModifiedBy varchar(50)
		AS 
		 /*
		**Name		:Debtor_Assets_Update
		**Function	:Updates a record into the Debtor_Assets table
		**Creation	:mr 3/3/2004 for version 4.0.23
		**Used by 	:Latitude.exe Asset class
		**Change History:
		*/
		UPDATE Debtor_Assets SET
			Name = @Name, 
			AssetType = @AssetType, 
			Description = @Description, 
			CurrentValue = @CurrentValue, 
			LienAmount = @LienAmount,
			ValueVerified = @ValueVerified,
			LienVerified = @LienVerified,
			Modified = GETDATE(),
			ModifiedBy = (SELECT [LoginName] FROM [dbo].[GetCurrentLatitudeUser]())
		WHERE ID = @ID

		Return @@Error
GO
