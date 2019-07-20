package models

import (
	"encoding/json"
	"os"
	"io/ioutil"
	"fmt"
)

type Schema struct{
	Name string
	Tables []Table
	Procedures []Procedure
	Packages []Package
	Functions []Function
	Views []View
	Description map[string]string
}




    func (this *Schema) GetProcedure(name string) *Procedure {
		for _, procedure := range this.Procedures {
			if procedure.Name == name{
				return &procedure
			}
		}
		return nil
	}
	
	func (this *Schema) GetFunction(name string) *Function {
		for _, function := range this.Functions {
			if function.Name == name{
				return &function
			}
		}
		return nil
	}
	
	func (this *Schema) GetTable(name string) *Table {
		for _, table := range this.Tables {
			if table.Name == name{
				return &table
			}
		}
		return nil
	}
	
	func (this *Schema) GetPackage(name string) *Package {
		for _, pkg := range this.Packages {
			if pkg.Name == name{
				return &pkg
			}
		}
		return nil
	}
	
	func (this *Schema) GetView(name string) *View {
		for _,view := range this.Views {
			if view.Name == name{
				return &view
			}
		}
		return nil
	}
	
	func (this *Schema) Compare(mashhadSchema Schema) []ChangeDescription{ //compare with new version
		var diffList []ChangeDescription
		//compare prc
		for _, mashhadPrc := range mashhadSchema.Procedures {
			prc := this.GetProcedure(mashhadPrc.Name)
			if prc != nil && mashhadPrc.GetDigest() == prc.GetDigest() {
				continue
			}
			//else
			diff := ChangeDescription{}
			diff.Brief = "PRC CREATE: " + mashhadPrc.Name
			diff.ChangeType = "create"
			diff.ObjectType = "procedure"
			diff.ObjectName = mashhadPrc.Name
			diff.ObjectID = mashhadPrc.ObjectID
			diff.AlterScript = mashhadPrc.SQLCode
			diffList = append(diffList, diff)
			if prc != nil {
				diff.ChangeType = "modify"
				diff.Brief = "PRC MODIFY: " + mashhadPrc.Name
			}
			
		}
		for _, currentVersionPrc := range this.Procedures {//drop old procedure
			prc := mashhadSchema.GetProcedure(currentVersionPrc.Name)
			if prc == nil {
				diff := ChangeDescription{}
				diff.Brief = "PRC DROP: "+ currentVersionPrc.Name
				diff.ChangeType = "drop"
				diff.ObjectType = "procedure"
				diff.ObjectName = currentVersionPrc.Name
				diff.ObjectID = currentVersionPrc.ObjectID
				diff.AlterScript = "Drop Procedure "+currentVersionPrc.Name + ";"
				diffList = append(diffList, diff)
			}
		}
		// //compare fnc
		for _, mashhadFnc := range mashhadSchema.Functions {
			fnc := this.GetFunction(mashhadFnc.Name)
			if fnc != nil && mashhadFnc.GetDigest() == fnc.GetDigest() {
				continue
			}
			//else
			diff := ChangeDescription{}
			diff.Brief = "FNC CREATE: " + mashhadFnc.Name
			diff.ChangeType = "create"
			diff.ObjectType = "function"
			diff.ObjectName = mashhadFnc.Name
			diff.ObjectID = mashhadFnc.ObjectID
			diff.AlterScript = mashhadFnc.SQLCode
			diffList = append(diffList, diff)
			if fnc != nil {
				diff.ChangeType = "modify"
				diff.Brief = "FNC MODIFY: " + mashhadFnc.Name
			}
			
		}
		for _, currentVersionFnc := range this.Functions {//drop old procedure
			prc := mashhadSchema.GetFunction(currentVersionFnc.Name)
			if prc == nil {
				diff := ChangeDescription{}
				diff.Brief = "FNC DROP: "+ currentVersionFnc.Name
				diff.ChangeType = "drop"
				diff.ObjectType = "function"
				diff.ObjectName = currentVersionFnc.Name
				diff.ObjectID = currentVersionFnc.ObjectID
				diff.AlterScript = "Drop Function "+currentVersionFnc.Name + ";"
				diffList = append(diffList, diff)
			}
		}
		//compare pkg
		for _, mashhadPkg := range mashhadSchema.Packages {
			pkg := this.GetPackage(mashhadPkg.Name)
			if pkg != nil && mashhadPkg.GetDigest() == pkg.GetDigest() {
				continue
			}
			//else
			diff := ChangeDescription{}
			diff.Brief = "PKG CREATE: " + mashhadPkg.Name
			diff.ChangeType = "create"
			diff.ObjectType = "package"
			diff.ObjectName = mashhadPkg.Name
			diff.ObjectID = mashhadPkg.ObjectID
			diff.AlterScript = mashhadPkg.Specification + "\n\n"+ mashhadPkg.SQLCode 
			diffList = append(diffList, diff)
			if pkg != nil {
				diff.ChangeType = "modify"
				diff.Brief = "PKG MODIFY: " + mashhadPkg.Name
			}
			
		}
		for _, currentVersionPkg := range this.Packages {//drop old procedure
			pkg := mashhadSchema.GetPackage(currentVersionPkg.Name)
			if pkg == nil {
				diff := ChangeDescription{}
				diff.Brief = "PKG DROP: "+ currentVersionPkg.Name // drop body and spec
				diff.ChangeType = "drop"
				diff.ObjectType = "package"
				diff.ObjectName = currentVersionPkg.Name
				diff.ObjectID = currentVersionPkg.ObjectID
				diff.AlterScript = "Drop Package "+currentVersionPkg.Name + ";"
				diffList = append(diffList, diff)
			}
		}
		//compare tbl
		for _, mashhadTbl := range mashhadSchema.Tables {
			tehranTbl := this.GetTable(mashhadTbl.Name)
			if tehranTbl == nil {//not found=> add new procedure
				diff := ChangeDescription{}
				diff.Brief = "TBL CREATE: "+ mashhadTbl.Name // drop body and spec
				diff.ChangeType = "create"
				diff.ObjectType = "table"
				diff.ObjectName = mashhadTbl.Name
				diff.ObjectID = mashhadTbl.ObjectID
				diff.AlterScript = "Create Table "+ mashhadTbl.Name + ";"//crete statement**********************************
				diffList = append(diffList, diff)
			}else {
				list, err := tehranTbl.Compare(&mashhadTbl)// call by reference for speed efficiency
				if err == nil {
					diffList = append(diffList, list...)
				}
			}
		}
		for _, currentVersionTbl := range this.Tables {//drop old view
			tbl := mashhadSchema.GetTable(currentVersionTbl.Name)
			if tbl == nil {
				diff := ChangeDescription{}
				diff.Brief = "TBL CREDROP: "+ currentVersionTbl.Name // drop body and spec
				diff.ChangeType = "drop"
				diff.ObjectType = "table"
				diff.ObjectName = currentVersionTbl.Name
				diff.ObjectID = currentVersionTbl.ObjectID
				diff.AlterScript = "Drop Table "+ currentVersionTbl.Name + ";"//crete statement
				diffList = append(diffList, diff)
			}
		}
		//compare nvw
		for _, mashhadNvw := range mashhadSchema.Views {
			nvw := this.GetFunction(mashhadNvw.Name)
			if nvw != nil && mashhadNvw.GetDigest() == nvw.GetDigest() {
				continue
			}
			//else
			diff := ChangeDescription{}
			diff.Brief = "NVW CREATE: " + mashhadNvw.Name
			diff.ChangeType = "create"
			diff.ObjectType = "view"
			diff.ObjectName = mashhadNvw.Name
			diff.ObjectID = mashhadNvw.ObjectID
			diff.AlterScript = "Create View " + mashhadNvw.Name + " As " + mashhadNvw.SQLCode + ";"
			diffList = append(diffList, diff)
			if nvw != nil {
				diff.ChangeType = "modify"
				diff.Brief = "NVW MODIFY: " + mashhadNvw.Name
				diff.AlterScript = "Drop View " + mashhadNvw.Name + "; " + diff.AlterScript
			}
		}
		
		for _, currentVersionNvw := range this.Views {//drop old procedure
			nvw := mashhadSchema.GetView(currentVersionNvw.Name)
			if nvw == nil {
				diff := ChangeDescription{}
				diff.Brief = "NVW DROP: "+ currentVersionNvw.Name
				diff.ChangeType = "drop"
				diff.ObjectType = "view"
				diff.ObjectName = currentVersionNvw.Name
				diff.ObjectID = currentVersionNvw.ObjectID
				diff.AlterScript = "Drop View "+ currentVersionNvw.Name + ";"
				diffList = append(diffList, diff)
			}
		}
		return diffList
	}
	
	func (this *Schema) ToJSONString() string{
		js, err := json.Marshal(this)
		if err != nil{
			return "-"
		}
		return string(js)
	}

	func FetchSchema(dbimage string) Schema {
			// Open our jsonFile
		jsonFile, err := os.Open(dbimage)
		var schema Schema
		// if we os.Open returns an error then handle it
		if err != nil {
			fmt.Println(err)
		}
		fmt.Println("Successfully Opened dbimage")
		// defer the closing of our jsonFile so that we can parse it later on
		defer jsonFile.Close()
		// read our opened xmlFile as a byte array.
		byteValue, _ := ioutil.ReadAll(jsonFile)

		// we initialize our Users array
		// we unmarshal our byteArray which contains our
		// jsonFile's content into 'users' which we defined above
		json.Unmarshal(byteValue, &schema)
		return schema
	}

	func (this *Schema) DeleteTable(tblName string){
		for i,tbl := range this.Tables{
			if tbl.Name == tblName {
				this.Tables[i] = this.Tables[len(this.Tables) - 1]
				this.Tables[len(this.Tables) - 1] = Table{}
				this.Tables = this.Tables[:len(this.Tables)-1]
			}
		}
	}