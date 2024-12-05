CREATE TABLE [bck].[Phones_Master_Remove_brianm_12052023_164212]
(
[historyid] [int] NOT NULL,
[MasterPhoneID] [int] NOT NULL,
[Number] [int] NOT NULL,
[PhoneTypeID] [int] NOT NULL,
[Relationship] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneStatusID] [int] NULL,
[OnHold] [bit] NOT NULL,
[PhoneNumber] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PhoneExt] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DebtorID] [int] NULL,
[DateAdded] [datetime] NOT NULL,
[RequestID] [int] NULL,
[PhoneName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoginName] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NearbyContactID] [int] NULL,
[LastUpdated] [datetime] NULL,
[UpdatedBy] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
