CREATE TABLE [dbo].[Linking_Configuration]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Class] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LinkMode] [int] NOT NULL,
[CustomGroupID] [int] NOT NULL,
[CrossBranch] [bit] NOT NULL,
[LinkThreshold] [int] NOT NULL,
[PossibleLinkThreshold] [int] NOT NULL,
[LastNameScore] [int] NOT NULL,
[FullNameScore] [int] NOT NULL,
[SSNScore] [int] NOT NULL,
[PhoneScore] [int] NOT NULL,
[DLNumScore] [int] NOT NULL,
[DOBScore] [int] NOT NULL,
[StreetScore] [int] NOT NULL,
[CityScore] [int] NOT NULL,
[ZipCodeScore] [int] NOT NULL,
[AccountScore] [int] NOT NULL,
[ID1Score] [int] NOT NULL,
[ID2Score] [int] NOT NULL,
[EvaluateDriver] [bit] NOT NULL,
[LinkDriverMode] [int] NOT NULL,
[FavorCollectorDesk] [bit] NOT NULL,
[FavorPDCs] [bit] NOT NULL,
[FavorPromises] [bit] NOT NULL,
[DriverQueueLevel] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FollowerQueueLevel] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ShuffleAccounts] [bit] NOT NULL,
[MoveInventoryToCollectorDesk] [bit] NOT NULL,
[DeskConflictSupervisorQueueLevel] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MovePromisesToNewDriver] [bit] NOT NULL CONSTRAINT [DF__Linking_C__MoveP__4027DFE9] DEFAULT ((-1)),
[DeskLinkingMode] [tinyint] NOT NULL CONSTRAINT [def_Linking_Configuration_DeskLinkingType] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Linking_Configuration] ADD CONSTRAINT [ck_Linking_Configuration_ClassCustomer] CHECK (([Class] IS NULL OR [Customer] IS NULL))
GO
ALTER TABLE [dbo].[Linking_Configuration] ADD CONSTRAINT [pk_Linking_Configuration] PRIMARY KEY NONCLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Linking_Configuration_ClassCustomer] ON [dbo].[Linking_Configuration] ([Class], [Customer]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Linking_Configuration] ADD CONSTRAINT [uq_Linking_Configuration_ClassCustomer] UNIQUE NONCLUSTERED ([Class], [Customer]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table is used by Linking Console to set options and thresholds that are used to link accounts', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Weighted score for matching Account number on master', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'AccountScore'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Weighted score for matching City', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'CityScore'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Class of business of the respective Customer', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'Class'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'Class'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator when set allows accounts to be linked across Branchcodes', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'CrossBranch'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer Code', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'Customer'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'Customer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity ID of respective CustomCustGroup when link mode option 4 is set.', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'CustomGroupID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Supervisor queue level (700-799) to receive linked accounts where multiple collectors have worked the accounts. Only used if the shuffle accounts indicator is set above', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'DeskConflictSupervisorQueueLevel'
GO
EXEC sp_addextendedproperty N'MS_Description', N'(1)   All open accounts that permit linking  All of the open accounts in the existing link must be assigned to a desk that permits linking, otherwise the new account will not join the link. If there are no open accounts in the existing link then it applies the same logic to the closed accounts, requiring them all to be assigned to desks that permit linking.   (2)   Any open account that permits linking  At least one of the open accounts in the existing link must be assigned to a desk that permits linking, otherwise the new account will not join the link. If there are no open accounts in the existing link then it applies the same logic to the closed accounts, requiring at least one of them to be assigned to a desk that permits linking.   (3)   All accounts that permit linking All of the accounts in the existing link must be assigned to desks that permit linking, otherwise the new account will not join the existing link.   (4)   Any account that permits linking At least one of the accounts in the existing link must be assigned to a desk that permits linking, otherwise the new account will not join the link.  ', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'DeskLinkingMode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Weighted score for matching Drivers License Number', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'DLNumScore'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Weighted score for matching Date of Birth', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'DOBScore'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates the queue level to set on the account that will be set as the link driver', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'DriverQueueLevel'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator when set will allow the current linkdriver on the linked accounts to be re-evaluated', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'EvaluateDriver'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account link driver will be weighted towards an account in the group that is currently assigned to a collector desk (regardless of Link Driver Mode).', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'FavorCollectorDesk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account link driver will be weighted towards an account in the group that has post dated checks assigned (regardless of Link Driver Mode)', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'FavorPDCs'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account link driver will be weighted towards an account in the group that has active promises (regardless of Link Driver Mode)', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'FavorPromises'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates the queue level to set on accounts set as non-link drivers (follower accounts).', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'FollowerQueueLevel'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Weighted score for matching FullNames', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'FullNameScore'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Weighted score for matching ID1 on master ', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'ID1Score'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Weighted score for matching ID2 on master', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'ID2Score'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Weighted score for matching LastNames', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'LastNameScore'
GO
EXEC sp_addextendedproperty N'MS_Description', N'If re-evaluate is set then this mode would determine how the linkdriver is evaluated.  Any settings can be overriden by the favor options below.  (1) Newest Account (2) Oldest Account (3) Highest Current Balance (4) Highest original Balance (5) Most Worked (6) Least Worked', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'LinkDriverMode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Set within the Linking Cosole:  (1) Do not link - Disables account linking. (2) Link within the same customer - Only link accounts that meet Link Threshold criteria if they belong to the same customer. (3) Link within same class of business - Only link accounts that meet Link Threshold criteria if they belong to the same Class of Business. (4) Link within custom groups - Only link accounts that meet Link Threshold criteria if they belong to a customer contained within the Customer Group specified . (5) Link with any account (default) - Link within any account that meets the Link Threshold criteria     ', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'LinkMode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Link Threshold is used to calculate if accounts meet enough criteria to warrant linking.  This is determined by adding all Matching Field Scores . If the number is greater than the threshold, the accounts will be linked.  The higher the value applied to each matching field, the more weight the field will have in determining a debtor match', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'LinkThreshold'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator when set moves linked accounts currently belonging to an inventory desk to a collector desk after linking.', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'MoveInventoryToCollectorDesk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator that allows promises on linked accounts to be moved to the new linkdriver account', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'MovePromisesToNewDriver'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Weighted score for matching Home Phone', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'PhoneScore'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Possible Threshold is used to create a list of accounts that almost meet threshold criteria. This information is saved to a table in the database that may be reviewed for later linking', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'PossibleLinkThreshold'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator that allows distribution of accounts after linking', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'ShuffleAccounts'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Weighted score for matching SSN', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'SSNScore'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Weighted score for matching Address line 1', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'StreetScore'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Weighted score for matching Zipcode', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Configuration', 'COLUMN', N'ZipCodeScore'
GO
