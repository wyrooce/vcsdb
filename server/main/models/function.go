package models

import (
	"database/sql"
	_ "gopkg.in/goracle.v2"
	"log"
	"encoding/json"
)

type Function struct{
	DatabaseObject
}

func FetchFunction(db *sql.DB) ([]Function) {
    var name, code string
    var list []Function
	var objectIDUint uint64

    rows, err := db.Query(FUNCTION_QUERY)
	for rows.Next(){
		if err = rows.Scan(&name, &code, &objectIDUint); err != nil {
      		log.Fatal(err)
		}
	fnc := Function{}
	fnc.Name = name
	fnc.SQLCode = code
	fnc.ObjectID = objectIDUint
	fnc.GetDigest()
    list = append(list, fnc)
    }
    return list
}

func (this *Function) ToJSONString() string{
	js, err := json.Marshal(this)
	if err != nil{
		return "-"
	}
	return string(js)
}

