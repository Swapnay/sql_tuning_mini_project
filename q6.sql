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

create  unique index uni_stud on Student(id,name);
create index ind_course on Course(crsCode,deptId);
with crs_cte as(
	SELECT crsCode FROM Course WHERE deptId = @v8 AND crsCode IN (SELECT crsCode FROM Teaching)
)

SELECT name FROM Student where id in
	(SELECT studId
	FROM Transcript
		WHERE crsCode IN
		(select crsCode from crs_cte)
        GROUP BY studId
		HAVING COUNT(*) = (select count(*) from crs_cte ))