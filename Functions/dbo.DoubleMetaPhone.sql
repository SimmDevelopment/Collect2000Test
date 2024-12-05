SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   FUNCTION [dbo].[DoubleMetaPhone] (@str varchar(70))
RETURNS char(10)
WITH SCHEMABINDING
AS


    BEGIN
    	
    	/*#########################################################################
    	
    	DOUBLE Metaphone Phonetic Matching Function
    	
    	This reduces word TO approximate phonetic string. This is deliberately
    	NOT a direct phonetic
    	
    	Based OFF original C++ code AND algorithm BY 
    					 Lawrence Philips (lphilips_AT_verity.com)
    	
    	Published IN the C/C++ Users Journal:
    	 http://www.cuj.com/articles/2000/0006/0006d/0006d.htm?topic=articles
    	
    	Original Metaphone presented in article in "Computer Language" in 1990.
    	
    	Reduces alphabet TO 
    	
    		 The 14 constonant sounds:
    		 "sh""p"or"b" "th"
    		 | | |
    		 X S K J T F H L M N P R 0 W
    	
    		 DROP vowels EXCEPT at the beginning
    	
    	Produces a char(10) string. The left(@result,5) gives the most common 
    	pronouciation, right(@result,5) gives the commonest alternate.
    	
    	
    	Translated INTO t-SQL BY Keith Henry (keithh@lbm-solutions.com)
    	
    	#########################################################################*/
    	
    	DECLARE	@original 	varchar(70),
    		@primary	varchar(70),
    		@secondary 	varchar(70),
    		@length		int,
    		@last	 	int,
    		@current	int,
    		@strcur1	char(1) ,
    		@strnext1 	char(1) ,
    		@strprev1	char(1),
    		@SlavoGermanic 	bit
    	
    	SET @SlavoGermanic	= 0
    	SET @primary 		= ''
    	SET @secondary 	= ''
    	SET @current 		= 1
    	SET @length		= len(@str)
    	SET @last	 	= @length
    	SET @original 		= lTrim(isnull(@str,'')) + '	'
    	
    	SET @original 		= upper(@original)
    	
    	IF patindex('%[WK]%',@str) + charindex('CZ',@str) + charindex('WITZ',@str) <> 0
    		SET @SlavoGermanic = 1
    	
    	-- skip this at beginning OF word
    	IF substring(@original, 1, 2) in ('GN', 'KN', 'PN', 'WR', 'PS')
    	 	SET @current = @current + 1
    	
    	-- Initial 'X' IS pronounced 'Z' e.g. 'Xavier'
    	IF substring(@original, 1, 1) = 'X'
    	BEGIN
    		SET @primary = @primary + 'S'-- 'Z' maps TO 'S'
    		SET @secondary = @secondary + 'S'
    		SET @current = @current + 1
    	END
    	
    	IF substring(@original, 1, 1) in ('A', 'E', 'I', 'O', 'U', 'Y')
    	BEGIN
    		SET @primary = @primary + 'A'-- ALL init vowels now map TO 'A'
    		SET @secondary = @secondary + 'A'
    		SET @current = @current + 1
    	END
    	
    	WHILE @current <= @length
    	BEGIN
    		IF len(@primary) >= 5 BREAK
    	
    		SET @strcur1 = substring(@original, @current, 1)
    		SET @strnext1 = substring(@original, (@current + 1), 1)
    		SET @strprev1 = substring(@original, (@current - 1), 1)
    		
    		IF @strcur1 IN ('A', 'E', 'I', 'O', 'U', 'Y', ' ', '''', '-')
    			SET @current = @current + 1
    		ELSE
    		
    		IF @strcur1 = 'B'		 -- '-mb', e.g. 'dumb', already skipped OVER ...
    		BEGIN
    			SET @primary = @primary + 'P'
    			SET @secondary = @secondary + 'P'
    			
    			IF @strnext1 = 'B'
    				SET @current = @current + 2
    			ELSE
    				SET @current = @current + 1
    		END
    		ELSE
    	
    		IF @strcur1 = '?'
    		BEGIN
    			SET @primary = @primary + 'S'
    			SET @secondary = @secondary + 'S'
    			SET @current = @current + 1
    		END
    		ELSE
    	
    		IF @strcur1 = 'C'
    		BEGIN	
    			IF @strnext1 = 'H'
    			BEGIN		
    		
    				IF substring(@original, @current, 4) = 'CHIA'	-- italian 'chianti'
    				BEGIN
    					SET @primary = @primary + 'K'
    					SET @secondary = @secondary + 'K'
    				END
    				ELSE
    				BEGIN
    					IF @current > 1	-- find 'michael'
    						AND substring(@original, @current, 4) = 'CHAE' 
    					BEGIN
    						 SET @primary = @primary + 'K'
    						 SET @secondary = @secondary + 'X'
    					END
    					ELSE
    					BEGIN
    						IF @current = 1		-- greek roots e.g. 'chemistry', 'chorus'
    							AND (substring(@original, @current + 1, 5) in ('HARAC', 'HARIS')
    								OR substring(@original, @current + 1, 3) in ('HOR', 'HYM', 'HIA', 'HEM')
    							)
    							AND substring(@original, 1, 5) <> 'CHORE'
    						BEGIN
    							SET @primary = @primary + 'K'
    							SET @secondary = @secondary + 'K'
    						END
    						ELSE
    						BEGIN
    							IF 	(	substring(@original, 0, 4) in ('VAN ', 'VON ')	-- germanic, greek, or otherwise 'ch' FOR 'kh' sound
    									OR substring(@original, 0, 3) = 'SCH'
    								)
    								OR substring(@original, @current - 2, 6) in ('ORCHES', 'ARCHIT', 'ORCHID')	-- 'architect' but NOT 'arch', orchestra', 'orchid'
    								OR substring(@original, @current + 2, 1) in ('T', 'S')
    								OR 	(	(	@strprev1 IN ('A','O','U','E')
    											OR @current = 1
    										)
    									AND substring(@original, @current + 2, 1) in ('L','R','N','M','B','H','F','V','W',' ')	-- e.g. 'wachtler', 'weschsler', but NOT 'tichner'
    								)
    							BEGIN 
    								SET @primary = @primary + 'K'
    								SET @secondary = @secondary + 'K'
    							END
    							ELSE 
    							BEGIN
    								IF (@current > 1) 
    								BEGIN
    									IF substring(@original, 1, 2) = 'MC' -- e.g. 'McHugh'
    									BEGIN
    										SET @primary = @primary + 'K'
    										SET @secondary = @secondary + 'K'
    									END
    									ELSE
    									BEGIN
    										SET @primary = @primary + 'X'
    										SET @secondary = @secondary + 'K'
    									END
    								END
    								ELSE
    								BEGIN
    									SET @primary = @primary + 'X'
    									SET @secondary = @secondary + 'X'
    								END
    							END
    						END
    					END
    				END
    				SET @current = @current + 2
    			END --ch logic
    			ELSE
    			BEGIN
    				IF @strnext1 = 'C'	-- DOUBLE 'C', but NOT McClellan'
    					AND not(@current = 1 
    							AND substring(@original, 1, 1) = 'M'
    						)
    				BEGIN
    					IF substring(@original, @current + 2, 1) in ('I','E','H')	-- 'bellocchio' but NOT 'bacchus'
    						AND substring(@original, @current + 2, 2) <> 'HU'
    					BEGIN
    						IF (	@current = 2	-- 'accident', 'accede', 'succeed'
    								AND @strprev1 = 'A'
    							)
    							OR substring(@original, @current - 1, 5) in ('UCCEE', 'UCCES')
    						BEGIN
    							SET @primary = @primary + 'KS'
    							SET @secondary = @secondary + 'KS'
    						END
    						ELSE
    						BEGIN	-- 'bacci', 'bertucci', other italian
    							SET @primary = @primary + 'X'
    							SET @secondary = @secondary + 'X'
    							-- e.g. 'focaccia'	IF substring(@original, @current, 4) = 'CCIA'	
    						END
    						SET @current = @current + 3
    					END
    					ELSE
    					BEGIN
    						SET @primary = @primary + 'K'	-- Pierce's RULE
    						SET @secondary = @secondary + 'K'
    						SET @current = @current + 2
    					END
    				END
    				ELSE
    				BEGIN
    					IF @strnext1 IN ('K','G','Q') 
    					BEGIN
    						SET @primary = @primary + 'K'
    						SET @secondary = @secondary + 'K'
    						SET @current = @current + 2
    					END
    					ELSE
    					BEGIN
    						IF @strnext1 IN ('I','E','Y')
    						BEGIN
    							IF substring(@original, @current, 3) in ('CIO','CIE','CIA')	-- italian vs. english
    							BEGIN
    								SET @primary = @primary + 'S'
    								SET @secondary = @secondary + 'X'
    							END
    							ELSE
    							BEGIN
    								SET @primary = @primary + 'S'
    								SET @secondary = @secondary + 'S'
    							END
    							SET @current = @current + 2
    						END
    						ELSE
    						BEGIN
    							IF @strnext1 = 'Z'	-- e.g. 'czerny'
    								AND substring(@original, @current -2, 4) <> 'WICZ'
    							BEGIN
    								SET @primary = @primary + 'S'
    								SET @secondary = @secondary + 'X'
    								SET @current = @current + 2
    							END
    							ELSE
    							BEGIN
    								IF @current > 2 -- various gremanic
    									AND substring(@original, @current - 2,1) NOT in ('A', 'E', 'I', 'O', 'U', 'Y') 
    									AND substring(@original, @current - 1, 3) = 'ACH'
    									AND ((substring(@original, @current + 2, 1) <> 'I')
    										AND ((substring(@original, @current + 2, 1) <> 'E')
    											OR substring(@original, @current - 2, 6) in ('BACHER', 'MACHER') 
    										)
    									)
    								BEGIN
    									SET @primary = @primary + 'K'
    									SET @secondary = @secondary + 'K'
    									SET @current = @current + 2
    								END
    								ELSE
    								BEGIN
    									IF @current = 1 -- special CASE 'caesar'
    										AND substring(@original, @current, 6) = 'CAESAR'
    									
    									BEGIN
    										SET @primary = @primary + 'S'
    										SET @secondary = @secondary + 'S'
    										SET @current = @current + 2
    									END
    									ELSE
    									BEGIN	-- final ELSE
    										SET @primary = @primary + 'K'
    										SET @secondary = @secondary + 'K'
    									
    										IF substring(@original, @current + 1, 2) in (' C',' Q',' G')	-- name sent in 'mac caffrey', 'mac gregor'
    											SET @current = @current + 3
    										ELSE
    										 	SET @current = @current + 1
    									END
    								END
    							END
    						END
    					END
    				END
    			END
    		END
    		ELSE
    	
    		IF @strcur1 = 'D'
    		BEGIN
    			IF @strnext1 = 'G'
    			BEGIN
    				IF substring(@original, @current + 2, 1) in ('I','E','Y')
    				BEGIN
    					SET @primary = @primary + 'J'	-- e.g. 'edge'
    					SET @secondary = @secondary + 'J'
    					SET @current = @current + 3
    				END
    				ELSE
    				BEGIN
    					SET @primary = @primary + 'TK'	-- e.g. 'edgar'
    					SET @secondary = @secondary + 'TK'
    					SET @current = @current + 2
    				END
    			END
    			ELSE
    			BEGIN
    				IF substring(@original, @current, 2) in ('DT','DD') 
    				BEGIN
    					SET @primary = @primary + 'T'
    					SET @secondary = @secondary + 'T'
    					SET @current = @current + 2
    				END
    				ELSE
    				BEGIN
    					SET @primary = @primary + 'T'
    					SET @secondary = @secondary + 'T'
    					SET @current = @current + 1
    				END
    			END
    		END
    		ELSE
    	
    		IF @strcur1 = 'F'
    		BEGIN
    			SET @primary = @primary + 'F'
    			SET @secondary = @secondary + 'F'
    			IF (@strnext1 = 'F')
    				SET @current = @current + 2
    			ELSE
    				SET @current = @current + 1
    		END
    		ELSE
    	
    		IF @strcur1 = 'G'
    		BEGIN
    			IF (@strnext1 = 'H')
    			BEGIN
    				IF @current > 1
    					AND @strprev1 NOT IN ('A', 'E', 'I', 'O', 'U', 'Y')
    				BEGIN
    					SET @primary = @primary + 'K'
    					SET @secondary = @secondary + 'K'
    				END
    				ELSE
    				BEGIN
    			
    					IF 	not(	(@current > 2	-- Parker's RULE (with SOME further refinements) - e.g. 'hugh'
    								AND substring(@original, @current - 2, 1) in ('B','H','D')
    							)	-- e.g. 'bough'
    							OR (@current > 3
    								AND substring(@original, @current - 3, 1) in ('B','H','D')
    							)	-- e.g. 'broughton'
    							OR (@current > 4
    								AND substring(@original, @current - 4, 1) in ('B','H')
    						)	)
    					BEGIN
    						IF @current > 3		-- e.g. 'laugh', 'McLaughlin', 'cough', 'gough', 'rough', 'tough'
    							AND @strprev1 = 'U'
    							AND substring(@original, @current - 3, 1) in ('C','G','L','R','T')
    						BEGIN
    							SET @primary = @primary + 'F'
    							SET @secondary = @secondary + 'F'
    						END
    						ELSE
    						BEGIN
    							IF @current > 1
    								AND @strprev1 <> 'I'
    							BEGIN
    								SET @primary = @primary + 'K'
    								SET @secondary = @secondary + 'K'
    							END
    							ELSE
    							BEGIN
    								IF (@current < 4)
    								BEGIN
    									IF (@current = 1)	-- 'ghislane', 'ghiradelli'
    									BEGIN
    										IF (substring(@original, @current + 2, 1) = 'I')
    										BEGIN
    											SET @primary = @primary + 'J'
    											SET @secondary = @secondary + 'J'
    										END
    										ELSE
    										BEGIN
    											SET @primary = @primary + 'K'
    											SET @secondary = @secondary + 'K'
    										END
    									END
    								END
    							END
    						END
    					END
    				END
    				SET @current = @current + 2
    			END
    			ELSE
    			BEGIN
    				IF (@strnext1 = 'N')
    				BEGIN
    					IF @current = 1 
    						AND substring(@original, 0,1) in ('A', 'E', 'I', 'O', 'U', 'Y')
    						AND @SlavoGermanic = 0
    					BEGIN
    						SET @primary = @primary + 'KN'
    						SET @secondary = @secondary + 'N'
    					END
    					ELSE
    					BEGIN
    						-- NOT e.g. 'cagney'
    						IF substring(@original, @current + 2, 2) = 'EY'
    							AND (@strnext1 <> 'Y')
    							AND @SlavoGermanic = 0
    						BEGIN
    							SET @primary = @primary + 'N'
    							SET @secondary = @secondary + 'KN'
    						END
    						ELSE
    						BEGIN
    							SET @primary = @primary + 'KN'
    							SET @secondary = @secondary + 'KN'
    						END
    					END
    					SET @current = @current + 2
    				END
    				ELSE
    				BEGIN
    					IF substring(@original, @current + 1, 2) = 'LI'	-- 'tagliaro'
    						AND @SlavoGermanic = 0
    					BEGIN
    						SET @primary = @primary + 'KL'
    						SET @secondary = @secondary + 'L'
    						SET @current = @current + 2
    					END
    					ELSE
    					BEGIN
    						IF @current = 1		-- -ges-, -gep-, -gel- at beginning
    							AND (@strnext1 = 'Y'
    								OR substring(@original, @current + 1, 2) in ('ES','EP','EB','EL','EY','IB','IL','IN','IE', 'EI','ER')
    							)
    						BEGIN
    							SET @primary = @primary + 'K'
    							SET @secondary = @secondary + 'J'
    							SET @current = @current + 2
    						END
    						ELSE
    						BEGIN
    							IF (substring(@original, @current + 1, 2) = 'ER'	-- -ger-, -gy-
    								OR @strnext1 = 'Y'
    								)
    							 	AND substring(@original, 1, 6) NOT in ('DANGER','RANGER','MANGER')
    							 	AND @strprev1 NOT IN ('E', 'I')
    							 	AND substring(@original, @current - 1, 3) NOT in ('RGY','OGY')
    							BEGIN
    								SET @primary = @primary + 'K'
    								SET @secondary = @secondary + 'J'
    								SET @current = @current + 2
    							END
    							ELSE
    							BEGIN
    								IF @strnext1 IN ('E','I','Y')	-- italian e.g. 'biaggi'
    									OR substring(@original, @current -1, 4) in ('AGGI','OGGI')
    								BEGIN
    									IF (substring(@original, 1, 4) in ('VAN ', 'VON ')	-- obvious germanic
    										OR substring(@original, 1, 3) = 'SCH'
    										)
    										OR substring(@original, @current + 1, 2) = 'ET'
    									BEGIN
    										SET @primary = @primary + 'K'
    										SET @secondary = @secondary + 'K'
    									END
    									ELSE
    									BEGIN
    										-- always soft IF french ending
    										IF substring(@original, @current + 1, 4) = 'IER '
    										BEGIN
    											SET @primary = @primary + 'J'
    											SET @secondary = @secondary + 'J'
    										END
    										ELSE
    										BEGIN
    											SET @primary = @primary + 'J'
    											SET @secondary = @secondary + 'K'
    										END
    									END
    									SET @current = @current + 2
    								END
    								ELSE
    								BEGIN	-- other options exausted call it k sound
    									SET @primary = @primary + 'K'
    									SET @secondary = @secondary + 'K'
    									IF (@strnext1 = 'G')
    										SET @current = @current + 2
    									ELSE
    										SET @current = @current + 1
    								END
    							END
    						END
    					END
    				END
    			END
    		END
    		ELSE
    	
    		IF @strcur1 = 'H'
    		BEGIN
    			IF (@current = 1 	-- ONLY keep if first & before vowel or btw. 2 vowels
    					OR @strprev1 IN ('A', 'E', 'I', 'O', 'U', 'Y')
    				)
    				AND @strnext1 IN ('A', 'E', 'I', 'O', 'U', 'Y')
    			BEGIN
    				SET @primary = @primary + 'H'
    				SET @secondary = @secondary + 'H'
    				SET @current = @current + 2
    			END
    			ELSE
    				SET @current = @current + 1
    		END
    		ELSE
    	
    		IF @strcur1 = 'J'
    		BEGIN
    			IF substring(@original, @current, 4) = 'JOSE'	-- obvious spanish, 'jose', 'san jacinto'
    				OR substring(@original, 1, 4) = 'SAN '
    			BEGIN
    				IF (@current = 1
    					AND substring(@original, @current + 4, 1) = ' '
    					)
    					OR substring(@original, 1, 4) = 'SAN '
    				BEGIN
    					SET @primary = @primary + 'H'
    					SET @secondary = @secondary + 'H'
    				END
    				ELSE
    				BEGIN
    					SET @primary = @primary + 'J'
    					SET @secondary = @secondary + 'H'
    				END
    		
    				SET @current = @current + 1
    			END
    			ELSE
    			BEGIN
    				IF @current = 1
    				BEGIN
    					SET @primary = @primary + 'J' -- Yankelovich/Jankelowicz
    					SET @secondary = @secondary + 'A'
    					SET @current = @current + 1
    				END
    				ELSE
    				BEGIN
    					IF @strprev1 IN ('A', 'E', 'I', 'O', 'U', 'Y') -- spanish pron. OF .e.g. 'bajador'
    						AND @SlavoGermanic = 0
    						AND @strnext1 IN ('A','O')
    					BEGIN
    						SET @primary = @primary + 'J'
    						SET @secondary = @secondary + 'H'
    						SET @current = @current + 1
    					END
    					ELSE
    					BEGIN
    						IF (@current = @last)
    						BEGIN
    							SET @primary = @primary + 'J'
    							SET @secondary = @secondary + ''
    							SET @current = @current + 1
    						END
    						ELSE
    						BEGIN
    							IF @strnext1 IN ('L','T','K','S','N','M','B','Z')
    								AND @strprev1 NOT IN ('S','K','L')
    							BEGIN
    								SET @primary = @primary + 'J'
    								SET @secondary = @secondary + 'J'
    								SET @current = @current + 1
    							END
    							ELSE
    							BEGIN
    								IF (@strnext1 = 'J') -- it could happen
    									SET @current = @current + 2
    								ELSE 
    									SET @current = @current + 1
    							END
    						END
    					END	
    				END
    			END
    		END
    		ELSE
    	
    		IF @strcur1 = 'K'
    		BEGIN
    			SET @primary = @primary + 'K'
    			SET @secondary = @secondary + 'K'
    	
    			IF (@strnext1 = 'K')
    				SET @current = @current + 2
    			ELSE
    				SET @current = @current + 1
    		END
    		ELSE
    	
    		IF @strcur1 = 'L'
    		BEGIN
    			IF (@strnext1 = 'L')
    			BEGIN
    				IF (@current = (@length - 3)	-- spanish e.g. 'cabrillo', 'gallegos'
    					AND substring(@original, @current - 1, 4) in ('ILLO','ILLA','ALLE')
    					)
    					OR ((substring(@original, @last - 1, 2) in ('AS','OS')
    							OR substring(@original, @last, 1) in ('A','O')
    						)
    						AND substring(@original, @current - 1, 4) = 'ALLE'
    					)
    					SET @primary = @primary + 'L'	--Alternate IS silent
    				ELSE
    				BEGIN
    					SET @primary = @primary + 'L'
    					SET @secondary = @secondary + 'L'
    				END
    					SET @current = @current + 2
    			END
    			ELSE
    			BEGIN 
    				SET @current = @current + 1
    				SET @primary = @primary + 'L'
    				SET @secondary = @secondary + 'L'
    			END
    		END
    		ELSE
    	
    		IF @strcur1 = 'M'
    		BEGIN
    			SET @primary = @primary + 'M'
    			SET @secondary = @secondary + 'M'
    	
    			IF substring(@original, @current - 1, 3) = 'UMB'
    					AND (@current + 1 = @last
    						OR substring(@original, @current + 2, 2) = 'ER'
    					)	-- 'dumb', 'thumb'
    				OR @strnext1 = 'M'
    				SET @current = @current + 2
    			ELSE
    				SET @current = @current + 1
    		END
    		ELSE
    	
    		IF @strcur1 IN ('N','?')
    		BEGIN
    			SET @primary = @primary + 'N'
    			SET @secondary = @secondary + 'N'
    	
    			IF @strnext1 IN ('N','?')
    				SET @current = @current + 2
    			ELSE
    				SET @current = @current + 1
    		END
    		ELSE
    	
    		IF @strcur1 = 'P'
    		BEGIN
    			IF (@strnext1 = 'H')
    			BEGIN
    				SET @current = @current + 2
    				SET @primary = @primary + 'F'
    				SET @secondary = @secondary + 'F'
    			END
    			ELSE
    			BEGIN
    				-- also account FOR 'campbell' AND 'raspberry'
    				IF @strnext1 IN ('P','B')
    					SET @current = @current + 2
    				ELSE
    				BEGIN
    					SET @current = @current + 1
    					SET @primary = @primary + 'P'
    					SET @secondary = @secondary + 'P'
    				END
    			END
    		END
    		ELSE
    	
    		IF @strcur1 = 'Q'
    		BEGIN
    			SET @primary = @primary + 'K'
    			SET @secondary = @secondary + 'K'
    			
    			IF (@strnext1 = 'Q') 
    				SET @current = @current + 2
    			ELSE 
    				SET @current = @current + 1
    		END
    		ELSE
    	
    		IF @strcur1 = 'R'
    		BEGIN
    			IF @current = @last	-- french e.g. 'rogier', but exclude 'hochmeier'
    				AND @SlavoGermanic = 0
    				AND substring(@original, @current - 2, 2) = 'IE'
    				AND substring(@original, @current - 4, 2) NOT in ('ME','MA')
    				SET @secondary = @secondary + 'R' --set @primary = @primary + ''
    			ELSE
    			BEGIN
    				SET @primary = @primary + 'R'
    				SET @secondary = @secondary + 'R'
    			END
    	
    			IF (@strnext1 = 'R')
    			BEGIN
    				IF substring(@original, @current, 3) = 'RRI' --alternate Kerrigan, Corrigan
    					SET @secondary = @secondary + 'R'
    				
    				SET @current = @current + 2
    			END
    			ELSE
    				SET @current = @current + 1
    		END
    		ELSE
    	
    		IF @strcur1 = 'S'
    		BEGIN
    			IF substring(@original, @current - 1, 3) in ('ISL','YSL') -- special cases 'island', 'isle', 'carlisle', 'carlysle'
    				SET @current = @current + 1	--silent s
    			ELSE
    			BEGIN
    				IF substring(@original, @current, 2) = 'SH'
    				BEGIN
    					-- germanic
    					IF substring(@original, @current + 1, 4) in ('HEIM','HOEK','HOLM','HOLZ')
    					BEGIN
    						SET @primary = @primary + 'S'
    						SET @secondary = @secondary + 'S'
    					END
    					ELSE
    					BEGIN
    						SET @primary = @primary + 'X'
    						SET @secondary = @secondary + 'X'
    					END
    			
    					SET @current = @current + 2
    				END
    				ELSE
    				BEGIN
    		
    				
    			
    				
    					-- italian & armenian 
    					IF substring(@original, @current, 3) in ('SIO','SIA')
    						OR substring(@original, @current, 4) in ('SIAN')
    					BEGIN
    						IF @SlavoGermanic = 0
    						BEGIN
    							SET @primary = @primary + 'S'
    							SET @secondary = @secondary + 'X'
    						END
    						ELSE
    						BEGIN
    							SET @primary = @primary + 'S'
    							SET @secondary = @secondary + 'S'
    						END
    				
    						SET @current = @current + 3
    					END
    					ELSE
    					BEGIN
    						IF (@current = 1					-- german & anglicisations, e.g. 'smith' match 'schmidt', 'snider' match 'schneider'
    								AND @strnext1 IN ('M','N','L','W')	-- also, -sz- in slavic language altho in hungarian it IS pronounced 's'
    							)
    							OR @strnext1 = 'Z'
    						BEGIN
    							SET @primary = @primary + 'S'
    							SET @secondary = @secondary + 'X'
    			
    							IF @strnext1 = 'Z'
    								SET @current = @current + 2
    							ELSE
    								SET @current = @current + 1
    						END
    						ELSE
    						BEGIN
    							IF substring(@original, @current, 2) = 'SC'
    							BEGIN
    								IF substring(@original, @current + 2, 1) = 'H'	-- Schlesinger's RULE 
    								BEGIN
    									IF substring(@original, @current + 3, 2) in ('OO','ER','EN','UY','ED','EM')	-- dutch origin, e.g. 'school', 'schooner'
    									BEGIN
    										IF substring(@original, @current + 3, 2) in ('ER','EN')	-- 'schermerhorn', 'schenker' 
    										BEGIN
    											SET @primary = @primary + 'X'
    											SET @secondary = @secondary + 'SK'
    										END
    										ELSE
    										BEGIN
    											SET @primary = @primary + 'SK'
    											SET @secondary = @secondary + 'SK'
    										END
    						
    										SET @current = @current + 3
    									END
    									ELSE
    									BEGIN
    										IF @current = 1 
    											AND substring(@original, 3,1) NOT in ('A', 'E', 'I', 'O', 'U', 'Y')
    											AND substring(@original, @current + 3, 1) <> 'W'
    										BEGIN
    											SET @primary = @primary + 'X'
    											SET @secondary = @secondary + 'S'
    										END
    										ELSE
    										BEGIN
    											SET @primary = @primary + 'X'
    											SET @secondary = @secondary + 'X'
    										END
    										
    										SET @current = @current + 3
    									END
    								END
    								ELSE
    								BEGIN
    									IF substring(@original, @current + 2, 1) in ('I','E','Y')
    									BEGIN
    										SET @primary = @primary + 'S'
    										SET @secondary = @secondary + 'S'
    									END
    									ELSE
    									BEGIN
    										SET @primary = @primary + 'SK'
    										SET @secondary = @secondary + 'SK'
    									END
    									SET @current = @current + 3
    								END
    							END
    							ELSE
    							BEGIN
    								IF @current = 1		-- special CASE 'sugar-'
    									AND substring(@original, @current, 5) = 'SUGAR'
    								BEGIN
    									SET @primary = @primary + 'X'
    									SET @secondary = @secondary + 'S'
    									SET @current = @current + 1
    								END
    								ELSE
    								BEGIN
    									IF @current = @last	-- french e.g. 'resnais', 'artois'
    										AND substring(@original, @current - 2, 2) in ('AI','OI')
    										SET @secondary = @secondary + 'S' --set @primary = @primary + ''
    									ELSE
    									BEGIN
    										SET @primary = @primary + 'S'
    										SET @secondary = @secondary + 'S'
    									END
    									
    									IF @strnext1 IN ('S','Z')
    										SET @current = @current + 2
    									ELSE 
    										SET @current = @current + 1
    								END
    							END
    						END
    					END
    				END
    			END
    		END
    		ELSE
    	
    		IF @strcur1 = 'T'
    		BEGIN
    			IF substring(@original, @current, 4) = 'TION'
    			BEGIN
    				SET @primary = @primary + 'X'
    				SET @secondary = @secondary + 'X'
    				SET @current = @current + 3
    			END
    			ELSE
    				IF substring(@original, @current, 3) in ('TIA','TCH')
    				BEGIN
    					SET @primary = @primary + 'X'
    					SET @secondary = @secondary + 'X'
    					SET @current = @current + 3
    				END
    				ELSE
    					IF substring(@original, @current, 2) = 'TH'
    						OR substring(@original, @current, 3) = 'TTH'
    					BEGIN
    						IF substring(@original, @current + 2, 2) in ('OM','AM')	-- special CASE 'thomas', 'thames' or germanic
    							OR substring(@original, 0, 4) in ('VAN ','VON ')
    							OR substring(@original, 0, 3) = 'SCH'
    						BEGIN
    							SET @primary = @primary + 'T'
    							SET @secondary = @secondary + 'T'
    						END
    						ELSE
    						BEGIN
    							SET @primary = @primary + '0'
    							SET @secondary = @secondary + 'T'
    						END
    						SET @current = @current + 2
    					END
    					ELSE
    					BEGIN 
    						IF @strnext1 IN ('T','D')
    						BEGIN
    							SET @current = @current + 2
    							SET @primary = @primary + 'T'
    							SET @secondary = @secondary + 'T'
    						END
    						ELSE
    						BEGIN
    							SET @current = @current + 1
    							SET @primary = @primary + 'T'
    							SET @secondary = @secondary + 'T'
    						END
    					END
    		END
    		ELSE
    	
    		IF @strcur1 = 'V'
    			IF (@strnext1 = 'V')
    				SET @current = @current + 2
    			ELSE
    			BEGIN
    				SET @current = @current + 1
    				SET @primary = @primary + 'F'
    				SET @secondary = @secondary + 'F'
    			END
    		ELSE
    	
    		IF @strcur1 = 'W'
    		BEGIN
    			-- can also be IN middle OF word
    			IF substring(@original, @current, 2) = 'WR'
    			BEGIN
    				SET @primary = @primary + 'R'
    				SET @secondary = @secondary + 'R'
    				SET @current = @current + 2
    			END
    			ELSE
    				IF @current = 1
    					AND (@strnext1 IN ('A', 'E', 'I', 'O', 'U', 'Y')
    						OR substring(@original, @current, 2) = 'WH'
    					)
    				BEGIN
    					IF @strnext1 IN ('A', 'E', 'I', 'O', 'U', 'Y')	-- Wasserman should match Vasserman 
    					BEGIN
    						SET @primary = @primary + 'A'
    						SET @secondary = @secondary + 'F'
    						SET @current = @current + 1
    					END
    					ELSE
    					BEGIN
    						SET @primary = @primary + 'A'	-- need Uomo TO match Womo 
    						SET @secondary = @secondary + 'A'
    						SET @current = @current + 1
    					END
    				END
    				ELSE
    					IF (@current = @last -- Arnow should match Arnoff
    							AND @strprev1 IN ('A', 'E', 'I', 'O', 'U', 'Y')
    						)
    					 	OR substring(@original, @current - 1, 5) in ('EWSKI','EWSKY','OWSKI','OWSKY')
    					 	OR substring(@original, 0, 3) = 'SCH'
    					BEGIN
    						SET @secondary = @secondary + 'F'	--set @primary = @primary + ''
    						SET @current = @current + 1
    					END
    					ELSE
    						IF substring(@original, @current, 4) in ('WICZ','WITZ') -- polish e.g. 'filipowicz'
    						BEGIN
    							SET @primary = @primary + 'TS'
    							SET @secondary = @secondary + 'FX'
    							SET @current = @current + 4
    						END
    						ELSE		
    							SET @current = @current + 1	-- ELSE skip it
    		END
    		ELSE
    	
    		IF @strcur1 = 'X'
    		BEGIN
    			IF NOT (@current = @last	-- french e.g. breaux 
    				AND (substring(@original, @current - 3, 3) in ('IAU', 'EAU')
    				 	OR substring(@original, @current - 2, 2) in ('AU', 'OU')
    				)
    			) 
    			BEGIN
    				SET @primary = @primary + 'KS'
    				SET @secondary = @secondary + 'KS'
    			END	--else skip it
    			
    			IF @strnext1 IN ('C','X')
    				SET @current = @current + 2
    			ELSE
    				SET @current = @current + 1
    		END
    		ELSE
    	
    		IF @strcur1 = 'Z'
    		BEGIN
    			IF (@strnext1 = 'Z')
    			BEGIN
    				SET @primary = @primary + 'S'
    				SET @secondary = @secondary + 'S'
    				SET @current = @current + 2
    			END
    			ELSE
    			BEGIN
    				IF (@strnext1 = 'H') -- chinese pinyin e.g. 'zhao' 
    				BEGIN
    					SET @primary = @primary + 'J'
    					SET @secondary = @secondary + 'J'
    					SET @current = @current + 2
    				END
    				ELSE
    				BEGIN
    					IF (substring(@original, @current + 1, 2) in ('ZO', 'ZI', 'ZA'))
    							OR (@SlavoGermanic = 1
    								AND (@current > 1
    									AND @strprev1 <> 'T'
    								)
    							)
    					BEGIN
    						SET @primary = @primary + 'S'
    						SET @secondary = @secondary + 'TS'
    					END
    					ELSE
    					BEGIN
    						SET @primary = @primary + 'S'
    						SET @secondary = @secondary + 'S'
    					END
    				END
    				SET @current = @current + 1
    			END
    		END
    		ELSE
    			SET @current = @current + 1
    	END
    	RETURN cast(@primary as char(5)) + cast(@secondary as char(5))
end

GO
