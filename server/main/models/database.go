package models
    
import (
    "fmt"
    "database/sql"
    _ "gopkg.in/goracle.v2"
    "os"
   	"mym/VCSTahlil/server/main/util"

)


func GetDB() *sql.DB{
   
    port := os.Getenv("db_port")
	username := os.Getenv("db_user")
	password := os.Getenv("db_pass")
	host := os.Getenv("db_address")
	database := os.Getenv("db_database")

    databaseURL := username+"/"+password + "@" + host +":"+port +"/"+database
    
    db, err := sql.Open("goracle", databaseURL)
    if err != nil {
        fmt.Println(err)
        return nil
    }

	return db
}


type DatabaseObject struct{
    // Text interface{}
    Name string
    ObjectID uint64
    Digest string
    SQLCode string

    // ToJSONString() string
    // GetDigest() string
    // Compare() []string

   // (do *DatabaseObject) Compare() (string[], error)
}

func (this *DatabaseObject) GetDigest() string {
    	//space&newLine to singel space
	//allcase to lowercase
	if this.Digest == "" {
		this.Digest = util.Hash(util.FormatCode(this.SQLCode))
	}
	return this.Digest
}