package main

import (
	// "mym/vcs/server/main/models"
	"mym/vcs/server/main/cmd"
	"fmt"
	"github.com/joho/godotenv"
	// "os"
	// "time"
	// dif "github.com/yudai/gojsondiff"
	// tst "github.com/yudai/gojsondiff/tests"
)

func main() {

	//start := time.Now()
	
	e := godotenv.Load()
	if e != nil {
		fmt.Print(e)
	}
	
	
	cmd.Execute()

	// mashhadSchema := models.FetchSchema("dbimage_pragg.json")	//file sent from Mashhad
	// // tehranSchema := models.FetchSchema("dbimage_pragg.json")	//file sent from Mashhad
	// // schema.DeleteTable("TBL_LEDGER_BRANCH")
	// // mshdSchema.DeleteTable("TBL_LEDGER_BRANCH")

	// list := tehranSchema.Compare(mashhadSchema)

	// for _, change := range list{
	// 	fmt.Println(change)
	// }
	// if len(list) == 0 {
	// 	fmt.Println("No Different Found.")
	// }
	

}

