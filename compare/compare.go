package compare

import (
	"bytes"
	"context"
	"database/sql"
	"database/sql/driver"
	"fmt"
	"github.com/beltran/gohive"
	"log"
	"strconv"
	"strings"
	"sync"
)

type DsnRes interface {
	fmt.Stringer
	Err() error
}

type QueryDsnRes struct {
	Res *SqlResult
	err error
}

func (q *QueryDsnRes) Err() error {
	return q.err
}

func (q *QueryDsnRes) String() string {
	return q.Res.String()
}

func newQueryDsnRes(db *sql.DB, sql string) *QueryDsnRes {
	result, err := query(db, sql)
	return &QueryDsnRes{result, err}
}

type execDsnRes struct {
	rowsAffected int64
	err          error
}

func (e *execDsnRes) String() string {
	return strconv.FormatInt(e.rowsAffected, 10)
}

func (e *execDsnRes) Err() error {
	return e.err
}

func newExecDsnRes(db *sql.DB, sql string) *execDsnRes {
	r, err := exec(db, sql)
	return &execDsnRes{r, err}
}

type Visitor func(sql string, dsn1Res DsnRes, dsn2Res DsnRes) error

func ByDsn(sqls []string, dsn1 string, dsn2 string, nonOrder bool, visitor Visitor) error {

	db1, err := cache.initDb(dsn1)
	if err != nil {
		return err
	}

	db2, err := cache.initDb(dsn2)
	if err != nil {
		return err
	}

	return ByDb(sqls, db1, db2, nonOrder, visitor)
}

func ByDb(sqls []string, db1 *sql.DB, db2 *sql.DB, nonOrder bool, visitor Visitor) error {

	for _, sql := range sqls {
		if sql == "" {
			continue
		}

		consistent, dsn1Res, dsn2Res := BySql(sql, db1, db2, nonOrder)

		if !consistent {
			if err := visitor(sql, dsn1Res, dsn2Res); err != nil {
				return err
			}
		}
	}

	return nil
}

func ByHiveSql(sql string, db1 *sql.DB, db2 *sql.DB, connHive *gohive.Connection, nonOrder bool) (consistent bool, dsn1Res DsnRes,
	dsn2Res DsnRes) {
	if isExec(sql) {
		return ByExec(sql, db1, db2)
	} else {
		var res1 *QueryDsnRes
		var res2 *QueryDsnRes

		wg := &sync.WaitGroup{}
		wg.Add(2)

		go func() {
			res1 = newQueryDsnRes(db1, sql)
			wg.Done()
		}()

		go func() {
			ctx := context.Background()
			cursor := connHive.Cursor()
			defer cursor.Close()
			log.Println("[sql]", sql)
			cursor.Exec(ctx, sql)
			if cursor.Err != nil {
				res2 = &QueryDsnRes{nil, cursor.Err}
				log.Println("[output", cursor.Err)
				return
			}

			desc := cursor.Description()
			cols := make([]string, len(desc))
			for i := 0; i < len(desc); i++ {
				cols[i] = desc[i][0]
			}
			var allRows [][][]byte
			rowSet := make(map[string]bool)
			log.Println("[output]")
			for cursor.HasMore(ctx) {
				row := cursor.RowMap(ctx)
				var columns = make([][]byte, len(cols))
				rowStrBuf := &bytes.Buffer{}
				for i := 0; i < len(cols); i++ {
					cellValue := row[cols[i]]
					if cellValue == nil {
						columns[i] = nil
						rowStrBuf.WriteString("NULL\t")
						continue
					}
					cellStrBuf := &bytes.Buffer{}
					cellValueStr := fmt.Sprint(cellValue)
					if desc[i][1] == "TIMESTAMP_TYPE" {
						cellValueStr = strings.Split(cellValueStr, ".")[0]
					}
					cellStrBuf.WriteString(cellValueStr)
					columns[i] = cellStrBuf.Bytes()
					rowStrBuf.WriteString(cellStrBuf.String() + "\t")
				}
				log.Println(rowStrBuf)
				rowSet[rowStrBuf.String()] = true
				allRows = append(allRows, columns)
			}

			res2 = &QueryDsnRes{&SqlResult{Data: allRows, Rows: rowSet, Header: cols}, nil}
			wg.Done()
		}()

		wg.Wait()

		if res1.err == driver.ErrBadConn {
			log.Printf("Error: connection to dsn1 error, %v \n", res1.err)
		}

		if res2.err == driver.ErrBadConn {
			log.Printf("Error: connection to dsn2 error, %v \n", res2.err)
		}

		if !errConsistent(res1.err, res2.err) {
			return false, res1, res2
		}

		// err all not nil, think it is consistent without need to compare
		if res1.err != nil && res2.err != nil {
			return true, res1, res2
		}

		// compare
		if nonOrder {
			if !res1.Res.NonOrderEqualTo(res2.Res) {
				return false, res1, res2
			}
		} else {
			if !res1.Res.BytesEqualTo(res2.Res) {
				return false, res1, res2
			}
		}

		return true, res1, res2
	}
}

func BySql(sql string, db1 *sql.DB, db2 *sql.DB, nonOrder bool) (consistent bool, dsn1Res DsnRes,
	dsn2Res DsnRes) {
	if isExec(sql) {
		return ByExec(sql, db1, db2)
	} else {
		return ByQuery(sql, db1, db2, nonOrder)
	}
}

func ByQuery(sql string, db1 *sql.DB, db2 *sql.DB, nonOrder bool) (consistent bool, dsn1Res DsnRes,
	dsn2Res DsnRes) {

	var res1 *QueryDsnRes
	var res2 *QueryDsnRes

	wg := &sync.WaitGroup{}
	wg.Add(2)

	go func() {
		res1 = newQueryDsnRes(db1, sql)
		wg.Done()
	}()

	go func() {
		res2 = newQueryDsnRes(db2, sql)
		wg.Done()
	}()

	wg.Wait()

	if res1.err == driver.ErrBadConn {
		log.Printf("Error: connection to dsn1 error, %v \n", res1.err)
	}

	if res2.err == driver.ErrBadConn {
		log.Printf("Error: connection to dsn2 error, %v \n", res2.err)
	}

	if !errConsistent(res1.err, res2.err) {
		return false, res1, res2
	}

	// err all not nil, think it is consistent without need to compare
	if res1.err != nil && res2.err != nil {
		return true, res1, res2
	}

	// compare
	if nonOrder {
		if !res1.Res.NonOrderEqualTo(res2.Res) {
			return false, res1, res2
		}
	} else {
		if !res1.Res.BytesEqualTo(res2.Res) {
			return false, res1, res2
		}
	}

	return true, res1, res2
}

func ByExec(sql string, db1 *sql.DB, db2 *sql.DB) (consistent bool, dsn1Res DsnRes,
	dsn2Res DsnRes) {

	var res1 *execDsnRes
	var res2 *execDsnRes

	wg := &sync.WaitGroup{}
	wg.Add(2)

	go func() {
		res1 = newExecDsnRes(db1, sql)
		wg.Done()
	}()

	go func() {
		res2 = newExecDsnRes(db2, sql)
		wg.Done()
	}()

	wg.Wait()

	if res1.err == driver.ErrBadConn {
		log.Printf("Error: connection to dsn1 error, %v \n", res1.err)
	}

	if res2.err == driver.ErrBadConn {
		log.Printf("Error: connection to dsn2 error, %v \n", res2.err)
	}

	if !errConsistent(res1.err, res2.err) {
		return false, res1, res2
	}

	if res1.err != nil && res2.err != nil {
		return true, res1, res2
	}

	if res1.rowsAffected != res2.rowsAffected {
		return false, res1, res2
	}

	return true, res1, res2
}

func errConsistent(err1 error, err2 error) bool {
	return (err1 == nil && err2 == nil) || (err1 != nil && err2 != nil)
}
