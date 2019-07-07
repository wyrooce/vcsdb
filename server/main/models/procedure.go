package models

import (
	"database/sql"
	_ "gopkg.in/goracle.v2"
	"log"
)

type Procedure struct{
	DatabaseObject
}


func FetchProcedure(db *sql.DB) ([]Procedure) {
    var name, code string
    var list []Procedure
	var objectIDUint uint64

    rows, err := db.Query(PROCEDURE_QUERY)
	for rows.Next(){
		if err = rows.Scan(&name, &code, &objectIDUint); err != nil {
      		log.Fatal(err)
		}
	//objectIDUint, _ = strconv.ParseUint(objectID, 64,10)
	prc := Procedure{}
	prc.Name = name
	prc.SQLCode = code
	prc.ObjectID = objectIDUint
	prc.GetDigest()	
    list = append(list, prc)
    }
    return list
}


