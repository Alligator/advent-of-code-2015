CREATE OR ALTER PROCEDURE dbo.Day4(@key VARCHAR(10), @leadingString VARCHAR(10)) AS
BEGIN
	;WITH Nums AS (
		SELECT TOP 10000000
			Number = ROW_NUMBER() OVER (ORDER BY t1.number)
		FROM master..spt_values t1
		CROSS JOIN master..spt_values t2
		CROSS JOIN master..spt_values t3
	)
	SELECT TOP 1 Number
	FROM (
		SELECT
			Number
		,	hash = CONVERT(VARCHAR(MAX), HASHBYTES('md5', @key + CONVERT(VARCHAR(MAX), Number)), 2)
		FROM Nums
	) Hash
	WHERE LEFT(hash, LEN(@leadingString)) = @leadingString
	ORDER BY Number
END
GO

EXEC tSQLt.NewTestClass 'TestDay4';
GO

CREATE PROCEDURE TestDay4.[Test - Day 4 A] AS
BEGIN
	CREATE TABLE #actual (Number INT)
	INSERT INTO #actual (Number)
	EXEC dbo.Day4 N'abcdef', N'00000'

	SELECT Number = 609043
	INTO #expected

	EXEC tSQLt.AssertEqualsTable '#expected', '#actual'
END;
GO

CREATE PROCEDURE TestDay4.[Test - Day 4 B] AS
BEGIN
	CREATE TABLE #actual (Number INT)
	INSERT INTO #actual (Number)
	EXEC dbo.Day4 N'pqrstuv', N'00000'

	SELECT Number = 1048970
	INTO #expected

	EXEC tSQLt.AssertEqualsTable '#expected', '#actual'
END;
GO

GO
EXEC tSQLt.Run 'TestDay4';
GO