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

create unique index uni_trans on Transcript(studId,crsCode);
-- 3. List the names of students who have taken course v4 (crsCode).
SELECT name FROM Student WHERE id IN (SELECT studId FROM Transcript WHERE crsCode = @v4);


/* Transcript table does not have any index.Query optimiser is looking at all rows to execute where condition on that table.
Explain analyze also revealed that executors spending most of the time on executing the where condition.adding index improving the performance
 */
 /*before and after explain analyze


 -----------------------------------------------------------------------------------------------------------------------------------------------------------------+
| -> Nested loop inner join  (cost=5.50 rows=10) (actual time=3.711..3.711 rows=0 loops=1)
    -> Filter: (`<subquery2>`.studId is not null)  (cost=2.00 rows=10) (actual time=3.680..3.680 rows=0 loops=1)
        -> Table scan on <subquery2>  (cost=2.00 rows=10) (actual time=0.016..0.016 rows=0 loops=1)
            -> Materialize with deduplication  (cost=10.25 rows=10) (actual time=3.649..3.649 rows=0 loops=1)
                -> Filter: (Transcript.studId is not null)  (cost=10.25 rows=10) (actual time=3.584..3.584 rows=0 loops=1)
                    -> Filter: (Transcript.crsCode = <cache>((@v4)))  (cost=10.25 rows=10) (actual time=3.553..3.553 rows=0 loops=1)
                        -> Table scan on Transcript  (cost=10.25 rows=100) (actual time=0.618..2.707 rows=100 loops=1)
    -> Index lookup on Student using id (id=`<subquery2>`.studId)  (cost=2.60 rows=1) (never executed)
 |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


explain analyze SELECT name FROM Student WHERE id IN (SELECT studId FROM Transcript WHERE crsCode = @v4);
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| EXPLAIN                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| -> Nested loop inner join  (cost=13.75 rows=10) (actual time=2.022..2.022 rows=0 loops=1)
    -> Filter: ((Transcript.crsCode = <cache>((@v4))) and (Transcript.studId is not null))  (cost=10.25 rows=10) (actual time=1.986..1.986 rows=0 loops=1)
        -> Index scan on Transcript using uni_trans  (cost=10.25 rows=100) (actual time=0.057..1.028 rows=100 loops=1)
    -> Index lookup on Student using id (id=Transcript.studId)  (cost=0.26 rows=1) (never executed)
 |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------










  */