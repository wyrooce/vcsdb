package models

type Column struct {
	Name string
	DataType string
	Default string
	Length string
	Nullable bool
	ID uint64
}

func (this *Column) Compare(mashhadCol Column) ([]string, error){
	var list []string
	if this.Name == mashhadCol.Name && this.ID != mashhadCol.ID {
		return nil, nil
	}
	if this.Name == mashhadCol.Name && this.ID != mashhadCol.ID {
		list = append(list, "COLUMN MODIFY: Rename "+this.Name + " TO " + mashhadCol.Name)
	}
	if this.DataType != mashhadCol.DataType {
		list = append(list, "COLUMN MODIFY: Typte change " + this.Name + " TO " + mashhadCol.DataType)
	}
	if this.Default != mashhadCol.Default {
		list = append(list, "COLUMN MODIFY: Default " + this.Name + " TO " + mashhadCol.Default)
	}
	if this.Nullable != mashhadCol.Nullable {
		nullable := "false"
		if mashhadCol.Nullable {
			nullable = "true"
		}
		list = append(list, "COLUMN MODIFY: Nullable " + this.Name + " TO " + nullable)
	}
	if this.Length != mashhadCol.Length {
		list = append(list, "COLUMN MODIFY: Length " + this.Name + " TO " + mashhadCol.Length)
	}
	return list, nil
}