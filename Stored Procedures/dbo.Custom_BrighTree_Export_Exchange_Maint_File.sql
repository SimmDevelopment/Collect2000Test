SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_BrighTree_Export_Exchange_Maint_File]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  CommunicationType,
CommunicationIdent AS CommunicationID ,
        RSPLastName ,
        RSPFirstName ,
        DebtorIdent AS DebtorID ,
        PatientAccountNo ,
        CreditorName ,
        CommunicationDate ,
        PaymentDate ,
        Amount ,
        CurrentBalance ,
        CommunicationText ,
        CreditorContactFirstName ,
        CreditorContactLastName ,
        CreditorContactEmail ,
        CreditorContactPhone ,
        CreditorContactExtension
FROM Custom_BrighTree_Maintenance_Table cbtmt
WHERE CommunicationType <> 'Other'


END
GO
