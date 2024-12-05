SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan, Simm Associates
-- Create date: 10/28/2008
-- Description:	Updates special note fields with Fee amount for steam of business after loading maintenance for the account
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Resurgent_Update_Received]
	-- Add the parameters for the stored procedure here
@number INT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--Adds the fee for the stream to the special note field for the SUF WOR record
UPDATE dbo.master
SET received = dbo.date(GETDATE()), 
specialnote = CASE customer WHEN '0001029' THEN '0.2000'
							WHEN '0001121' THEN '0.2500'
							WHEN '0001134' THEN '0.5000'
							WHEN '0001186' THEN '0.1400'
							WHEN '0001188' THEN '0.2500'
							WHEN '0001316' THEN '0.2000'
							WHEN '0001457' THEN '0.2500'
							WHEN '0001466' THEN '0.1800'
							WHEN '0001549' THEN '0.3700'
							WHEN '0002771' THEN '0.5000' --Test Account, remove for production
							END
WHERE number = @number

END
GO
