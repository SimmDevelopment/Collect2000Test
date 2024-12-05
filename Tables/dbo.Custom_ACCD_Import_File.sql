CREATE TABLE [dbo].[Custom_ACCD_Import_File]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[FPSYSN] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPPRIN] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPCOLL] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPACCT] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPPNME] [varchar] (26) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPSNME] [varchar] (26) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPCFLG] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPWKPH] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPHMPH] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPXSTA] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPISTA] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPCBAL] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPCRLN] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPAMTD] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPDAYD] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPDTLP] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPAMLP] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPZPCD] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPBSCR] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPRMTN] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPAFLG] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPADR1] [varchar] (26) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPADR2] [varchar] (26) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPCITY] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPSTAT] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPZIP4] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPSECF] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPSPF] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FP6MF] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPAFMT] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPPRDT] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPPRAM] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPLREA] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPSTAC] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPSSN] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPWRKD] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPMNCK] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPPORT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPUDRP] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPSC58] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPMIS1] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPMIS2] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPMIS3] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPMIS4] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPMIS5] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPMIS6] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPMIS7] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPMIS8] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPMIS9] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPMI10] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPFIXP] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPCURP] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPEXPD] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPCRDF] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPNMOG] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FP1CYC] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FP2CYC] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FP3CYC] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPCRDS] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPCRRN] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPRGED] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPPMTA] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPRYAM] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPRTTL] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPRTND] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPRTNA] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPUDR2] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPUDR3] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPUDR4] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPSTRC] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPOPND] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPSTCD] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPFLG1] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPFLG2] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPFLG3] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPFLG4] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPCYCL] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPORAC] [varchar] (24) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPRAND] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPD1CA] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPD2CA] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPD3CA] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPD4CA] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPD5CA] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPD6CA] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPD7CA] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPPH1] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPPF1] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPPM1] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPPB1] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPPP1] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPPC1] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPPH2] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPPF2] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPPM2] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPPB2] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPPP2] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPPC2] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FPHHMM] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_ACCD_Import_File] ADD CONSTRAINT [PK_Custom_ACCD_Import_File] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
