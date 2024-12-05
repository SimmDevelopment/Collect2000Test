SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[AIM_InsertContactEx]

@ContactTypeID int,
@GroupID int,
@Username varchar(50)
AS

DECLARE @contactid int
INSERT INTO AIM_Contact (ContactTypeID,CreatedBy,UpdatedBy,QuestionnaireReceived,ConfidentialityReceived) VALUES (@ContactTypeID,@Username,@Username,0,0)
SELECT @contactid = @@IDENTITY

INSERT INTO AIM_GroupContactASSN (GroupID,ContactID,OwnershipPercentage) VALUES (@GroupID,@contactid,0)

SELECT @contactid





GO
