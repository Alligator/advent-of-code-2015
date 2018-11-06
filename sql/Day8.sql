CREATE OR ALTER FUNCTION dbo.Day8_Count(@input NVARCHAR(100))
RETURNS TABLE
AS
RETURN (
	WITH HexReplaced AS (
		SELECT
			Depth = 1
		,	Input =
			CASE PATINDEX('%\x[0-9a-f][0-9a-f]%', @input)
				WHEN 0 THEN @input
				ELSE STUFF(
					@input,
					PATINDEX('%\x[0-9a-f][0-9a-f]%', @input),
					4,
					N'1'
				)
			END

		UNION ALL

		SELECT
			Depth = Depth + 1
		,	Input = STUFF(
				Input,
				PATINDEX('%\x[0-9a-f][0-9a-f]%', Input),
				4,
				N'1'
			)
		FROM HexReplaced
		WHERE PATINDEX('%\x[0-9a-f][0-9a-f]%', Input) > 0
	)
	SELECT
		Code			= LEN(@input)
	,	Characters		= LEN(REPLACE(REPLACE(Input, N'\"', '1'), N'\\', N'1')) - 2
	,	Input			= REPLACE(REPLACE(Input, N'\"', '1'), N'\\', N'1')
	,	Encoded			= E.Encoded
	,	EncodedLenth	= LEN(E.Encoded) 
	FROM HexReplaced
	CROSS APPLY (
		SELECT Encoded	= '"' + REPLACE(REPLACE(@input, N'\', N'\\'), N'"', N'\"') + '"'
	) AS E
	WHERE Depth = (SELECT MAX(Depth) FROM HexReplaced)
)
GO

CREATE OR ALTER PROC dbo.Day8_Part1
AS
BEGIN
	DECLARE @inp NVARCHAR(MAX)
	SELECT @inp = BulkColumn
	FROM OPENROWSET(BULK N'C:\Users\alligator\dev\aoc2015\8.txt', SINGLE_CLOB) x;

	SELECT Total = SUM(Code) - SUM(Characters)
	FROM STRING_SPLIT(REPLACE(@inp, NCHAR(13), ''), NCHAR(10)) AS S
	CROSS APPLY (
		SELECT Code, Characters
		FROM dbo.Day8_Count(S.value)
	) AS C
END
GO
-- EXEC dbo.Day8_Part1

CREATE OR ALTER PROC dbo.Day8_Part2
AS
BEGIN
	DECLARE @inp NVARCHAR(MAX)
	SELECT @inp = BulkColumn
	FROM OPENROWSET(BULK N'C:\Users\alligator\dev\aoc2015\8.txt', SINGLE_CLOB) x;

	SELECT Total = SUM(EncodedLenth) - SUM(Code)
	FROM STRING_SPLIT(REPLACE(@inp, NCHAR(13), ''), NCHAR(10)) AS S
	CROSS APPLY (
		SELECT Code, EncodedLenth
		FROM dbo.Day8_Count(S.value)
	) AS C
END
GO
EXEC dbo.Day8_Part2

EXEC tSQLt.NewTestClass 'TestDay8';
GO

CREATE PROCEDURE TestDay8.[Test - Day8_Part1 examples] AS
BEGIN
	CREATE TABLE #expected (Input NVARCHAR(30), Code INT, Characters INT)
	INSERT INTO #expected (Input, Code, Characters)
	VALUES	(N'""',	2, 0)
		,	(N'"abc"', 5, 3)
		,	(N'"a\\b"', 6, 3)
		,	(N'"aaa\"aaa"', 10, 7)
		,	(N'"\x27"', 6, 1)
		,	(N'"\x27\xaf"', 10, 2)
		,	(N'"\x27\xafabc\""', 15, 6)

	SELECT
		I.Input
	,	O.Code
	,	O.Characters
	INTO #results
	FROM #expected I
	CROSS APPLY dbo.Day8_Count(I.Input) AS O;

	EXEC tSQLt.AssertEqualsTable '#expected', '#results'
END;
GO

CREATE PROCEDURE TestDay8.[Test - Day8_Part2 examples] AS
BEGIN
	CREATE TABLE #expected (Input NVARCHAR(30), Code INT, Characters INT, Encoded NVARCHAR(30), EncodedLenth INT)
	INSERT INTO #expected (Input, Code, Characters, Encoded, EncodedLenth)
	VALUES	(N'""',	2, 0, N'"\"\""', 6)
		,	(N'"abc"', 5, 3, N'"\"abc\""', 9)
		,	(N'"a\\b"', 6, 3, N'"\"a\\\\b\""', 12)
		,	(N'"aaa\"aaa"', 10, 7, N'"\"aaa\\\"aaa\""', 16)
		,	(N'"\x27"', 6, 1, N'"\"\\x27\""', 11)
		,	(N'"\x27\xaf"', 10, 2, N'"\"\\x27\\xaf\""', 16)
		,	(N'"\x27\xafabc\""', 15, 6, N'"\"\\x27\\xafabc\\\"\""', 23)

	SELECT
		I.Input
	,	O.Code
	,	O.Characters
	,	O.Encoded
	,	O.EncodedLenth
	INTO #results
	FROM #expected I
	CROSS APPLY dbo.Day8_Count(I.Input) AS O;

	EXEC tSQLt.AssertEqualsTable '#expected', '#results'
END;
GO

EXEC tSQLt.Run 'TestDay8';
GO