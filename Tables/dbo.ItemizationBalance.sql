CREATE TABLE [dbo].[ItemizationBalance]
(
[ItemizationID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[ItemizationDateType] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ItemizationDate] [date] NOT NULL,
[ItemizationBalance0] [money] NULL,
[ItemizationBalance1] [money] NULL,
[ItemizationBalance2] [money] NULL,
[ItemizationBalance3] [money] NULL,
[ItemizationBalance4] [money] NULL,
[ItemizationBalance5] [money] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_ItemizationBalance_Insert]
ON [dbo].[ItemizationBalance]
AFTER INSERT
AS
BEGIN

DECLARE @AccountID INT;
DECLARE @ItemizationDate DATE;
SELECT @AccountID = AccountID, @ItemizationDate = ItemizationDate FROM inserted;

IF(@ItemizationDate is null)
return;

IF EXISTS (SELECT 1 FROM payhistory where number = @AccountId)
BEGIN
	;WITH PayHist AS(
	select
	@AccountID As Number,
	SUM(case
	when i.[batchtype] in ('PU','PC','PA') then -i.paid1
	when i.[batchtype] in ('PUR','PCR','PAR') then i.paid1
	when i.[batchtype] in ('DA') then -i.[paid1]
	when i.[batchtype] in ('DAR') then i.[paid1]
	when i.[batchtype] in ('LJ') then -i.[paid1]
	when i.[batchtype] in ('LJR') then i.[paid1]
	else 0.00 end
	)
	as Bal1,
	SUM(case
	when i.[batchtype] in ('DA') then -i.[paid2]
	when i.[batchtype] in ('DAR') then i.[paid2]
	when i.[batchtype] in ('LJ') then i.[paid2]
	when i.[batchtype] in ('LJR') then -i.[paid2]
	else 0.00 end
	)
	as Bal2,
	SUM(case
	when i.[batchtype] in ('DA') then -(i.[paid3]+i.[paid4]+i.[paid5]+i.[paid6]+i.[paid7]+i.[paid8]+i.[paid9]+i.[paid10])
	when i.[batchtype] in ('DAR') then (i.[paid3]+i.[paid4]+i.[paid5]+i.[paid6]+i.[paid7]+i.[paid8]+i.[paid9]+i.[paid10])
	when i.[batchtype] in ('LJ') then (i.[paid3]+i.[paid4]+i.[paid5]+i.[paid6]+i.[paid7]+i.[paid8]+i.[paid9]+i.[paid10])
	when i.[batchtype] in ('LJR') then -(i.[paid3]+i.[paid4]+i.[paid5]+i.[paid6]+i.[paid7]+i.[paid8]+i.[paid9]+i.[paid10])
	else 0.00 end
	)
	as Bal3,
	SUM(case
	when i.[batchtype] in ('PU','PA','PC') then (i.[totalpaid]-i.[accruedsurcharge])
	when i.[batchtype] in ('PUR','PAR','PCR') then -(i.[totalpaid]-i.[accruedsurcharge])
	when i.[batchtype] in ('DA') then i.[paid1]
	when i.[batchtype] in ('DAR') then -i.[paid1]
	when i.[batchtype] in ('LJ') then i.[paid1]
	when i.[batchtype] in ('LJR') then -i.[paid1]
	else 0.00
	end
	)
	as Bal4
	from payhistory i where number = @AccountId and i.entered > @ItemizationDate and i.BatchNumber IS NOT NULL
	)
	update ib
	set
	ib.[ItemizationBalance1] = isnull(ib.[ItemizationBalance1],0.00)+ isnull(Bal1,0.00),
	ib.[ItemizationBalance2] = isnull(ib.[ItemizationBalance2],0.00)+ isnull(Bal2,0.00),
	ib.[ItemizationBalance3] = isnull(ib.[ItemizationBalance3],0.00)+ isnull(Bal3,0.00),
	ib.[ItemizationBalance4] = isnull(ib.[ItemizationBalance4],0.00)+ isnull(Bal4,0.00)
	from
	[dbo].[itemizationbalance] ib
	inner join PayHist i on i.Number = ib.[AccountID]
	where ib.AccountID = @AccountID
END

END
GO
ALTER TABLE [dbo].[ItemizationBalance] ADD CONSTRAINT [PK_ItemizationBalance] PRIMARY KEY NONCLUSTERED ([ItemizationID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ItemizationBalance] ADD CONSTRAINT [IX_ItemizationBalance] UNIQUE CLUSTERED ([AccountID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ItemizationBalance] ADD CONSTRAINT [FK_ItemizationBalance_master] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[master] ([number])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique file number related to Master.number', 'SCHEMA', N'dbo', 'TABLE', N'ItemizationBalance', 'COLUMN', N'AccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ItemizationBalance bucket 0', 'SCHEMA', N'dbo', 'TABLE', N'ItemizationBalance', 'COLUMN', N'ItemizationBalance0'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ItemizationBalance bucket 1', 'SCHEMA', N'dbo', 'TABLE', N'ItemizationBalance', 'COLUMN', N'ItemizationBalance1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ItemizationBalance bucket 2', 'SCHEMA', N'dbo', 'TABLE', N'ItemizationBalance', 'COLUMN', N'ItemizationBalance2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ItemizationBalance bucket 3', 'SCHEMA', N'dbo', 'TABLE', N'ItemizationBalance', 'COLUMN', N'ItemizationBalance3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ItemizationBalance bucket 4', 'SCHEMA', N'dbo', 'TABLE', N'ItemizationBalance', 'COLUMN', N'ItemizationBalance4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ItemizationBalance bucket 5', 'SCHEMA', N'dbo', 'TABLE', N'ItemizationBalance', 'COLUMN', N'ItemizationBalance5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ItemizationBalance Date', 'SCHEMA', N'dbo', 'TABLE', N'ItemizationBalance', 'COLUMN', N'ItemizationDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ItemizationBalance Date', 'SCHEMA', N'dbo', 'TABLE', N'ItemizationBalance', 'COLUMN', N'ItemizationDateType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID to represent specific Itemization Detail', 'SCHEMA', N'dbo', 'TABLE', N'ItemizationBalance', 'COLUMN', N'ItemizationID'
GO
