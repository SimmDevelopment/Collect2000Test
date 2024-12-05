SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[Tmp_FixDemoGrphFields] as 
begin   

BEGIN TRANSACTION 

SET NOCOUNT ON;
SET CURSOR_CLOSE_ON_COMMIT OFF;

DECLARE @CommitThreshold INTEGER
DECLARE @CommitCount INTEGER
DECLARE @MstrDmGrph CURSOR;
DECLARE @DbtrDmGrph CURSOR;
DECLARE @Number INTEGER;
DECLARE @Name VARCHAR(30);
DECLARE @Street1 VARCHAR(30);
DECLARE @Street2 VARCHAR(30);
DECLARE @City VARCHAR(20);
DECLARE @State VARCHAR(3);
DECLARE @Zipcode VARCHAR(10);
DECLARE @HomePhone VARCHAR(30);
DECLARE @WorkPhone VARCHAR(30);
DECLARE @SSN VARCHAR(15);
DECLARE @Count INTEGER;
DECLARE @CountUpdated INTEGER;
DECLARE @Updated BIT;
DECLARE @Length INTEGER;
DECLARE @Index INTEGER;
DECLARE @TmpName VARCHAR(30);
DECLARE @TmpStreet1 VARCHAR(30);
DECLARE @TmpStreet2 VARCHAR(30);
DECLARE @TmpCity VARCHAR(20);
DECLARE @TmpState VARCHAR(3);
DECLARE @TmpZipcode VARCHAR(10);
DECLARE @TmpHomePhone VARCHAR(30);
DECLARE @TmpWorkPhone VARCHAR(30);
DECLARE @TmpSSN VARCHAR(15);
DECLARE @Char INTEGER;
DECLARE @TmpLastName VARCHAR(50);
DECLARE @TmpFirstName VARCHAR(50);
DECLARE @TmpMiddleName VARCHAR(50);
DECLARE @LastName VARCHAR(50);
DECLARE @FirstName VARCHAR(50);
DECLARE @MiddleName VARCHAR(50);
DECLARE @OriginalCreditor VARCHAR(50);
DECLARE @TmpOriginalCreditor VARCHAR(50);

SET @CommitThreshold = 100


SET @MstrDmGrph = CURSOR LOCAL OPTIMISTIC FOR
	SELECT Number, [Name], Street1, Street2, City, State, Zipcode, HomePhone, WorkPhone, SSN
	FROM dbo.master;

OPEN @MstrDmGrph;

SET @CommitCount = 0
SET @Count = 0;
SET @CountUpdated = 0;

FETCH NEXT FROM @MstrDmGrph INTO @Number, @Name, @Street1, @Street2, @City, @State, @Zipcode, @HomePhone, @WorkPhone, @SSN;

WHILE @@FETCH_STATUS = 0 BEGIN


	SET @Updated = 0;


	SET @Index = 1;
	SET @Length = LEN(@Name) + 1;
	SET @TmpName = '';
	
	--Ignore Nulls and Zero length strings
	IF @Name IS NOT NULL AND @Length <> 1
	BEGIN
	  WHILE @Index < @Length BEGIN
		SET @Char = ASCII(SUBSTRING(@Name, @Index, 1));

		IF @Char BETWEEN 32 AND 127
			SET @TmpName = @TmpName + CHAR(@Char);
		ELSE
			SET @Updated = 1;

		SET @Index = @Index + 1;
	  END;
	END;

	SET @Index = 1;
	SET @Length = LEN(@Street1) + 1;
	SET @TmpStreet1 = '';

	IF @Street1 IS NOT NULL AND @Length <> 1
	BEGIN
	  WHILE @Index < @Length BEGIN
		SET @Char = ASCII(SUBSTRING(@Street1, @Index, 1));

		IF @Char BETWEEN 32 AND 127
			SET @TmpStreet1 = @TmpStreet1 + CHAR(@Char);
		ELSE
			SET @Updated = 1;

		SET @Index = @Index + 1;
	  END;
	END;


	SET @Index = 1;
	SET @Length = LEN(@Street2) + 1;
	SET @TmpStreet2 = '';

	IF @Street2 IS NOT NULL AND @Length <> 1
	BEGIN 
	  WHILE @Index < @Length BEGIN
		SET @Char = ASCII(SUBSTRING(@Street2, @Index, 1));

		IF @Char BETWEEN 32 AND 127
			SET @TmpStreet2 = @TmpStreet2 + CHAR(@Char);
		ELSE
			SET @Updated = 1;

		SET @Index = @Index + 1;
	  END;
	END;


	SET @Index = 1;
	SET @Length = LEN(@City) + 1;
	SET @TmpCity = '';

	IF @City IS NOT NULL AND @Length <> 1
	BEGIN 
	  WHILE @Index < @Length BEGIN
		SET @Char = ASCII(SUBSTRING(@City, @Index, 1));

		IF @Char BETWEEN 32 AND 127
			SET @TmpCity = @TmpCity + CHAR(@Char);
		ELSE
			SET @Updated = 1;

		SET @Index = @Index + 1;
	  END;
	end;


	SET @Index = 1;
	SET @Length = LEN(@State) + 1;
	SET @TmpState = '';

	IF @State IS NOT NULL AND @Length <> 1
	BEGIN 
	  WHILE @Index < @Length BEGIN
		SET @Char = ASCII(SUBSTRING(@State, @Index, 1));

		IF @Char BETWEEN 32 AND 127
			SET @TmpState = @TmpState + CHAR(@Char);
		ELSE
			SET @Updated = 1;

		SET @Index = @Index + 1;
	  END;
	END;


	SET @Index = 1;
	SET @Length = LEN(@Zipcode) + 1;
	SET @TmpZipcode = '';

	IF @Zipcode IS NOT NULL AND @Length <> 1
	BEGIN
	  WHILE @Index < @Length BEGIN
		SET @Char = ASCII(SUBSTRING(@Zipcode, @Index, 1));

		IF @Char BETWEEN 32 AND 127
			SET @TmpZipcode = @TmpZipcode + CHAR(@Char);
		ELSE
			SET @Updated = 1;

		SET @Index = @Index + 1;
	  END;
	END;

	SET @Index = 1;
	SET @Length = LEN(@HomePhone) + 1;
	SET @TmpHomePhone = '';

	IF @HomePhone IS NOT NULL AND @Length <> 1
	BEGIN 
	  WHILE @Index < @Length BEGIN
		SET @Char = ASCII(SUBSTRING(@HomePhone, @Index, 1));

		IF @Char BETWEEN 32 AND 127
			SET @TmpHomePhone = @TmpHomePhone + CHAR(@Char);
		ELSE
			SET @Updated = 1;

		SET @Index = @Index + 1;
	  END;
	END;

	SET @Index = 1;
	SET @Length = LEN(@WorkPhone) + 1;
	SET @TmpWorkPhone = '';

	IF @WorkPhone IS NOT NULL AND @Length <> 1
	BEGIN 
 	  WHILE @Index < @Length BEGIN
		SET @Char = ASCII(SUBSTRING(@WorkPhone, @Index, 1));

		IF @Char BETWEEN 32 AND 127
			SET @TmpWorkPhone = @TmpWorkPhone + CHAR(@Char);
		ELSE
			SET @Updated = 1;

		SET @Index = @Index + 1;
	  END;
	END;

	SET @Index = 1;
	SET @Length = LEN(@SSN) + 1;
	SET @TmpSSN = '';

	IF @SSN IS NOT NULL AND @Length <> 1
	BEGIN 
	  WHILE @Index < @Length BEGIN
		SET @Char = ASCII(SUBSTRING(@SSN, @Index, 1));

		IF @Char BETWEEN 32 AND 127
			SET @TmpSSN = @TmpSSN + CHAR(@Char);
		ELSE
			SET @Updated = 1;

		SET @Index = @Index + 1;
	  END;
	END;


	SET @Index = 1;
	SET @Length = LEN(@OriginalCreditor) + 1;
	SET @TmpOriginalCreditor = '';

	IF @OriginalCreditor IS NOT NULL AND @Length <> 1
	BEGIN 
	  WHILE @Index < @Length BEGIN
		SET @Char = ASCII(SUBSTRING(@OriginalCreditor, @Index, 1));

		IF @Char BETWEEN 32 AND 127
			SET @TmpOriginalCreditor = @TmpOriginalCreditor + CHAR(@Char);
		ELSE
			SET @Updated = 1;

		SET @Index = @Index + 1;
	  END;
	END;


	IF @Updated = 1 BEGIN
		UPDATE dbo.master
		SET 
		    [Name] 		= @TmpName,
		    Street1		= @TmpStreet1,
		    Street2		= @TmpStreet2,
		    City 		= @TmpCity,
		    State 		= @TmpState,
		    Zipcode		= @TmpZipcode,
		    HomePhone 	= @TmpHomePhone,
		    WorkPhone 	= @TmpWorkPhone,
		    SSN 		= @TmpSSN,
			OriginalCreditor = @TmpOriginalCreditor

		WHERE CURRENT OF @MstrDmGrph;


		SET @CountUpdated = @CountUpdated + 1;
		SET @CommitCOUNT = @CommitCount + 1;

		IF @CommitCount >= @CommitThreshold
		BEGIN
			COMMIT TRANSACTION 
			SET @CommitCOUNT = 0
			BEGIN TRANSACTION 
			
		END;
	END;

	SET @Count = @Count + 1;

	IF @Count % 1000 = 0
		RAISERROR('Checked %d accounts, fixed %d accounts.', 10, 1, @Count, @CountUpdated);

	FETCH NEXT FROM @MstrDmGrph INTO @Number, @Name, @Street1, @Street2, @City, @State, @Zipcode, @HomePhone, @WorkPhone, @SSN;
END;

CLOSE @MstrDmGrph;
DEALLOCATE @MstrDmGrph;

COMMIT TRANSACTION ;

RAISERROR('Checked %d accounts, fixed %d accounts.', 10, 1, @Count, @CountUpdated);


--debtors table



SET @DbtrDmGrph = CURSOR LOCAL OPTIMISTIC FOR
	SELECT Number, [Name], Street1, Street2, City, State, Zipcode, HomePhone, WorkPhone, SSN, LastName, FirstName, MiddleName
	FROM dbo.debtors;


BEGIN TRANSACTION 

OPEN @DbtrDmGrph;

SET @CommitCount = 0
SET @Count = 0;
SET @CountUpdated = 0;

FETCH NEXT FROM @DbtrDmGrph INTO @Number, @Name, @Street1, @Street2, @City, @State, @Zipcode, @HomePhone, @WorkPhone, @SSN, @LastName, @FirstName, @MiddleName;

WHILE @@FETCH_STATUS = 0 BEGIN

	SET @Updated = 0;


	SET @Index = 1;
	SET @Length = LEN(@Name) + 1;
	SET @TmpName = '';

	IF @Name IS NOT NULL AND @Length <> 1
	BEGIN 
	  WHILE @Index < @Length BEGIN
		SET @Char = ASCII(SUBSTRING(@Name, @Index, 1));

		IF @Char BETWEEN 32 AND 127
			SET @TmpName = @TmpName + CHAR(@Char);
		ELSE
			SET @Updated = 1;

		SET @Index = @Index + 1;
	  END;
	END;

	SET @Index = 1;
	SET @Length = LEN(@Street1) + 1;
	SET @TmpStreet1 = '';

	IF @Street1 IS NOT NULL AND @Length <> 1
	BEGIN 
	  WHILE @Index < @Length BEGIN
		SET @Char = ASCII(SUBSTRING(@Street1, @Index, 1));

		IF @Char BETWEEN 32 AND 127
			SET @TmpStreet1 = @TmpStreet1 + CHAR(@Char);
		ELSE
			SET @Updated = 1;

		SET @Index = @Index + 1;
	  END;
	END;

	SET @Index = 1;
	SET @Length = LEN(@Street2) + 1;
	SET @TmpStreet2 = '';

	IF @Street2 IS NOT NULL AND @Length <> 1
	BEGIN 
	  WHILE @Index < @Length BEGIN
		SET @Char = ASCII(SUBSTRING(@Street2, @Index, 1));

		IF @Char BETWEEN 32 AND 127
			SET @TmpStreet2 = @TmpStreet2 + CHAR(@Char);
		ELSE
			SET @Updated = 1;

		SET @Index = @Index + 1;
	  END;
	END;

	SET @Index = 1;
	SET @Length = LEN(@City) + 1;
	SET @TmpCity = '';

	IF @City IS NOT NULL AND @Length <> 1
	BEGIN 
	  WHILE @Index < @Length BEGIN
		SET @Char = ASCII(SUBSTRING(@City, @Index, 1));

		IF @Char BETWEEN 32 AND 127
			SET @TmpCity = @TmpCity + CHAR(@Char);
		ELSE
			SET @Updated = 1;

		SET @Index = @Index + 1;
	  END;
	END;


	SET @Index = 1;
	SET @Length = LEN(@State) + 1;
	SET @TmpState = '';

	IF @State IS NOT NULL AND @Length <> 1
	BEGIN 
	  WHILE @Index < @Length BEGIN
		SET @Char = ASCII(SUBSTRING(@State, @Index, 1));

		IF @Char BETWEEN 32 AND 127
			SET @TmpState = @TmpState + CHAR(@Char);
		ELSE
			SET @Updated = 1;

		SET @Index = @Index + 1;
	  END;
	END;

	SET @Index = 1;
	SET @Length = LEN(@Zipcode) + 1;
	SET @TmpZipcode = '';

	IF @Zipcode IS NOT NULL AND @Length <> 1
	BEGIN 
	  WHILE @Index < @Length BEGIN
		SET @Char = ASCII(SUBSTRING(@Zipcode, @Index, 1));

		IF @Char BETWEEN 32 AND 127
			SET @TmpZipcode = @TmpZipcode + CHAR(@Char);
		ELSE
			SET @Updated = 1;

		SET @Index = @Index + 1;
	  END;
	END;

	SET @Index = 1;
	SET @Length = LEN(@HomePhone) + 1;
	SET @TmpHomePhone = '';

	IF @HomePhone IS NOT NULL AND @Length <> 1
	BEGIN 
	  WHILE @Index < @Length BEGIN
		SET @Char = ASCII(SUBSTRING(@HomePhone, @Index, 1));

		IF @Char BETWEEN 32 AND 127
			SET @TmpHomePhone = @TmpHomePhone + CHAR(@Char);
		ELSE
			SET @Updated = 1;

		SET @Index = @Index + 1;
	  END;
	END;

	SET @Index = 1;
	SET @Length = LEN(@WorkPhone) + 1;
	SET @TmpWorkPhone = '';

	IF @WorkPhone IS NOT NULL AND @Length <> 1
	BEGIN 
	  WHILE @Index < @Length BEGIN
		SET @Char = ASCII(SUBSTRING(@WorkPhone, @Index, 1));

		IF @Char BETWEEN 32 AND 127
			SET @TmpWorkPhone = @TmpWorkPhone + CHAR(@Char);
		ELSE
			SET @Updated = 1;

		SET @Index = @Index + 1;
	  END;
	END;

	SET @Index = 1;
	SET @Length = LEN(@SSN) + 1;
	SET @TmpSSN = '';

	IF @SSN IS NOT NULL AND @Length <> 1
	BEGIN
	  WHILE @Index < @Length BEGIN
		SET @Char = ASCII(SUBSTRING(@SSN, @Index, 1));

		IF @Char BETWEEN 32 AND 127
			SET @TmpSSN = @TmpSSN + CHAR(@Char);
		ELSE
			SET @Updated = 1;

		SET @Index = @Index + 1;
	  END;
	END;

	SET @Index = 1;
	SET @Length = LEN(@LastName) + 1;
	SET @TmpLastName = '';

	IF @LastName IS NOT NULL AND @Length <> 1
	BEGIN
	  WHILE @Index < @Length BEGIN
		SET @Char = ASCII(SUBSTRING(@LastName, @Index, 1));

		IF @Char BETWEEN 32 AND 127
			SET @TmpLastName = @TmpLastName + CHAR(@Char);
		ELSE
			SET @Updated = 1;

		SET @Index = @Index + 1;
	  END;
	END;

	SET @Index = 1;
	SET @Length = LEN(@FirstName) + 1;
	SET @TmpFirstName = '';

	IF @FirstName IS NOT NULL AND @Length <> 1
	BEGIN
	  WHILE @Index < @Length BEGIN
		SET @Char = ASCII(SUBSTRING(@FirstName, @Index, 1));

		IF @Char BETWEEN 32 AND 127
			SET @TmpFirstName = @TmpFirstName + CHAR(@Char);
		ELSE
			SET @Updated = 1;

		SET @Index = @Index + 1;
	  END;
	END;

	SET @Index = 1;
	SET @Length = LEN(@MiddleName) + 1;
	SET @TmpMiddleName = '';

	IF @MiddleName IS NOT NULL AND @Length <> 1
	BEGIN
	  WHILE @Index < @Length BEGIN
		SET @Char = ASCII(SUBSTRING(@MiddleName, @Index, 1));

		IF @Char BETWEEN 32 AND 127
			SET @TmpMiddleName = @TmpMiddleName + CHAR(@Char);
		ELSE
			SET @Updated = 1;

		SET @Index = @Index + 1;
	  END;
	END;


	IF @Updated = 1 BEGIN
	  	
		UPDATE dbo.debtors
		SET [Name] 		= @TmpName,
		    Street1 	= @TmpStreet1,
		    Street2 	= @TmpStreet2,
		    City 		= @TmpCity,
		    State 		= @TmpState,
		    Zipcode 	= @TmpZipcode,
		    HomePhone 	= @TmpHomePhone,
		    WorkPhone 	= @TmpWorkPhone,
		    SSN 		= @TmpSSN,
			lastName	= @LastName,
			FirstName	= @FirstName,
			MiddleName	= @MiddleName

		WHERE CURRENT OF @DbtrDmGrph;


		SET @CountUpdated = @CountUpdated + 1;
		SET @CommitCOUNT = @CommitCount + 1;

		IF @CommitCount >= @CommitThreshold
		BEGIN
			COMMIT TRANSACTION 
			SET @CommitCOUNT = 0
			BEGIN TRANSACTION 
			
		END;
	END;

	SET @Count = @Count + 1;

	IF @Count % 1000 = 0
		RAISERROR('Checked %d debtors, fixed %d debtors.', 10, 1, @Count, @CountUpdated);

	FETCH NEXT FROM @DbtrDmGrph INTO @Number, @Name, @Street1, @Street2, @City, @State, @Zipcode, @HomePhone, @WorkPhone, @SSN, @LastName, @FirstName, @MiddleName;
END;

CLOSE @DbtrDmGrph;
DEALLOCATE @DbtrDmGrph;

COMMIT TRANSACTION 


RAISERROR('Checked %d debtors, fixed %d debtors.', 10, 1, @Count, @CountUpdated);



END;

GO
