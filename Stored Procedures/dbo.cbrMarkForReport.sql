SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/****** Object:  StoredProcedure [dbo].[cbrMarkForReport]    Script Date: 27-01-2020 15:06:30
        LAT-10482 Created to mark the accounts to Report again when Reporting is Enabled for particular Customer Type except for Fraud accounts ******/
CREATE PROCEDURE [dbo].[cbrMarkForReport]
     @CustomerID VARCHAR(50)
AS
BEGIN
--obtain all accounts that are in a delete and oes not have a status having cbrDelete as 1

	DECLARE @reportaccts_table TABLE (
	number int NOT NULL
	);
        
	INSERT into @reportaccts_table
	select m.number
	from master m
	inner join status s on s.code = m.status
	where m.customer=@CustomerID and specialnote ='DA' and s.cbrDelete!= 1 

	--update master
	UPDATE master set cbrPrevent = 0, specialnote = '' from @reportaccts_table r inner join master m on r.number = m.number

END
GO
