package main

import (
	"mym/vcs/server/main/models"
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
	// schema.Procedures = models.FetchProcedure(db)
	schema.Views = models.FetchView(db)
	schema.Tables = models.FetchTable(db)
	schema.Procedures = models.FetchProcedure(db)
	schema.Functions = models.FetchFunction(db)
	otherSchema := models.FetchSchema("dbimage_pragg.json")	//file sent from Mashhad
	//fmt.Println(otherSchema.GetProcedure("PRC_REPORT_VALUE").SQLCode)
	list := schema.Compare(otherSchema)

	for _, change := range list{
		fmt.Println(change)
	}
	if len(list) == 0 {
		fmt.Println("No Different Found.")
	}


	// f, err := os.Create("dbimage_"+os.Getenv("db_user")+".json")
    // if err != nil {
    //     fmt.Println(err)
    //     return
    // }
    // l, err := f.WriteString(schema.ToJSONString())
    // if err != nil {
    //     fmt.Println(err)
    //     f.Close()
    //     return
    // }
    // fmt.Println(l, "bytes written successfully")
    // err = f.Close()
    // if err != nil {
    //     fmt.Println(err)
    //     return
	// }


	
	// fmt.Println(hash)
	fmt.Println(time.Now().Sub(start))
}

