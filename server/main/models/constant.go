package models

const FUNCTION_QUERY = "WITH tmp AS\n" +
            "  ( SELECT DISTINCT NAME, TYPE FROM user_source WHERE TYPE = 'FUNCTION')\n" +
            "SELECT t.NAME, dbms_metadata.get_ddl(t.TYPE, t.NAME) code, o.object_id \n" +
            "FROM tmp t,\n" +
            "  user_objects o\n" +
            "WHERE t.NAME = o.object_name\n" +
			"ORDER BY o.created"
			
const PACKAGE_QUERY = "WITH tmp AS\n" +
            "  ( SELECT DISTINCT NAME, TYPE FROM user_source WHERE TYPE = 'PACKAGE')\n" +
            "SELECT t.NAME, dbms_metadata.get_ddl('PACKAGE', t.NAME) BODY, dbms_metadata.get_ddl('PACKAGE_SPEC', name) SPEC, o.object_id\n" +
            "FROM tmp t,\n" +
            "  user_objects o\n" +
            "WHERE t.NAME = o.object_name\n" +
			"ORDER BY o.created"

const PROCEDURE_QUERY = "WITH tmp AS\n" +
            "  ( SELECT DISTINCT NAME, TYPE FROM user_source WHERE TYPE = 'PROCEDURE')\n" +
            "SELECT t.NAME, dbms_metadata.get_ddl(t.TYPE, t.NAME) code, o.object_id \n" +
            "FROM tmp t,\n" +
            "  user_objects o\n" +
            "WHERE t.NAME = o.object_name\n" +
            "ORDER BY o.created"

const TABLE_PROPERTY_QUERY = "SELECT table_name, column_name, data_type, data_length, nullable, data_default, column_id, o.object_id\n" +
            "FROM dba_tab_columns, user_objects o\n" +
            "WHERE owner       = USER\n" +
            "AND o.object_name = table_name\n" +
            "AND table_name   IN\n" +
            "  (SELECT object_name\n" +
            "  FROM dba_objects\n" +
            "  WHERE owner     = USER\n" +
            "  AND object_type = 'TABLE'\n" +
            "  )\n" +
            "ORDER BY o.created"

const VIEW_PROPERTY_QUERY = "SELECT t.view_name, t.text, o.object_id\n" +
                    "FROM user_views t, user_objects o\n" +
                    "WHERE t.view_name = o.object_name\n" +
                    "ORDER BY o.created"