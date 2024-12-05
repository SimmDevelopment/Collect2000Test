SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_ReportTUCPEPrimary]
	@queryId as varchar(8000)
AS
BEGIN
SET NOCOUNT ON;
	
--select * from dbo.CustomStringToSet(@queryId, '|')
	Select	number			as [Number],
			Upper(ltrim(rtrim(isnull(name,''))))			as [Name],
			Upper(ltrim(rtrim(isnull(Street1,''))))			as [Address],
			Upper(ltrim(rtrim(isnull(City,''))))			as [City],
			Upper(ltrim(rtrim(isnull(State,''))))			as [State],
			Upper(ltrim(rtrim(isnull(Zipcode,''))))			as [Zipcode],
			replace(isnull(Ssn,''),'-','')				as [Ssn],
			isnull(dob,'')				as [Dob],
			'Y'				as [PermPurpCode]
	FROM debtors with (nolock)
	--Where number in @queryId and seq=0
	Where number in (select string from dbo.CustomStringToSetText(@queryId, '|')) and seq=0
END
GO
