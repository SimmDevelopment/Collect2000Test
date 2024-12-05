CREATE TABLE [dbo].[HCFAForms]
(
[form_uid] [int] NOT NULL IDENTITY(1, 1),
[number] [int] NULL,
[seq_id] [int] NULL,
[claim_ty] [smallint] NULL,
[emp_rel_flg] [bit] NULL,
[auto_acc_rel_flg] [bit] NULL,
[oth_acc_rel_flg] [bit] NULL,
[acc_state_cd] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[curr_claim_dte] [datetime] NULL,
[first_occur_dte] [datetime] NULL,
[oow_start_dte] [datetime] NULL,
[oow_end_dte] [datetime] NULL,
[hosp_start_dte] [datetime] NULL,
[hosp_end_dte] [datetime] NULL,
[reserved19_txt] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[outside_lab_flg] [bit] NULL,
[outside_lab_amt] [money] NULL,
[diag_1_no] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[diag_1_desc] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[diag_2_no] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[diag_2_desc] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[diag_3_no] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[diag_3_desc] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[diag_4_no] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[diag_4_desc] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[med_resub_no] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[med_orig_ref_no] [varchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prior_auth_txt] [varchar] (29) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[accept_assign_flg] [bit] NULL,
[total_charge_amt] [money] NULL,
[total_paid_amt] [money] NULL,
[total_bal_amt] [money] NULL,
[pat_full_nm] [varchar] (29) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pat_birth_dte] [datetime] NULL,
[pat_sex_cd] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pat_address_txt] [varchar] (29) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pat_city_txt] [varchar] (24) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pat_state_cd] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pat_zip_cd] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pat_phone] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pat_rel_ins] [smallint] NULL,
[pat_marital_stat] [smallint] NULL,
[pat_empl_stat] [smallint] NULL,
[reserved10_txt] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pat_sig_on_file_flg] [bit] NULL,
[pat_sig_dte] [datetime] NULL,
[ins_id_txt] [varchar] (29) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ins_full_nm] [varchar] (29) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ins_address_txt] [varchar] (29) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ins_city_txt] [varchar] (23) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ins_state_cd] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ins_zip_cd] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ins_phone] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ins_pol_nm] [varchar] (24) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ins_birth_dte] [datetime] NULL,
[ins_sex_cd] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ins_emp_sch_txt] [varchar] (29) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ins_plan_nm] [varchar] (29) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[oth_plan_flg] [bit] NULL,
[ins_sig_on_file_flg] [bit] NULL,
[ins_sig_dte] [datetime] NULL,
[oth_full_nm] [varchar] (29) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[oth_pol_nm] [varchar] (29) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[oth_birth_dte] [datetime] NULL,
[oth_sex_cd] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[oth_emp_sch_txt] [varchar] (29) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[oth_plan_nm] [varchar] (29) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prov_ref_nm] [varchar] (26) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prov_ref_id] [varchar] (21) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prov_sig_on_file_flg] [bit] NULL,
[prov_sig_dte] [datetime] NULL,
[prov_tax_id_no] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prov_tax_id_ty] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prov_pat_acct_no] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prov_fac_nm] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prov_fac_add_txt] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prov_fac_csz] [varchar] (29) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prov_bill_nm] [varchar] (29) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prov_bill_add_txt] [varchar] (29) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prov_bill_csz] [varchar] (29) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prov_pin_cd] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prov_grp_cd] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[timestamp] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HCFAForms] ADD CONSTRAINT [PK_HCFAForms] PRIMARY KEY NONCLUSTERED ([form_uid]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'acc_state_cd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'accept_assign_flg'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'auto_acc_rel_flg'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'claim_ty'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'curr_claim_dte'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'diag_1_desc'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'diag_1_no'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'diag_2_desc'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'diag_2_no'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'diag_3_desc'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'diag_3_no'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'diag_4_desc'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'diag_4_no'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'emp_rel_flg'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'first_occur_dte'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'form_uid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'hosp_end_dte'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'hosp_start_dte'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'ins_address_txt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'ins_birth_dte'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'ins_city_txt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'ins_emp_sch_txt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'ins_full_nm'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'ins_id_txt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'ins_phone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'ins_plan_nm'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'ins_pol_nm'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'ins_sex_cd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'ins_sig_dte'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'ins_sig_on_file_flg'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'ins_state_cd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'ins_zip_cd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'med_orig_ref_no'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'med_resub_no'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'oow_end_dte'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'oow_start_dte'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'oth_acc_rel_flg'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'oth_birth_dte'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'oth_emp_sch_txt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'oth_full_nm'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'oth_plan_flg'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'oth_plan_nm'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'oth_pol_nm'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'oth_sex_cd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'outside_lab_amt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'outside_lab_flg'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'pat_address_txt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'pat_birth_dte'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'pat_city_txt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'pat_empl_stat'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'pat_full_nm'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'pat_marital_stat'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'pat_phone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'pat_rel_ins'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'pat_sex_cd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'pat_sig_dte'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'pat_sig_on_file_flg'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'pat_state_cd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'pat_zip_cd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'prior_auth_txt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'prov_bill_add_txt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'prov_bill_csz'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'prov_bill_nm'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'prov_fac_add_txt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'prov_fac_csz'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'prov_fac_nm'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'prov_grp_cd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'prov_pat_acct_no'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'prov_pin_cd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'prov_ref_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'prov_ref_nm'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'prov_sig_dte'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'prov_sig_on_file_flg'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'prov_tax_id_no'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'prov_tax_id_ty'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'reserved10_txt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'reserved19_txt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'seq_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'timestamp'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'total_bal_amt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'total_charge_amt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAForms', 'COLUMN', N'total_paid_amt'
GO
