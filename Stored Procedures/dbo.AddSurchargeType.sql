SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* AddSurchargeType Procedure */
CREATE  PROCEDURE [dbo].[AddSurchargeType]
	@Description	varchar(40),
	@SurchargeAmount	money,
	@SurchargePercent	real,
	@AdditionalAmount	money,
	@AdditionalPercent	real,
	@Active				bit,
	@LatitudeUser		varchar(50),
	@UID				int 	output
AS

 /*
**Name		:AddSurchargeType	
**Function	:Adds a record to the SurchargeType Table
**Creation	:03/13/2006
**CreatedBy	:Mike Devlin
**Used by 	:Promises		
**Parameters
	:@Description		A short description that will display in dropdown
	:@SurchargeAmount	If not null, then it is the flat amount to be used for surcharge.
	:@SurchargePercent	If not null, then it is the percentage to be used to calculate the surcharge.
	:@AdditionalAmount	If not null, then it is the flat amount to be added to default surcharge.
	:@AdditionalPercent	If not null, then it is the percentage to be used to calculate the amount to be added to default surcharge.
	:@Active			If this is True, then this will display in dropdown.
	:@LatitudeUser		The Latitude user, or the SQLUser if not passed in.
	:@UID				Output parm to pass the identity value back.
**Change History:
*/


Declare @ReturnSts int

IF @LatitudeUser is null
	Select @LatitudeUser = suser_sname()
ELSE
	Select @LatitudeUser = @LatitudeUser

INSERT INTO SurchargeType(
	Description,
	SurchargeAmount,
	SurchargePercent,
	AdditionalAmount,
	AdditionalPercent,
	Active, 
	LastUpdatedBy)
VALUES(@Description,
	@SurchargeAmount,
	@SurchargePercent,
	@AdditionalAmount,
	@AdditionalPercent,
	@Active,
	@LatitudeUser)
	

SELECT @ReturnSts = @@Error
SELECT @UID = SCOPE_IDENTITY()

Return @ReturnSts

GO
