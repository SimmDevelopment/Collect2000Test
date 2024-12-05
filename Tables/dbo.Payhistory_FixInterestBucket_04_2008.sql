CREATE TABLE [dbo].[Payhistory_FixInterestBucket_04_2008]
(
[m_number] [int] NOT NULL,
[m_current0] [money] NOT NULL,
[m_current_sum] [money] NULL,
[m_current1] [money] NOT NULL,
[m_current1_NewValue] [money] NULL,
[m_current2] [money] NOT NULL,
[m_current2_NewValue] [money] NULL,
[m_lastpaidamt] [money] NULL,
[p_uid] [int] NOT NULL,
[p_totalpaid] [money] NOT NULL,
[p_paid_sum] [money] NULL,
[p_paid1] [money] NOT NULL,
[p_paid1_NewValue] [money] NULL,
[p_paid1_OffBy] [money] NULL,
[p_paid2] [money] NOT NULL,
[p_paid2_NewValue] [money] NULL,
[p_paid2_OffBy] [money] NULL,
[p_balance] [money] NULL,
[p_overpaidamt] [money] NULL,
[p_overpaidamt_NewValue] [money] NULL,
[p_invoice] [int] NULL,
[p_invoiced] [datetime] NULL,
[ZeroIfFixed] [money] NULL
) ON [PRIMARY]
GO
