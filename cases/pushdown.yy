#1. trim
#TRIM([{BOTH | LEADING | TRAILING} [remstr] FROM] str), TRIM([remstr FROM] str)
#trim( str,num,null,'',\t,\n, ascii code )
#trim( remstr from str)
#2. upper/ucase/lower/lcase
#3. format
#FORMAT(X,D[,locale])
#四舍五入
#4. sum(enum)
#5. cast(time as real) sql_mode ?
#小数点
#6. SYSDATE([fsp])
#根据语境返回数值或字符串
#7. SECOND(time)
#8. MINUTE(time)
#9. HOUR(time)
#10. RTRIM(str)
#LTRIM(str)
#11. like variable
#12. ROUND(X), ROUND(X,D)
#D 正负
#13. group concat
#GROUP_CONCAT([DISTINCT] expr [,expr ...]
#             [ORDER BY {unsigned_integer | col_name | expr}
#                 [ASC | DESC] [,col_name ...]]
#             [SEPARATOR str_val])
#

# todo sum,group_concat, where condition, func(expression)
query:
    select

select:
    SELECT str_func,num_func FROM _table  t1 order by t1. pk
    | SELECT str_func,num_func from _table  t1 where expression order by t1. pk
    #| SELECT groupc from _table t1
    | SELECT str_func2,num_func2 FROM _table  t1 order by t1. pk
    | SELECT str_func3,num_func3 FROM _table  t1 order by t1. pk
    | SELECT str_func2,num_func2 from _table  t1 where expression order by t1. pk
    | SELECT str_func3,num_func3 from _table  t1 where expression order by t1. pk

groupc:
    group_concat(distinct groupc_exp order by groupc_exp)
    | group_concat(distinct groupc_exp,groupc_exp order by groupc_exp,groupc_exp)
    | group_concat(distinct groupc_exp,groupc_exp,groupc_exp order by groupc_exp,groupc_exp,groupc_exp)
    | group_concat( groupc_exp order by groupc_exp)
    | group_concat( groupc_exp,groupc_exp order by groupc_exp)
    | group_concat( groupc_exp,groupc_exp,groupc_exp order by groupc_exp)
    | group_concat(distinct groupc_exp order by groupc_exp desc)
    | group_concat(distinct groupc_exp,groupc_exp order by groupc_exp asc)
    | group_concat(distinct groupc_exp,groupc_exp,groupc_exp order by groupc_exp,groupc_exp,groupc_exp desc )
    | group_concat( groupc_exp order by groupc_exp separator "###")
    | group_concat( groupc_exp,groupc_exp order by groupc_exp,groupc_exp desc )
    | group_concat( groupc_exp,groupc_exp,groupc_exp order by groupc_exp,groupc_exp,groupc_exp desc)

str_func3:
    trim(expression)
    | trim( (expression) from (expression))
    | upper(expression)
    | ucase(expression)
    | lower(expression)
    | lcase(expression)
    | rtrim(expression)
    | ltrim(expression)
    | ((expression) like (expression))
    | ((expression) not like (expression))
    | ((expression) rlike like_operator_v)
    | ((expression) not rlike like_operator_v)

num_func3:
    format(expression, little_param_random)
    | cast((expression) as real)
#    | sysdate(expression)
    | second(expression)
    | minute(expression)
    | hour(expression)
    | round(expression)
# https://github.com/pingcap/tics/issues/3333
#    | round(expression,expression)
    | round(expression,little_param_random)

str_func2:
    trim(column_values_str)
    | trim( (column_values_str) from (column_values_str))
    | upper(column_values_str)
    | ucase(column_values_str)
    | lower(column_values_str)
    | lcase(column_values_str)
    | rtrim(column_values_str)
    | ltrim(column_values_str)
    | ((column_values_str) like (column_values_str))
    | ((column_values_str) not like (column_values_str))
    | ((column_values_str) rlike like_operator_v)
    | ((column_values_str) not rlike like_operator_v)

like_operator_v:
    "A%"
    | "a%"
    | "ABC"
    | "A*"
    | "a*"
    | NULL
    | '0'
    | '1'

num_func2:
    format(column_values_str, little_param_random)
    | cast((column_values_str) as real)
#    | sysdate(column_values_str)
    | second(column_values_str)
    | minute(column_values_str)
    | hour(column_values_str)
    | round(column_values_str)
# https://github.com/pingcap/tics/issues/3333
#    | round(column_values_str,column_values_str)
    | round(column_values_str,little_param_random)

str_func:
    trim(param_random)
    | trim( param_random from param_random)
    | upper(param_random)
    | ucase(param_random)
    | lower(param_random)
    | lcase(param_random)
    | rtrim(param_random)
    | ltrim(param_random)
    | (param_random like param_random)
    | (param_random not like param_random)
    | (param_random rlike like_operator_v)
    | (param_random not rlike like_operator_v)

num_func:
    format(param_random, little_param_random)
    | cast(param_random as real)
#    | sysdate(param_random)
    | second(param_random)
    | minute(param_random)
    | hour(param_random)
    | round(param_random)
# https://github.com/pingcap/tics/issues/3333
#    | round(param_random,field_random)
    | round(param_random,little_param_random)

groupc_exp:
    t1. _field
    | str_func
    | num_func
    | (expression)

expression:
    str_expression
    | str_expression
    | str_expression
    | str_expression
    | str_expression
    | str_expression
    | not (str_expression)
    | (if_when_expression) comparison (if_when_expression)
#    | ((if_when_expression) comparison (if_when_expression)) logical_operator str_expression
#    | ((if_when_expression) comparison (if_when_expression)) logical_operator ((if_when_expression) comparison (if_when_expression))
#    | not ((if_when_expression) comparison (if_when_expression))
    | (str_expression) logical_operator (str_expression)
    | not (str_expression) logical_operator (str_expression)

str_expression:
    column_values_str is_operator
    | column_values_str in_operator
    | column_values_num in (column_values_num,column_values_num)
    | column_values_num is_operator
    | column_values_str between column_values_str and column_values_str
    | column_values_str not between column_values_str and column_values_str
    | column_values_num between column_values_num and column_values_num
    | column_values_num not between column_values_num and column_values_num
    | ret_str_func comparison column_values_str
    | column_values_str comparison column_values_str
    | column_values_str comparison column_values_str
    | column_values_str comparison column_values_str
    | column_values_str comparison column_values_str
    | column_values_str comparison column_values_str
    | column_values_num comparison column_values_num
    | column_values_num comparison column_values_num


if_when_expression:
    if(str_expression,column_values_str,column_values_str)
    | case when str_expression then column_values_str end
    | case when str_expression then column_values_str else column_values_str end

is_operator:
    is is_operator_v
    | is not is_operator_v

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



ret_str_func:
    concat(column_values_str,column_values_str)
    | ifnull(column_values_str,column_values_str)
    | nullif(column_values_str,column_values_str)
    | case column_values_str when column_values_str then column_values_str end
    | case column_values_str when column_values_str then column_values_str else column_values_str end


column_values_str:
    str_func
    | t1. _field_char
    | str_func
    | str_func
    | str_func

column_values_num:
    num_func
    | num_func
    | num_func
    | t1. _field_int

field_random:
    t1. _field
    | null
    | t1. _field
    | t1. _field

little_param_random:
    little_value_random
    | t1. _field_int
    | t1. _field_char
    | null

little_value_random:
    12.991
    | 1.009
    | -9.183
    | 0
    | ""
    | -1
    | -2
    | 1
    | 12
    | "y"
    | "#"
    | "gg"
    | "cc"
    | "ee"
    | "b"
    | "x"
    | "%b%"
    | "%y"
    | "0%"
    | "%1"
    | "%-"
    | _letter
    | _english


param_random:
    little_value_random
    | 100
    | 12000101000000.023
    | "1200-01-01 00:00:00.023"
    | _date
    | _datetime
    | _time
    | field_random
    | field_random
    | field_random
    | field_random
    | field_random
    | field_random

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
    | <=>

is_operator_v:
    null
    | unknown
#    | true
#    | false

# param 2 type num
# mod

# param 1 type all
# ascii char_length position(arg1 in arg2) right(arg1, arg_num)
# left(arg1 , arg_num)

# param 3 type all
# replace

# param all type all
# coalesce concat concat_ws

# special char
# 0 null ""

#abs, ceil, ceiling, conv

# 希望能够尽量覆盖足够多的 sql select 模式
# 1. 简单查询
# select xxx from single_table where expression order by xxx limit xxx
# 2. join
# 常规 join，子查询，多层嵌套 join
# 3. aggregation
# 简单查询 / join aggregation group by on expression

# 一些问题
# 在多层嵌套的时候如何在 expression 中指定对应的表名
# select * from _table as t1 join _table as t2 on expression join _table t3 where expression

# 使用非关键字的时候，像调用函数一样可以加上参数传递 -- 支持该功能
# select * from _table as t1 join _table as t2 on expression(t1,t2) join _table t3 where expression(t2,t3)

