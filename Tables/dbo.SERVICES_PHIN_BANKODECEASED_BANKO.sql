CREATE TABLE [dbo].[SERVICES_PHIN_BANKODECEASED_BANKO]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[Case_number] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Chapter] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Noticetype] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Assets] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filed_date] [datetime] NULL,
[Discharge_date] [datetime] NULL,
[Dismissal_date] [datetime] NULL,
[Converted_date] [datetime] NULL,
[Closed_date] [datetime] NULL,
[Re-opened_date] [datetime] NULL,
[vacate_date] [datetime] NULL,
[Transferred_date] [datetime] NULL,
[Claim_date_bar_date] [datetime] NULL,
[Objection_Date] [datetime] NULL,
[Plan_Confirm_Date] [datetime] NULL,
[341_Date] [datetime] NULL,
[341_Time] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[341_Location] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Bc_id] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Courtid] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Courtdist] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Division] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Courtaddr1] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Courtaddr2] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Courtcity] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Courtstate] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Courtzip] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Courtphone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Court_Email] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Judge] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Judge_Initials] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Account_pri_sec] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Pri_Sec_Debtor] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Voluntary_Involuntary] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_first] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_middle] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_last] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_suffix] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_alias1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_alias2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_alias3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_alias4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_SSN] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_Taxid] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_address1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_address2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_address3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_address4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_city] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_state] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_zip] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_phone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_email] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_county] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_lawfirm] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_attorney] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_attorneyaddress1] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_attorneyaddress2] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_attorneyaddress3] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_attorneyaddress4] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_attorneycity] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_attorneystate] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_attorneyzip] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_attorneyphone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtor_attorney_email] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Trustee_id] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Trustee_name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Trustee_address1] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Trustee_address2] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Trustee_address3] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Trustee_address4] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Trustee_city] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Trustee_state] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Trustee_zip] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Trustee_phone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Trustee_email] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Creditor_number] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Creditor_name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Creditor_address1] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Creditor_address2] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Creditor_address3] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Creditor_address4] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Creditor_city] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Creditor_state] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Creditor_zip] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filler] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Matchcode] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sentdate] [datetime] NULL,
[Clientcode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Matchstring] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SERVICES_PHIN_BANKODECEASED_BANKO] ADD CONSTRAINT [PK_SERVICES_PHIN_BANKODECEASED_BANKO] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
