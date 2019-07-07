package models

type Column struct {
	Name string
	DataType string
	Default string
	Length string
	Nullable bool
	ID uint64
}

func (this *Column) Compare(other Column) ([]string, error){
	var list []string
	if this.Name == other.Name && this.ID != other.ID {
		return nil, nil
	}
	if this.Name == other.Name && this.ID != other.ID {
		list = append(list, "MODIFY: Rename "+this.Name + " TO " + other.Name)
	}
	if this.DataType != other.DataType {
		list = append(list, "MODIFY: Typte change " + this.Name + " TO " + other.DataType)
	}
	if this.Default != other.Default {
		list = append(list, "MODIFY: Default " + this.Name + " TO " + other.Default)
	}
	if this.Nullable != other.Nullable {
		nullable := "false"
		if other.Nullable {
			nullable = "true"
		}
		list = append(list, "MODIFY: Nullable " + this.Name + " TO " + nullable)
	}
	if this.Length != other.Length {
		list = append(list, "MODIFY: Length " + this.Name + " TO " + other.Length)
	}
	return list, nil
}