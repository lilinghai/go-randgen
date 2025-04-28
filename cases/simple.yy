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

comparison_oper:
    =
    | >=
    | >
    | <=
    | <
    | <>
    | !=
    | <=>

arithmetic_oper:
    +
    | -
# Error 1690: BIGINT value is out of range in
# avoid multiple operator
#    | *
#    | /
#    | %

bitwise_oper:
    &
    | ^

logical_oper:
    and 
    | or

comparison_is_oper:
    is
    | is not


in_oper:
    in
    | not in

between_oper:
    between
    | not between

like_oper:
    like
    | not like

join_oper:
    join
    | inner join
    | left join
    | right join

string_literal:
    null
    | null
    | numeric_literal
    | datetime_literal
    | _letter
    | _letter
    | _letter
    | _english
    | _english
    | _english
    | numeric_literal
    | datetime_literal
    | _letter
    | _letter
    | _letter
    | _english
    | _english
    | _english    
    | numeric_literal
    | datetime_literal
    | _letter
    | _letter
    | _letter
    | _english
    | _english
    | _english
    | "A"
    | "B"
    | "C"
    | "D"
    | "E"
    | "F"
    | "G"
    | "H"
    | "I"
    | "J"
    | "K"
    | "L"
    | "M"
    | "N"
    | "O"
    | "P"
    | "Q"
    | "R"
    | "S"
    | "T"
    | "U"
    | "V"
    | "W"
    | "X"
    | "Y"
    | "Z"

numeric_literal:
    null
    | null
    | _digit
    | _digit 
    | _digit
    | _digit
    | _digit
    | _digit
    | _digit
    | _digit
    | _digit
    | _digit   
    | -1
    | -2
    | -3
    | -4
    | -5
    | -6
    | -7
    | -8
    | -9
    | -10
    | 2147483647
    | -2147483648
    | 1.111
    | 2.111
    | 3.111

date_literal:
    null
    | null
    | "2020-10-10"
    | "2020-10-11"
    | "2020-10-12"
    | "2020-10-13"
    | "2020-10-14"
    | "2020-10-15"
    | "2020-10-16"
    | "2020-10-17"
    | "2020-10-18"
    | "2020-10-19"

datetime_literal:
    null
    | null
    | date_literal
    | "2020-10-10 10:00:00"
    | "2020-10-11 10:00:00"
    | "2020-10-12 10:00:00"
    | "2020-10-13 10:00:00"
    | "2020-10-14 10:00:00"
    | "2020-10-15 10:00:00"
    | "2020-10-16 10:00:00"
    | "2020-10-17 10:00:00"
    | "2020-10-18 10:00:00"
    | "2020-10-19 10:00:00"

timestamp_literal:
    datetime_literal


field_num:
    t1. _field_int
    | t2. _field_int
# Float/double 比较时候精度的问题，导致不一致，去掉 decimal 类型数据，或者去掉一些位数较多的值，如 2147483647
#    | t1. _field_decimal

# 用于判断第一个参数是否为 NULL。如果第一个参数为 NULL，则返回第二个参数；否则返回第一个参数。IFNULL
# 比较两个参数。如果两个参数相等，则返回 NULL；否则返回第一个参数。NULLIF
# 是一个条件函数，用于根据条件表达式返回不同的值。如果条件表达式为 TRUE，则返回第二个参数；否则返回第三个参数。IF
#    CASE
#        WHEN age < 18 THEN 'Minor'
#        WHEN age BETWEEN 18 AND 65 THEN 'Adult'
#        ELSE 'Senior'
#    END AS age_group

# TODO filed_char_expr
field_num_expr:
    field_num arithmetic_oper field_num
    | field_num arithmetic_oper numeric_literal
    | IFNULL(field_num,field_num)
    | NULLIF(field_num, field_num)
    | NULLIF(numeric_literal, field_num)
    | CASE WHEN field_num comparison_oper numeric_literal THEN field_num END
    | CASE WHEN field_num comparison_oper numeric_literal THEN field_num ELSE field_num END
    | IF(field_num comparison_oper numeric_literal,field_num,field_num)
    | field_num
    | field_num
    | field_num

field_string:
    t1. _field_char
    | t2. _field_char


field_char_expr:
    IFNULL(field_string,field_string)
    | NULLIF(field_string, field_string)
    | NULLIF(string_literal, field_string)
    | CASE WHEN field_string comparison_oper field_string THEN field_string END
    | CASE WHEN field_string comparison_oper string_literal THEN field_string ELSE field_string END
    | IF(field_string comparison_oper field_string,field_string,field_string)
    | field_string
    | field_string
    | field_string

bool_in_expr:
     field_num_expr in_oper (field_num_expr, field_num_expr, numeric_literal)
     | field_num_expr in_oper (field_num_expr, field_num_expr)
     | field_num_expr in_oper (numeric_literal, numeric_literal, numeric_literal)
     | field_char_expr in_oper (field_char_expr, field_char_expr,string_literal)
     | field_char_expr in_oper (field_char_expr, field_char_expr)
     | field_char_expr in_oper (string_literal, string_literal,string_literal)
     | string_literal in_oper (field_char_expr, field_char_expr)

bool_cmp_expr:
    field_num_expr comparison_oper field_num_expr
    | field_num_expr comparison_oper numeric_literal
    | field_char_expr comparison_oper field_char_expr
    | field_char_expr comparison_oper string_literal

bool_between_expr:
    field_num_expr between_oper field_num_expr and field_num_expr
    | field_num_expr between_oper field_num_expr and numeric_literal
    | field_num_expr between_oper numeric_literal and numeric_literal
    | numeric_literal between_oper field_num_expr and numeric_literal    
    | numeric_literal between_oper field_num_expr and field_num_expr
    | field_char_expr between field_char_expr and field_char_expr
    | field_char_expr between field_char_expr and string_literal
    | field_char_expr between string_literal and string_literal
    | string_literal between field_char_expr and field_char_expr 
    | string_literal between field_char_expr and string_literal

bool_is_expr:
    field_num comparison_is_oper null
    | field_char_expr comparison_is_oper null

bool_expr:
    bool_in_expr
    | bool_cmp_expr
    | bool_between_expr
    | bool_is_expr

logic_expr:
    bool_expr
    | bool_expr
    | bool_expr
    | not bool_expr
    | bool_expr logical_oper bool_expr
    | bool_expr logical_oper bool_expr logical_oper bool_expr
    | not bool_expr logical_oper bool_expr
    | not bool_expr logical_oper not bool_expr


hint_func:
    nth_plan(2) */
    | nth_plan(3) */

hint_begin:
    /*+

projection:
    count(*)


query:
    # 修改 field_num 和 filed_string 的 t1 t2 来支持不同数量表的查询
#    select projection from _table where logic_expr
#    | select hint_begin hint_func count(*) from _table where logic_expr
     SELECT projection FROM _table  t1 join_oper _table t2 on logic_expr