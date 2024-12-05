SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create procedure [collector].[sp_LX_updMasterRecord] @Street1 varchar(30),@Street2 varchar(30), @City varchar(20), @State varchar(3), @ZipCode varchar(10),@HPhone varchar(30), @Number int, @MR varchar(1) as Begin Update master set street1 = @Street1, street2 = @Street2, City = @City,State = @State, ZipCode = @ZipCode where number = @Number 
Update debtors set street1 = @Street1, street2 = @Street2, City = @City, State = @State, ZipCode = @ZipCode where number = @Number  and SEQ = 0 
IF @HPhone <> '' Update master set HomePhone = @HPhone where number = @Number 
IF @HPhone <> '' Update debtors set HomePhone = @HPhone where number = @Number 
IF @MR <> '' Update debtors set MR = @MR where number = @Number and SEQ = 0 End 
GO
