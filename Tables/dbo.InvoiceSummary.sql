CREATE TABLE [dbo].[InvoiceSummary]
(
[Invoice] [int] NOT NULL,
[Tdate] [datetime] NULL,
[Tcode] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Syyear] [int] NULL,
[SyMonth] [int] NULL,
[customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AmountA] [money] NULL,
[AmountB] [money] NULL,
[AmountC] [money] NULL,
[AmountD] [money] NULL,
[AmountE] [money] NULL,
[AmountF] [money] NULL,
[Itype] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SortOn] [tinyint] NULL,
[ShowBalance] [bit] NULL,
[ShowRcvd] [bit] NULL,
[NetGross] [bit] NULL,
[SepCombined] [bit] NULL,
[ShowAmtDueClient] [bit] NULL,
[ByPassDPs] [bit] NULL,
[Tax] [money] NULL CONSTRAINT [DF__InvoiceSumm__Tax__33807B34] DEFAULT (0),
[WithHeldAmt] [money] NOT NULL CONSTRAINT [DF__InvoiceSu__WithH__6CE3E119] DEFAULT (0),
[Created] [datetime] NULL,
[InvoiceType] [tinyint] NOT NULL CONSTRAINT [DF__invoicesu__Invoi__5CAE44A7] DEFAULT (0),
[CreatedBy] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__invoicesu__Creat__5DA268E0] DEFAULT (suser_sname()),
[Description] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrencyISO3] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_InvoiceSummary_CurrencyISO3] DEFAULT ('USD')
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* trInvoiceSummaryInsert */
CREATE TRIGGER [dbo].[trInvoiceSummaryInsert] ON [dbo].[InvoiceSummary] 
FOR INSERT
AS
update invoicesummary set Created = getdate() from invoicesummary, inserted where invoicesummary.invoice = inserted.invoice

GO
ALTER TABLE [dbo].[InvoiceSummary] ADD CONSTRAINT [PK_InvoiceSummary] PRIMARY KEY NONCLUSTERED ([Invoice]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_InvoiceSummary_customer] ON [dbo].[InvoiceSummary] ([customer]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [IX_InvoiceSummary_Invoice] ON [dbo].[InvoiceSummary] ([Invoice]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_InvoiceSummary_TDate] ON [dbo].[InvoiceSummary] ([Tdate]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Summarized Total amounts of respective generated invoice displayed by the invoice application.', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceSummary', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sum of PU,PUR,PA,PAR (paid agency, paid attorney) batchtype payments for respective Customer or Group that have not been previously invoiced.', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceSummary', 'COLUMN', N'AmountA'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sum of PC,PCR (paid to client) batchtype payments for respective Customer or Group that have not been previously invoiced.', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceSummary', 'COLUMN', N'AmountB'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sum of fees (fee1..fee10 on payhistory) for all batchtype payments', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceSummary', 'COLUMN', N'AmountC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total amount due Agency', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceSummary', 'COLUMN', N'AmountD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total collected amount', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceSummary', 'COLUMN', N'AmountE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total amount due Customer', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceSummary', 'COLUMN', N'AmountF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp of row created', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceSummary', 'COLUMN', N'Created'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Logon Name of User processing Invoice', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceSummary', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Currency Code', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceSummary', 'COLUMN', N'CurrencyISO3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer code or Customer Group Code for respective customer or customer group', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceSummary', 'COLUMN', N'customer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description of Invoice', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceSummary', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Invoice number', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceSummary', 'COLUMN', N'Invoice'
GO
EXEC sp_addextendedproperty N'MS_Description', N'(1) Separate: Used to divide payment types and create separate invoices for each payment type for the customer.    (2) Combined: Used to include all payment types together (combined) in one customer invoice.   ', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceSummary', 'COLUMN', N'InvoiceType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Relates to InvoiceMethod: ("1 - Net" = off = 0, "2 - Gross = on = Gross).    Net  (0)- when selected nets your fee from the customer invoice.  Customer invoices will be sent minus your agencys fee. NOTE: If you set the Invoice Type to Combined, PC (direct) payments will be included in the fees withheld.  If Invoice Type is set to Separate, PC (direct) payments will be created as open items for the invoice.   Gross (1)- when selected sends customer invoices with all monies included.  The customer will pay your fee based on the invoice information.   ', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceSummary', 'COLUMN', N'NetGross'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Invoice type = "1 - Separate" then  (off - 0) Separate creates separate invoices for each payment type for the customer.        Invoicetype = "2 - Combined) then (on - 1)  Combined includes all payment types together in one customer invoice.  ', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceSummary', 'COLUMN', N'SepCombined'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Onn-Off switch used to print amount due to the client on the customer invoice.  ', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceSummary', 'COLUMN', N'ShowAmtDueClient'
GO
EXEC sp_addextendedproperty N'MS_Description', N'On-off indicator used to display or print the current debtor balance on the customer invoice.  ', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceSummary', 'COLUMN', N'ShowBalance'
GO
EXEC sp_addextendedproperty N'MS_Description', N'On-off indicaote used to display or print the date payments were received on the customer invoice.  ', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceSummary', 'COLUMN', N'ShowRcvd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Invoicesort - (1) Account Name , Sort by debtor name. (2) Customer Account , sort by customer account number for the debtor', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceSummary', 'COLUMN', N'SortOn'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Billing cycle month defined in control file at time of invoiceing / Invocied month', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceSummary', 'COLUMN', N'SyMonth'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Billing cycle year defined in control file at time of invoicing / Invoiced Year', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceSummary', 'COLUMN', N'Syyear'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total tax amount', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceSummary', 'COLUMN', N'Tax'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Defaulted to 00', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceSummary', 'COLUMN', N'Tcode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Invoice date', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceSummary', 'COLUMN', N'Tdate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total of WithHeld Fees when InvoiceMethod is Net', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceSummary', 'COLUMN', N'WithHeldAmt'
GO
