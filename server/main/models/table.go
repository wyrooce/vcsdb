package models

import (
	"errors"
	"database/sql"
	_ "gopkg.in/goracle.v2"
//	"fmt"
	"log"
	"strconv"
	"encoding/json"
)

type Table struct{
	DatabaseObject
	Columns []Column
}

func (this *Table) Compare(mashhadTbl *Table) ([]string, error) {
	var changeList []string
	if this.Name != mashhadTbl.Name {
		return nil, errors.New("compare: Incompatible compare")
	}
	for _, mashhadColumn := range mashhadTbl.Columns {
		tehranColumn := this.GetColumn(mashhadColumn.Name)
		if tehranColumn == nil {
			alter := "ALTER TABLE "+mashhadTbl.Name + " ADD " + mashhadColumn.Name + " " +mashhadColumn.DataType+ ";"
			changeList = append(changeList, this.Name + ": " + alter)
		} else {
			list, _ := tehranColumn.Compare(mashhadColumn)
			changeList = append(changeList, list...)
		}
	}
	return changeList, nil	
}

func (this *Table) GetColumn(columnName string) *Column {
	for _, col := range this.Columns{
		if columnName == col.Name {
			return &col
		}
	}
	return nil
}

func FetchTable(db *sql.DB) ([]Table) {
	var tableName, colName, datatype, length, nullable, defaultValue, colID, objectID  string
	var isNullable bool
	var list []Table
	var colIDUint, objectIDuint uint64
	prevName := "notab"
	tbl := Table{}



    rows, err := db.Query(TABLE_PROPERTY_QUERY)
	for rows.Next(){
		if err = rows.Scan(&tableName, &colName, &datatype, &length, &nullable, &defaultValue, &colID, &objectID); err != nil {
      		log.Fatal(err)
		}
		if prevName == "notab" || prevName == tableName {
			if nullable == "Y" {
				isNullable = true
			}else {
				isNullable = false
			}
			colIDUint, _ = strconv.ParseUint(colID, 10, 32)
			objectIDuint, _ = strconv.ParseUint(objectID, 10, 32)
			col := Column{Name:colName, DataType:datatype, Length: length, Nullable: isNullable, Default:defaultValue, ID: colIDUint}
			tbl.Columns = append(tbl.Columns, col)
		}else {
			tbl.Name = tableName
			tbl.ObjectID = objectIDuint			
			list = append(list, tbl)
			tbl = Table{}
		}
		prevName = tableName
    }
    return list
}

func (this *Table) ToJSONString() string {
	js, err := json.Marshal(this)
	if err != nil{
		return "-"
	}
	return string(js)
}