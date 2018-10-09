--DECLARE @inp NVARCHAR(MAX)
--SELECT @inp = BulkColumn
--FROM OPENROWSET(BULK N'C:\Users\alligator\dev\aoc2015\3.txt', SINGLE_CLOB) x;

--EXEC dbo.Day3_Part2 @inp

CREATE OR ALTER PROCEDURE dbo.Day3_Part1(@inp NVARCHAR(MAX)) AS
BEGIN
	;WITH Inp AS (
		SELECT
			chr = SUBSTRING(@inp, Number, 1)
		,	rownum = ROW_NUMBER() OVER (ORDER BY (SELECT 1))
		FROM dbo.Numbers
		WHERE Number > 0 AND Number <= LEN(@inp)
	),
	Tracking AS (
		SELECT chr = N'', x = 0, y = 0

		UNION ALL

		SELECT
			chr
		,	x = SUM(CASE WHEN chr = '>' THEN 1 WHEN chr = '<' THEN -1 ELSE 0 END) OVER (ORDER BY rownum ROWS UNBOUNDED PRECEDING)
		,	y = SUM(CASE WHEN chr = '^' THEN 1 WHEN chr = 'v' THEN -1 ELSE 0 END) OVER (ORDER BY rownum ROWS UNBOUNDED PRECEDING)
		FROM Inp
	)
	SELECT Houses = COUNT(*)	
	FROM (
		SELECT DISTINCT x, y
		FROM Tracking
	) D
END
GO

CREATE OR ALTER PROCEDURE dbo.Day3_Part2(@inp NVARCHAR(MAX)) AS
BEGIN
	;WITH Inp1 AS (
		SELECT
			chr = SUBSTRING(@inp, Number, 1)
		,	rownum = ROW_NUMBER() OVER (ORDER BY (SELECT 1))
		FROM dbo.Numbers
		WHERE Number > 0 AND Number <= LEN(@inp) AND Number % 2 = 0
	),
	Inp2 AS (
		SELECT
			chr = SUBSTRING(@inp, Number, 1)
		,	rownum = ROW_NUMBER() OVER (ORDER BY (SELECT 1))
		FROM dbo.Numbers
		WHERE Number > 0 AND Number <= LEN(@inp) AND Number % 2 = 1
	),
	Tracking1 AS (
		SELECT chr = N'', rownum = 0, x = 0, y = 0

		UNION ALL

		SELECT
			chr
		,	rownum
		,	x = SUM(CASE WHEN chr = '>' THEN 1 WHEN chr = '<' THEN -1 ELSE 0 END) OVER (ORDER BY rownum ROWS UNBOUNDED PRECEDING)
		,	y = SUM(CASE WHEN chr = '^' THEN 1 WHEN chr = 'v' THEN -1 ELSE 0 END) OVER (ORDER BY rownum ROWS UNBOUNDED PRECEDING)
		FROM Inp1
	),
	Tracking2 AS (
		SELECT
			chr
		,	rownum
		,	x = SUM(CASE WHEN chr = '>' THEN 1 WHEN chr = '<' THEN -1 ELSE 0 END) OVER (ORDER BY rownum ROWS UNBOUNDED PRECEDING)
		,	y = SUM(CASE WHEN chr = '^' THEN 1 WHEN chr = 'v' THEN -1 ELSE 0 END) OVER (ORDER BY rownum ROWS UNBOUNDED PRECEDING)
		FROM Inp2
	)
	SELECT Houses = COUNT(*)
	FROM (
		SELECT x, y
		FROM Tracking1

		UNION

		SELECT x, y
		FROM Tracking2
	) D
END
GO

EXEC tSQLt.NewTestClass 'TestDay3';
GO

CREATE PROCEDURE TestDay3.[Test - Day 3 - Part 1 A] AS
BEGIN
	CREATE TABLE #actual (Houses INT)
	INSERT INTO #actual (Houses)
	EXEC dbo.Day3_Part1 N'^>v<'

	SELECT Houses = 4
	INTO #expected

	EXEC tSQLt.AssertEqualsTable '#expected', '#actual'
END;
GO

CREATE PROCEDURE TestDay3.[Test - Day 3 - Part 1 B] AS
BEGIN
	CREATE TABLE #actual (Houses INT)
	INSERT INTO #actual (Houses)
	EXEC dbo.Day3_Part1 N'^v^v^v^v^v'

	SELECT Houses = 2
	INTO #expected

	EXEC tSQLt.AssertEqualsTable '#expected', '#actual'
END;
GO

CREATE PROCEDURE TestDay3.[Test - Day 3 - Part 2 A] AS
BEGIN
	CREATE TABLE #actual (Houses INT)
	INSERT INTO #actual (Houses)
	EXEC dbo.Day3_Part2 N'^v^v^v^v^v'

	SELECT Houses = 11
	INTO #expected

	EXEC tSQLt.AssertEqualsTable '#expected', '#actual'
END;
GO

CREATE PROCEDURE TestDay3.[Test - Day 3 - Part 2 B] AS
BEGIN
	CREATE TABLE #actual (Houses INT)
	INSERT INTO #actual (Houses)
	EXEC dbo.Day3_Part2 N'^>v<'

	SELECT Houses = 3
	INTO #expected

	EXEC tSQLt.AssertEqualsTable '#expected', '#actual'
END;
GO

CREATE PROCEDURE TestDay3.[Test - Day 3 - Part 2 C] AS
BEGIN
	CREATE TABLE #actual (Houses INT)
	INSERT INTO #actual (Houses)
	EXEC dbo.Day3_Part2 N'^v'

	SELECT Houses = 3
	INTO #expected

	EXEC tSQLt.AssertEqualsTable '#expected', '#actual'
END;
GO

EXEC tSQLt.Run 'TestDay3';
GO