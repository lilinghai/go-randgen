tables = {
    rows = {1, 10, 20, 50, 100, 200, 500, 1000},
    charsets = {'utf8mb4 collate=utf8mb4_general_ci', 'utf8mb4 collate = utf8mb4_bin'},
    -- pk partition column
    partitions = {4, 10}
};

fields = {
    -- The four BLOB types are TINYBLOB, BLOB, MEDIUMBLOB, and LONGBLOB.
    -- The four TEXT types are TINYTEXT, TEXT, MEDIUMTEXT, and LONGTEXT.
    types = {'int', 'bigint', 'datetime', 'date', 'timestamp', 'float', 'double', 'decimal', 'char(20)', 'varchar(20)',
             'bool' --              'enum', 'set',
    -- todo key blob and text prefix
    --      'tinyblob','blob','mediumblob','longblob',
    --      'tinytext','text','mediumtext','longtext',
    -- 'time',
    },
    -- sign = {'signed', 'unsigned'}
    keys = {'key'}
}

data = {
    -- enum = { '"y"', '"b"', '"Abc"', '"null"', '"1"', '"2"', '"0"' },
    int = {'null', 'null', 'null', 'digit', 'digit', 'digit', 'digit', 'digit', 'digit', 'digit', 'digit', 'digit',
           'digit','tinyint', 'tinyint', 'tinyint', 'tinyint', 'tinyint', 'tinyint', 'tinyint', 'tinyint', 'tinyint', '-1', '-2', '-3', '-4', '-5', '-6', '-7', '-8', '-9', '10', '-10', '2147483647', '-2147483648'},
    bigint = {'null', 'null', 'null', 'digit', 'digit', 'digit', 'digit', 'digit', 'digit', 'digit', 'digit', 'digit',
              'digit','tinyint', 'tinyint', 'tinyint', 'tinyint', 'tinyint', 'tinyint', 'tinyint', 'tinyint', 'tinyint', '-1', '-2', '-3', '-4', '-5', '-6', '-7', '-8', '-9', '10', '-10', '2147483647', '-2147483648'},
    numbers = {'null', 'null', 'null', 'digit', 'digit', 'digit', 'digit', 'digit', 'digit', 'digit', 'digit', 'digit',
               'digit','tinyint', 'tinyint', 'tinyint', 'tinyint', 'tinyint', 'tinyint', 'tinyint', 'tinyint', 'tinyint', '-1', '-2', '-3', '-4', '-5', '-6', '-7', '-8', '-9', '10', '-10', '2147483647', '-2147483648',
               '1.111', '2.111', '3.111'},
    strings = {'null', 'null', 'null', 'null', 'letter', 'letter', 'letter', 'letter', 'letter', 'letter', 'letter',
               'letter', 'letter', 'letter', 'letter', 'letter','tinyint', 'tinyint', 'tinyint', 'tinyint', 'tinyint', 'tinyint', 'tinyint', 'tinyint', 'tinyint', '"A"', '"B"', '"C"', '"D"', '"E"', '"F"', '"G"', '"H"',
               '"I"', '"J"', '"K"', '"L"', '"M"', '"N"', '"O"', '"P"', '"Q"', '"R"', '"S"', '"T"', '"U"', '"V"', '"W"',
               '"X"', '"Y"', '"Z"', 'english', 'english', 'english', 'english', 'english', 'english', 'english',
               'english', 'english', 'digit', 'digit', 'digit', 'digit', 'digit', 'digit'},
    datetime = {'null', 'null', 'null', 'null', '"2020-10-10 10:00:00"', '"2020-10-11 10:00:00"',
                '"2020-10-12 10:00:00"', '"2020-10-13 10:00:00"', '"2020-10-14 10:00:00"', '"2020-10-15 10:00:00"',
                '"2020-10-16 10:00:00"', '"2020-10-17 10:00:00"', '"2020-10-18 10:00:00"', '"2020-10-19 10:00:00"'},
    timestamp = {'null', 'null', 'null', 'null', '"2020-10-10 10:00:00"', '"2020-10-11 10:00:00"',
                 '"2020-10-12 10:00:00"', '"2020-10-13 10:00:00"', '"2020-10-14 10:00:00"', '"2020-10-15 10:00:00"',
                 '"2020-10-16 10:00:00"', '"2020-10-17 10:00:00"', '"2020-10-18 10:00:00"', '"2020-10-19 10:00:00"'},
    date = {'null', 'null', 'null', 'null', '"2020-10-10"', '"2020-10-11"', '"2020-10-12"', '"2020-10-13"',
            '"2020-10-14"', '"2020-10-15"', '"2020-10-16"', '"2020-10-17"', '"2020-10-18"', '"2020-10-19"'},
    bool = {'bool', 'null'}
}
