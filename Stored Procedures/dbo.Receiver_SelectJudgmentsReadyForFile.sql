SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Receiver_SelectJudgmentsReadyForFile]
@clientid int
AS
BEGIN

	DECLARE @lastFileSentDT datetime
	SELECT @lastFileSentDT = dbo.Receiver_GetLastFileDate(23,@clientid)

 			/*<column name="record_type" dataType="string" width="4" />
			<column name="file_number" dataType="int" width="9" />
			<column name="JudgementFlag" dataType="string" width="1" /> 
			<column name="CaseNumber" dataType="string" width="50" />
			<column name="JudgementAmt" dataType="decimal" width="12" />
			<column name="JudgementIntAward" dataType="decimal" width="12" />
			<column name="JudgementCostAward" dataType="decimal" width="12" />
			<column name="JudgementAttorneyCostAward" dataType="decimal" width="12" />
			<column name="JudgementOtherAward" dataType="decimal" width="12" />
			<column name="JudgementIntRate" dataType="decimal" width="5" />
			<column name="IntFromDate" dataType="dateTime" width="8" />
			<column name="AttorneyAckDate" dataType="dateTime" width="8" />
			<column name="DateFiled" dataType="dateTime" width="8" />
			<column name="ServiceDate" dataType="dateTime" width="8" />
			<column name="JudgementDate" dataType="dateTime" width="8" />
			<column name="JudgementRecordedDate" dataType="dateTime" width="8" />
			<column name="DateAnswered" dataType="dateTime" width="8" />
			<column name="StatuteDeadline" dataType="dateTime" width="8" />
			<column name="CourtDate" dataType="dateTime" width="8" />
			<column name="DiscoveryCutoff" dataType="dateTime" width="8" />
			<column name="DiscoveryReplyDate" dataType="dateTime" width="8" />
			<column name="MotionCutoff" dataType="dateTime" width="8" />
			<column name="ArbitrationDate" dataType="dateTime" width="8" />
			<column name="LastSummaryJudgementDate" dataType="dateTime" width="8" />
			<column name="Status" dataType="string" width="50" />
			<column name="ServiceType" dataType="string" width="20" />
			<column name="MiscInfo1" dataType="string" width="100" />
			<column name="MiscInfo2" dataType="string" width="100" />
			<column name="Remarks" dataType="string" width="100" />
			<column name="Plaintiff" dataType="string" width="100" />
			<column name="Defendant" dataType="string" width="100" />
			<column name="JudgementBook" dataType="string" width="20" />
			<column name="JudgementPage" dataType="string" width="20" />
			<column name="Judge" dataType="string" width="100" />
			<column name="CourtRoom" dataType="string" width="15" />
			<column name="CourtName" dataType="string" width="50" />
			<column name="CourtCounty" dataType="string" width="50" />
			<column name="CourtStreet1" dataType="string" width="50" />
			<column name="CourtStreet2" dataType="string" width="50" />
			<column name="CourtCity" dataType="string" width="50" />
			<column name="CourtState" dataType="string" width="5" />
			<column name="CourtZipcode" dataType="string" width="10" />
			<column name="CourtPhone" dataType="string" width="50" />
			<column name="CourtFax" dataType="string" width="50" />
			<column name="CourtSalutation" dataType="string" width="50" />
			<column name="CourtClerkFirstName" dataType="string" width="50" />
			<column name="CourtClerkMiddleName" dataType="string" width="50" />
			<column name="CourtClerkLastName" dataType="string" width="50" />
			<column name="CourtNotes" dataType="string" width="250" />*/
	SELECT
		'AJDG' as record_type, -- <column name="record_type" dataType="string" width="4" />
		r.sendernumber as file_number,--<column name="file_number" dataType="int" width="9" />
		-- I believe this still needs some work, need to get a better handle as to how a Reversal would be communicated.
		CASE 
			WHEN cc.Judgement IN (1) AND cc.JudgementRecordedDate IS NOT NULL AND cc.JudgementRecordedDate >= @lastFileSentDT THEN 'A' 
			ELSE 'U' 
		END as JudgementFlag,-- <column name="JudgementFlag" dataType="string" width="1" /> 
		cc.CaseNumber as CaseNumber, --<column name="CaseNumber" dataType="string" width="50" />
		cc.JudgementAmt as JudgementAmt,--<column name="JudgementAmt" dataType="decimal" width="12" />
		cc.JudgementIntAward as JudgementIntAward,--<column name="JudgementIntAward" dataType="decimal" width="12" />
		cc.JudgementCostAward as JudgementCostAward,--<column name="JudgementCostAward" dataType="decimal" width="12" />
		cc.JudgementAttorneyCostAward as JudgementAttorneyCostAward,--<column name="JudgementAttorneyCostAward" dataType="decimal" width="12" />
		cc.JudgementOtherAward as JudgementOtherAward,--<column name="JudgementOtherAward" dataType="decimal" width="12" />
		cc.JudgementIntRate as JudgementIntRate,--<column name="JudgementIntRate" dataType="decimal" width="5" />
		cc.IntFromDate as IntFromDate,--<column name="IntFromDate" dataType="dateTime" width="8" />
		cc.AttorneyAckDate as AttorneyAckDate,--<column name="AttorneyAckDate" dataType="dateTime" width="8" />
		cc.DateFiled as DateFiled,--<column name="DateFiled" dataType="dateTime" width="8" />
		cc.ServiceDate as ServiceDate,--<column name="ServiceDate" dataType="dateTime" width="8" />
		cc.JudgementDate as JudgementDate,--<column name="JudgementDate" dataType="dateTime" width="8" />
		cc.JudgementRecordedDate as JudgementRecordedDate,--<column name="JudgementRecordedDate" dataType="dateTime" width="8" />
		cc.DateAnswered as DateAnswered,--<column name="DateAnswered" dataType="dateTime" width="8" />
		cc.StatuteDeadline as StatuteDeadline,--<column name="StatuteDeadline" dataType="dateTime" width="8" />
		cc.CourtDate as CourtDate,--<column name="CourtDate" dataType="dateTime" width="8" />
		cc.DiscoveryCutoff as DiscoveryCutoff,--<column name="DiscoveryCutoff" dataType="dateTime" width="8" />
		cc.DiscoveryReplyDate as DiscoveryReplyDate,--<column name="DiscoveryReplyDate" dataType="dateTime" width="8" />
		cc.MotionCutoff as MotionCutoff,--<column name="MotionCutoff" dataType="dateTime" width="8" />
		cc.ArbitrationDate as ArbitrationDate,--<column name="ArbitrationDate" dataType="dateTime" width="8" />
		cc.LastSummaryJudgementDate as LastSummaryJudgementDate,--<column name="LastSummaryJudgementDate" dataType="dateTime" width="8" />
		cc.Status as Status,--<column name="Status" dataType="string" width="50" />
		cc.ServiceType as ServiceType,--<column name="ServiceType" dataType="string" width="20" />
		cc.MiscInfo1 as MiscInfo1,--<column name="MiscInfo1" dataType="string" width="100" />
		cc.MiscInfo2 as MiscInfo2,--<column name="MiscInfo2" dataType="string" width="100" />
		cc.Remarks as Remarks,--<column name="Remarks" dataType="string" width="100" />
		cc.Plaintiff as Plaintiff,--<column name="Plaintiff" dataType="string" width="100" />
		cc.Defendant as Defendant,--<column name="Defendant" dataType="string" width="100" />
		cc.JudgementBook as JudgementBook,--<column name="JudgementBook" dataType="string" width="20" />
		cc.JudgementPage as JudgementPage,--<column name="JudgementPage" dataType="string" width="20" />
		cc.Judge as Judge,--<column name="Judge" dataType="string" width="100" />
		cc.CourtRoom as CourtRoom,--<column name="CourtRoom" dataType="string" width="15" />
		c.CourtName as CourtName,--<column name="CourtName" dataType="string" width="50" />
		c.County as CourtCounty,--<column name="CourtCounty" dataType="string" width="50" />
		c.Address1 as CourtStreet1,--<column name="CourtStreet1" dataType="string" width="50" />
		c.Address2 as CourtStreet2,--<column name="CourtStreet2" dataType="string" width="50" />
		c.City as CourtCity,--<column name="CourtCity" dataType="string" width="50" />
		c.State as CourtState,--<column name="CourtState" dataType="string" width="5" />
		c.Zipcode as CourtZipcode,--<column name="CourtZipcode" dataType="string" width="10" />
		c.Phone as CourtPhone,--<column name="CourtPhone" dataType="string" width="50" />
		c.Fax as CourtFax,--<column name="CourtFax" dataType="string" width="50" />
		c.Salutation as CourtSalutation,--<column name="CourtSalutation" dataType="string" width="50" />
		c.ClerkFirstName as CourtClerkFirstName,--<column name="CourtClerkFirstName" dataType="string" width="50" />
		c.ClerkMiddleName as CourtClerkMiddleName,--<column name="CourtClerkMiddleName" dataType="string" width="50" />
		c.ClerkLastName as CourtClerkLastName,--<column name="CourtClerkLastName" dataType="string" width="50" />
		c.Notes as CourtNotes--<column name="CourtNotes" dataType="string" width="250" />

		  
	FROM  dbo.master m WITH (NOLOCK) 
		INNER JOIN receiver_reference r WITH (NOLOCK)
		ON r.receivernumber = m.number
		INNER JOIN [dbo].[CourtCases] cc WITH (NOLOCK)
		ON cc.[AccountID] = m.[Number]
		INNER JOIN [dbo].[Courts] c WITH (NOLOCK) -- INNER OR LEFT OUTER JOIN
		ON cc.[CourtID] = c.[CourtID]
	WHERE r.clientid = @clientid
		AND cc.[DateUpdated] > @lastFileSentDT AND cc.UpdatedBy != -1
END
GO
