# collation 影响 topN
# mpp `Sort` is not supported now
# test point
    # data type -- The string data types are CHAR, VARCHAR, BINARY, VARBINARY, BLOB, TEXT, ENUM, and SET.
    # aggregation function - count,max,min
    # agg,topN,join,sub query
    # string function -- ascii,upper 等
    # 运算符 -- +,like,or,in 等
    # window function todo

# select aggregation(expression1) from table1 join table2 where expression2 group expression3
query:
    {column_prefix1="t1.";column_prefix2="t2."} select agg_expression from _table as t1 join_type_on _table as t2 on expression
    | {column_prefix1="t1.";column_prefix2="t2."} select agg_expression from _table as t1 join_type_on _table as t2 on expression having having_exp
    # 子查询需要保证 projection 项中包含的列属于 t1；同时要保证子查询中有一部分条件是关联的
    | {column_prefix1="t1.";column_prefix2=""} select agg_expression from _table as t1 where t1. _field_char not in (select _field_char from _table as t2 where expression)
    | {column_prefix1="t1.";column_prefix2=""} select agg_expression from _table as t1 where t1. _field_char in (select _field_char from _table as t2 where expression)
    | {column_prefix1="t1.";column_prefix2=""} select agg_expression from _table as t1 where not exists (select _field_char from _table as t2 where expression)
    | {column_prefix1="t1.";column_prefix2=""} select agg_expression from _table as t1 where exists (select _field_char from _table as t2 where expression)
    | {column_prefix1="t1.";column_prefix2=""} select agg_expression from _table as t1 where t1. _field_char comparison sub_query_modifier (select _field_char from _table as t2 where expression)
    | {column_prefix1="t1.";column_prefix2=""} select agg_expression from _table as t1 where t1. _field_char comparison sub_query_modifier (select _field_char from _table as t2 where expression)
    | {column_prefix1="t1.";column_prefix2=""} select agg_expression from _table as t1 where t1. _field_char comparison (select _field_char from _table as t2 where expression order_by_limit1)
#    # having
#    | select agg_expression as x from _table as t1 group by t1. _field_char having x not in (select _field_char from _table as t2 where aggregation_condition)
#    | select agg_expression as x from _table as t1 group by t1. _field_char having x not in (select _field_char from _table as t2 where condition)
#    | select agg_expression as x from _table as t1 group by t1. _field_char having not exists (select _field_char from _table as t2 where aggregation_condition)
#    | select agg_expression as x from _table as t1 group by t1. _field_char having exists (select _field_char from _table as t2 where aggregation_condition)
#    | select agg_expression as x from _table as t1 group by t1. _field having x comparison_operation sub_query_modifier (select _field from _table as t2 where condition)
#    | select agg_expression as x from _table as t1 group by t1. _field having x comparison_operation sub_query_modifier (select _field from _table as t2 where aggregation_condition)
#    | select agg_expression as x from _table as t1 group by t1. _field having x comparison_operation (select _field from _table as t2 where condition order_by_limit1)
#    | select agg_expression as x from _table as t2 group by t2. _field having x comparison_operation (select common_aggregation as y from _table as t1)


having_exp:
    agg_expression
    | agg_expression comparison agg_expression
    | agg_expression comparison const_value
    | agg_expression is null
    | agg_expression comparison null
    | agg_expression between 0 and 3
    | agg_expression between "A" and "Y"
    | agg_expression in ("b","y","B",null,"Y","ABC")
    | case agg_expression when null then null end
    | case when null then agg_expression end
    | case when agg_expression then agg_expression end
    | case when agg_expression then agg_expression else agg_expression end
    | ifnull(null,agg_expression)
    | ifnull(agg_expression comparison agg_expression, agg_expression)
    | nullif(null,agg_expression) is null
    | if(null,agg_expression,agg_expression)
    | if( agg_expression,null,null)

agg_operator_v:
    column_values_str
    | const_value
    | ret_num_func
    | ret_str_func
    | if_when_expression
    | expression

agg_expression:
    agg_operator agg_operator_v)
    | count(*)
# skip for a known issue
#    | count(distinct agg_operator_v,agg_operator_v)
#    | count(distinct agg_operator_v,agg_operator_v,agg_operator_v)

column_str:
    { print(column_prefix1)} _field_char
    | { print(column_prefix2) }  _field_char

column_values_str:
    const_str_value
    | column_str
    | column_str
    | column_str
    | column_str
    | column_str
    | column_str

str_expression:
    column_str is_operator
    | column_str like_operator
    | column_str in_operator
    | column_str between_operator
    | ret_num_func comparison const_int_value
    | ret_str_func comparison column_values_str
    | column_values_str comparison column_values_str
    | column_values_str comparison column_values_str
    | column_values_str comparison column_values_str
    | column_values_str comparison column_values_str
    | column_values_str comparison column_values_str


if_when_expression:
    if(str_expression,column_values_str,column_values_str)
    | case when str_expression then column_values_str end
    | case when str_expression then column_values_str else column_values_str end

expression:
    str_expression
    | str_expression
    | str_expression
    | str_expression
    | str_expression
    | str_expression
    | not (str_expression)
    | (if_when_expression) comparison (if_when_expression)
    | ((if_when_expression) comparison (if_when_expression)) logical_operator str_expression
    | ((if_when_expression) comparison (if_when_expression)) logical_operator ((if_when_expression) comparison (if_when_expression))
    | not ((if_when_expression) comparison (if_when_expression))
    | (str_expression) logical_operator (str_expression)

is_operator:
    is is_operator_v
    | is not is_operator_v

like_operator:
    like like_operator_v
    | not like like_operator_v
    | rlike like_operator_v
    | not rlike like_operator_v

like_operator_v:
    "A%"
    | "a%"
    | "ABC"
    | "A*"
    | "a*"
    | NULL
    | '0'
    | '1'

in_operator:
    in ( in_operator_v )
    | not in ( in_operator_v )

in_operator_v:
    column_values_str
    | column_values_str, column_values_str
    | column_values_str, column_values_str, column_values_str
    | column_values_str, column_values_str, column_values_str
    | column_values_str, column_values_str, column_values_str
    | column_values_str, column_values_str, column_values_str, column_values_str


between_operator:
    between column_values_str and column_values_str
    | not between column_values_str and column_values_str

ret_num_func:
    strcmp(column_values_str,column_values_str)
    | find_in_set(column_values_str,column_values_str)
    | instr(column_values_str,column_values_str)
    | locate(column_values_str,column_values_str)
    | char_length(column_values_str)
    | length(column_values_str)

ret_str_func:
    concat(column_values_str,column_values_str)
    | ifnull(column_values_str,column_values_str)
    | nullif(column_values_str,column_values_str)
    | case column_values_str when column_values_str then column_values_str end
    | case column_values_str when column_values_str then column_values_str else column_values_str end


const_value:
    const_str_value
    | "0"
    | "1"
    | "-1"
    | "20"
    | null
    | const_int_value

const_int_value:
    0
    | 1
    | 1
    | 2
    | 2
    | 3
    | -1
    | 10
    | _tinyint
    | NULL

const_str_value:
    _english
    | _english
    | _english
    | _english
    | _english
    | _english
    | _english
    | NULL

order_by_limit1:
    order by pk desc limit 1
    | order by pk asc limit 1

sub_query_modifier:
    some
    | any
    | all

# not
logical_operator:
    and
    | or
    | xor

comparison:
    =
    | >
    | <
    | <>
    | >=
    | <=
    | !=
#    | <=>

is_operator_v:
    null
    | unknown
#    | true
#    | false

join_type_on:
    inner join
    | cross join
    | left join
    | right join

agg_func:
    count(
    | max(
    | min(

agg_operator:
    agg_func
    | agg_func distinct