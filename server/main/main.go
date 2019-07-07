package main

import (
	"mym/VCSTahlil/server/main/models"
	"fmt"
	"github.com/joho/godotenv"
	"os"
	"time"
	// dif "github.com/yudai/gojsondiff"
	// tst "github.com/yudai/gojsondiff/tests"
)

func main() {

	start := time.Now()

	e := godotenv.Load()
	if e != nil {
		fmt.Print(e)
	}

	var schema =  models.Schema{Name:os.Getenv("db_user")}
	db := models.GetDB()
	schema.Procedures = models.FetchProcedure(db)
	schema.Functions = models.FetchFunction(db)
	schema.Tables = models.FetchTable(db)
	schema.Views = models.FetchView(db)
	schema.Packages = models.FetchPackage(db)
	


	f, err := os.Create("dbimage_"+os.Getenv("db_user")+".json")
    if err != nil {
        fmt.Println(err)
        return
    }
    l, err := f.WriteString(schema.ToJSONString())
    if err != nil {
        fmt.Println(err)
        f.Close()
        return
    }
    fmt.Println(l, "bytes written successfully")
    err = f.Close()
    if err != nil {
        fmt.Println(err)
        return
	}



	// fmt.Println(hash)
	fmt.Println(time.Now().Sub(start))
}

