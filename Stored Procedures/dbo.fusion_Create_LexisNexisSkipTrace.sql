SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Jeff Mixon
-- Create date:	10/19/2006
-- Description:	LexisNexis SkipTrace Fusion Create
-- =============================================
CREATE PROCEDURE [dbo].[fusion_Create_LexisNexisSkipTrace]
AS
BEGIN
	SET NOCOUNT ON;

IF not exists (select * from Services where ManifestId='7789F41A-D5C0-4203-8FB8-5D39D53AE9E8')
  BEGIN
	INSERT INTO [Services]
	([Description],[Enabled],[UpdateAccounts],[ManifestID],[MinBalance],[TransformationSchema])
	 VALUES
	 ('LexisNexis SkipTrace Service',1,0,'7789F41A-D5C0-4203-8FB8-5D39D53AE9E8',0,
	'<?xml version="1.0"?>
	<html xsl:version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/TR/xhtml1/strict">
		<head>
			<title>SurePlacement Data</title>
		</head>
		<body>
			<xsl:for-each select=".//DataRows/DataRow">
				<table border="1" cellspacing="0" bgcolor="#b0c4de" cellpadding="1" width="100%" borderColor="b0c4de" style="WIDTH: 100%FONT-FAMILY: Verdana, Tahoma, Helvetica, Arial FONT-SIZE: 10pt">
					<tr align="left" bgcolor="#b0c4de" width="98%">
						<th><xsl:text>L Type</xsl:text></th>
					</tr>
				</table>	
				<table border="1" cellspacing="0" bgcolor="#b0c4de" cellpadding="1" width="100%" borderColor="b0c4de" style="WIDTH: 100%FONT-FAMILY: Verdana, Tahoma, Helvetica, Arial FONT-SIZE: 10pt">
					<tbody>
							<xsl:for-each select="node()">
								<tr>
									<td align="left" bgcolor="eee8aa" width="30%">
										<xsl:value-of select="translate(name(), ''_'', '' '')"/>
									</td>
									<td align="left" bgcolor="eee8aa" width="70%">
										<xsl:value-of select="text()"/>
									</td>							
								</tr>
							</xsl:for-each>			
					</tbody>
				</table>
				<br></br>			
			</xsl:for-each>													
		</body>
	</html>'
	)

	DECLARE @ServiceID INTEGER
	SET @ServiceID = @@IDENTITY

	INSERT INTO [dbo].[ServicesCustomers] ([ServiceID], [CustomerID], [ProfileID], [MinBalance]) 
	SELECT @ServiceID, [Customer].[CCustomerID], NULL, 0 FROM [dbo].[Customer] AS [Customer] 
	WHERE [Customer].[CCustomerID] NOT IN ( SELECT [ServicesCustomers1].[CustomerID] FROM [dbo].[ServicesCustomers] AS [ServicesCustomers1] WHERE [ServicesCustomers1].[ServiceID] = @ServiceID)
  END 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Services_LexisNexis_SkipTrace]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
CREATE TABLE [dbo].[Services_LexisNexis_SkipTrace](
[ID] [int] IDENTITY(1,1) NOT NULL,
[RequestId] [int] NOT NULL,
[RecordId]  [varchar] (2) NULL,
[Agency]  [varchar] (5) NULL,
[Batch]  [varchar] (5) NULL,
[DocumentId]  [int] NULL,
[Name]  [varchar] (50) NULL,
[Filler]  [varchar] (1) NULL,
[Address]  [varchar] (50) NULL,
[City]  [varchar] (50) NULL,
[State]  [varchar] (5) NULL,
[Zip]  [varchar] (10) NULL,
[Zip2]  [varchar] (10) NULL,
[Reserved1]  [varchar] (50) NULL,
[SurnameCount]  [varchar] (5) NULL,
[AddressFlag]  [varchar] (50) NULL,
[Reserved2]  [varchar] (50) NULL,
[DeliveryCode]  [varchar] (10) NULL,
[Reserved3]  [varchar] (50) NULL,
[InputPhone]  [varchar] (15) NULL,
[Reserved4]  [varchar] (50) NULL,
[ClientId]  [varchar] (5) NULL,
[NCOAFlag]  [varchar] (2) NULL,
[AddressOld]  [varchar] (50) NULL,
[MoveFlag]  [varchar] (2) NULL,
[MoveType]  [varchar] (2) NULL,
[CarrierRoute]  [varchar] (5) NULL,
[SSN]  [varchar] (15) NULL,
[Request codes]  [varchar] (5) NULL,
[Hit code]  [varchar] (50) NULL,
[MoveDate]  [datetime] NULL,
[Reserved5]  [varchar] (50) NULL,
[NCOAIndicator]  [varchar] (2) NULL,
[Branch]  [varchar] (10) NULL,
[Reserved6]  [varchar] (50) NULL,
 CONSTRAINT [PK_Services_LexisNexis_SkipTrace_SkipTrace] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)ON [PRIMARY]
) ON [PRIMARY]
END
---------------
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Services_LexisNexis_SkipTrace_Nixie]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
CREATE TABLE [dbo].[Services_LexisNexis_SkipTrace_Nixie](
[ID] [int] IDENTITY(1,1) NOT NULL,
[RequestId] [int] NOT NULL,
[RecordId]  [varchar] (2) NULL,
[Agency]  [varchar] (5) NULL,
[Batch]  [varchar] (5) NULL,
[DocumentId]  [int] NULL,
[Reserved1]  [varchar] (50) NULL,
[ClientId]  [varchar] (5) NULL,
[Reserved2]  [varchar] (50) NULL,
[A]  [varchar] (5) NULL,
[B]  [varchar] (5) NULL,
[C]  [varchar] (5) NULL,
[D]  [varchar] (5) NULL,
[E]  [varchar] (5) NULL,
[F]  [varchar] (5) NULL,
[G]  [varchar] (5) NULL,
[H]  [varchar] (5) NULL,
[I]  [varchar] (5) NULL,
[J]  [varchar] (5) NULL,
[K]  [varchar] (5) NULL,
[L]  [varchar] (5) NULL,
[M]  [varchar] (5) NULL,
[N]  [varchar] (5) NULL,
[O]  [varchar] (5) NULL,
[P]  [varchar] (5) NULL,
[Q]  [varchar] (5) NULL,
[R]  [varchar] (5) NULL,
[S]  [varchar] (5) NULL,
[T]  [varchar] (5) NULL,
[U]  [varchar] (5) NULL,
[V]  [varchar] (5) NULL,
[W]  [varchar] (5) NULL,
[X]  [varchar] (5) NULL,
[Reserved3]  [varchar] (50) NULL,
[NCOADeliverableCode]  [varchar] (2) NULL,
[Reserved4]  [varchar] (50) NULL,
[Branch]  [varchar] (10) NULL,
[Reserved5] [varchar] (50) NULL,
 CONSTRAINT [PK_Services_LexisNexis_SkipTrace_Nixie] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
) ON [PRIMARY] 
) ON [PRIMARY]
END
----------------------2A, 2B, 3, 4, 4A
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Services_LexisNexis_SkipTrace_Return]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
CREATE TABLE [dbo].[Services_LexisNexis_SkipTrace_Return](
[ID] [int] IDENTITY(1,1) NOT NULL,
[RequestId] [int] NOT NULL,
[RecordId]  [varchar] (2) NULL,
[Agency]  [varchar] (5) NULL,
[Batch]  [varchar] (5) NULL,
[DocumentId]  [int] NULL,
[Name]  [varchar] (50) NULL,
[Filler]  [varchar] (1) NULL,
[Address]  [varchar] (50) NULL,
[City]  [varchar] (50) NULL,
[State]  [varchar] (5) NULL,
[Zip]  [varchar] (10) NULL,
[Reserved1]  [varchar] (50) NULL,
[OwnTypeCode]  [int] NULL,
[Reserved2]  [varchar] (50) NULL,
[IncomeCode]  [int] NULL,
[Reserved3]  [varchar] (50) NULL,
[LengthResidence]  [varchar] (10) NULL,
[DwellingType]  [int] NULL,
[SpouseName]  [varchar] (10) NULL,
[Reserved4]  [varchar] (50) NULL,
[Reserved5]  [varchar] (50) NULL,
[OutputPhone]  [varchar] (15) NULL,
[Reserved6]  [varchar] (50) NULL,
[ClientId]  [varchar] (5) NULL,
[Reserved7]  [varchar] (50) NULL,
[Branch]  [varchar] (10) NULL,
[Reserved8]  [varchar] (50) NULL,
[TypeCode] [varchar] (2) NULL,
 CONSTRAINT [PK_Services_LexisNexis_SkipTrace_Return] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
) ON [PRIMARY] 
) ON [PRIMARY]
END
--------------------------------4B, 4C
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Services_LexisNexis_SkipTrace_SSN]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
CREATE TABLE [dbo].[Services_LexisNexis_SkipTrace_SSN](
[ID] [int] IDENTITY(1,1) NOT NULL,
[RequestId] [int] NOT NULL,
[RecordId]  [varchar] (2) NULL,
[Agency]  [varchar] (5) NULL,
[Batch]  [varchar] (5) NULL,
[DocumentId]  [int] NULL,
[Name]  [varchar] (50) NULL,
[Filler]  [varchar] (1) NULL,
[Address]  [varchar] (50) NULL,
[City]  [varchar] (50) NULL,
[State]  [varchar] (5) NULL,
[Zip]  [varchar] (10) NULL,
[Reserved1]  [varchar] (50) NULL,
[IncomeCode]  [int] NULL,
[Reserved2]  [varchar] (50) NULL,
[LengthResidence]  [varchar] (10) NULL,
[Reserved3]  [varchar] (50) NULL,
[Reserved4]  [varchar] (50) NULL,
[OutputPhone]  [varchar] (15) NULL,
[Reserved5]  [varchar] (50) NULL,
[ClientId]  [varchar] (5) NULL,
[Reserved6]  [varchar] (50) NULL,
[RecordDate]  [datetime] NULL,
[Reserved7]  [varchar] (50) NULL,
[Branch]  [varchar] (10) NULL,
[Reserved8]  [varchar] (50) NULL,
 CONSTRAINT [PK_Services_LexisNexis_SkipTrace_SSN] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
----------------------------------------------------4D
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Services_LexisNexis_SkipTrace_EDA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
CREATE TABLE [dbo].[Services_LexisNexis_SkipTrace_EDA](
[ID] [int] IDENTITY(1,1) NOT NULL,
[RequestId] [int] NOT NULL,
[RecordId]  [varchar] (2) NULL,
[Agency]  [varchar] (5) NULL,
[Reserved1]  [varchar] (50) NULL,
[Name]  [varchar] (50) NULL,
[Address]  [varchar] (50) NULL,
[City]  [varchar] (50) NULL,
[State]  [varchar] (5) NULL,
[Zip]  [varchar] (10) NULL,
[Zip2]  [varchar] (10) NULL,
[Reserved2]  [varchar] (50) NULL,
[Phone]  [varchar] (50) NULL,
[Reserved3]  [varchar] (50) NULL,
[ClientId]  [varchar] (5) NULL,
[Reserved4]  [varchar] (50) NULL,
[ReturnCode]  [varchar] (2) NULL,
[Reserved5]  [varchar] (50) NULL,
[Reserved6]  [varchar] (50) NULL,
[Branch]  [varchar] (10) NULL,
[Reserved7]  [varchar] (50) NULL,
 CONSTRAINT [PK_Services_LexisNexis_SkipTrace_EDA] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
------------------------------------------------------
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Services_LexisNexis_SkipTrace_Deceased]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
CREATE TABLE [dbo].[Services_LexisNexis_SkipTrace_Deceased](
[ID] [int] IDENTITY(1,1) NOT NULL,
[RequestId] [int] NOT NULL,
[RecordId]  [varchar] (2) NULL,
[Agency]  [varchar] (5) NULL,
[Batch]  [varchar] (5) NULL,
[DocumentId]  [int] NULL,
[MatchCode]  [int] NULL,
[GivenNameAlert]  [int] NULL,
[SurnameAlert]  [int] NULL,
[Gender Alert]  [int] NULL,
[SubUnitAlert]  [int] NULL,
[Reserved1]  [varchar] (50) NULL,
[DOB]  [datetime] NULL,
[DOD]  [datetime] NULL,
[DOBCode]  [int] NULL,
[Reserved2]  [varchar] (50) NULL,
[StateLastKnown]  [varchar] (5) NULL,
[CountyFlag]  [varchar] (5) NULL,
[Reserved3]  [varchar] (50) NULL,
[ClientId]  [varchar] (5) NULL,
[Reserved4]  [varchar] (50) NULL,
[Branch]  [varchar] (10) NULL,
[Reserved5]  [varchar] (50) NULL,
 CONSTRAINT [PK_Services_LexisNexis_SkipTrace_Deceased] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
) ON [PRIMARY] )
ON [PRIMARY]
END
--------------------------------------------------
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Services_LexisNexis_SkipTrace_Bankruptcy]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
CREATE TABLE [dbo].[Services_LexisNexis_SkipTrace_Bankruptcy](
[ID] [int] IDENTITY(1,1) NOT NULL,
[RequestId] [int] NOT NULL,
[RecordId]  [varchar] (2) NULL,
[Agency]  [varchar] (5) NULL,
[Batch]  [varchar] (5) NULL,
[DocumentId]  [int] NULL,
[MatchCode]  [int] NULL,
[GivenNameAlert]  [int] NULL,
[SurnameAlert]  [int] NULL,
[Gender Alert]  [int] NULL,
[Subunit Alert]  [varchar] (50) NULL,
[Reserved1]  [varchar] (50) NULL,
[Disposition Code]  [varchar] (50) NULL,
[Chapter Code]  [varchar] (50) NULL,
[AliasFlag]  [varchar] (2) NULL,
[FilingDate]  [datetime] NULL,
[CaseNumber]  [varchar] (20) NULL,
[ECOACode]  [varchar] (5) NULL,
[CityFiled]  [varchar] (25) NULL,
[StateFiled]  [varchar] (5) NULL,
[CountyFiled]  [varchar] (30) NULL,
[CountyCodeFiled]  [varchar] (5) NULL,
[Reserved2]  [varchar] (50) NULL,
[ClientId]  [varchar] (5) NULL,
[Reserved3]  [varchar] (50) NULL,
[DebtorPhone]  [varchar] (15) NULL,
[Reserved4]  [varchar] (50) NULL,
[Branch]  [varchar] (10) NULL,
[Reserved5]  [varchar] (50) NULL,
 CONSTRAINT [PK_Services_LexisNexis_SkipTrace_Bankruptcy] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
-----------------------------------------------
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Services_LexisNexis_SkipTrace_341]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
CREATE TABLE [dbo].[Services_LexisNexis_SkipTrace_341](
[ID] [int] IDENTITY(1,1) NOT NULL,
[RequestId] [int] NOT NULL,
[RecordId]  [varchar] (2) NULL,
[Agency]  [varchar] (5) NULL,
[Batch]  [varchar] (5) NULL,
[DocumentId]  [int] NULL,
[MatchCode]  [int] NULL,
[GivenNameAlert]  [int] NULL,
[SurnameAlert]  [int] NULL,
[Gender Alert]  [int] NULL,
[Subunit Alert]  [varchar] (50) NULL,
[Status Date]  [varchar] (50) NULL,
[Funds]  [varchar] (50) NULL,
[DismissalFlag]  [varchar] (5) NULL,
[DispositionCode]  [varchar] (5) NULL,
[ChapterCode]  [varchar] (5) NULL,
[AliasFlag]  [varchar] (2) NULL,
[FilingDate]  [datetime] NULL,
[CaseNumber]  [varchar] (20) NULL,
[ECOACode]  [varchar] (2) NULL,
[CityFiled]  [varchar] (25) NULL,
[StateFiled]  [varchar] (5) NULL,
[CountyFiled]  [varchar] (30) NULL,
[CountyFiledCode]  [varchar] (5) NULL,
[341Location]  [varchar] (60) NULL,
[Reserved1]  [varchar] (50) NULL,
[ClientId]  [varchar] (5) NULL,
[Reserved2]  [varchar] (50) NULL,
[341Date]  [datetime] NULL,
[341Time]  [datetime] NULL,
[Bardate]  [datetime] NULL,
[POCDate]  [datetime] NULL,
[DebtorPhone]  [varchar] (15) NULL,
[Screen]  [varchar] (2) NULL,
[Reserved3]  [varchar] (50) NULL,
[Branch]  [varchar] (10) NULL,
[Reserved4]  [varchar] (50) NULL,
 CONSTRAINT [PK_Services_LexisNexis_SkipTrace_341] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
------------------------------------------
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Services_LexisNexis_SkipTrace_Attorney]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
CREATE TABLE [dbo].[Services_LexisNexis_SkipTrace_Attorney](
[ID] [int] IDENTITY(1,1) NOT NULL,
[RequestId] [int] NOT NULL,
[RecordId]  [varchar] (2) NULL,
[Agency]  [varchar] (5) NULL,
[Batch]  [varchar] (5) NULL,
[DocumentId]  [int] NULL,
[LawFirm]  [varchar] (50) NULL,
[AttorneyName]  [varchar] (50) NULL,
[Attorney Street Address]  [varchar] (50) NULL,
[Attorney City]  [varchar] (50) NULL,
[AttorneyState]  [varchar] (5) NULL,
[Reserved1] [varchar] (50) NULL,
[ClientId] [varchar] (5) NULL,
[Reserved2] [varchar] (50) NULL,
[AttorneyZip] [varchar] (15) NULL,
[AttorneyPhone] [varchar] (15) NULL,
[Reserved3] [varchar] (50) NULL,
[Branch] [varchar] (10) NULL,
[Reserved4] [varchar] (50) NULL,
 CONSTRAINT [PK_Services_SurePlacement_Attorney] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
----------------------------------
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Services_LexisNexis_SkipTrace_Terminator]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
CREATE TABLE [dbo].[Services_LexisNexis_SkipTrace_Terminator](
[ID] [int] IDENTITY(1,1) NOT NULL,
[RequestId] [int] NOT NULL,
[RecordId]  [varchar] (2) NULL,
[Agency]  [varchar] (5) NULL,
[Batch]  [varchar] (5) NULL,
[DocumentId]  [int] NULL,
[Custom]  [varchar] (50) NULL,
[FileName]  [varchar] (50) NULL,
[ProcessDate]  [datetime] NULL,
[C]  [varchar] (5) NULL,
[D]  [varchar] (5) NULL,
[V]  [varchar] (5) NULL,
[W]  [varchar] (5) NULL,
[N]  [varchar] (5) NULL,
[BankoSkipHit]  [varchar] (5) NULL,
[Reserved1]  [varchar] (50) NULL,
[ClientId]  [varchar] (5) NULL,
[Reserved2]  [varchar] (50) NULL,
[Branch]  [varchar] (10) NULL,
[Reserved3]  [varchar] (50) NULL,
 CONSTRAINT [PK_Services_LexisNexis_SkipTrace_Terminator] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
) ON [PRIMARY]) ON [PRIMARY]
END
END
--------------------------
--CONDITIONS--
--------------------------
-- Conditions Script File, exported on 10/19/2006 2:50 PM
-- Address
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Address') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Address';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'Address', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace].[Address]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Address</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- AddressFlag
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'AddressFlag') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'AddressFlag';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'AddressFlag', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace].[AddressFlag]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">AddressFlag</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- AddressOld
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'AddressOld') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'AddressOld';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'AddressOld', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace].[AddressOld]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">AddressOld</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Agency
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Agency') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Agency';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'Agency', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace].[Agency]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Agency</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Batch
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Batch') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Batch';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'Batch', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace].[Batch]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Batch</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Branch
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Branch') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Branch';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'Branch', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace].[Branch]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Branch</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- CarrierRoute
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'CarrierRoute') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'CarrierRoute';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'CarrierRoute', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace].[CarrierRoute]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">CarrierRoute</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- City
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'City') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'City';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'City', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace].[City]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">City</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ClientId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'ClientId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'ClientId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'ClientId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace].[ClientId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ClientId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DeliveryCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'DeliveryCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'DeliveryCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'DeliveryCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace].[DeliveryCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">DeliveryCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DocumentId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'DocumentId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'DocumentId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'DocumentId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace].[DocumentId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">DocumentId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Filler
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Filler') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Filler';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'Filler', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace].[Filler]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Filler</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Hit code
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Hit code') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Hit code';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'Hit code', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace].[Hit code]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Hit code</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ID
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'ID') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'ID';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'ID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace].[ID]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">ID</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- InputPhone
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'InputPhone') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'InputPhone';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'InputPhone', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace].[InputPhone]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">InputPhone</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- MoveDate
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'MoveDate') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'MoveDate';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'MoveDate', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:DateCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<lowValue>
<condition xsi:null="1"/>
<relative>false</relative>
<value>0001-01-01T00:00:00.0000000-05:00</value>
<relativeType>Days</relativeType>
<amount>0</amount>
</lowValue>
<highValue>
<condition xsi:null="1"/>
<relative>false</relative>
<value>0001-01-01T00:00:00.0000000-05:00</value>
<relativeType>Days</relativeType>
<amount>0</amount>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace].[MoveDate]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">MoveDate</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:DateCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- MoveFlag
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'MoveFlag') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'MoveFlag';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'MoveFlag', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace].[MoveFlag]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">MoveFlag</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- MoveType
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'MoveType') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'MoveType';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'MoveType', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace].[MoveType]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">MoveType</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Name
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Name') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Name';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'Name', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace].[Name]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Name</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NCOAFlag
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'NCOAFlag') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'NCOAFlag';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'NCOAFlag', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace].[NCOAFlag]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NCOAFlag</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NCOAIndicator
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'NCOAIndicator') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'NCOAIndicator';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'NCOAIndicator', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace].[NCOAIndicator]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NCOAIndicator</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RecordId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'RecordId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'RecordId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'RecordId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace].[RecordId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">RecordId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Request codes
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Request codes') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Request codes';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'Request codes', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace].[Request codes]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Request codes</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RequestId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'RequestId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'RequestId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'RequestId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace].[RequestId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">RequestId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved1
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Reserved1') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Reserved1';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'Reserved1', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace].[Reserved1]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved1</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved2
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Reserved2') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Reserved2';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'Reserved2', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace].[Reserved2]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved2</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved3
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Reserved3') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Reserved3';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'Reserved3', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace].[Reserved3]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved3</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved4
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Reserved4') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Reserved4';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'Reserved4', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace].[Reserved4]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved4</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved5
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Reserved5') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Reserved5';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'Reserved5', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace].[Reserved5]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved5</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved6
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Reserved6') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Reserved6';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'Reserved6', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace].[Reserved6]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved6</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- SSN
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'SSN') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'SSN';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'SSN', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace].[SSN]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">SSN</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- State
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'State') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'State';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'State', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace].[State]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">State</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- SurnameCount
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'SurnameCount') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'SurnameCount';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'SurnameCount', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace].[SurnameCount]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">SurnameCount</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Zip
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Zip') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Zip';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'Zip', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace].[Zip]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Zip</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Zip2
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Zip2') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace' AND [Description] = 'Zip2';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace', 'Zip2', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace].[Zip2]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Zip2</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- 341Date
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = '341Date') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = '341Date';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', '341Date', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:DateCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<lowValue>
<condition xsi:null="1"/>
<relative>false</relative>
<value>0001-01-01T00:00:00.0000000-05:00</value>
<relativeType>Days</relativeType>
<amount>0</amount>
</lowValue>
<highValue>
<condition xsi:null="1"/>
<relative>false</relative>
<value>0001-01-01T00:00:00.0000000-05:00</value>
<relativeType>Days</relativeType>
<amount>0</amount>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_341].[341Date]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">341Date</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:DateCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- 341Location
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = '341Location') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = '341Location';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', '341Location', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_341].[341Location]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">341Location</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- 341Time
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = '341Time') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = '341Time';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', '341Time', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:DateCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<lowValue>
<condition xsi:null="1"/>
<relative>false</relative>
<value>0001-01-01T00:00:00.0000000-05:00</value>
<relativeType>Days</relativeType>
<amount>0</amount>
</lowValue>
<highValue>
<condition xsi:null="1"/>
<relative>false</relative>
<value>0001-01-01T00:00:00.0000000-05:00</value>
<relativeType>Days</relativeType>
<amount>0</amount>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_341].[341Time]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">341Time</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:DateCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Agency
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'Agency') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'Agency';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'Agency', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_341].[Agency]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Agency</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- AliasFlag
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'AliasFlag') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'AliasFlag';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'AliasFlag', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_341].[AliasFlag]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">AliasFlag</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Bardate
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'Bardate') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'Bardate';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'Bardate', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:DateCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<lowValue>
<condition xsi:null="1"/>
<relative>false</relative>
<value>0001-01-01T00:00:00.0000000-05:00</value>
<relativeType>Days</relativeType>
<amount>0</amount>
</lowValue>
<highValue>
<condition xsi:null="1"/>
<relative>false</relative>
<value>0001-01-01T00:00:00.0000000-05:00</value>
<relativeType>Days</relativeType>
<amount>0</amount>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_341].[Bardate]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">Bardate</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:DateCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Batch
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'Batch') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'Batch';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'Batch', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_341].[Batch]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Batch</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Branch
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'Branch') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'Branch';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'Branch', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_341].[Branch]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Branch</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- CaseNumber
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'CaseNumber') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'CaseNumber';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'CaseNumber', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_341].[CaseNumber]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">CaseNumber</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ChapterCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'ChapterCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'ChapterCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'ChapterCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_341].[ChapterCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ChapterCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- CityFiled
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'CityFiled') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'CityFiled';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'CityFiled', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_341].[CityFiled]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">CityFiled</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ClientId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'ClientId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'ClientId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'ClientId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_341].[ClientId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ClientId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- CountyFiled
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'CountyFiled') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'CountyFiled';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'CountyFiled', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_341].[CountyFiled]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">CountyFiled</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- CountyFiledCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'CountyFiledCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'CountyFiledCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'CountyFiledCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_341].[CountyFiledCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">CountyFiledCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DebtorPhone
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'DebtorPhone') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'DebtorPhone';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'DebtorPhone', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_341].[DebtorPhone]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">DebtorPhone</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DismissalFlag
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'DismissalFlag') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'DismissalFlag';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'DismissalFlag', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_341].[DismissalFlag]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">DismissalFlag</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DispositionCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'DispositionCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'DispositionCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'DispositionCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_341].[DispositionCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">DispositionCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DocumentId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'DocumentId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'DocumentId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'DocumentId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_341].[DocumentId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">DocumentId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ECOACode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'ECOACode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'ECOACode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'ECOACode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_341].[ECOACode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ECOACode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- FilingDate
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'FilingDate') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'FilingDate';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'FilingDate', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:DateCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<lowValue>
<condition xsi:null="1"/>
<relative>false</relative>
<value>0001-01-01T00:00:00.0000000-05:00</value>
<relativeType>Days</relativeType>
<amount>0</amount>
</lowValue>
<highValue>
<condition xsi:null="1"/>
<relative>false</relative>
<value>0001-01-01T00:00:00.0000000-05:00</value>
<relativeType>Days</relativeType>
<amount>0</amount>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_341].[FilingDate]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">FilingDate</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:DateCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Funds
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'Funds') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'Funds';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'Funds', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_341].[Funds]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Funds</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Gender Alert
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'Gender Alert') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'Gender Alert';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'Gender Alert', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_341].[Gender Alert]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">Gender Alert</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- GivenNameAlert
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'GivenNameAlert') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'GivenNameAlert';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'GivenNameAlert', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_341].[GivenNameAlert]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">GivenNameAlert</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ID
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'ID') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'ID';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'ID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_341].[ID]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">ID</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- MatchCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'MatchCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'MatchCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'MatchCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_341].[MatchCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">MatchCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- POCDate
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'POCDate') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'POCDate';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'POCDate', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:DateCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<lowValue>
<condition xsi:null="1"/>
<relative>false</relative>
<value>0001-01-01T00:00:00.0000000-05:00</value>
<relativeType>Days</relativeType>
<amount>0</amount>
</lowValue>
<highValue>
<condition xsi:null="1"/>
<relative>false</relative>
<value>0001-01-01T00:00:00.0000000-05:00</value>
<relativeType>Days</relativeType>
<amount>0</amount>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_341].[POCDate]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">POCDate</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:DateCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RecordId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'RecordId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'RecordId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'RecordId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_341].[RecordId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">RecordId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RequestId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'RequestId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'RequestId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'RequestId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_341].[RequestId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">RequestId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved1
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'Reserved1') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'Reserved1';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'Reserved1', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_341].[Reserved1]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved1</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved2
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'Reserved2') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'Reserved2';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'Reserved2', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_341].[Reserved2]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved2</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved3
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'Reserved3') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'Reserved3';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'Reserved3', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_341].[Reserved3]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved3</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved4
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'Reserved4') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'Reserved4';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'Reserved4', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_341].[Reserved4]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved4</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Screen
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'Screen') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'Screen';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'Screen', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_341].[Screen]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Screen</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- StateFiled
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'StateFiled') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'StateFiled';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'StateFiled', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_341].[StateFiled]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">StateFiled</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Status Date
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'Status Date') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'Status Date';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'Status Date', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_341].[Status Date]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Status Date</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Subunit Alert
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'Subunit Alert') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'Subunit Alert';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'Subunit Alert', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_341].[Subunit Alert]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Subunit Alert</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- SurnameAlert
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'SurnameAlert') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341' AND [Description] = 'SurnameAlert';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_341', 'SurnameAlert', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_341].[SurnameAlert]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">SurnameAlert</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_341]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_341</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_341].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Agency
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'Agency') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'Agency';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney', 'Agency', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Attorney].[Agency]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Agency</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Attorney]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Attorney</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Attorney].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Attorney City
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'Attorney City') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'Attorney City';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney', 'Attorney City', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Attorney].[Attorney City]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Attorney City</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Attorney]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Attorney</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Attorney].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Attorney Street Address
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'Attorney Street Address') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'Attorney Street Address';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney', 'Attorney Street Address', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Attorney].[Attorney Street Address]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Attorney Street Address</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Attorney]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Attorney</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Attorney].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- AttorneyName
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'AttorneyName') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'AttorneyName';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney', 'AttorneyName', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Attorney].[AttorneyName]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">AttorneyName</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Attorney]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Attorney</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Attorney].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- AttorneyPhone
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'AttorneyPhone') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'AttorneyPhone';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney', 'AttorneyPhone', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Attorney].[AttorneyPhone]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">AttorneyPhone</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Attorney]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Attorney</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Attorney].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- AttorneyState
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'AttorneyState') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'AttorneyState';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney', 'AttorneyState', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Attorney].[AttorneyState]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">AttorneyState</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Attorney]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Attorney</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Attorney].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- AttorneyZip
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'AttorneyZip') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'AttorneyZip';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney', 'AttorneyZip', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Attorney].[AttorneyZip]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">AttorneyZip</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Attorney]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Attorney</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Attorney].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Batch
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'Batch') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'Batch';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney', 'Batch', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Attorney].[Batch]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Batch</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Attorney]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Attorney</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Attorney].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Branch
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'Branch') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'Branch';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney', 'Branch', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Attorney].[Branch]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Branch</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Attorney]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Attorney</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Attorney].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ClientId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'ClientId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'ClientId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney', 'ClientId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Attorney].[ClientId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ClientId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Attorney]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Attorney</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Attorney].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DocumentId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'DocumentId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'DocumentId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney', 'DocumentId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Attorney].[DocumentId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">DocumentId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Attorney]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Attorney</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Attorney].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ID
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'ID') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'ID';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney', 'ID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Attorney].[ID]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">ID</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Attorney]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Attorney</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Attorney].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- LawFirm
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'LawFirm') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'LawFirm';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney', 'LawFirm', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Attorney].[LawFirm]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">LawFirm</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Attorney]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Attorney</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Attorney].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RecordId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'RecordId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'RecordId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney', 'RecordId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Attorney].[RecordId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">RecordId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Attorney]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Attorney</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Attorney].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RequestId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'RequestId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'RequestId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney', 'RequestId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Attorney].[RequestId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">RequestId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Attorney]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Attorney</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Attorney].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved1
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'Reserved1') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'Reserved1';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney', 'Reserved1', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Attorney].[Reserved1]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved1</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Attorney]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Attorney</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Attorney].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved2
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'Reserved2') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'Reserved2';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney', 'Reserved2', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Attorney].[Reserved2]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved2</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Attorney]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Attorney</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Attorney].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved3
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'Reserved3') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'Reserved3';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney', 'Reserved3', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Attorney].[Reserved3]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved3</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Attorney]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Attorney</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Attorney].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved4
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'Reserved4') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney' AND [Description] = 'Reserved4';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Attorney', 'Reserved4', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Attorney].[Reserved4]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved4</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Attorney]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Attorney</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Attorney].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Agency
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'Agency') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'Agency';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy', 'Agency', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Bankruptcy].[Agency]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Agency</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Bankruptcy]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- AliasFlag
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'AliasFlag') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'AliasFlag';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy', 'AliasFlag', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Bankruptcy].[AliasFlag]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">AliasFlag</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Bankruptcy]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Batch
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'Batch') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'Batch';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy', 'Batch', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Bankruptcy].[Batch]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Batch</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Bankruptcy]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Branch
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'Branch') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'Branch';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy', 'Branch', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Bankruptcy].[Branch]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Branch</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Bankruptcy]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- CaseNumber
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'CaseNumber') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'CaseNumber';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy', 'CaseNumber', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Bankruptcy].[CaseNumber]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">CaseNumber</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Bankruptcy]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Chapter Code
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'Chapter Code') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'Chapter Code';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy', 'Chapter Code', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Bankruptcy].[Chapter Code]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Chapter Code</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Bankruptcy]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- CityFiled
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'CityFiled') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'CityFiled';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy', 'CityFiled', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Bankruptcy].[CityFiled]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">CityFiled</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Bankruptcy]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ClientId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'ClientId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'ClientId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy', 'ClientId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Bankruptcy].[ClientId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ClientId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Bankruptcy]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- CountyCodeFiled
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'CountyCodeFiled') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'CountyCodeFiled';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy', 'CountyCodeFiled', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Bankruptcy].[CountyCodeFiled]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">CountyCodeFiled</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Bankruptcy]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- CountyFiled
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'CountyFiled') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'CountyFiled';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy', 'CountyFiled', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Bankruptcy].[CountyFiled]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">CountyFiled</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Bankruptcy]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DebtorPhone
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'DebtorPhone') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'DebtorPhone';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy', 'DebtorPhone', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Bankruptcy].[DebtorPhone]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">DebtorPhone</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Bankruptcy]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Disposition Code
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'Disposition Code') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'Disposition Code';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy', 'Disposition Code', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Bankruptcy].[Disposition Code]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Disposition Code</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Bankruptcy]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DocumentId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'DocumentId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'DocumentId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy', 'DocumentId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Bankruptcy].[DocumentId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">DocumentId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Bankruptcy]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ECOACode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'ECOACode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'ECOACode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy', 'ECOACode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Bankruptcy].[ECOACode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ECOACode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Bankruptcy]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- FilingDate
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'FilingDate') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'FilingDate';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy', 'FilingDate', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:DateCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<lowValue>
<condition xsi:null="1"/>
<relative>false</relative>
<value>0001-01-01T00:00:00.0000000-05:00</value>
<relativeType>Days</relativeType>
<amount>0</amount>
</lowValue>
<highValue>
<condition xsi:null="1"/>
<relative>false</relative>
<value>0001-01-01T00:00:00.0000000-05:00</value>
<relativeType>Days</relativeType>
<amount>0</amount>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Bankruptcy].[FilingDate]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">FilingDate</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:DateCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Bankruptcy]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Gender Alert
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'Gender Alert') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'Gender Alert';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy', 'Gender Alert', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Bankruptcy].[Gender Alert]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">Gender Alert</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Bankruptcy]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- GivenNameAlert
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'GivenNameAlert') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'GivenNameAlert';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy', 'GivenNameAlert', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Bankruptcy].[GivenNameAlert]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">GivenNameAlert</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Bankruptcy]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ID
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'ID') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'ID';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy', 'ID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Bankruptcy].[ID]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">ID</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Bankruptcy]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- MatchCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'MatchCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'MatchCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy', 'MatchCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Bankruptcy].[MatchCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">MatchCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Bankruptcy]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RecordId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'RecordId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'RecordId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy', 'RecordId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Bankruptcy].[RecordId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">RecordId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Bankruptcy]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RequestId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'RequestId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'RequestId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy', 'RequestId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Bankruptcy].[RequestId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">RequestId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Bankruptcy]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved1
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'Reserved1') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'Reserved1';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy', 'Reserved1', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Bankruptcy].[Reserved1]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved1</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Bankruptcy]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved2
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'Reserved2') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'Reserved2';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy', 'Reserved2', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Bankruptcy].[Reserved2]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved2</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Bankruptcy]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved3
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'Reserved3') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'Reserved3';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy', 'Reserved3', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Bankruptcy].[Reserved3]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved3</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Bankruptcy]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved4
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'Reserved4') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'Reserved4';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy', 'Reserved4', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Bankruptcy].[Reserved4]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved4</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Bankruptcy]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved5
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'Reserved5') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'Reserved5';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy', 'Reserved5', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Bankruptcy].[Reserved5]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved5</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Bankruptcy]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- StateFiled
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'StateFiled') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'StateFiled';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy', 'StateFiled', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Bankruptcy].[StateFiled]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">StateFiled</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Bankruptcy]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Subunit Alert
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'Subunit Alert') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'Subunit Alert';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy', 'Subunit Alert', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Bankruptcy].[Subunit Alert]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Subunit Alert</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Bankruptcy]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- SurnameAlert
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'SurnameAlert') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy' AND [Description] = 'SurnameAlert';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Bankruptcy', 'SurnameAlert', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Bankruptcy].[SurnameAlert]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">SurnameAlert</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Bankruptcy]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Agency
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'Agency') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'Agency';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased', 'Agency', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Deceased].[Agency]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Agency</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Deceased]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Batch
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'Batch') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'Batch';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased', 'Batch', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Deceased].[Batch]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Batch</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Deceased]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Branch
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'Branch') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'Branch';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased', 'Branch', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Deceased].[Branch]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Branch</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Deceased]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ClientId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'ClientId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'ClientId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased', 'ClientId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Deceased].[ClientId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ClientId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Deceased]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- CountyFlag
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'CountyFlag') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'CountyFlag';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased', 'CountyFlag', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Deceased].[CountyFlag]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">CountyFlag</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Deceased]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DOB
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'DOB') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'DOB';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased', 'DOB', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:DateCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<lowValue>
<condition xsi:null="1"/>
<relative>false</relative>
<value>0001-01-01T00:00:00.0000000-05:00</value>
<relativeType>Days</relativeType>
<amount>0</amount>
</lowValue>
<highValue>
<condition xsi:null="1"/>
<relative>false</relative>
<value>0001-01-01T00:00:00.0000000-05:00</value>
<relativeType>Days</relativeType>
<amount>0</amount>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Deceased].[DOB]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">DOB</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:DateCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Deceased]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DOBCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'DOBCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'DOBCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased', 'DOBCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Deceased].[DOBCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">DOBCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Deceased]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DocumentId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'DocumentId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'DocumentId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased', 'DocumentId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Deceased].[DocumentId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">DocumentId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Deceased]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DOD
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'DOD') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'DOD';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased', 'DOD', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:DateCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<lowValue>
<condition xsi:null="1"/>
<relative>false</relative>
<value>0001-01-01T00:00:00.0000000-05:00</value>
<relativeType>Days</relativeType>
<amount>0</amount>
</lowValue>
<highValue>
<condition xsi:null="1"/>
<relative>false</relative>
<value>0001-01-01T00:00:00.0000000-05:00</value>
<relativeType>Days</relativeType>
<amount>0</amount>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Deceased].[DOD]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">DOD</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:DateCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Deceased]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Gender Alert
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'Gender Alert') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'Gender Alert';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased', 'Gender Alert', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Deceased].[Gender Alert]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">Gender Alert</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Deceased]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- GivenNameAlert
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'GivenNameAlert') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'GivenNameAlert';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased', 'GivenNameAlert', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Deceased].[GivenNameAlert]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">GivenNameAlert</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Deceased]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ID
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'ID') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'ID';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased', 'ID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Deceased].[ID]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">ID</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Deceased]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- MatchCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'MatchCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'MatchCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased', 'MatchCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Deceased].[MatchCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">MatchCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Deceased]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RecordId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'RecordId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'RecordId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased', 'RecordId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Deceased].[RecordId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">RecordId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Deceased]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RequestId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'RequestId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'RequestId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased', 'RequestId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Deceased].[RequestId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">RequestId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Deceased]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved1
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'Reserved1') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'Reserved1';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased', 'Reserved1', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Deceased].[Reserved1]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved1</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Deceased]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved2
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'Reserved2') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'Reserved2';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased', 'Reserved2', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Deceased].[Reserved2]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved2</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Deceased]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved3
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'Reserved3') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'Reserved3';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased', 'Reserved3', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Deceased].[Reserved3]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved3</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Deceased]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved4
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'Reserved4') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'Reserved4';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased', 'Reserved4', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Deceased].[Reserved4]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved4</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Deceased]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved5
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'Reserved5') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'Reserved5';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased', 'Reserved5', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Deceased].[Reserved5]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved5</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Deceased]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- StateLastKnown
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'StateLastKnown') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'StateLastKnown';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased', 'StateLastKnown', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Deceased].[StateLastKnown]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">StateLastKnown</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Deceased]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- SubUnitAlert
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'SubUnitAlert') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'SubUnitAlert';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased', 'SubUnitAlert', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Deceased].[SubUnitAlert]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">SubUnitAlert</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Deceased]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- SurnameAlert
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'SurnameAlert') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased' AND [Description] = 'SurnameAlert';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Deceased', 'SurnameAlert', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Deceased].[SurnameAlert]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">SurnameAlert</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Deceased]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Address
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'Address') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'Address';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA', 'Address', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_EDA].[Address]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Address</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_EDA]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_EDA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_EDA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Agency
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'Agency') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'Agency';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA', 'Agency', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_EDA].[Agency]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Agency</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_EDA]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_EDA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_EDA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Branch
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'Branch') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'Branch';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA', 'Branch', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_EDA].[Branch]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Branch</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_EDA]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_EDA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_EDA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- City
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'City') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'City';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA', 'City', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_EDA].[City]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">City</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_EDA]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_EDA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_EDA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ClientId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'ClientId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'ClientId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA', 'ClientId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_EDA].[ClientId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ClientId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_EDA]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_EDA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_EDA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ID
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'ID') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'ID';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA', 'ID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_EDA].[ID]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">ID</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_EDA]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_EDA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_EDA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Name
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'Name') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'Name';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA', 'Name', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_EDA].[Name]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Name</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_EDA]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_EDA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_EDA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Phone
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'Phone') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'Phone';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA', 'Phone', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_EDA].[Phone]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Phone</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_EDA]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_EDA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_EDA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RecordId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'RecordId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'RecordId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA', 'RecordId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_EDA].[RecordId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">RecordId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_EDA]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_EDA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_EDA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RequestId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'RequestId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'RequestId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA', 'RequestId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_EDA].[RequestId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">RequestId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_EDA]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_EDA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_EDA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved1
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'Reserved1') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'Reserved1';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA', 'Reserved1', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_EDA].[Reserved1]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved1</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_EDA]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_EDA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_EDA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved2
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'Reserved2') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'Reserved2';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA', 'Reserved2', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_EDA].[Reserved2]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved2</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_EDA]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_EDA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_EDA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved3
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'Reserved3') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'Reserved3';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA', 'Reserved3', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_EDA].[Reserved3]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved3</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_EDA]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_EDA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_EDA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved4
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'Reserved4') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'Reserved4';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA', 'Reserved4', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_EDA].[Reserved4]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved4</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_EDA]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_EDA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_EDA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved5
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'Reserved5') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'Reserved5';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA', 'Reserved5', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_EDA].[Reserved5]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved5</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_EDA]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_EDA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_EDA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved6
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'Reserved6') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'Reserved6';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA', 'Reserved6', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_EDA].[Reserved6]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved6</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_EDA]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_EDA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_EDA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved7
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'Reserved7') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'Reserved7';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA', 'Reserved7', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_EDA].[Reserved7]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved7</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_EDA]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_EDA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_EDA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ReturnCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'ReturnCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'ReturnCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA', 'ReturnCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_EDA].[ReturnCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ReturnCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_EDA]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_EDA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_EDA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- State
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'State') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'State';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA', 'State', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_EDA].[State]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">State</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_EDA]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_EDA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_EDA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Zip
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'Zip') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'Zip';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA', 'Zip', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_EDA].[Zip]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Zip</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_EDA]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_EDA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_EDA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Zip2
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'Zip2') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA' AND [Description] = 'Zip2';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_EDA', 'Zip2', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_EDA].[Zip2]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Zip2</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_EDA]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_EDA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_EDA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- A
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'A') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'A';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'A', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[A]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">A</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Agency
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'Agency') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'Agency';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'Agency', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[Agency]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Agency</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- B
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'B') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'B';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'B', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[B]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">B</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Batch
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'Batch') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'Batch';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'Batch', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[Batch]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Batch</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Branch
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'Branch') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'Branch';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'Branch', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[Branch]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Branch</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- C
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'C') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'C';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'C', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[C]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">C</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ClientId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'ClientId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'ClientId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'ClientId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[ClientId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ClientId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- D
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'D') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'D';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'D', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[D]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">D</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DocumentId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'DocumentId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'DocumentId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'DocumentId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Nixie].[DocumentId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">DocumentId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- E
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'E') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'E';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'E', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[E]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">E</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- F
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'F') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'F';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'F', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[F]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">F</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- G
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'G') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'G';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'G', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[G]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">G</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- H
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'H') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'H';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'H', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[H]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">H</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- I
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'I') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'I';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'I', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[I]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">I</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ID
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'ID') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'ID';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'ID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Nixie].[ID]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">ID</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- J
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'J') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'J';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'J', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[J]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">J</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- K
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'K') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'K';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'K', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[K]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">K</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- L
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'L') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'L';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'L', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[L]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">L</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- M
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'M') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'M';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'M', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[M]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">M</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- N
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'N') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'N';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'N', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[N]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">N</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NCOADeliverableCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'NCOADeliverableCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'NCOADeliverableCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'NCOADeliverableCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[NCOADeliverableCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NCOADeliverableCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- O
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'O') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'O';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'O', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[O]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">O</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- P
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'P') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'P';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'P', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[P]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">P</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Q
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'Q') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'Q';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'Q', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[Q]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Q</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- R
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'R') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'R';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'R', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[R]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">R</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RecordId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'RecordId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'RecordId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'RecordId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[RecordId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">RecordId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RequestId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'RequestId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'RequestId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'RequestId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Nixie].[RequestId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">RequestId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved1
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'Reserved1') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'Reserved1';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'Reserved1', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[Reserved1]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved1</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved2
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'Reserved2') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'Reserved2';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'Reserved2', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[Reserved2]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved2</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved3
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'Reserved3') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'Reserved3';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'Reserved3', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[Reserved3]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved3</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved4
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'Reserved4') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'Reserved4';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'Reserved4', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[Reserved4]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved4</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved5
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'Reserved5') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'Reserved5';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'Reserved5', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[Reserved5]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved5</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- S
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'S') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'S';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'S', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[S]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">S</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- T
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'T') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'T';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'T', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[T]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">T</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- U
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'U') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'U';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'U', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[U]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">U</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- V
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'V') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'V';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'V', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[V]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">V</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- W
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'W') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'W';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'W', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[W]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">W</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- X
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'X') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie' AND [Description] = 'X';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Nixie', 'X', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Nixie].[X]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">X</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Nixie]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Nixie</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Nixie].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Address
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'Address') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'Address';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return', 'Address', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Return].[Address]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Address</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Return]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Return</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Return].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Agency
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'Agency') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'Agency';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return', 'Agency', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Return].[Agency]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Agency</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Return]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Return</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Return].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Batch
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'Batch') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'Batch';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return', 'Batch', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Return].[Batch]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Batch</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Return]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Return</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Return].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Branch
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'Branch') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'Branch';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return', 'Branch', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Return].[Branch]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Branch</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Return]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Return</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Return].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- City
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'City') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'City';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return', 'City', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Return].[City]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">City</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Return]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Return</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Return].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ClientId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'ClientId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'ClientId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return', 'ClientId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Return].[ClientId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ClientId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Return]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Return</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Return].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DocumentId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'DocumentId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'DocumentId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return', 'DocumentId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Return].[DocumentId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">DocumentId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Return]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Return</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Return].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DwellingType
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'DwellingType') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'DwellingType';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return', 'DwellingType', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Return].[DwellingType]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">DwellingType</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Return]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Return</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Return].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Filler
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'Filler') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'Filler';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return', 'Filler', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Return].[Filler]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Filler</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Return]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Return</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Return].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ID
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'ID') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'ID';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return', 'ID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Return].[ID]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">ID</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Return]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Return</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Return].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- IncomeCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'IncomeCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'IncomeCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return', 'IncomeCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Return].[IncomeCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">IncomeCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Return]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Return</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Return].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- LengthResidence
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'LengthResidence') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'LengthResidence';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return', 'LengthResidence', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Return].[LengthResidence]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">LengthResidence</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Return]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Return</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Return].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Name
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'Name') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'Name';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return', 'Name', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Return].[Name]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Name</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Return]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Return</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Return].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- OutputPhone
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'OutputPhone') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'OutputPhone';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return', 'OutputPhone', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Return].[OutputPhone]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">OutputPhone</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Return]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Return</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Return].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- OwnTypeCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'OwnTypeCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'OwnTypeCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return', 'OwnTypeCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Return].[OwnTypeCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">OwnTypeCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Return]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Return</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Return].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RecordId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'RecordId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'RecordId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return', 'RecordId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Return].[RecordId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">RecordId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Return]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Return</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Return].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RequestId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'RequestId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'RequestId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return', 'RequestId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Return].[RequestId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">RequestId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Return]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Return</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Return].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved1
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'Reserved1') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'Reserved1';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return', 'Reserved1', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Return].[Reserved1]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved1</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Return]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Return</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Return].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved2
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'Reserved2') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'Reserved2';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return', 'Reserved2', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Return].[Reserved2]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved2</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Return]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Return</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Return].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved3
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'Reserved3') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'Reserved3';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return', 'Reserved3', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Return].[Reserved3]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved3</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Return]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Return</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Return].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved4
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'Reserved4') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'Reserved4';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return', 'Reserved4', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Return].[Reserved4]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved4</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Return]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Return</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Return].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved5
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'Reserved5') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'Reserved5';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return', 'Reserved5', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Return].[Reserved5]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved5</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Return]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Return</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Return].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved6
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'Reserved6') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'Reserved6';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return', 'Reserved6', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Return].[Reserved6]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved6</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Return]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Return</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Return].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved7
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'Reserved7') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'Reserved7';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return', 'Reserved7', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Return].[Reserved7]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved7</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Return]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Return</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Return].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved8
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'Reserved8') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'Reserved8';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return', 'Reserved8', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Return].[Reserved8]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved8</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Return]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Return</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Return].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- SpouseName
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'SpouseName') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'SpouseName';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return', 'SpouseName', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Return].[SpouseName]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">SpouseName</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Return]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Return</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Return].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- State
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'State') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'State';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return', 'State', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Return].[State]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">State</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Return]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Return</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Return].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- TypeCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'TypeCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'TypeCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return', 'TypeCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Return].[TypeCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">TypeCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Return]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Return</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Return].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Zip
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'Zip') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return' AND [Description] = 'Zip';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Return', 'Zip', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Return].[Zip]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Zip</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Return]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Return</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Return].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Address
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'Address') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'Address';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN', 'Address', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_SSN].[Address]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Address</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_SSN]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_SSN</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_SSN].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Agency
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'Agency') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'Agency';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN', 'Agency', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_SSN].[Agency]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Agency</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_SSN]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_SSN</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_SSN].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Batch
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'Batch') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'Batch';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN', 'Batch', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_SSN].[Batch]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Batch</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_SSN]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_SSN</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_SSN].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Branch
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'Branch') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'Branch';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN', 'Branch', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_SSN].[Branch]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Branch</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_SSN]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_SSN</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_SSN].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- City
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'City') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'City';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN', 'City', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_SSN].[City]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">City</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_SSN]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_SSN</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_SSN].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ClientId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'ClientId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'ClientId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN', 'ClientId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_SSN].[ClientId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ClientId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_SSN]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_SSN</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_SSN].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DocumentId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'DocumentId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'DocumentId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN', 'DocumentId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_SSN].[DocumentId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">DocumentId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_SSN]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_SSN</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_SSN].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Filler
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'Filler') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'Filler';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN', 'Filler', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_SSN].[Filler]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Filler</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_SSN]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_SSN</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_SSN].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ID
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'ID') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'ID';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN', 'ID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_SSN].[ID]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">ID</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_SSN]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_SSN</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_SSN].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- IncomeCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'IncomeCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'IncomeCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN', 'IncomeCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_SSN].[IncomeCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">IncomeCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_SSN]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_SSN</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_SSN].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- LengthResidence
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'LengthResidence') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'LengthResidence';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN', 'LengthResidence', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_SSN].[LengthResidence]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">LengthResidence</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_SSN]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_SSN</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_SSN].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Name
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'Name') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'Name';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN', 'Name', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_SSN].[Name]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Name</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_SSN]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_SSN</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_SSN].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- OutputPhone
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'OutputPhone') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'OutputPhone';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN', 'OutputPhone', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_SSN].[OutputPhone]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">OutputPhone</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_SSN]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_SSN</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_SSN].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RecordDate
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'RecordDate') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'RecordDate';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN', 'RecordDate', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:DateCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<lowValue>
<condition xsi:null="1"/>
<relative>false</relative>
<value>0001-01-01T00:00:00.0000000-05:00</value>
<relativeType>Days</relativeType>
<amount>0</amount>
</lowValue>
<highValue>
<condition xsi:null="1"/>
<relative>false</relative>
<value>0001-01-01T00:00:00.0000000-05:00</value>
<relativeType>Days</relativeType>
<amount>0</amount>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_SSN].[RecordDate]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">RecordDate</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:DateCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_SSN]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_SSN</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_SSN].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RecordId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'RecordId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'RecordId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN', 'RecordId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_SSN].[RecordId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">RecordId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_SSN]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_SSN</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_SSN].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RequestId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'RequestId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'RequestId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN', 'RequestId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_SSN].[RequestId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">RequestId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_SSN]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_SSN</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_SSN].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved1
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'Reserved1') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'Reserved1';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN', 'Reserved1', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_SSN].[Reserved1]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved1</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_SSN]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_SSN</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_SSN].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved2
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'Reserved2') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'Reserved2';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN', 'Reserved2', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_SSN].[Reserved2]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved2</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_SSN]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_SSN</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_SSN].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved3
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'Reserved3') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'Reserved3';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN', 'Reserved3', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_SSN].[Reserved3]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved3</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_SSN]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_SSN</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_SSN].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved4
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'Reserved4') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'Reserved4';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN', 'Reserved4', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_SSN].[Reserved4]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved4</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_SSN]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_SSN</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_SSN].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved5
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'Reserved5') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'Reserved5';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN', 'Reserved5', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_SSN].[Reserved5]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved5</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_SSN]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_SSN</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_SSN].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved6
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'Reserved6') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'Reserved6';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN', 'Reserved6', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_SSN].[Reserved6]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved6</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_SSN]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_SSN</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_SSN].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved7
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'Reserved7') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'Reserved7';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN', 'Reserved7', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_SSN].[Reserved7]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved7</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_SSN]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_SSN</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_SSN].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved8
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'Reserved8') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'Reserved8';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN', 'Reserved8', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_SSN].[Reserved8]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved8</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_SSN]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_SSN</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_SSN].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- State
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'State') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'State';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN', 'State', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_SSN].[State]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">State</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_SSN]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_SSN</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_SSN].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Zip
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'Zip') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN' AND [Description] = 'Zip';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_SSN', 'Zip', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_SSN].[Zip]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Zip</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_SSN]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_SSN</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_SSN].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Agency
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'Agency') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'Agency';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator', 'Agency', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Terminator].[Agency]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Agency</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Terminator]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Terminator</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Terminator].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- BankoSkipHit
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'BankoSkipHit') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'BankoSkipHit';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator', 'BankoSkipHit', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Terminator].[BankoSkipHit]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">BankoSkipHit</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Terminator]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Terminator</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Terminator].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Batch
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'Batch') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'Batch';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator', 'Batch', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Terminator].[Batch]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Batch</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Terminator]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Terminator</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Terminator].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Branch
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'Branch') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'Branch';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator', 'Branch', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Terminator].[Branch]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Branch</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Terminator]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Terminator</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Terminator].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- C
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'C') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'C';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator', 'C', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Terminator].[C]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">C</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Terminator]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Terminator</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Terminator].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ClientId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'ClientId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'ClientId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator', 'ClientId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Terminator].[ClientId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ClientId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Terminator]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Terminator</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Terminator].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Custom
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'Custom') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'Custom';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator', 'Custom', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Terminator].[Custom]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Custom</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Terminator]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Terminator</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Terminator].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- D
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'D') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'D';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator', 'D', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Terminator].[D]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">D</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Terminator]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Terminator</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Terminator].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DocumentId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'DocumentId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'DocumentId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator', 'DocumentId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Terminator].[DocumentId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">DocumentId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Terminator]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Terminator</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Terminator].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- FileName
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'FileName') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'FileName';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator', 'FileName', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Terminator].[FileName]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">FileName</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Terminator]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Terminator</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Terminator].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ID
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'ID') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'ID';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator', 'ID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Terminator].[ID]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">ID</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Terminator]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Terminator</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Terminator].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- N
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'N') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'N';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator', 'N', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Terminator].[N]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">N</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Terminator]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Terminator</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Terminator].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ProcessDate
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'ProcessDate') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'ProcessDate';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator', 'ProcessDate', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:DateCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<lowValue>
<condition xsi:null="1"/>
<relative>false</relative>
<value>0001-01-01T00:00:00.0000000-05:00</value>
<relativeType>Days</relativeType>
<amount>0</amount>
</lowValue>
<highValue>
<condition xsi:null="1"/>
<relative>false</relative>
<value>0001-01-01T00:00:00.0000000-05:00</value>
<relativeType>Days</relativeType>
<amount>0</amount>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Terminator].[ProcessDate]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">ProcessDate</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:DateCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Terminator]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Terminator</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Terminator].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RecordId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'RecordId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'RecordId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator', 'RecordId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Terminator].[RecordId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">RecordId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Terminator]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Terminator</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Terminator].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RequestId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'RequestId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'RequestId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator', 'RequestId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_LexisNexis_SkipTrace_Terminator].[RequestId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">RequestId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_LexisNexis_SkipTrace_Terminator]</expression>
<alias id="ref-18">Services_LexisNexis_SkipTrace_Terminator</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Terminator].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved1
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'Reserved1') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'Reserved1';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator', 'Reserved1', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Terminator].[Reserved1]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved1</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Terminator]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Terminator</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Terminator].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved2
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'Reserved2') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'Reserved2';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator', 'Reserved2', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Terminator].[Reserved2]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved2</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Terminator]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Terminator</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Terminator].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reserved3
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'Reserved3') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'Reserved3';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator', 'Reserved3', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Terminator].[Reserved3]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reserved3</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Terminator]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Terminator</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Terminator].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- V
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'V') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'V';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator', 'V', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Terminator].[V]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">V</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Terminator]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Terminator</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Terminator].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- W
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'W') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator' AND [Description] = 'W';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\LexisNexis\SkipTrace\Services_LexisNexis_SkipTrace_Terminator', 'W', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_LexisNexis_SkipTrace_Terminator].[W]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">W</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_LexisNexis_SkipTrace_Terminator]</expression>
<alias id="ref-19">Services_LexisNexis_SkipTrace_Terminator</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_LexisNexis_SkipTrace_Terminator].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');
GO
