SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_ACCD_Export_Placement_File]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  FPSYSN , FPPRIN , FPCOLL , FPACCT , FPPNME , FPSNME , FPCFLG , FPWKPH , FPHMPH , FPXSTA , FPISTA , FPCBAL , FPCRLN , FPAMTD , FPDAYD , FPDTLP , 
 FPAMLP , FPZPCD , FPBSCR , FPRMTN , FPAFLG , FPADR1 , FPADR2 , FPCITY , FPSTAT , FPZIP4 , FPSECF , FPSPF , FP6MF , FPAFMT , FPPRDT , FPPRAM , FPLREA , 
 FPSTAC , FPSSN , FPWRKD , FPMNCK , FPPORT , FPUDRP , FPSC58 , FPMIS1 , FPMIS2 , FPMIS3 , FPMIS4 , FPMIS5 , FPMIS6 , FPMIS7 , FPMIS8 , FPMIS9 , FPMI10 ,
 FPFIXP , FPCURP , FPEXPD , FPCRDF , FPNMOG , FP1CYC , FP2CYC , FP3CYC , FPCRDS , FPCRRN , FPRGED , FPPMTA , FPRYAM , FPRTTL , FPRTND , FPRTNA , FPUDR2 ,
 FPUDR3 , FPUDR4 , FPSTRC , FPOPND , FPSTCD , FPFLG1 , FPFLG2 , FPFLG3 , FPFLG4 , FPCYCL , FPORAC , FPRAND , FPD1CA , FPD2CA , FPD3CA , FPD4CA , FPD5CA ,
 FPD6CA , FPD7CA , FPPH1 , FPPF1 , FPPM1 , FPPB1 , FPPP1 , FPPC1 , FPPH2 , FPPF2 , FPPM2 , FPPB2 , FPPP2 , FPPC2 , FPHHMM
FROM Custom_ACCD_Import_File caif WITH (NOLOCK)
WHERE fpxsta NOT IN ('b', 'f', 'l', 'u', 'z', 'i') AND fpista IN ('d', 'x') AND fpdayd >= '040'
AND SUBSTRING(fpmis7, 1, 3) NOT IN ('SP1', 'SP2', 'TP1', 'TP2' ,'UP1', 'UP2', 'VP1', 'VP2', 'WP1', 'WP2')
AND fpcurp NOT IN ('CCU3','COLZ', 'HRDM','HRD1','HRD2','HRD3', 'CAI1','CAI2','CA0%','CA10','CA15','CMI1','CMI2','CM0%','CM10','CM15')
AND fpudrp not in ('LIQD','NLIQ','LIQN','LIQL','LEGL')
AND fpstrc not in (62)
AND SUBSTRING(fpmis4,7,1) not in ('K','Z')
AND SUBSTRING(fpmi10,6,1) not in ('A')
AND SUBSTRING(fpmis7,10,1) not in ('B') 
AND fpcoll not in (95,41,42, 545)
AND SUBSTRING(fpmis9,8,1) not in ('P','C')
AND fpacct NOT IN (SELECT account FROM master m WITH (NOLOCK) WHERE customer = '0001042' AND closed IS NOT NULL)

END
GO
