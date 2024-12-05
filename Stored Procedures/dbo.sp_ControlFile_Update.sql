SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*sp_ControlFile_Update*/
CREATE Procedure [dbo].[sp_ControlFile_Update]
(
	@Company varchar(50),
	@Street1 varchar(30),
	@Street2 varchar(30),
	@City varchar(20),
	@State varchar(3),
	@Zipcode varchar(10),
	@Fax varchar(20),
	@Phone varchar(20),
	@Phone800 varchar(20),
	@Nextdebtor int,
	@Nextinvoice int,
	@Nextlink int,
	@Password varchar(128),
	@Currentmonth smallint,
	@Currentyear smallint,
	@Useroptions varchar(50),
	@Userdate1 varchar(20),
	@Userdate2 varchar(20),
	@Userdate3 varchar(20),
	@Money1 varchar(20),
	@Money2 varchar(20),
	@Money3 varchar(20),
	@Money4 varchar(20),
	@Money5 varchar(20),
	@Money6 varchar(20),
	@Money7 varchar(20),
	@Money8 varchar(20),
	@Money9 varchar(20),
	@Money10 varchar(20),
	@Ctl varchar(3),
	@X1 int,
	@X2 int,
	@Fees money,
	@Collections money,
	@Mtdpdcfees money,
	@Mtdpdccollections money,
	@Mtdfees money,
	@Mtdcollections money,
	@Ytdfees money,
	@Ytdcollections money,
	@Letterrm varchar(50),
	@Letterpdc varchar(50),
	@Letterbp varchar(50),
	@Option1 varchar(3),
	@Backuppath varchar(50),
	@SoftwareVersion varchar(25),
	@CrystalReports varchar(50),
	@Eomdate datetime,
	@LastDayEnd datetime,
	@CheckStocks image,
	@HomePage varchar(50),
	@Email varchar(50),
	@LastMatchDate datetime,
	@SeedLetterNo int,
	@AIMFilesPath varchar(50),
	@Images varbinary,
	@Options varchar(50),
	@LastDialerRead datetime,
	@InvoiceOption1 bit,
	@InvoiceOption2 bit,
	@WebBase varchar(100),
	@RightFaxServerName varchar(50),
	@RightFaxUserID varchar(50),
	@MailServerOut varchar(100)
)
AS
	UPDATE controlFile
	SET
	Company = @Company,
	Street1 = @Street1,
	Street2 = @Street2,
	City = @City,
	State = @State,
	Zipcode = @Zipcode,
	fax = @Fax,
	phone = @Phone,
	phone800 = @Phone800,
	nextdebtor = @Nextdebtor,
	nextinvoice = @Nextinvoice,
	nextlink = @Nextlink,
--	password = @Password,
	currentmonth = @Currentmonth,
	currentyear = @Currentyear,
	useroptions = @Useroptions,
	userdate1 = @Userdate1,
	userdate2 = @Userdate2,
	userdate3 = @Userdate3,
	money1 = @Money1,
	money2 = @Money2,
	money3 = @Money3,
	money4 = @Money4,
	money5 = @Money5,
	money6 = @Money6,
	money7 = @Money7,
	money8 = @Money8,
	money9 = @Money9,
	money10 = @Money10,
	ctl = @Ctl,
	X1 = @X1,
	X2 = @X2,
	fees = @Fees,
	collections = @Collections,
	mtdpdcfees = @Mtdpdcfees,
	mtdpdccollections = @Mtdpdccollections,
	mtdfees = @Mtdfees,
	mtdcollections = @Mtdcollections,
	ytdfees = @Ytdfees,
	ytdcollections = @Ytdcollections,
	letterrm = @Letterrm,
	letterpdc = @Letterpdc,
	letterbp = @Letterbp,
	Option1 = @Option1,
	backuppath = @Backuppath,
	SoftwareVersion = @SoftwareVersion,
	CrystalReports = @CrystalReports,
	eomdate = @Eomdate,
	LastDayEnd = @LastDayEnd,
	CheckStocks = @CheckStocks,
	HomePage = @HomePage,
	Email = @Email,
	LastMatchDate = @LastMatchDate,
	SeedLetterNo = @SeedLetterNo,
	AIMFilesPath = @AIMFilesPath,
	--This was commented out because somehow the data was getting corrupted
	--Images = @Images,
	options = @Options,
	LastDialerRead = @LastDialerRead,
	InvoiceOption1 = @InvoiceOption1,
	InvoiceOption2 = @InvoiceOption2,
	WebBase = @WebBase,
	RightFaxServerName = @RightFaxServerName,
	RightFaxUserID = @RightFaxUserID,
	MailServerOut = @MailServerOut

GO