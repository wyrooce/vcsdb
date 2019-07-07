package models

import (
	"encoding/json"
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
					changeList = append(changeList, "PRC EDIT: " + prc.Name)
				}
			}
		}
		for _, currentVersionPrc := range this.Procedures {//drop old procedure
			prc := newVersion.GetProcedure(currentVersionPrc.Name)
			if prc == nil {
				changeList = append(changeList, "PRC DROP: "+ currentVersionPrc.Name)
			}
		}
		//compare fnc
		for _, newVersionFnc := range newVersion.Functions {
			fnc := this.GetFunction(newVersionFnc.Name)
			if fnc == nil {//not found=> add new procedure
				changeList = append(changeList, "PRC CREATE: " + newVersionFnc.Name)
			}else {
				if newVersionFnc.GetDigest() != fnc.GetDigest() {//exist but not equal
					changeList = append(changeList, "PRC EDIT: " + fnc.Name)
				}
			}
		}
		for _, currentVersionFnc := range this.Functions {//drop old function
			fnc := newVersion.GetFunction(currentVersionFnc.Name)
			if fnc == nil {
				changeList = append(changeList, "PRC DROP: "+ currentVersionFnc.Name)
			}
		}
		//compare pkg
		//compare tbl
		for _, newVersionTbl := range newVersion.Tables {
			tbl := this.GetView(newVersionTbl.Name)
			if tbl == nil {//not found=> add new procedure
				changeList = append(changeList, "TBL CREATE: " + newVersionTbl.Name)
			}else {
				// if newVersionTbl.GetDigest() != tbl.GetDigest() {//exist but not equal
				// 	changeList = append(changeList, "TBL EDIT: " + tbl.Name)
				// }
			}
		}
		for _, currentVersionNvw := range this.Functions {//drop old view
			tbl := newVersion.GetView(currentVersionNvw.Name)
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
		for _, currentVersionNvw := range this.Functions {//drop old view
			nvw := newVersion.GetView(currentVersionNvw.Name)
			if nvw == nil {
				changeList = append(changeList, "NVW DROP: "+ currentVersionNvw.Name)
			}
		}
		return nil
	}
	
	func (this *Schema) ToJSONString() string{
		js, err := json.Marshal(this)
		if err != nil{
			return "-"
		}
		return string(js)
	}


