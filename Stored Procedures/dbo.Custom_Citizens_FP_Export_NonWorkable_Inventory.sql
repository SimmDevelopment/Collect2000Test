SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 12/13/2022
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Citizens_FP_Export_NonWorkable_Inventory] 

AS
BEGIN

	SET NOCOUNT ON;

SELECT DISTINCT  adddap, adc1, bank_num, adc3, adc4, acct_num, acct_num2, filler0, name, name2, address, address2, zip,
        zipplus4, phone1, phone2, phone3, phone4, curbal, delamt, latpmdt, pduedt, deldays, applid, instmake, branch,
        ltcdate, loantype, ssn, filler1, nextdate, filedate, oddays, filler2, curqno, lsptprt, edacctno, aporgdt,
        fldagnt, maturdt, ddopndt, filler3, sflag, eflag, nflag, New1, New2, New3, New4, New5, SafeHarbor_Ind,
        Phone1_Type, Phone2_Type, Phone3_Type, Phone4_Type, Phone1_Consent, Phone2_Consent, Phone3_Consent,
        Phone4_Consent, Skip_Phone1, Skip_Phone2, Skip_Phone3, Skip_Phone4, Skip_Phone1_Type, Skip_Phone2_Type,
        Skip_Phone3_Type, Skip_Phone4_Type, st_code2, st_code10, auto_dial_flg_sec, st_code47, st_code50, st_code58,
        auto_dial_flg, resp_coll, mult_acct, ssn_2, coll_option_set, curr_alt, prev_alt, alt_disc_start, alt_disc_stop,
        lst_broken_dte, min_payment, home_phone_consent, business_phone_consent, at1_phone_consent, bucket, prim_city,
        prim_state, lst_worked_dte, cycle_id, dlq1_30, dlq31_60, dlq61_90, dlq91_120, dlq121_150, dlq151_180, dlq181_210,
        dlq211_240, dlq241_270, dlq271_300, dlq301_330, dlq331_plus, c_flag, hb_flag, filler4, collection_ID, collection_ID_Description
FROM Custom_Citizens_First_Party_NonWorkable_Temp_File c WITH (NOLOCK)
WHERE acct_num NOT IN (SELECT account FROM master WITH (NOLOCK) WHERE customer = '0002226')
AND c_flag NOT IN ('Y', '1')

END
GO
