SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_Update_Phones_CeaseAndDesist]
@PhoneNumber VARCHAR(30),
@Enable bit = 1,
@UpdatedBy varchar(256),
@ID int OUT
AS

SET @UpdatedBy = ISNULL(@UpdatedBy, suser_sname())
SET @ID = 0

-- Update the Phones_CeaseAndDesist table, if no rows affected, then insert a row.
UPDATE [Phones_CeaseAndDesist] SET [Enabled] = @Enable, [UpdatedBy] = @UpdatedBy, [Updated] = getdate(), @ID = Phones_CeaseAndDesistID WHERE [PhoneNumber] = @PhoneNumber

IF @@ROWCOUNT = 0 AND @Enable = 1
BEGIN
	INSERT INTO [Phones_CeaseAndDesist] ([PhoneNumber], [UpdatedBy], [CreatedBy]) VALUES (@PhoneNumber, @UpdatedBy, @UpdatedBy)
	SET @ID = scope_identity()
END

RETURN @@Error

GO
