package main

import (
	"mym/vcs/server/main/models"
	"mym/vcs/server/main/cmd"
	"fmt"
	"github.com/joho/godotenv"
	"os"
	"time"
	// dif "github.com/yudai/gojsondiff"
	// tst "github.com/yudai/gojsondiff/tests"
)

func main() {

	start := time.Now()
	cmd.Execute()

	e := godotenv.Load()
	if e != nil {
		fmt.Print(e)
	}

	var tehranSchema =  models.Schema{Name:os.Getenv("db_user")}
	
	db := models.GetDB()
	tehranSchema.Views = models.FetchView(db)
	tehranSchema.Tables = models.FetchTable(db)
	tehranSchema.Procedures = models.FetchProcedure(db)
	tehranSchema.Functions = models.FetchFunction(db)
	tehranSchema.Packages = models.FetchPackage(db)
	

	mashhadSchema := models.FetchSchema("dbimage_pragg.json")	//file sent from Mashhad
	// tehranSchema := models.FetchSchema("dbimage_pragg.json")	//file sent from Mashhad
	// schema.DeleteTable("TBL_LEDGER_BRANCH")
	// mshdSchema.DeleteTable("TBL_LEDGER_BRANCH")

	list := tehranSchema.Compare(mashhadSchema)

	for _, change := range list{
		fmt.Println(change)
	}
	if len(list) == 0 {
		fmt.Println("No Different Found.")
	}
	

		
	// fmt.Println(string(js))

	// f, err := os.Create("dbimage_"+os.Getenv("db_user")+".json")
    // if err != nil {
    //     fmt.Println(err)
    //     return
    // }
    // l, err := f.WriteString(tehranSchema.ToJSONString())
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
		
	
	fmt.Println("Duration:", time.Now().Sub(start))
}

