SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Union_Bank_Export_Placement_File]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  SystemNo, PrinNo, CollCode, CHDAccountNo, PrinName, SpouseName, CredBurFlag, WorkPhone, HomePhone, ExtStatus,
	        IntStatus, CurrBalance, Creditline, AmountDelq, DaysDelq, DateLastPayment, AmountLastPayment, ZipCode,
	        CreditScore, RemoteNumber, AuthFlag, AddressLine1, AddressLine2, City, State, ZipLast4, GropMMBRTypeCD, Filler,
	        Format, PIID, SocSecurityNo, SecondarySocSecurityNo, NextCyclDT, Del1CYCAMT, Del2CYCAMT, Del3CYCAMT, Del4CYCAMT,
	        Del5CYCAMT, Del6CYCAMT, Del7CYCAMT, Del8CYCAMT, OpenDate
	FROM Custom_UnionBank_Import_Dial_File c WITH (NOLOCK)
WHERE CHDAccountNo NOT IN (SELECT account FROM master m WITH (NOLOCK) WHERE customer = '0001103' AND closed IS NOT NULL)

END
GO
