tables = {
    rows = { 1, 10, 20, 25, 50, 75, 100, 1000 },
    charsets = { 'utf8mb4 collate=utf8mb4_general_ci', 'utf8mb4 collate = utf8mb4_bin' },
    partitions = { 'undef' },
};

fields = {
    -- The four BLOB types are TINYBLOB, BLOB, MEDIUMBLOB, and LONGBLOB.
    -- The four TEXT types are TINYTEXT, TEXT, MEDIUMTEXT, and LONGTEXT.
    types = { 'int', 'datetime', 'date', 'timestamp', 'float', 'double',
              'char(20)', 'varchar(20)',
        --              'enum', 'set',
        -- todo key blob and text prefix
        --      'tinyblob','blob','mediumblob','longblob',
        --      'tinytext','text','mediumtext','longtext',
        -- 'time',
    },
    sign = { 'signed', 'unsigned' },
    keys = { 'key', 'undef' }
}

data = {
    enum = { '"y"', '"b"', '"Abc"', '"null"', '"1"', '"2"', '"0"' },
    numbers = { 'null', '12', '0', '-1', '1', '10', '4', '12.991', '1.009', '-9.183' },
    strings = { 'null', 'english', 'english', 'english', 'english', 'english', 'english', 'english' },
    datetime = { 'null', 'datetime' },
    timestamp = { 'null', 'datetime' },
    date = { 'null', 'date' },
}
