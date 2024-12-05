CREATE TABLE [dbo].[FeeSchedules]
(
[Code] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SchedType] [tinyint] NULL,
[BaseDate] [tinyint] NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_FeeSchedules_CreatedDate] DEFAULT (getdate()),
[LastModifiedDate] [datetime] NULL CONSTRAINT [DF_FeeSchedules_LastModifiedDate] DEFAULT (getdate()),
[Invoiced1] [bit] NULL,
[Invoiced2] [bit] NULL,
[Invoiced3] [bit] NULL,
[Invoiced4] [bit] NULL,
[Invoiced5] [bit] NULL,
[Invoiced6] [bit] NULL,
[Invoiced7] [bit] NULL,
[Invoiced8] [bit] NULL,
[Invoiced9] [bit] NULL,
[Invoiced10] [bit] NULL,
[Priority1] [tinyint] NULL CONSTRAINT [DF_FeeSchedules_Priority1] DEFAULT (1),
[Priority2] [tinyint] NULL CONSTRAINT [DF_FeeSchedules_Priority2] DEFAULT (2),
[Priority3] [tinyint] NULL CONSTRAINT [DF_FeeSchedules_Priority3] DEFAULT (3),
[Priority4] [tinyint] NULL CONSTRAINT [DF_FeeSchedules_Priority4] DEFAULT (4),
[Priority5] [tinyint] NULL CONSTRAINT [DF_FeeSchedules_Priority5] DEFAULT (5),
[Priority6] [tinyint] NULL CONSTRAINT [DF_FeeSchedules_Priority6] DEFAULT (6),
[Priority7] [tinyint] NULL CONSTRAINT [DF_FeeSchedules_Priority7] DEFAULT (7),
[Priority8] [tinyint] NULL CONSTRAINT [DF_FeeSchedules_Priority8] DEFAULT (8),
[Priority9] [tinyint] NULL CONSTRAINT [DF_FeeSchedules_Priority9] DEFAULT (9),
[Priority10] [tinyint] NULL CONSTRAINT [DF_FeeSchedules_Priority10] DEFAULT (10),
[FeeCapAmount] [money] NOT NULL CONSTRAINT [DF__FeeSchedu__FeeCa__4EFF43CE] DEFAULT (0.0),
[FeeCapPercent] [real] NOT NULL CONSTRAINT [DF__FeeSchedu__FeeCa__4FF36807] DEFAULT (0.0),
[InvoicePUFlags] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoicePCFlags] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoicePAFlags] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ToDateField] [int] NULL,
[CreatedBy] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__FeeSchedu__Creat__53C3F8EB] DEFAULT (suser_sname()),
[UpdatedBy] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__FeeSchedu__Updat__54B81D24] DEFAULT (suser_sname()),
[AllocationRate1] [decimal] (7, 6) NOT NULL CONSTRAINT [DF_FeeSchedules_AllocationRate1] DEFAULT ((1)),
[AllocationRate2] [decimal] (7, 6) NOT NULL CONSTRAINT [DF_FeeSchedules_AllocationRate2] DEFAULT ((1)),
[AllocationRate3] [decimal] (7, 6) NOT NULL CONSTRAINT [DF_FeeSchedules_AllocationRate3] DEFAULT ((1)),
[AllocationRate4] [decimal] (7, 6) NOT NULL CONSTRAINT [DF_FeeSchedules_AllocationRate4] DEFAULT ((1)),
[AllocationRate5] [decimal] (7, 6) NOT NULL CONSTRAINT [DF_FeeSchedules_AllocationRate5] DEFAULT ((1)),
[AllocationRate6] [decimal] (7, 6) NOT NULL CONSTRAINT [DF_FeeSchedules_AllocationRate6] DEFAULT ((1)),
[AllocationRate7] [decimal] (7, 6) NOT NULL CONSTRAINT [DF_FeeSchedules_AllocationRate7] DEFAULT ((1)),
[AllocationRate8] [decimal] (7, 6) NOT NULL CONSTRAINT [DF_FeeSchedules_AllocationRate8] DEFAULT ((1)),
[AllocationRate9] [decimal] (7, 6) NOT NULL CONSTRAINT [DF_FeeSchedules_AllocationRate9] DEFAULT ((1)),
[AllocationRate10] [decimal] (7, 6) NOT NULL CONSTRAINT [DF_FeeSchedules_AllocationRate10] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FeeSchedules] ADD CONSTRAINT [PK_FeeSchedules] PRIMARY KEY NONCLUSTERED ([Code]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fee schedules are used to set up fee rates for your Agency', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'This value indicates the multiplier to use for the allocation amount. So that the remaining payment amount * this rate = the amount to allocate for the individual bucket. Default to 1.0, aka 100%.', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'AllocationRate1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This value indicates the multiplier to use for the allocation amount. So that the remaining payment amount * this rate = the amount to allocate for the individual bucket. Default to 1.0, aka 100%.', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'AllocationRate10'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This value indicates the multiplier to use for the allocation amount. So that the remaining payment amount * this rate = the amount to allocate for the individual bucket. Default to 1.0, aka 100%.', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'AllocationRate2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This value indicates the multiplier to use for the allocation amount. So that the remaining payment amount * this rate = the amount to allocate for the individual bucket. Default to 1.0, aka 100%.', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'AllocationRate3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This value indicates the multiplier to use for the allocation amount. So that the remaining payment amount * this rate = the amount to allocate for the individual bucket. Default to 1.0, aka 100%.', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'AllocationRate4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This value indicates the multiplier to use for the allocation amount. So that the remaining payment amount * this rate = the amount to allocate for the individual bucket. Default to 1.0, aka 100%.', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'AllocationRate5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This value indicates the multiplier to use for the allocation amount. So that the remaining payment amount * this rate = the amount to allocate for the individual bucket. Default to 1.0, aka 100%.', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'AllocationRate6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This value indicates the multiplier to use for the allocation amount. So that the remaining payment amount * this rate = the amount to allocate for the individual bucket. Default to 1.0, aka 100%.', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'AllocationRate7'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This value indicates the multiplier to use for the allocation amount. So that the remaining payment amount * this rate = the amount to allocate for the individual bucket. Default to 1.0, aka 100%.', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'AllocationRate8'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This value indicates the multiplier to use for the allocation amount. So that the remaining payment amount * this rate = the amount to allocate for the individual bucket. Default to 1.0, aka 100%.', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'AllocationRate9'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Starting date range for Age Based fees.  One of the follwing dates may be used:  Received date of account,  Client DLP, Client DLC, Account DLP or one of three user defined dates from the control file.', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'BaseDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A user defined unique numeric Fee Schedule Code.  ', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Creation DateTimeStamp', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Creation DateTimeStamp', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'CreatedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fee cap amount  which will eliminate the fee collected after a certain percent of the original balance or dollar amount is recovered. ', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'FeeCapAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fee cap percent which will eliminate the fee collected after a certain percent of the original balance or dollar amount is recovered. ', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'FeeCapPercent'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Invoiceable flag 1', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'Invoiced1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Invoiceable flag 10', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'Invoiced10'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Invoiceable flag 2', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'Invoiced2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Invoiceable flag 3', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'Invoiced3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Invoiceable flag 4', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'Invoiced4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Invoiceable flag 5', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'Invoiced5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Invoiceable flag 6', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'Invoiced6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Invoiceable flag 7', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'Invoiced7'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Invoiceable flag 8', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'Invoiced8'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Invoiceable flag 9', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'Invoiced9'
GO
EXEC sp_addextendedproperty N'MS_Description', N'10 on - off indicators used to include respective bucket amount in customer invoice for Paid to Attorney (PA)  transactions', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'InvoicePAFlags'
GO
EXEC sp_addextendedproperty N'MS_Description', N'10 on - off indicators used to include respective bucket amount in customer invoice for Paid to Client (PC)  transactions', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'InvoicePCFlags'
GO
EXEC sp_addextendedproperty N'MS_Description', N'10 on - off indicators used to include respective bucket amount in customer invoice for Paid to Agency (PU)  transactions.', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'InvoicePUFlags'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Last modification DateTimeStamp', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'LastModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descriptive name of fee schedule ', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Order or priority used when applying transaction amounts to respective bucket.  A value from 1 to 10.', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'Priority1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Order or priority used when applying transaction amounts to respective bucket.  A value from 1 to 10.', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'Priority10'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Order or priority used when applying transaction amounts to respective bucket.  A value from 1 to 10.', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'Priority2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Order or priority used when applying transaction amounts to respective bucket.  A value from 1 to 10.', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'Priority3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Order or priority used when applying transaction amounts to respective bucket.  A value from 1 to 10.', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'Priority4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Order or priority used when applying transaction amounts to respective bucket.  A value from 1 to 10.', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'Priority5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Order or priority used when applying transaction amounts to respective bucket.  A value from 1 to 10.', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'Priority6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Order or priority used when applying transaction amounts to respective bucket.  A value from 1 to 10.', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'Priority7'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Order or priority used when applying transaction amounts to respective bucket.  A value from 1 to 10.', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'Priority8'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Order or priority used when applying transaction amounts to respective bucket.  A value from 1 to 10.', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'Priority9'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fee Schedule Type: Age Based (default), Liquidation Based or Dollar Based. This will be used to calculate how fees are added to the account.   ', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'SchedType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Ending date range for Age Based fees.  One of the follwing dates may be used:  Received date of account,  Client DLP, Client DLC, Account DLP or one of three user defined dates from the control file.', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'ToDateField'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Logon Name', 'SCHEMA', N'dbo', 'TABLE', N'FeeSchedules', 'COLUMN', N'UpdatedBy'
GO
