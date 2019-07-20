package cmd

import (
  "fmt"
  "github.com/spf13/cobra"
  "os"
  "mym/vcs/server/main/models"

  ptime "github.com/yaa110/go-persian-calendar"
)

func Execute() {
  if err := rootCmd.Execute(); err != nil {
    fmt.Println(err)
    os.Exit(1)
  }
}

var version bool
var output string
var mashhadSchemaFilePath string
func init(){
  // compareCmd.Flags().StringVarP(&mashhadSchemaFilePath, "source", "s", "", "Source file to read from")
  rootCmd.PersistentFlags().BoolVarP(&version, "version", "v", false, "version of current app")
  compareCmd.PersistentFlags().StringVarP(&output, "output", "o", "", "output file of comparison alert commands")
  rootCmd.AddCommand(compareCmd, exportCmd, docCmd)
}


var rootCmd = &cobra.Command{
  Use:   "vcs",
  Short: "Hugo is a very fast static site generator",
  Long: `A Fast and Flexible Static Site Generator built with
                love by spf13 and friends in Go.
                Complete documentation is available at http://hugo.spf13.com`,
  Run: func(cmd *cobra.Command, args []string) {
  // Do Stuff Here
  if version {
    fmt.Println("Tahlilgaran VCSDB Version 0.1.0")
  }else {
  fmt.Println(`Available Command:
  - exp
  - cmp
  - version`)
  }
  },
}


//flag for alert file
var docCmd = &cobra.Command{
  Use:   "doc",
  Short: "",
  Long: ``,
  Run: func(cmd *cobra.Command, args []string) {
    fmt.Println("Complete documentation is available at https://gitlab.partdp.ir/vcsdbhelp\nOr use this command: ./vcs --help")
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
      fmt.Println(change.Brief)
    }
    if len(list) == 0 {
      fmt.Println("No Different Found.")
      return
    }
    if output != ""{
      fmt.Println(output)

      f, err := os.Create(output)
      if err != nil {
          fmt.Println(err)
          return
      }
      for _, v := range list {
      _, err := f.WriteString(string(v.AlterScript+"\n"))
      if err != nil {
          fmt.Println(err)
          f.Close()
          return
      }
    }
      err = f.Close()
      if err != nil {
          fmt.Println(err)
          return
    }
    }

    
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

      des := map[string]string{"ExportedAt": ptime.Now(ptime.Iran()).String()}
      tehranSchema.Description = des

      f, err := os.Create(os.Getenv("db_user")+".dbimage")
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