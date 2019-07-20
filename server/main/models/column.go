package models

type Column struct {
	Name string
	DataType string
	Default string
	Length string
	Nullable bool
	ID uint64
}

func (this *Column) Compare(mashhadCol Column, table *Table) ([]ChangeDescription, error){
	var list []ChangeDescription
	if this.Name == mashhadCol.Name && this.ID != mashhadCol.ID {
		return nil, nil
	}
	// if this.Name == mashhadCol.Name && this.ID != mashhadCol.ID {
	// 	list = append(list, "COLUMN MODIFY: Rename "+this.Name + " TO " + mashhadCol.Name)
	// }
	if this.DataType != mashhadCol.DataType {
		diff := ChangeDescription{}
		diff.ObjectType = "table"
		// diff.ObjectID = this.ObjectID//table
		diff.ObjectName = table.Name
		diff.ChangeType = "modify"
		diff.AlterScript = "Alter Table ..."
		diff.Brief = "COLUMN MODIFY[Type]: " + table.Name + "." +  this.Name + "--->" + mashhadCol.DataType
		list = append(list, diff)
	}
	if this.Default != mashhadCol.Default {
		diff := ChangeDescription{}
		diff.ObjectType = "table"
		// diff.ObjectID = this.ObjectID//table
		diff.ObjectName = table.Name
		diff.ChangeType = "modify"
		diff.AlterScript = "Alter Table ..."
		diff.Brief = "COLUMN MODIFY[Default]: " + table.Name + "." + this.Name + "--->" + mashhadCol.Default
		list = append(list, diff)
	}
	if this.Nullable != mashhadCol.Nullable {
		nullable := "false"
		if mashhadCol.Nullable {
			nullable = "true"
		}
		diff := ChangeDescription{}
		diff.ObjectType = "table"
		// diff.ObjectID = this.ObjectID//table
		diff.ObjectName = table.Name
		diff.ChangeType = "modify"
		diff.AlterScript = "Alter Table ..."
		diff.Brief = "COLUMN MODIFY[Nullable]: " + table.Name + "." +  this.Name + "--->" + nullable
		list = append(list, diff)
	}
	if this.Length != mashhadCol.Length {
		diff := ChangeDescription{}
		diff.ObjectType = "table"
		// diff.ObjectID = this.ObjectID//table
		diff.ObjectName = table.Name
		diff.ChangeType = "modify"
		diff.AlterScript = "Alter Table ..."
		diff.Brief = "COLUMN MODIFY[Length]: " + table.Name + "." +  this.Name + "--->" + mashhadCol.Length
		list = append(list, diff)
	}
	return list, nil
}