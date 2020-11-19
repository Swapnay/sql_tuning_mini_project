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

--Sol
Alter table Student ADD Primary KEY(id);

-- 1. List the name of the student with id equal to v1 (id).
SELECT name FROM Student WHERE id = @v1;


--- What was the bottleneck?
----- Since the data was not sorted , all 400 rows were being scanned to get student with id.
--- How did you identify it? using explain
----- Explain
    /*'''-> SELECT name FROM Student WHERE id = @v1 \G ;
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: Student
   partitions: NULL
         type: ALL
possible_keys: NULL
          key: NULL
      key_len: NULL
          ref: NULL
         rows: 400
     filtered: 10.00
        Extra: Using where
1 row in set, 1 warning (0.00 sec)'''*/

-- What method you chose to resolve the bottleneck
---- indexing on the id .Since there is no primary key, set a primary key index on id.

---Explain analyze, Before and after

/*Explain analyze  SELECT name FROM Student WHERE id = @v1\G
*************************** 1. row ***************************
EXPLAIN: -> Filter: (Student.id = <cache>((@v1)))  (cost=41.00 rows=40) (actual time=3.329..9.435 rows=1 loops=1)
    -> Table scan on Student  (cost=41.00 rows=400) (actual time=1.598..5.671 rows=400 loops=1)

Explain analyze  SELECT name FROM Student WHERE id = @v1\G;
*************************** 1. row ***************************
EXPLAIN: -> Rows fetched before execution  (cost=0.00 rows=1) (actual time=0.016..0.024 rows=1 loops=1)*/
