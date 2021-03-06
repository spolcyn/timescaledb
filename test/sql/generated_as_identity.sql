-- This file and its contents are licensed under the Apache License 2.0.
-- Please see the included NOTICE for copyright information and
-- LICENSE-APACHE for a copy of the license.

CREATE table test_gen (
    id int generated by default AS IDENTITY primary key,
    payload text
);

 SELECT create_hypertable('test_gen', 'id', chunk_time_interval=>10);

insert into test_gen (payload) select generate_series(1,15) returning *;

select * from test_gen;

\set ON_ERROR_STOP 0
insert into test_gen values('1', 'a');
\set ON_ERROR_STOP 1

ALTER TABLE test_gen ALTER COLUMN id DROP IDENTITY;
\set ON_ERROR_STOP 0
insert into test_gen (payload) select generate_series(15,20) returning *;
\set ON_ERROR_STOP 1

ALTER TABLE test_gen ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY;
\set ON_ERROR_STOP 0
insert into test_gen (payload) select generate_series(15,20) returning *;
\set ON_ERROR_STOP 1
ALTER TABLE test_gen ALTER COLUMN id SET GENERATED BY DEFAULT RESTART 100;

insert into test_gen (payload) select generate_series(15,20) returning *;
select * from test_gen;

SELECT * FROM test.show_subtables('test_gen');
