SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 03/14/2022
-- Description:	Exports Data to the Citizens FP Off Dialer Report
-- Changes:
--		07/01/2022 BGM Added new field DialDate to first column
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Citizens_FP_Export_OffDialer_Report] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DECLARE @prodDate DATE
SET @prodDate = DATEADD(dd, -1, GETDATE())

SELECT FORMAT(@prodDate, 'MM/dd/yyyy') AS DialDate, RTRIM(od.Agent) AS Agent, od.[First Name] AS firstName, od.[Last Name] AS lastName, od.[Successful Op Transfer] AS successOTrans, od.[Successful OB Transfer] AS successOBTrans, od.[Successful Manual Transfer] AS successManTran, 
od.[Successful IB Transfer] AS successIBTran, od.[Successful Transactional Email] AS successTranEmail, od.[Successful Transactional SMS] AS successTranSMS, od.[In Call (Min)] AS InCallMin, od.[In Call (%)] AS InCallPerc, 
od.[Ready (Min)] AS readyMin, od.[Ready (%)] AS readyPerc, od.[Wrapup (Min)] AS wrapupMin, od.[Wrapup (%)] AS wrapupPerc, od.[Not Ready (Min)] AS notReadyMin, od.[Not Ready (%)] AS notReadyPerc, od.[Lunch (Mins)] AS lunchMin, 
od.[Lunch %] AS lunchPerc, od.[Training (Mins)] AS trainMin, od.[Training %] AS trainPerc, od.[Break Time (Mins)] AS breakMin, od.[Break Time %] AS breakPerc, od.[Meeting (Mins)] AS meetMin, od.[Meeting %] AS meetPerc, 
od.[Technical Difficulty (Mins)] AS techDiffMin, od.[Technical Difficulty %] AS techDiffPerc, od.[Other (Mins)] AS otherMin, od.[Other %] AS otherPerc, od.[Agent System Time (Min)] AS agentSysTimeMin, 
od.[Agent Productive Time (Min)] AS agentProdTimeMin, od.[Avg Calls Handled   Agent Talk Hr] AS avgCallsHandTalkHr, od.[Avg Calls Handled   Agent System Hr] AS avgCallsHandSysHr, od.[Avg Call Length (Min)] AS avgCallLenMin, 
od.[RPC   Payment PTP] AS rpcPayPTP, od.[RPC   No Payment PTP] AS rpcNoPayPTP, od.WPC, od.[Non-Contacts] AS noContact, od.[Total RPCs] AS totalRPC, od.[Total RPCs   Agent System Hr] AS totalRPCSysHr, od.[RPC Rate(%)] AS rpcRatePerc, od.[Conversion Rate(%)] AS convRatePerc
FROM DCLatitude.citizens.OffDialer od WITH (NOLOCK) 
WHERE CAST(od.ProductionDate AS DATE) = CAST(@prodDate AS DATE)


END
GO
