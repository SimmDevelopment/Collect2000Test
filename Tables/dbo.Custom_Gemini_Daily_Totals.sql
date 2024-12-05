CREATE TABLE [dbo].[Custom_Gemini_Daily_Totals]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[TotalAccounts] [int] NULL,
[TotalAmount] [money] NULL,
[LoadDate] [date] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Gemini_Daily_Totals] ADD CONSTRAINT [PK_Custom_Gemini_Daily_Totals] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
