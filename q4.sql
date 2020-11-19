USE springboardopt;

-- -------------------------------------
SET @v1 = 1612521;
SET @v2 = 1145072;
SET @v3 = 1828467;
SET @v4 = 'MGT382';
SET @v5 = 'Amber Hill';
SET @v6 = 'MGT';
SET @v7 = 'EE';			  
SET @v8 = 'MAT';

CREATE TEMPORARY TABLE prof_teach
	SELECT crsCode, semester
	FROM Professor
	JOIN Teaching
	WHERE  Professor.id = Teaching.profId
	AND Professor.name = @v5;

SELECT name FROM Student WHERE id IN(
    SELECT studId FROM Transcript,(SELECT crsCode, semester FROM prof_teach) as prof_teach1
WHERE Transcript.crsCode = prof_teach1.crsCode AND Transcript.semester =prof_teach1.semester);

/* Since where condition is on varchar field, inner query to get professor course code and semester
 had poor performance.Explain showed that no indexes are being used and nested join is taking longer.
 Adding indexes and converting CTE didn't have much effect due to nested join in that subquery.
 Only replacing CTE with temporary table improved performance.
 */
