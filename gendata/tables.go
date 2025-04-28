package gendata

import (
	"bytes"
	"fmt"
	"github.com/yuin/gopher-lua"
	"strconv"
	"strings"
)

type Tables struct {
	*options
}

var tablesTmpl = mustParse("tables", "create table {{.tname}} (\n"+
	"`pk` int primary key NONCLUSTERED global %s\n"+
	") {{.charsets}} {{.partitions}}")

// support vars
var tablesVars = []*varWithDefault{
	{
		"rows",
		[]string{"0", "1", "2", "10", "100"},
	},
	{
		"charsets",
		[]string{"undef"},
	},
	{
		"partitions",
		[]string{"undef"},
	},
}

// process function
var tableFuncs = map[string]func(string, *tableStmt) (string, error){
	"rows": func(text string, stmt *tableStmt) (s string, e error) {
		rows, err := strconv.Atoi(text)
		if err != nil {
			return "", err
		}

		stmt.rowNum = rows
		return "", nil
	},
	"charsets": func(text string, stmt *tableStmt) (s string, e error) {
		if text == "undef" {
			return "", nil
		}
		return fmt.Sprintf("character set %s", text), nil
	},
	"partitions": func(text string, stmt *tableStmt) (s string, e error) {
		if text == "undef" {
			return "", nil
		}
		num, err := strconv.Atoi(text)
		if err != nil {
			return "", err
		}
		// PARTITION BY RANGE ( YEAR(separated) ) (
		// 	PARTITION p0 VALUES LESS THAN (1991),
		// 	PARTITION p1 VALUES LESS THAN (1996),
		// 	PARTITION p2 VALUES LESS THAN (2001),
		// 	PARTITION p3 VALUES LESS THAN MAXVALUE
		// );
		res := "PARTITION BY RANGE (col_int_key_signed) ( "
		for i := 0; i < num; i++ {
			res += fmt.Sprintf("PARTITION p%d VALUES LESS THAN (%d),", i, i*10)
		}
		res += fmt.Sprintf("PARTITION p%d VALUES LESS THAN MAXVALUE )", num)
		// return fmt.Sprintf("\npartition by hash(col_int_key_signed)\npartitions %d", num), nil
		return res, nil
	},
}

func newTables(l *lua.LState) (*Tables, error) {
	o, err := newOptions(tablesTmpl, l, "tables", tablesVars)

	if err != nil {
		return nil, err
	}

	return &Tables{o}, nil
}

func (t *Tables) gen() ([]*tableStmt, error) {
	tnamePrefix := "table"

	buf := &bytes.Buffer{}
	m := make(map[string]string)
	stmts := make([]*tableStmt, 0, t.numbers)

	err := t.traverse(func(cur []string) error {
		buf.Reset()
		buf.WriteString(tnamePrefix)
		stmt := &tableStmt{}
		for i := range cur {
			// current field name: fields[i]
			// current field value: curr[i]
			field := t.fields[i]
			tmpCur := cur[i]
			if field == "charsets" {
				charsetCollation := strings.Fields(cur[i])
				// define charset and collation
				if len(charsetCollation) >= 2 {
					tmpCur = strings.ReplaceAll(strings.Join(charsetCollation, ""), "=", "_")
				}
			}
			buf.WriteString("_" + tmpCur)
			target, err := tableFuncs[field](cur[i], stmt)
			if err != nil {
				return err
			}
			m[field] = target
		}

		tname := buf.String()

		stmt.name = tname

		m["tname"] = tname

		stmt.format = t.format(m)

		stmts = append(stmts, stmt)

		return nil
	})

	if err != nil {
		return nil, err
	}

	return stmts, nil
}

type tableStmt struct {
	// create statement without field part
	format string
	// table name
	name   string
	rowNum int
	// generate by wrapInTable
	ddl string
}

func (t *tableStmt) wrapInTable(fieldStmts []string) {
	buf := &bytes.Buffer{}
	buf.WriteString(",\n")
	buf.WriteString(strings.Join(fieldStmts, ",\n"))
	t.ddl = fmt.Sprintf(t.format, buf.String())
}
