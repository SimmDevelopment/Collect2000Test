CREATE TABLE [dbo].[Custom_AFF_Outsourcer_Phones_Import]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ACCOUNTHOLDER_PHONES_PLACEMENT_ACCOUNTHOLDER_PHONES] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACCOUNTHOLDER_PHONES_OUTSOURCERACCOUNTID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACCOUNTHOLDER_PHONES_ACCOUNTHOLDERREF] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACCOUNTHOLDER_PHONES_COUNTRYCODE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACCOUNTHOLDER_PHONES_PHONENUMBER] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACCOUNTHOLDER_PHONES_EXTENSION] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACCOUNTHOLDER_PHONES_PHONE_TYPE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACCOUNTHOLDER_PHONES_HASCONTACTCONSENT] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACCOUNTHOLDER_PHONES_HASDIALERCONSENT] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACCOUNTHOLDER_PHONES_HASSMSCONSENT] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_AFF_Outsourcer_Phones_Import] ADD CONSTRAINT [PK_Custom_AFF_Outsourcer_Phones_Import] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
