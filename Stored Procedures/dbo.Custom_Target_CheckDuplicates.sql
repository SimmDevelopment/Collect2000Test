SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE   PROCEDURE [dbo].[Custom_Target_CheckDuplicates]
@number int

AS

IF EXISTS(
	SELECT * FROM master m WITH (NOLOCK) INNER JOIN master m2 WITH (NOLOCK)
		ON m.account = m2.account AND m2.number = @number AND m.number <> @number
	WHERE m.customer = '0000856' AND m2.customer = '0000856')
BEGIN
	
	INSERT notes (number, created, user0, action, result, comment)
	SELECT m.number, GETDATE(), 'EXCHNG', '+++++', '+++++', 'Account re-opened/re-assigned by client.  Previous balance: ' 
		+ CONVERT(varchar, m.current1) + ' Previous starting balance: ' + CONVERT(varchar, m.current1) 
		+ ' Previous assign date: ' + CONVERT(varchar, m.received)
	FROM master m INNER JOIN master m2
		ON m.account = m2.account AND m2.number = @number AND m.number <> @number 
	where m.customer = '0000856' and m2.customer = '0000856'

	UPDATE m
	SET m.received = m2.received,
		m.qlevel = 15,
		m.status = 'NEW',
		m.desk = '071',
		m.closed = NULL,
		m.returned = NULL,
		m.qdate = m2.qdate,
		m.sysmonth = m2.sysmonth,
		m.sysyear = m2.sysyear,
		m.ShouldQueue = 1,
		m.paid = 0,
		m.paid1 = 0,
		m.paid2 = 0,
		m.paid3 = 0,
		m.paid4 = 0,
		m.paid5 = 0,
		m.paid6 = 0,
		m.paid7 = 0,
		m.paid8 = 0,
		m.paid9 = 0,
		m.paid10 = 0,
		m.accrued2 = 0,
		m.accrued10 = 0,
		m.current0 = m2.current0,
		m.original = m2.current1,
		m.original1 = m2.original1,
		m.id2 = NULL
	FROM master m WITH (NOLOCK) INNER JOIN master m2 WITH (NOLOCK)
		ON m.account = m2.account AND m2.number = @number AND m.number <> @number 
	WHERE m.customer = '0000856' AND m2.customer = '0000856'
	

	--now get rid of this account and its auxillaries
	DELETE notes WHERE number = @number

	DELETE Debtors WHERE Number = @number

	DELETE MiscExtra WHERE number = @number	

	DELETE master WHERE number = @number
END
GO
