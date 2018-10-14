----------------------
-- Part 1
----------------------
CREATE OR ALTER FUNCTION Day5_IsNice(@input NVARCHAR(16))
RETURNS BIT
AS
BEGIN
	DECLARE @VowelCount INT =
		LEN(@input) - LEN(REPLACE(@input, 'a', '')) +
		LEN(@input) - LEN(REPLACE(@input, 'e', '')) +
		LEN(@input) - LEN(REPLACE(@input, 'i', '')) +
		LEN(@input) - LEN(REPLACE(@input, 'o', '')) +
		LEN(@input) - LEN(REPLACE(@input, 'u', ''))

	DECLARE @HasDouble BIT = CAST(
		CASE
			WHEN CHARINDEX('aa', @input) > 0	OR   CHARINDEX('bb', @input) > 0	
			OR   CHARINDEX('cc', @input) > 0	OR   CHARINDEX('dd', @input) > 0
			OR   CHARINDEX('ee', @input) > 0	OR   CHARINDEX('ff', @input) > 0
			OR   CHARINDEX('gg', @input) > 0	OR   CHARINDEX('hh', @input) > 0
			OR   CHARINDEX('ii', @input) > 0	OR   CHARINDEX('jj', @input) > 0
			OR   CHARINDEX('kk', @input) > 0	OR   CHARINDEX('ll', @input) > 0
			OR   CHARINDEX('mm', @input) > 0	OR   CHARINDEX('nn', @input) > 0
			OR   CHARINDEX('oo', @input) > 0	OR   CHARINDEX('pp', @input) > 0
			OR   CHARINDEX('qq', @input) > 0	OR   CHARINDEX('rr', @input) > 0
			OR   CHARINDEX('ss', @input) > 0	OR   CHARINDEX('tt', @input) > 0
			OR   CHARINDEX('uu', @input) > 0	OR   CHARINDEX('vv', @input) > 0
			OR   CHARINDEX('ww', @input) > 0	OR   CHARINDEX('xx', @input) > 0
			OR   CHARINDEX('yy', @input) > 0	OR   CHARINDEX('zz', @input) > 0
			THEN 1
			ELSE 0
		END
	AS BIT)

	DECLARE @HasBlacklisted BIT = CAST(
		CASE
			WHEN CHARINDEX('ab', @input) > 0
			OR   CHARINDEX('cd', @input) > 0
			OR   CHARINDEX('pq', @input) > 0
			OR   CHARINDEX('xy', @input) > 0
			THEN 1
			ELSE 0
		END
	AS BIT)

	DECLARE @IsValid BIT = CASE 
		WHEN @VowelCount >= 3 AND @HasDouble = 1 AND @HasBlacklisted = 0 THEN 1
		ELSE 0
	END

	RETURN @IsValid
END
GO

CREATE OR ALTER PROC dbo.Day5_Part1
AS
BEGIN
	DECLARE @inp NVARCHAR(MAX)
	SELECT @inp = BulkColumn
	FROM OPENROWSET(BULK N'C:\Users\alligator\dev\aoc2015\5.txt', SINGLE_CLOB) x;

	SELECT NiceStrings = COUNT(*)
	FROM STRING_SPLIT(REPLACE(@inp, NCHAR(13), ''), NCHAR(10))
	WHERE dbo.Day5_IsNice(value) = 1
END
GO

----------------------
-- Part 2
----------------------
CREATE OR ALTER FUNCTION Day5_Part2_IsNice(@input NVARCHAR(16))
RETURNS BIT
AS
BEGIN
	DECLARE @HasPair BIT
	SELECT @HasPair = dbo.RegexMatch(@input, N'([a-z])([a-z]).*\1\2')

	DECLARE @HasRepeat BIT
	SELECT @HasRepeat = dbo.RegexMatch(@input, N'([a-z])[a-z]\1')

	RETURN @HasPair & @HasRepeat
END
GO

-- EXEC dbo.Day5_Part1
-- EXEC dbo.Day5_Part2

CREATE OR ALTER PROC dbo.Day5_Part2
AS
BEGIN
	DECLARE @inp NVARCHAR(MAX)
	SELECT @inp = BulkColumn
	FROM OPENROWSET(BULK N'C:\Users\alligator\dev\aoc2015\5.txt', SINGLE_CLOB) x;

	SELECT NiceStrings = COUNT(*)
	FROM STRING_SPLIT(REPLACE(@inp, NCHAR(13), ''), NCHAR(10))
	WHERE dbo.Day5_Part2_IsNice(value) = 1
END
GO

EXEC tSQLt.NewTestClass 'TestDay5';
GO

CREATE PROCEDURE TestDay5.[Test - Day5_IsNice checks for at least 3 vowels] AS
BEGIN
	CREATE TABLE #expected (Input NVARCHAR(16), IsNice BIT)
	INSERT INTO #expected (Input, IsNice)
	VALUES	(N'aaa',	1)
		,	(N'zyx',	0)
		,	(N'aaa',	1)
		,	(N'uiz',	0)
		,	(N'aezxcv',	0)

	SELECT Input, IsNice = dbo.Day5_IsNice(Input)
	INTO #results
	FROM #expected

	EXEC tSQLt.AssertEqualsTable '#expected', '#results'
END;
GO

CREATE PROCEDURE TestDay5.[Test - Day5_IsNice checks for repeating letters] AS
BEGIN
	CREATE TABLE #expected (Input NVARCHAR(16), IsNice BIT)
	INSERT INTO #expected (Input, IsNice)
	VALUES	(N'aaa',	1)
		,	(N'abc',	0)

	SELECT Input, IsNice = dbo.Day5_IsNice(Input)
	INTO #results
	FROM #expected

	EXEC tSQLt.AssertEqualsTable '#expected', '#results'
END;
GO

CREATE PROCEDURE TestDay5.[Test - Day5_IsNice checks for blacklisted strings] AS
BEGIN
	CREATE TABLE #expected (Input NVARCHAR(16), IsNice BIT)
	INSERT INTO #expected (Input, IsNice)
	VALUES	(N'aaaab',	0)
		,	(N'aaacd',	0)
		,	(N'aaapq',	0)
		,	(N'aaaxy',	0)

	SELECT Input, IsNice = dbo.Day5_IsNice(Input)
	INTO #results
	FROM #expected

	EXEC tSQLt.AssertEqualsTable '#expected', '#results'
END;
GO

CREATE PROCEDURE TestDay5.[Test - Day5_Part2_IsNice] AS
BEGIN
	CREATE TABLE #expected (Input NVARCHAR(16), IsNice BIT)
	INSERT INTO #expected (Input, IsNice)
	VALUES	(N'qjhvhtzxzqqjkmpb',	1)
		,	(N'xxyxx',				1)
		,	(N'uurcxstgmygtbstg',	0)
		,	(N'ieodomkazucvgmuy',	0)

	SELECT Input, IsNice = dbo.Day5_Part2_IsNice(Input)
	INTO #results
	FROM #expected

	EXEC tSQLt.AssertEqualsTable '#expected', '#results'
END;
GO

EXEC tSQLt.Run 'TestDay5';
GO