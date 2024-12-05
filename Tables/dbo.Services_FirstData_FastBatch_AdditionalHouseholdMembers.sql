CREATE TABLE [dbo].[Services_FirstData_FastBatch_AdditionalHouseholdMembers]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NULL,
[HouseholdMember1Name] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HouseholdMember1AgeCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HouseholdMember1GenderCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HouseholdMember2Name] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HouseholdMember2AgeCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HouseholdMember2GenderCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HouseholdMember3Name] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HouseholdMember3AgeCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HouseholdMember3GenderCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HouseholdMember4Name] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HouseholdMember4AgeCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HouseholdMember4GenderCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HouseholdMember5Name] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HouseholdMember5AgeCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HouseholdMember5GenderCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SESIIndicator] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IncomeRange] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClusterCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DesignatedMarketArea] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AreaDominantInfluence] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LACSLinkTMReturnCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReservedforFutureUse] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_FirstData_FastBatch_AdditionalHouseholdMembers] ADD CONSTRAINT [PK_Services_FirstData_FastBatch_AdditionalHouseholdMembers] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
