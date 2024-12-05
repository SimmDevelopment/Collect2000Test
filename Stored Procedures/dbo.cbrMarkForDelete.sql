SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/****** Object:  StoredProcedure [dbo].[cbrMarkForDelete]    Script Date: 27-01-2020 15:06:30
        LAT-10482 Created to mark the accounts to Delete when Reporting is disabled for particular Customer Type except for Fraud accounts ******/
CREATE PROCEDURE [dbo].[cbrMarkForDelete]
    @CustomerID VARCHAR(50)
AS
BEGIN

	UPDATE master set cbrPrevent = 1, specialnote = 'DA' 
	where customer=@CustomerID AND (ISNULL(specialnote,'a')<>'DF' AND ISNULL(specialnote,'a')<>'DA')
		
END
GO
