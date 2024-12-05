SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Probate_Panel_Update_V26] 
	-- Add the parameters for the stored procedure here
@ID VARCHAR(10),
@comprop VARCHAR(10),
@court VARCHAR(255),
@address1 VARCHAR(255),
@address2 VARCHAR(255),
@city VARCHAR(255),
@state VARCHAR(255),
@zip VARCHAR(255),
@county VARCHAR(255),
@phone VARCHAR(255),
@email VARCHAR(255),
@website VARCHAR(1000),
@claimfee VARCHAR(255),
@searchfee VARCHAR(255),
@action VARCHAR(255),
@notes VARCHAR(255)



AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
UPDATE dbo.Custom_Probate_Court_Info
SET [CMTY PROP] = @comprop, COURT = @court, Street1 = @address1, street2 = @address2, City = @city,
	STATE = @state, zipcode = @zip, COUNTY = @county, TELEPHONE = @phone, Email = @email, WEBSITE = @website,
	[CLAIM FEE] = @claimfee, [SEARCH FEE] = @searchfee, ACTION = @action, Notes = @notes
WHERE ID = @id


END
GO
