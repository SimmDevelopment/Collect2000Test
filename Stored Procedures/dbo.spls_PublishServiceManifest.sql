SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.spls_PublishServiceManifest    Script Date: 12/21/2005 4:22:08 PM ******/

/*dbo.spls_PublishServiceManifest*/
CREATE  proc [dbo].[spls_PublishServiceManifest]
	@doc ntext
AS
-- Name:		spls_PublishServiceManifest
-- Function:		This procedure will publish a service manifest to Latitude database
-- Creation:		09/16/2004 jc
--			Used by Latitude Scheduler.
-- Change History:	10/5/2004 jc added support for new service profile attribute InFilenameFormat
--			10/6/2004 jc added support for new service profile attribute ftpOutPath
--			11/8/2004 jc added support for new service profile attribute ProcessResponse
BEGIN TRANSACTION
	--declare local variables 
	declare @idoc int
	declare @ManifestID varchar(256), @publish varchar(256) 
	declare @ManifestIDguid uniqueidentifier

	-- Create an internal representation of the XML document.
	exec sp_xml_preparedocument @idoc output, @doc, '<manifest xmlns:xsm="manifest.xsd"/>'
	if (@@error != 0) goto ErrHandler

	--assign local variables from xml data
	select @ManifestID = ManifestID, @publish = Publish
		from openxml (@idoc, '/xsm:manifest/xsm:Service',1)
        with (ManifestID varchar(256), Publish varchar(256))
	if (@@error != 0) goto ErrHandler

	--ensure ManifestID is a guid
	select @ManifestIDguid = cast(@ManifestID as uniqueIdentifier)
	if (@@error != 0) begin
		RAISERROR('Service manifest contains an invalid ManifestID %d.  spls_PublishServiceManifest failed.', 11, 1, @ManifestID)
    		goto ErrHandler
	end

	--determine whether to proceed with publish (examine publish xml attribute)
	if @publish <> 'Y' begin
		goto cuExit
	end

	--delete existing service manifest if exists
	if (select count(*) from Services_MANIFEST where ManifestID = @ManifestID) > 0 begin
		if (select count(*) from ServiceProducts_MANIFEST where ManifestID = @ManifestID) > 0 begin
			--delete service products
			delete ServiceProducts_MANIFEST where ManifestID = @ManifestID
			if (@@error != 0) goto ErrHandler
		end
		if (select count(*) from ServiceProfiles_MANIFEST where ManifestID = @ManifestID) > 0 begin
			--delete service profiles
			delete ServiceProfiles_MANIFEST where ManifestID = @ManifestID
			if (@@error != 0) goto ErrHandler
		end
		-- delete service manifest
		delete Services_MANIFEST where ManifestID = @ManifestID
		if (@@error != 0) goto ErrHandler
	end

	--insert Services_MANIFEST
	insert into Services_MANIFEST(ManifestID, Name, Version, Description, Enabled, Publish, Profile, XmlResponseEngine, XPathMatch, XPathMatchRequestID, XPathNoMatch, XPathNoMatchRequestID)
	select x.ManifestID, x.Name, x.Version, x.Description, case x.Enabled when 'Y' then 1 else 0 end, 
	case x.Publish when 'Y' then 1 else 0 end, x.Profile, x.XmlResponseEngine, x.XPathMatch, x.XPathMatchRequestID, x.XPathNoMatch, x.XPathNoMatchRequestID
	from openxml (@idoc, '/xsm:manifest/xsm:Service', 1) 
        with (ManifestID varchar(256), Name varchar(256), Version varchar(256), Description varchar(256), Enabled varchar(256), Publish varchar(256), Profile varchar(256), XmlResponseEngine varchar(256), 
	XPathMatch varchar(256), XPathMatchRequestID varchar(256), XPathNoMatch varchar(256), XPathNoMatchRequestID varchar(256)) x
	if (@@error != 0) goto ErrHandler

	--insert ServiceProducts_MANIFEST
	insert into ServiceProducts_MANIFEST (ProductID, ManifestID, Name, Description, ProfileID)
	select cast(x.ProductID as uniqueidentifier), @ManifestIDguid, x.Name, x.Description, cast(x.ProfileID as uniqueidentifier)
	from openxml (@idoc, '/xsm:manifest/xsm:Service/xsm:Products/xsm:Product', 1)
        with (ProductID varchar(256), Name varchar(256), Description varchar(256), ProfileID varchar(256)) x
	if (@@error != 0) goto ErrHandler

	--insert ServiceProfiles_MANIFEST
	insert into ServiceProfiles_MANIFEST (ProfileID, ManifestID, Name, Description, Active, IsDataWarehoused, 
		MaxRecords, OutPath, OutFilenameExpression, OutFilenameFormat, InPath, InFilenameExpression, 
		InFilenameFormat, ArchivePath, ExceptionPath, ftpEnabled, ftpServer, ftpUser, ftpPassword, ftpOutPath, ProcessResponse)
	select cast(x.ProfileID as uniqueidentifier), @ManifestIDguid, x.Name, x.Description, 
		case x.Active when 'Y' then 1 else 0 end, 
		case x.IsDataWarehoused when 'Y' then 1 else 0 end,
		x.MaxRecords, x.OutPath, x.OutFilenameExpression, x.OutFilenameFormat, x.InPath, x.InFilenameExpression,
		x.InFilenameFormat, x.ArchivePath, x.ExceptionPath, 
		case x.ftpEnabled when 'Y' then 1 else 0 end, x.ftpServer, x.ftpUser, x.ftpPassword, x.ftpOutPath, x.ProcessResponse
	from openxml (@idoc, '/xsm:manifest/xsm:Service/xsm:Profiles/xsm:Profile', 1)
        with (ProfileID varchar(256), Name varchar(256), Description varchar(256), Active varchar(256), IsDataWarehoused varchar(256),
		MaxRecords varchar(256), OutPath varchar(256), OutFilenameExpression varchar(256), OutFilenameFormat varchar(256),
		InPath varchar(256), InFilenameExpression varchar(256), InFilenameFormat varchar(256), ArchivePath varchar(256), 
		ExceptionPath varchar(256), ftpEnabled varchar(256), ftpServer varchar(256), ftpUser varchar(256), 
		ftpPassword varchar(256), ftpOutPath varchar(256), ProcessResponse varchar(256)) x 
	if (@@error != 0) goto ErrHandler

cuExit:
	-- Remove the document from memory
	if @idoc is not null exec sp_xml_removedocument @idoc
	if (@@error != 0) goto ErrHandler
	COMMIT TRANSACTION		
	Return	

ErrHandler:
	-- Remove the document from memory if @idoc variable set 
	if @idoc is not null exec sp_xml_removedocument @idoc
	RAISERROR('Error encountered in spls_PublishServiceManifest for ManifestID %d.  spls_PublishServiceManifest failed.', 11, 1, @ManifestID)
	ROLLBACK TRANSACTION
	Return


GO
