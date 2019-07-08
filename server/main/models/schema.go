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
	
	func (this *Schema) Compare(mshdSchema Schema) []string{ //compare with new version
		var changeList []string
		//compare prc
		for _, mshdPrc := range mshdSchema.Procedures {
			prc := this.GetProcedure(mshdPrc.Name)
			if prc == nil {//not found=> add new procedure
				changeList = append(changeList, "PRC CREATE: " + mshdPrc.Name)
			}else {
				if mshdPrc.GetDigest() != prc.GetDigest() {//exist but not equal
					changeList = append(changeList, "PRC MODIFY: " + prc.Name)
				}
			}
		}
		for _, currentVersionPrc := range this.Procedures {//drop old procedure
			prc := mshdSchema.GetProcedure(currentVersionPrc.Name)
			if prc == nil {
				changeList = append(changeList, "PRC DROP: "+ currentVersionPrc.Name)
			}
		}
		// //compare fnc
		for _, newVersionFnc := range mshdSchema.Functions {
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
			fnc := mshdSchema.GetFunction(currentVersionFnc.Name)
			if fnc == nil {
				changeList = append(changeList, "FNC DROP: "+ currentVersionFnc.Name)
			}
		}
		//compare pkg
		//compare tbl
		for _, mshdTbl := range mshdSchema.Tables {
			tehranTbl := this.GetTable(mshdTbl.Name)
			if tehranTbl == nil {//not found=> add new procedure
				changeList = append(changeList, "TBL CREATE: " + mshdTbl.Name)
			}else {
				list, err := tehranTbl.Compare(&mshdTbl)// call by reference for speed efficiency
				if err == nil {
					changeList = append(changeList, list...)
				}
			}
		}
		for _, currentVersionTbl := range this.Tables {//drop old view
			tbl := mshdSchema.GetTable(currentVersionTbl.Name)
			if tbl == nil {
				changeList = append(changeList, "TBL DROP: "+ currentVersionTbl.Name)
			}
		}
		//compare nvw
		for _, newVersionNvw := range mshdSchema.Views {
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
			nvw := mshdSchema.GetView(currentVersionNvw.Name)
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

	func (this *Schema) DeleteTable(tblName string){
		for i,tbl := range this.Tables{
			if tbl.Name == tblName {
				this.Tables[i] = this.Tables[len(this.Tables) - 1]
				this.Tables[len(this.Tables) - 1] = Table{}
				this.Tables = this.Tables[:len(this.Tables)-1]
			}
		}
	}