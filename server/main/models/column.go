package models

type Column struct {
	Name string
	DataType string
	Default string
	Length string
	Nullable bool
	ID uint64
}

func (this *Column) Compare(mashhadCol Column, tableName string) ([]string, error){
	var list []string
	if this.Name == mashhadCol.Name && this.ID != mashhadCol.ID {
		return nil, nil
	}
	// if this.Name == mashhadCol.Name && this.ID != mashhadCol.ID {
	// 	list = append(list, "COLUMN MODIFY: Rename "+this.Name + " TO " + mashhadCol.Name)
	// }
	if this.DataType != mashhadCol.DataType {
		list = append(list, "COLUMN MODIFY[Type]: " + tableName + "." +  this.Name + "--->" + mashhadCol.DataType)
	}
	if this.Default != mashhadCol.Default {
		list = append(list, "COLUMN MODIFY[Default]: " + tableName + "." + this.Name + "--->" + mashhadCol.Default)
	}
	if this.Nullable != mashhadCol.Nullable {
		nullable := "false"
		if mashhadCol.Nullable {
			nullable = "true"
		}
		list = append(list, "COLUMN MODIFY[Nullable]: " + tableName + "." +  this.Name + "--->" + nullable)
	}
	if this.Length != mashhadCol.Length {
		list = append(list, "COLUMN MODIFY[Length]: " + tableName + "." +  this.Name + "--->" + mashhadCol.Length)
	}
	return list, nil
}