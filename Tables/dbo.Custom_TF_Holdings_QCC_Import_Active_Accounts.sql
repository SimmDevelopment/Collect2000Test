CREATE TABLE [dbo].[Custom_TF_Holdings_QCC_Import_Active_Accounts]
(
[ID] [int] NOT NULL,
[loan_series_number] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[loan_balance] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cure_amount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[loan_series_create_date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[last_payment_date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[last_payment_amount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[payment_due_date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[days_past_due] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone_1_Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone_1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone_2_Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone_2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone_3_Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone_3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcceptableStartTime] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcceptableEndTime] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TimeZone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsVIP] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsCovid] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
