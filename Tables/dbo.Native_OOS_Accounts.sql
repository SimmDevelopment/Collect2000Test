CREATE TABLE [dbo].[Native_OOS_Accounts]
(
[number] [int] NOT NULL,
[OOSDate] [datetime] NOT NULL,
[IsOOS] AS (CONVERT([bit],case  when [OOSDate]<=getdate() then (1) else (0) end,(0)))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Native_OOS_Accounts] ADD CONSTRAINT [PK__Native_O__FD291E401A7B3100] PRIMARY KEY CLUSTERED ([number]) ON [PRIMARY]
GO
