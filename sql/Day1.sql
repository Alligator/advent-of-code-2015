CREATE OR ALTER PROCEDURE Day1_Part1 @inp NVARCHAR(MAX) AS
BEGIN
	SELECT
		chr = SUBSTRING(@inp, Number, 1)
	INTO #input
	FROM dbo.Numbers
	WHERE Number > 0 AND Number <= LEN(@inp)

	-- numbers table, 211 logical reads
	SELECT
		endFloor = SUM(CASE WHEN chr = '(' THEN 1 ELSE -1 END)
	FROM #input

	-- recursive CTE, 42,001 logical reads
	--;WITH Chars AS (
	--	SELECT
	--		num = 1
	--	,	chr = SUBSTRING(@inp, 1, 1)

	--	UNION ALL

	--	SELECT
	--		num = num + 1
	--	,	chr = SUBSTRING(@inp, num + 1, 1)
	--	FROM Chars
	--	WHERE num < len(@inp)
	--)
	--SELECT
	--	endFloor = SUM(CASE WHEN chr = '(' THEN 1 ELSE -1 END)
	--FROM Chars
	--OPTION (maxrecursion 0)
END
GO

CREATE OR ALTER PROCEDURE Day1_Part2 @inp NVARCHAR(MAX) AS
BEGIN
	-- numbers table, 10,934 logical reads
	SELECT TOP 1 position = C.Number
	FROM (
		SELECT
			currentFloor = SUM(CASE WHEN SUBSTRING(@inp, Number, 1) = '(' THEN 1 ELSE -1 END) OVER(ORDER BY Number),
			Number = Number
		FROM dbo.Numbers
		WHERE Number > 0 AND Number <= LEN(@inp)
	) C
	WHERE C.currentFloor = -1

	---- part 2
	---- recursive CTE, 52,766 logical reads
	--;WITH Chars AS (
	--	SELECT
	--		num = 1
	--	,	chr = SUBSTRING(@inp, 1, 1)

	--	UNION ALL

	--	SELECT
	--		num = num + 1
	--	,	chr = SUBSTRING(@inp, num + 1, 1)
	--	FROM Chars
	--	WHERE num < len(@inp)
	--)
	--SELECT TOP 1 num, C.currentFloor
	--FROM (
	--	SELECT
	--		currentFloor = SUM(CASE WHEN chr = '(' THEN 1 ELSE -1 END) OVER(ORDER BY num),
	--		num
	--	FROM Chars
	--) C
	--WHERE C.currentFloor < 0
	--OPTION (maxrecursion 0)
END
GO

EXEC tSQLt.NewTestClass 'TestDay1';
GO

CREATE PROCEDURE TestDay1.[Test - Day 1 - Part 1 A] AS
BEGIN
	CREATE TABLE #actual (endFloor INT)
	INSERT INTO #actual (endFloor)
	EXEC dbo.Day1_Part1 N'(())'

	SELECT endFloor = 0
	INTO #expected

	EXEC tSQLt.AssertEqualsTable '#expected', '#actual'
END;
GO

CREATE PROCEDURE TestDay1.[Test - Day 1 - Part 1 B] AS
BEGIN
	CREATE TABLE #actual (endFloor INT)
	INSERT INTO #actual (endFloor)
	EXEC dbo.Day1_Part1 N')())())'

	SELECT endFloor = -3
	INTO #expected

	EXEC tSQLt.AssertEqualsTable '#expected', '#actual'
END;
GO

CREATE PROCEDURE TestDay1.[Test - Day 1 - Part 2 A] AS
BEGIN
	CREATE TABLE #actual (position INT)
	INSERT INTO #actual (position)
	EXEC dbo.Day1_Part2 N')'

	SELECT position = 1
	INTO #expected

	EXEC tSQLt.AssertEqualsTable '#expected', '#actual'
END;
GO

CREATE PROCEDURE TestDay1.[Test - Day 1 - Part 2 B] AS
BEGIN
	CREATE TABLE #actual (position INT)
	INSERT INTO #actual (position)
	EXEC dbo.Day1_Part2 N'()())'

	SELECT position = 5
	INTO #expected

	EXEC tSQLt.AssertEqualsTable '#expected', '#actual'
END;
GO

EXEC tSQLt.Run 'TestDay1';
GO