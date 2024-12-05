CREATE TABLE [dbo].[CitizensDialerFile_December]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[adddap] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[adc1] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bank_num] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[adc3] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[adc4] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acct_num] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acct_num2] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[filler0] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name2] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address2] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[zip] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[zipplus4] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone1] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone2] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone3] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone4] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[curbal] [nvarchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delamt] [nvarchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[latpmdt] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pduedt] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[deldays] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[applid] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[instmake] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[branch] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ltcdate] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[loantype] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ssn] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[filler1] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nextdate] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[filedate] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[oddays] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[filler2] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[curqno] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lsptprt] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[edacctno] [nvarchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[aporgdt] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fldagnt] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[maturdt] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ddopndt] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[filler3] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sflag] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[eflag] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nflag] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[New1] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[New2] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[New3] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[New4] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[New5] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SafeHarbor_Ind] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone1_Type] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone2_Type] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone3_Type] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone4_Type] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone1_Consent] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone2_Consent] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone3_Consent] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone4_Consent] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Skip_Phone1] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Skip_Phone2] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Skip_Phone3] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Skip_Phone4] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Skip_Phone1_Type] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Skip_Phone2_Type] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Skip_Phone3_Type] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Skip_Phone4_Type] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[st_code2] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[st_code10] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[auto_dial_flg_sec] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[st_code47] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[st_code50] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[st_code58] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[auto_dial_flg] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[resp_coll] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mult_acct] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ssn_2] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[coll_option_set] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[curr_alt] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_alt] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[alt_disc_start] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[alt_disc_stop] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lst_broken_dte] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[min_payment] [nvarchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[home_phone_consent] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[business_phone_consent] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[at1_phone_consent] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bucket] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prim_city] [nvarchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prim_state] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lst_worked_dte] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cycle_id] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dlq1_30] [nvarchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dlq31_60] [nvarchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dlq61_90] [nvarchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dlq91_120] [nvarchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dlq121_150] [nvarchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dlq151_180] [nvarchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dlq181_210] [nvarchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dlq211_240] [nvarchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dlq241_270] [nvarchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dlq271_300] [nvarchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dlq301_330] [nvarchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dlq331_plus] [nvarchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[c_flag] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[hb_flag] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[filler4] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[collection_ID] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[collection_ID_Description] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CitizensDialerFile_December] ADD CONSTRAINT [PK_CitizensDialerFile_December] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
