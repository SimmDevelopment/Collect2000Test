SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 4/10/2020
-- Description:	Sends information back about emails and cell text messages being allowed or not
-- =============================================
CREATE PROCEDURE [dbo].[Custom_CollegeAve_Export_InputEfficiency] 
	-- Add the parameters for the stored procedure here
	@Date AS DATETIME
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT CASE WHEN Category = 'Service Transfer' THEN 'TFN' ELSE ie.Category END AS Category ,AddDate,
	ProductionDate,
	
	'' AS StaffingFiller,
	 AgentCount AS [Agents Staffed],
	 TotalAgentTime AS [Total Hours Worked],
	 AverageHoursPerAgent AS [Average Hours Per Agent],
	 '' AS CollectionFiller,
	 '' AS Inventory,
	 '' AS InboundFiller,
	  IBCallsOffered AS [Total Inbound calls],
	  IBShortAbandon AS [IB Short Abandons],
	  IBTrueAbandon AS [IB Abandons],
	  IBCallsOffered - (IBShortAbandon + IBTrueAbandon) AS [Net Inbound],  
	  IBAbandonRate AS [IB Abandon Rate],
	  IBAvgSpeedToAnswer AS [IB ASA],
	  IBAvgTalkTime / 60 AS [IB Avg Talk Time],
	  IBAvgWrapTime / 60 AS [IB Avg Wrap Time],
	  CAST(IBAvgHoldTime AS FLOAT) / 60 AS [IB Avg Hold Time],
	  IBAHT / 60 AS [IB Avg Handle Time],
	  IBRPC AS [IB RPC],
	  IBRPCRate AS [IB RPC Rate],
	  IBPTP AS [IB PTP],
	  IBPTPPerHour AS [IB PTP HR],
	  IBPTPRate AS [IB PTP Rate],
	  --'' AS [IB Num PTP Kept], -- how to get this number blank to start
	  --'' AS [IB PTP Kept Rate], -- hot to get this number blank to start
	  IBPaymentsTaken AS [IB Payments Taken],
	  IBConversionRate AS [IB Conv Rate],
	  IBHangUps AS [IB Total calls = Hang-Up],
      IBPartyHangUps AS [IB Total calls = Party HU],
      IBCallsTransferred AS [IB Calls Transferred to CS],
      IB3rdPartyContacts AS [IB 3P Contacts],
      '' AS OutboundFiller,
      OBTotalDials AS [Outbound Dials],
      OBUniqueAccountsDialed AS [OB Unique Accts Dialed],
      ISNULL(OBPenetrationRate, 0) AS [OB Pen Rate],
      OBAvgTalkTime / 60 AS [OB AVG Talk Time],
      OBAvgWrapTime / 60 AS [OB Avg Wrap Time],
      CAST(OBAvgHoldTime AS FLOAT) / 60 AS [OB Avg Hold Time],
      OBAHT / 60 AS [OB Avg Handle Time],
      OBRPC AS [OB RPC],
      OBRPCPerHour AS [OB RPC HR],
      OBRPCRate AS [OB RPC Rate],            
      OBPTP AS [OB PTPs],
      OBPTPPerHour AS [OB PTP HR],
      OBPTPRate AS [OB PTP Rate],
      OBPaymentsTaken AS [OB Payments Taken],
      OBConversionRate AS [OB Conv Rate],      
       --'' AS [OB Dollars Collected],
      OBMessagesLeft AS [OB Messages Left],
      OBBusy AS [OB Busy],      
      OBRefusedAuth AS [OB Refused Auth],
      OBHangUps AS [OB Total calls = Hang-up],
      OBPartyHangups AS [OB Total calls = 3P HU],
      OBCallsTransferred AS [OB Calls Transferred to CS],
      OB3rdPartyContacts AS [OB 3P Contacts],
      OBDroppedCalls AS [OB Dropped Calls],
      OBTotalNonConnects AS [OB Non Connects]
      --'' AS [OB PTP Kept], --blank to start
      
FROM DCLatitude.CollegeAve.CollegeAveInputEfficiency ie WITH (NOLOCK)
WHERE CAST(ProductionDate AS DATE) = CAST(DATEADD(dd, -1, @Date) AS DATE)
--AND ie.Category = '1st Party'
	
END
GO
