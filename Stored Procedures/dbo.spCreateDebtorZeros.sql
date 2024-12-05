SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*spCreateDebtorZeros*/
CREATE PROCEDURE [dbo].[spCreateDebtorZeros] AS

INSERT INTO Debtors
	(Number, 
	Seq, 
	Name, 
	Street1, 
	Street2, 
	City, 
	State, 
	Zipcode,
	HomePhone, 
	WorkPhone, 
	SSN, 
	MR, 
	OtherName, 
	DOB)
select 
	m.number, 
	0, 
	m.Name, 
	m.Street1, 
	m.Street2, 
	m.City, 
	m.State, 
	m.ZipCode,  
	m.HomePhone, 
	m.WorkPhone, 
	m.SSN, 
	m.MR, 
	m.Other, 
	m.DOB 
from master m 
left outer join debtors d on d.number = m.number 
where m.number not in (select number from debtors where Seq = 0)

Return @@Error
GO
