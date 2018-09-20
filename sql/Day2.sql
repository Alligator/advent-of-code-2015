/*
DECLARE @inp NVARCHAR(MAX)
SELECT @inp = BulkColumn
FROM OPENROWSET(BULK N'C:\Users\alligator\dev\aoc2015\2.txt', SINGLE_CLOB) x;

EXEC Day2_Part1 @inp
EXEC Day2_Part2 @inp
*/

CREATE OR ALTER FUNCTION Day2_Parse(@inp NVARCHAR(MAX))
RETURNS @result TABLE (
	Raw		NVARCHAR(100)
,	RowNum	INT
,	Length	INT
,	Width	INT
,	Height	INT
)
AS
BEGIN
	;WITH BoxesCTE AS (
		SELECT
			Raw = value
		,	RowNum = ROW_NUMBER() OVER(ORDER BY (SELECT 1))
		FROM STRING_SPLIT(REPLACE(@inp, NCHAR(13), ''), NCHAR(10))
	)
	INSERT INTO @result
	SELECT
		Raw		= Box.Raw
	,	RowNum	= Box.RowNum
	,	Length	= SUM(CASE WHEN GroupNum = 1 THEN Dimension ELSE 0 END)
	,	Width	= SUM(CASE WHEN GroupNum = 2 THEN Dimension ELSE 0 END)
	,	Height	= SUM(CASE WHEN GroupNum = 3 THEN Dimension ELSE 0 END)
	FROM (
		SELECT
			Raw			= B.Raw
		,	RowNum		= B.RowNum
		,	Dimension	= CAST(D.Value AS INT)
		,	GroupNum	= ROW_NUMBER() OVER(PARTITION BY B.RowNum ORDER BY B.RowNum)
		FROM BoxesCTE AS B
		CROSS APPLY STRING_SPLIT(B.Raw, 'x') AS D
	) AS Box
	GROUP BY Box.RowNum, Box.Raw

	RETURN;
END;
GO

CREATE OR ALTER PROCEDURE Day2_Part1 @inp NVARCHAR(MAX) AS
BEGIN
	SELECT
		TotalSqFt = SUM(
			2*Side1 + 2*Side2 + 2*Side3 +
				CASE
					WHEN Side1 <= Side2 AND Side1 < Side3 THEN Side1
					WHEN Side2 < Side1 AND Side2 <= Side3 THEN Side2
					ELSE Side3
				END
		)
	FROM (
		SELECT
			Raw
		,	RowNum
		,	Side1 = Length*Width 
		,	Side2 = Width*Height
		,	Side3 = Height*Length
		FROM dbo.Day2_Parse(@inp)
	) Totals
END
GO

CREATE OR ALTER PROCEDURE Day2_Part2 @inp NVARCHAR(MAX) AS
BEGIN
	SELECT
		TotalFt = SUM(
			Volume +
				CASE
					WHEN Side1 <= Side2 AND Side1 < Side3 THEN Side1
					WHEN Side2 < Side1 AND Side2 <= Side3 THEN Side2
					ELSE Side3
				END
		)
	FROM (
		SELECT
			Raw
		,	RowNum
		,	Side1 = Length*2 + Width*2
		,	Side2 = Width*2 + Height*2
		,	Side3 = Height*2 + Length*2
		,	Volume = Length*Width*Height
		FROM dbo.Day2_Parse(@inp)
	) Totals
END
GO

EXEC tSQLt.NewTestClass 'TestDay2';
GO

CREATE PROCEDURE TestDay2.[Test - Day 2 - Part 1] AS
BEGIN
	CREATE TABLE #actual (TotalSqFt INT)
	INSERT INTO #actual (TotalSqFt)
	EXEC dbo.Day2_Part1 N'2x3x4
1x1x10
25x2x25'

	SELECT TotalSqFt = 1601
	INTO #expected

	EXEC tSQLt.AssertEqualsTable '#expected', '#actual'
END;
GO

CREATE PROCEDURE TestDay2.[Test - Day 2 - Part 2] AS
BEGIN
	CREATE TABLE #actual (TotalFt INT)
	INSERT INTO #actual (TotalFt)
	EXEC dbo.Day2_Part2 N'2x3x4
1x1x10'

	SELECT TotalFt = 48
	INTO #expected

	EXEC tSQLt.AssertEqualsTable '#expected', '#actual'
END;
GO

EXEC tSQLt.Run 'TestDay2';
GO