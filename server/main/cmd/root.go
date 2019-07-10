package cmd

import (
  "fmt"
  "github.com/spf13/cobra"
  "os"
  "mym/vcs/server/main/models"

)

func Execute() {
  if err := rootCmd.Execute(); err != nil {
    fmt.Println(err)
    os.Exit(1)
  }
}

var mashhadSchemaFilePath string
func init(){
  // compareCmd.Flags().StringVarP(&mashhadSchemaFilePath, "source", "s", "", "Source file to read from")
  rootCmd.AddCommand(compareCmd, versionCmd, exportCmd)
}


var rootCmd = &cobra.Command{
  Use:   "vcs",
  Short: "Hugo is a very fast static site generator",
  Long: `A Fast and Flexible Static Site Generator built with
                love by spf13 and friends in Go.
                Complete documentation is available at http://hugo.spf13.com`,
  Run: func(cmd *cobra.Command, args []string) {
	// Do Stuff Here
  fmt.Println(`Available Command:
  - exp
  - cmp
  - version`)
  },
}

var compareCmd = &cobra.Command{
  Use:   "cmp",
  Short: "Compare two schema",
  Long: "salaam cmp command",
  Run: func(cmd *cobra.Command, args []string) {
    mashhadSchema := models.FetchSchema(args[0])	//file sent from Mashhad
    db := models.GetDB()
    var tehranSchema =  models.Schema{Name:os.Getenv("db_user")}

    tehranSchema.Views = models.FetchView(db)
    tehranSchema.Tables = models.FetchTable(db)
    tehranSchema.Procedures = models.FetchProcedure(db)
    tehranSchema.Functions = models.FetchFunction(db)
    tehranSchema.Packages = models.FetchPackage(db)

    list := tehranSchema.Compare(mashhadSchema)
    for _, change := range list{
      fmt.Println(change)
    }
    if len(list) == 0 {
      fmt.Println("No Different Found.")
    }

    
  },
}


var versionCmd = &cobra.Command{
  Use:   "version",
  Short: "Print the version number of TahlilVCSDB",
  Long:  ``,
  Run: func(cmd *cobra.Command, args []string) {
    fmt.Println("Tahlilgaran VCSDB Version 0.1.0")
  },
}

var exportCmd = &cobra.Command{
  Use:   "exp",
  Short: "export schema that registerd in .env",
  Long:  ``,
  Run: func(cmd *cobra.Command, args []string) {
      db := models.GetDB()
    	var tehranSchema =  models.Schema{Name:os.Getenv("db_user")}

      tehranSchema.Views = models.FetchView(db)
      tehranSchema.Tables = models.FetchTable(db)
      tehranSchema.Procedures = models.FetchProcedure(db)
      tehranSchema.Functions = models.FetchFunction(db)
      tehranSchema.Packages = models.FetchPackage(db)


      f, err := os.Create("dbimage_"+os.Getenv("db_user")+".json")
      if err != nil {
          fmt.Println(err)
          return
      }
      l, err := f.WriteString(tehranSchema.ToJSONString())
      if err != nil {
          fmt.Println(err)
          f.Close()
          return
      }
      fmt.Println(l, "bytes written successfully in", f.Name())

      err = f.Close()
      if err != nil {
          fmt.Println(err)
          return
    }
  },
}