SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*Account_WorkStats_Add Procedure*/
CREATE PROCEDURE [dbo].[Account_WorkStats_Add]
	@AccountID	int,
	@Dialer		bit,
	@Worked		bit,
	@Contact	bit,
	@TimeFrame	tinyint
AS

 /*
**Name		:Account_WorkStats_Add	
**Function	:Adds/Updates a record in the Account_WorkStats Table
**Creation	:mr 11/28/2003
**Used by 	:Latitude and Dialer Update programs		
**Parameters	:@AccountID	the account being updated
		:@Dialer	If a dialer worked or caused contact @Dialer=True, else if manual worked/contact=false
		:@Worked	True if the stat being recorded is a 'worked' stat
		:@Contact	True if the stat being recorded is a 'contact' stat
		:@TimeFrame	1=morning, 2=afternoon, 3=evening, 4=weekend
**Change History:10/18/2004 mr  added IF @Contact = 1 SET @Worked = 1.  Cant have a contact without a worked.
*/

Declare @Morning_DW	tinyint
Declare @Afternoon_DW	tinyint
Declare @Evening_DW	tinyint
Declare @Weekend_DW	tinyint
Declare @Morning_DC	tinyint
Declare @Afternoon_DC	tinyint
Declare @Evening_DC	tinyint
Declare @Weekend_DC	tinyint
Declare @Morning_MW	tinyint
Declare @Afternoon_MW	tinyint
Declare @Evening_MW	tinyint
Declare @Weekend_MW	tinyint
Declare @Morning_MC	tinyint
Declare @Afternoon_MC	tinyint
Declare @Evening_MC	tinyint
Declare @Weekend_MC	tinyint

SET @Morning_DW = 0
SET @Afternoon_DW = 0
SET @Evening_DW = 0
SET @Weekend_DW = 0
SET @Morning_DC = 0
SET @Afternoon_DC = 0
SET @Evening_DC = 0
SET @Weekend_DC = 0
SET @Morning_MW = 0
SET @Afternoon_MW = 0
SET @Evening_MW = 0
SET @Weekend_MW = 0
SET @Morning_MC = 0
SET @Afternoon_MC = 0
SET @Evening_MC = 0
SET @Weekend_MC = 0

IF @Contact = 1 SET @Worked = 1

IF @Dialer = 1 BEGIN
	IF @Worked = 1 BEGIN
		IF @TimeFrame = 1 SET @Morning_DW = 1
		IF @TimeFrame = 2 SET @Afternoon_DW = 1
		IF @TimeFrame = 3 SET @Evening_DW = 1
		IF @TimeFrame = 4 SET @Weekend_DW = 1
	END
	IF @Contact = 1 BEGIN
		IF @TimeFrame = 1 SET @Morning_DC = 1
		IF @TimeFrame = 2 SET @Afternoon_DC = 1
		IF @TimeFrame = 3 SET @Evening_DC = 1
		IF @TimeFrame = 4 SET @Weekend_DC = 1
	END
END
ELSE BEGIN
	IF @Worked = 1 BEGIN
		IF @TimeFrame = 1 SET @Morning_MW = 1
		IF @TimeFrame = 2 SET @Afternoon_MW = 1
		IF @TimeFrame = 3 SET @Evening_MW = 1
		IF @TimeFrame = 4 SET @Weekend_MW = 1
	END
	IF @Contact = 1 BEGIN
		IF @TimeFrame = 1 SET @Morning_MC = 1
		IF @TimeFrame = 2 SET @Afternoon_MC = 1
		IF @TimeFrame = 3 SET @Evening_MC = 1
		IF @TimeFrame = 4 SET @Weekend_MC = 1
	END
END

Select AccountID from Account_WorkStats where AccountID = @AccountID

IF @@Rowcount = 0 
	INSERT INTO Account_WorkStats(AccountID)VALUES(@AccountID)

UPDATE Account_WorkStats SET
	 Morning_DW = Morning_DW + @Morning_DW,
	 Afternoon_DW = Afternoon_DW + @Afternoon_DW,
	 Evening_DW =Evening_DW + @Evening_DW,
	 Weekend_DW = Weekend_DW + @Weekend_DW,
	 Morning_DC = Morning_DC + @Morning_DC,
	 Afternoon_DC = Afternoon_DC + @Afternoon_DC,
	 Evening_DC = Evening_DC + @Evening_DC,
	 Weekend_DC = Weekend_DC + @Weekend_DC,
	 Morning_MW = Morning_MW + @Morning_MW,
	 Afternoon_MW = Afternoon_MW + @Afternoon_MW,
	 Evening_MW = Evening_MW + @Evening_MW,
	 Weekend_MW = Weekend_MW + @Weekend_MW,
	 Morning_MC = Morning_MC + @Morning_MC,
	 Afternoon_MC = Afternoon_MC + @Afternoon_MC,
	 Evening_MC = Evening_MC + @Evening_MC,
	 Weekend_MC = Weekend_MC + @Weekend_MC
WHERE AccountID = @AccountID

Return @@Error

GO
