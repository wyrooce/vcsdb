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
	Description string
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
	
	func (this *Schema) Compare(newVersion Schema) []string{ //compare with new version
		var changeList []string
		//compare prc
		for _, newVersionPrc := range newVersion.Procedures {
			prc := this.GetProcedure(newVersionPrc.Name)
			if prc == nil {//not found=> add new procedure
				changeList = append(changeList, "PRC CREATE: " + newVersionPrc.Name)
			}else {
				if newVersionPrc.GetDigest() != prc.GetDigest() {//exist but not equal
					changeList = append(changeList, "PRC MODIFY: " + prc.Name)
				}
			}
		}
		for _, currentVersionPrc := range this.Procedures {//drop old procedure
			prc := newVersion.GetProcedure(currentVersionPrc.Name)
			if prc == nil {
				changeList = append(changeList, "PRC DROP: "+ currentVersionPrc.Name)
			}
		}
		// //compare fnc
		for _, newVersionFnc := range newVersion.Functions {
			fnc := this.GetFunction(newVersionFnc.Name)
			if fnc == nil {//not found=> add new procedure
				changeList = append(changeList, "FNC CREATE: " + newVersionFnc.Name)
			}else {
				if newVersionFnc.GetDigest() != fnc.GetDigest() {//exist but not equal
					changeList = append(changeList, "FNC MODIFY: " + fnc.Name)
				}
			}
		}
		for _, currentVersionFnc := range this.Functions {//drop old function
			fnc := newVersion.GetFunction(currentVersionFnc.Name)
			if fnc == nil {
				changeList = append(changeList, "FNC DROP: "+ currentVersionFnc.Name)
			}
		}
		// //compare pkg
		// //compare tbl
		for _, newVersionTbl := range newVersion.Tables {
			tbl := this.GetTable(newVersionTbl.Name)
			if tbl == nil {//not found=> add new procedure
				changeList = append(changeList, "TBL CREATE: " + newVersionTbl.Name)
			}else {
				// if newVersionTbl.GetDigest() != tbl.GetDigest() {//exist but not equal
				// 	changeList = append(changeList, "TBL MODIFY: " + tbl.Name)
				// }
				list, err := newVersionTbl.Compare(tbl)
				if err == nil {
					changeList = append(changeList, list...)
				}
			}
		}
		for _, currentVersionNvw := range this.Tables {//drop old view
			tbl := newVersion.GetTable(currentVersionNvw.Name)
			if tbl == nil {
				changeList = append(changeList, "TBL DROP: "+ currentVersionNvw.Name)
			}
		}
		//compare nvw
		for _, newVersionNvw := range newVersion.Views {
			nvw := this.GetView(newVersionNvw.Name)
			if nvw == nil {//not found=> add new procedure
				changeList = append(changeList, "NVW CREATE: " + newVersionNvw.Name)
			}else {
				if newVersionNvw.GetDigest() != nvw.GetDigest() {//exist but not equal
					changeList = append(changeList, "NVW EDIT: " + nvw.Name)
				}
			}
		}
		for _, currentVersionNvw := range this.Views {//drop old view
			nvw := newVersion.GetView(currentVersionNvw.Name)
			if nvw == nil {
				changeList = append(changeList, "NVW DROP: "+ currentVersionNvw.Name)
			}
		}
		return changeList
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