CREATE TABLE #coords (
	X			INT
,	Y			INT
,	State		BIT
,	Brightness	INT
,	CONSTRAINT PK_coords PRIMARY KEY(X, Y)
);

INSERT INTO #coords
SELECT
	X = N1.Number
,	Y = N2.Number
,	State = CAST(0 AS BIT)
,	Brightness = 0
FROM dbo.Numbers N1
CROSS JOIN dbo.Numbers N2
WHERE N1.Number <= 999
AND N2.Number <= 999;

CREATE TABLE #instructions (
	Action	TINYINT
,	StartX	INT
,	StartY	INT
,	EndX	INT
,	EndY	INT
);

BULK INSERT #instructions
FROM 'C:\Users\alligator\dev\aoc2015\6.csv'
WITH (
	FIELDTERMINATOR =',',
	ROWTERMINATOR = '0x0a'
);

DECLARE Cur CURSOR FAST_FORWARD
FOR
SELECT
	Action
,	StartX
,	StartY
,	EndX
,	EndY
FROM #instructions

DECLARE @action TINYINT;
DECLARE @startX INT;
DECLARE @startY INT;
DECLARE @endX INT;
DECLARE @endY INT;

OPEN Cur;

PRINT N'cursor open';

FETCH NEXT FROM Cur INTO @action, @startX, @startY, @endX, @endY;

WHILE (@@FETCH_STATUS = 0)
BEGIN
	--PRINT N'action: ' + CAST(@action AS NVARCHAR(10));
	--PRINT N'startX: ' + CAST(@startX AS NVARCHAR(10));
	--PRINT N'startY: ' + CAST(@startY AS NVARCHAR(10));
	--PRINT N'  endX: ' + CAST(@endX AS NVARCHAR(10));
	--PRINT N'  endY: ' + CAST(@endY AS NVARCHAR(10));

	UPDATE #coords
	SET
		State = CAST(
			CASE
				WHEN @action = 0 THEN 1
				WHEN @action = 1 THEN 0
				WHEN @action = 2 THEN ~State
			END AS BIT)
	,	Brightness =
			CASE
				WHEN @action = 0 THEN Brightness + 1
				WHEN @action = 1 AND Brightness > 0 THEN Brightness - 1
				WHEN @action = 2 THEN Brightness + 2
				ELSE Brightness
			END
	WHERE X BETWEEN @StartX AND @EndX
	AND Y BETWEEN @StartY And @EndY;

	FETCH NEXT FROM Cur INTO @action, @startX, @startY, @endX, @endY;
END

SELECT
	Total = SUM(CASE WHEN State = 1 THEN 1 ELSE 0 END)
,	TotalBrightness = SUM(Brightness)
FROM #coords

CLOSE Cur;
DEALLOCATE Cur;
DROP TABLE #coords;
DROP TABLE #instructions;