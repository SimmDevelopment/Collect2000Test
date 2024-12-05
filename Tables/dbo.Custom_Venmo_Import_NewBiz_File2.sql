CREATE TABLE [dbo].[Custom_Venmo_Import_NewBiz_File2]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[account_id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sender_user_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[date_created] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sender_state] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sender_social_score] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[amounts_owed] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[first_name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[last_name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[payment_date] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[receiver_user_name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[receiver_first_name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[receiver_last_name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[payment_note] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[amount] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bank] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[amount_recovered] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[recovery_date] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[call_eligibility] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Venmo_Import_NewBiz_File2] ADD CONSTRAINT [PK_Custom_Venmo_Import_NewBiz_File2] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
