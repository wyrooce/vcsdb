package models

import (
	"log"
		"database/sql"
	_ "gopkg.in/goracle.v2"
)

type View struct{
	DatabaseObject
}

func FetchView(db *sql.DB) []View {
    var name, code string
    var list []View
	var objectIDUint uint64

    rows, err := db.Query(VIEW_PROPERTY_QUERY)
	for rows.Next(){
		if err = rows.Scan(&name, &code, &objectIDUint); err != nil {
      		log.Fatal(err)
		}
	//objectIDUint, _ = strconv.ParseUint(objectID, 64,10)
	nvw := View{}
	nvw.Name = name
	nvw.SQLCode = code
	nvw.ObjectID = objectIDUint
	nvw.GetDigest()
    list = append(list, nvw)
    }
    return list
}





