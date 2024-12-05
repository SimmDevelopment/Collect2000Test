SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_SelectContact]

@ContactID int,
@GroupID int

AS

SELECT * FROM AIM_Contact WHERE ContactID = @ContactID

SELECT OwnershipPercentage FROM AIM_GroupContactASSN WHERE
ContactID = @ContactID AND GroupID = @GroupID

SELECT StateCode as Code FROM AIM_ContactStateASSN WHERE ContactID = @ContactID

SELECT p.[Name] FROM AIM_PaperType p 
JOIN AIM_ContactPaperASSN cpa
ON p.ID = cpa.PaperTypeID 
WHERE cpa.ContactID = @ContactID

SELECT m.[Name] FROM AIM_ContactMembershipASSN acm 
JOIN AIM_Membership m ON acm.MembershipID = m.ID
WHERE acm.ContactID = @ContactID


GO
