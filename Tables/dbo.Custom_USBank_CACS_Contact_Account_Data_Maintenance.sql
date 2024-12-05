CREATE TABLE [dbo].[Custom_USBank_CACS_Contact_Account_Data_Maintenance]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AgencyID] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LocationCode] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcctNum] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransDate] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactID] [varchar] (24) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactRecType] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NameRelationship] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LeadContactInd] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ResponsibleParty] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreferredCurrency] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_USBank_CACS_Contact_Account_Data_Maintenance] ADD CONSTRAINT [PK_Custom_USBank_CACS_Contact_Account_Data_Maintenance] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
