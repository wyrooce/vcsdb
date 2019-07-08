package models

type ChangeDescription struct{
	ChangeType string // create, drop, modify
	ObjectType string //table, column, procedure, ...
	ObjectName string //tbl_report_value
	ObjectID uint64 //12354
	AlterQuery string // alter table tbl_arz add column id varchar2(100)
}