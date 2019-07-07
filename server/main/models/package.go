package models

import (
	"database/sql"
	_ "gopkg.in/goracle.v2"
	"log"
	"encoding/json"
)

type Package struct{
	DatabaseObject
	Specification string
}


func (this *Package) ToJSONString() string{
	js, err := json.Marshal(this)
	if err != nil{
		return "-"
	}
	return string(js)
}



func FetchPackage(db *sql.DB) []Package {
	var name, body, spec string
    var list []Package
	var objectIDUint uint64

	
    rows, err := db.Query(PACKAGE_QUERY)
	for rows.Next(){
		if err = rows.Scan(&name, &body, &spec, &objectIDUint); err != nil {
      		log.Fatal(err)
		}
	//objectIDUint, _ = strconv.ParseUint(objectID, 64,10)
	pkg := Package{}
	pkg.Name = name
	pkg.SQLCode = body
	pkg.Specification = spec
	pkg.ObjectID = objectIDUint
	pkg.GetDigest()
    list = append(list, pkg)
    }
    return list
}