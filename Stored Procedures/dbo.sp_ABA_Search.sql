SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








/*CREATE       PROCEDURE sp_ABA_Search*/
CREATE       PROCEDURE [dbo].[sp_ABA_Search]
	@MICR varchar (9),
	@Bank varchar (50),
	@City varchar (30),
	@State varchar (2),
	@Zip varchar (9)
AS 
/*
** Name:		sp_ABA_Search
** Function:		This procedure will search ABA
** 			using input parameters.
** Creation:		7/3/2002 jc
**			Used by class CABARoutingFactory. 
** Change History:
*/
	SELECT *
		FROM ABA
		WHERE (MICR Like @MICR + '%') 
			And (LTRIM(Bank) Like @Bank + '%')  
			And (isnull(City,'') Like @City + '%')
			And (isnull(State,'') Like @State + '%')
			And (isnull(Zip,'') Like @Zip + '%')
		ORDER BY Bank
GO
