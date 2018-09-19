DECLARE @inp VARCHAR(MAX)

SELECT @inp = BulkColumn
FROM OPENROWSET(BULK 'C:\Users\alligator\Dropbox\aoc2015\1.txt', SINGLE_BLOB) x;

-- part 1
-- recursive CTE, 42,001 logical reads
;WITH Chars AS (
	SELECT
		num = 1
	,	chr = SUBSTRING(@inp, 1, 1)

	UNION ALL

	SELECT
		num = num + 1
	,	chr = SUBSTRING(@inp, num + 1, 1)
	FROM Chars
	WHERE num < len(@inp)
)
SELECT
	floor = SUM(CASE WHEN chr = '(' THEN 1 ELSE -1 END)
FROM Chars
OPTION (maxrecursion 0)

-- numbers table, 211 logical reads
SELECT
	floor = SUM(CASE WHEN SUBSTRING(@inp, Number, 1) = '(' THEN 1 ELSE -1 END)
FROM dbo.Numbers
WHERE Number > 0 AND Number <= LEN(@inp)


-- part 2
 -- recursive CTE, 52,766 logical reads
;WITH Chars AS (
	SELECT
		num = 1
	,	chr = SUBSTRING(@inp, 1, 1)

	UNION ALL

	SELECT
		num = num + 1
	,	chr = SUBSTRING(@inp, num + 1, 1)
	FROM Chars
	WHERE num < len(@inp)
)
SELECT TOP 1 num, C.currentFloor
FROM (
	SELECT
		currentFloor = SUM(CASE WHEN chr = '(' THEN 1 ELSE -1 END) OVER(ORDER BY num),
		num
	FROM Chars
) C
WHERE C.currentFloor < 0
OPTION (maxrecursion 0)

-- numbers table, 10,934 logical reads
SELECT TOP 1 C.Number, C.currentFloor
FROM (
	SELECT
		currentFloor = SUM(CASE WHEN SUBSTRING(@inp, Number, 1) = '(' THEN 1 ELSE -1 END) OVER(ORDER BY Number),
		Number = Number
	FROM dbo.Numbers
	WHERE Number > 0 AND Number <= LEN(@inp)
) C
WHERE C.currentFloor < 0