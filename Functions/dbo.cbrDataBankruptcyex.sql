SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[cbrDataBankruptcyex]
    ( @debtorid int)
RETURNS TABLE
AS 
    RETURN						
			select b.debtorid,b.accountid,
                       b.chapter AS bankruptcychapter,
                       CASE when b.chapter is not null then
							case when b.chapter in (7,11,12,13) then
								case when isnull(b.dateFiled,'19000101') <> (select max(d2.d1) from (select b.dateNotice as d1 union select b.proofFiled union select b.dateTime341 union select b.WithdrawnDate union select '19000101') d2)  
									and isnull(b.dischargeDate,'19000101') = (select max(d2.d1) from (select b.dismissalDate as d1 union select b.reaffirmDateFiled union select '19000101') d2)
									and isnull(b.dismissalDate,'19000101') = (select max(d2.d1) from (select b.dischargeDate as d1  union select b.reaffirmDateFiled union select '19000101') d2)
									and isnull(b.reaffirmDateFiled,'19000101') = (select max(d2.d1) from (select b.dischargeDate as d1  union select b.dismissalDate union select '19000101') d2)
									or isnull(b.dateFiled,'19000101') > (select max(d2.d1) from (select b.withdrawndate as d1 union select b.dischargeDate union select b.dismissalDate union select b.reaffirmDateFiled union select '19000101') d2) then
									case when b.chapter = 7 then 'A'
										when b.chapter = 11 then 'B'
										when b.chapter = 12 then 'C'
										when b.chapter = 13 then 'D'
									else 'Z' end
								else case when isnull(b.dischargeDate,'19000101') > (select max(d2.d1) from (select b.dismissalDate as d1 union select b.reaffirmDateFiled union select '19000101') d2) then
										case when b.chapter = 7 then 'E'
											when b.chapter = 11 then 'F'
											when b.chapter = 12 then 'G'
											when b.chapter = 13 then 'H'
										else 'Z' end
									else case when isnull(b.dismissalDate,'19000101') > (select max(d2.d1) from (select b.dischargeDate as d1 union select b.reaffirmDateFiled union select '19000101') d2) then	
											case when b.chapter = 7 then 'I'
												when b.chapter = 11 then 'J'
												when b.chapter = 12 then 'K'
												when b.chapter = 13 then 'L'
											else 'Z' end
									  else case when isnull(b.withdrawndate,'19000101') > (select max(d2.d1) from (select b.DateFiled as d1 union select '19000101') d2) then	
											case when b.chapter = 7 then 'M'
												when b.chapter = 11 then 'N'
												when b.chapter = 12 then 'O'
												when b.chapter = 13 then 'P'
											else 'Z' end
										   else case when isnull(b.reaffirmDateFiled,'19000101') > (select max(d2.d1) from (select b.dischargeDate as d1 union select b.dismissalDate union select '19000101') d2) then
												case when b.chapter = 7 then 'R'
													when b.chapter = 11 then 'R'
													when b.chapter = 12 then 'R'
													when b.chapter = 13 then 'R'
												else 'Z' end
											else 'Z' end
										end
										end
									end
								end
							else 'Z' end
						else '' 
						end AS nextinformationindicator,
						DATEADD(D,-1,CAST(CAST(YEAR(DATEADD(m,1,b.[DateFiled])) AS VARCHAR(4)) + RIGHT('0' + CAST(MONTH(DATEADD(m,1,b.[DateFiled])) AS VARCHAR(2)),2) + '01' AS DATETIME)) as [DateFiledEoM],
						DATEADD(D,-1,CAST(CAST(YEAR(DATEADD(m,1,b.[DischargeDate])) AS VARCHAR(4)) + RIGHT('0' + CAST(MONTH(DATEADD(m,1,b.[DischargeDate])) AS VARCHAR(2)),2) + '01' AS DATETIME)) as [DischargeDateEoM],
						DATEADD(D,-1,CAST(CAST(YEAR(DATEADD(m,1,b.[DismissalDate])) AS VARCHAR(4)) + RIGHT('0' + CAST(MONTH(DATEADD(m,1,b.[DismissalDate])) AS VARCHAR(2)),2) + '01' AS DATETIME)) as [DismissalDateEoM] 

			from Bankruptcy b
			where	b.debtorid = @debtorid 
GO
