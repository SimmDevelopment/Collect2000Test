SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionSearchDebtors    Script Date: 3/26/2007 9:52:01 AM ******/

-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 11/06/2006
-- Description:	Stored procedure used by Lion (Latitude.WebAccess) to search debtors
-- =============================================
/*
exec LionSearchDebtors @userid=2,@searchmethod='Name Contains',@searchstring='e'
exec LionSearchDebtors @userid=2,@searchmethod='Search by Debtor Number',@searchstring='1188'
select * from LionUsers
select * from LionAllowedCustomers(2)
*/
CREATE PROCEDURE [dbo].[LionSearchDebtors]
	@searchstring varchar(4000), 
	@searchmethod varchar(25), 
	@userid int
AS
BEGIN
	SET NOCOUNT ON;

	if( @searchmethod='Name Ends With')
	BEGIN
		Select	m.number				as [File number],
				d.Seq					as [Debtor Seq Number],
				d.debtorId				as [Debtor Id],
				dbo.ProperCase(m.name)	as [Name],
				m.[Status Code]			as [Status Code],
				m.Original				as [Original balance],
				m.current0				as [Current],
				m.Received				as [Received],
				m.Account				as [Account],
				mas.ssn					as [Ssn]
		From LionMasterView m with (nolock)
		Join Master mas with (nolock) on mas.number=m.number
		Join Debtors d with (nolock) on d.number=m.number
		Where m.name like @searchString + '%'
		and m.customer in ( select * from LionAllowedCustomers(@userId) )
	END
	else if (@searchMethod='Name Contains')
	BEGIN
		Select	m.number				as [File number],
				d.Seq					as [Debtor Seq Number],	
				d.debtorId				as [Debtor Id],			
				dbo.ProperCase(m.name)	as [Name],
				m.[Status code]				as [Status Code],
				m.Original				as [Original balance],
				m.current0				as [Current],
				m.Received				as [Received],
				m.Account				as [Account],
				mas.ssn					as [Ssn]
		From LionMasterView m with (nolock)
		Join Master mas with (nolock) on mas.number=m.number
		Join Debtors d with (nolock) on d.number=m.number
		Where m.name like '%' + @searchString + '%'
		and m.customer in ( select * from LionAllowedCustomers(@userId) )
	END
	else if(@searchMethod='Search by Account')
	BEGIN
		Select	m.number				as [File number],
				d.Seq					as [Debtor Seq Number],
				d.debtorId				as [Debtor Id],
				dbo.ProperCase(m.name)	as [Name],
				m.[Status Code]			as [Status Code],
				m.Original				as [Original balance],
				m.current0				as [Current],
				m.Received				as [Received],
				m.Account				as [Account],
				mas.ssn					as [Ssn]
		From LionMasterView m with (nolock)
		Join Master mas with (nolock) on mas.number=m.number
		Join Debtors d with (nolock) on d.number=m.number
		Where m.account=@searchString
		and m.customer in ( select * from LionAllowedCustomers(@userId) )
	END
	else if(@searchMethod='Account Contains')
	BEGIN
	SELECT @searchString = '%' + @searchString + '%'
		Select	m.number				as [File number],
				d.Seq					as [Debtor Seq Number],
				d.debtorId				as [Debtor Id],
				dbo.ProperCase(m.name)	as [Name],
				m.[Status Code]			as [Status Code],
				m.Original				as [Original balance],
				m.current0				as [Current],
				m.Received				as [Received],
				m.Account				as [Account],
				mas.ssn					as [Ssn]
		From LionMasterView m with (nolock)
		Join Master mas with (nolock) on mas.number=m.number
		Join Debtors d with (nolock) on d.number=m.number
		Where m.account like @searchString
		and m.customer in ( select * from LionAllowedCustomers(@userId) )
	END
	else if(@searchMethod='Search by SSN')
	BEGIN
		Select	m.number				as [File number],
				d.Seq					as [Debtor Seq Number],
				d.debtorId				as [Debtor Id],
				dbo.ProperCase(m.name)	as [Name],
				m.[Status Code]			as [Status Code],
				m.Original				as [Original balance],
				m.current0				as [Current],
				m.Received				as [Received],
				m.Account				as [Account],
				mas.ssn					as [Ssn]
		From LionMasterView m with (nolock)
		Join Master mas with (nolock) on mas.number=m.number
		Join Debtors d with (nolock) on d.number=m.number
		Where mas.Ssn=@searchString
		and m.customer in ( select * from LionAllowedCustomers(@userId) )		
	END
	else if(@searchMethod='Search by Debtor Number')
	BEGIN
		Select	m.number				as [File number],
				d.Seq					as [Debtor Seq Number],
				d.debtorId				as [Debtor Id],
				dbo.ProperCase(d.name)	as [Name],
				m.[Status Code]			as [Status Code],
				m.Original				as [Original balance],
				m.current0				as [Current],
				m.Received				as [Received],
				m.Account				as [Account],
				mas.ssn					as [Ssn]
		From LionMasterView m with (nolock)
		Join Master mas with (nolock) on mas.number=m.number
		Join Debtors d with (nolock) on d.number=m.number
		Where m.number=@searchString
		and m.customer in ( select * from LionAllowedCustomers(@userId) )				
	END
END

GO
