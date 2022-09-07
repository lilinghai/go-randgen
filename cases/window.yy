/* test window funtion */

query:
    select

select:
    SELECT
           window_function_with_window_name,
           fieldA,
           fieldB
    FROM (
	SELECT _field AS fieldA, _field AS fieldB
	FROM _table
    ) as t
    WINDOW window_clause
    | SELECT
           window_function,
           fieldA,
           fieldB
    FROM (
	SELECT _field AS fieldA, _field AS fieldB
	FROM _table
    ) as t
    | SELECT
           lead_lag_with_window_name,
           pk,
           fieldA,
           fieldB
    FROM (
	SELECT pk, _field AS fieldA, _field AS fieldB
	FROM _table
    ) as t
    WINDOW pk_window_clause
    | SELECT
           lead_lag,
           pk,
           fieldA,
           fieldB
    FROM (
	SELECT pk, _field AS fieldA, _field AS fieldB
	FROM _table
    ) as t

window_function:
           DENSE_RANK() OVER (window_spec) AS 'dense_rank'
           | RANK() OVER (window_spec) AS 'rank'
           | ROW_NUMBER() OVER (window_spec) AS 'row_number'

window_function_with_window_name:
                            DENSE_RANK() OVER window_name AS 'dense_rank'
                            | RANK() OVER window_name AS 'rank'
                            | ROW_NUMBER() OVER window_name AS 'row_number'

lead_lag:
    LEAD(fieldA) OVER (pk_window_spec) AS 'lead1'
    | LEAD(fieldB, 2) OVER (pk_window_spec) AS 'lead2'
    | LEAD(fieldA, 3, NULL) OVER (pk_window_spec) AS 'lead3'
    | LEAD(fieldA, 3, fieldA) OVER (pk_window_spec) AS 'lead3'
    | LAG(fieldA) OVER (pk_window_spec) AS 'lag1'
    | LAG(fieldB, 2) OVER (pk_window_spec) AS 'lag2'
    | LAG(fieldA, 3, NULL) OVER (pk_window_spec) AS 'lag3'
    | LAG(fieldA, 3, fieldA) OVER (pk_window_spec) AS 'lag3'

lead_lag_with_window_name:
    LEAD(fieldA) OVER window_name AS 'lead1'
    | LEAD(fieldB, 2) OVER window_name AS 'lead2'
    | LEAD(fieldA, 3, NULL) OVER window_name AS 'lead3'
    | LEAD(fieldA, 3, fieldA) OVER window_name AS 'lead3'
    | LAG(fieldA) OVER window_name AS 'lag1'
    | LAG(fieldB, 2) OVER window_name AS 'lag2'
    | LAG(fieldA, 3, NULL) OVER window_name AS 'lag3'
    | LAG(fieldA, 3, fieldA) OVER window_name AS 'lag3'

pk_window_clause:
	window_name AS (pk_window_spec)

window_clause:
	window_name AS (window_spec)

window_name:
	w1

pk_window_spec:
	partition_clause ORDER BY pk order_clause_indication

window_spec:
	partition_clause order_clause
	| partition_clause order_clause
	| partition_clause order_clause

partition_clause:
	PARTITION BY LOWER(fieldB)

order_clause:
	#ORDER BY LOWER(fieldA) order_clause_indication
	#| ORDER BY LOWER(fieldB) order_clause_indication
	ORDER BY LOWER(fieldA) order_clause_indication , LOWER(fieldB) order_clause_indication
	| ORDER BY LOWER(fieldB) order_clause_indication , LOWER(fieldA) order_clause_indication

order_clause_indication:
	ASC | DESC
