/******************************************************************************

		Copyright (c) 1984 - 1998 Prolog Development Center A/S

 Project:	ODBCLAB
 FileName:	DLG.PRO
 Purpose:	Dialogs tools
 Written by:	Sergey Alexeev
 Build:		005.970916
 Comments:
******************************************************************************/
database - dialog_db
  determ connect_str(STRING BaseNameInit,STRING UserIdInit,STRING PasswordInit)
  determ info_list(SLIST ListOfInfo,INTEGER Pos)
  determ func_list(SLIST ListOfFunc,INTEGER Pos)
  determ prepare_str(STRING ExecStr)
  determ column_num(INTEGER Column)
  determ freestmt_opt(INTEGER Option)
  determ extendedfetch_opt(INTEGER Direction)
  determ datasources_init(INTEGER Direction)
  determ datatype_init(INTEGER Type)
  determ colattr_init(INTEGER Attrib)
  determ catalog_init(STRING QualifierInit,STRING OwnerInit,STRING NamesInit,
  	STRING TypesInit,STRING ColumnNamesInit,STRING FkQualifierInit,STRING FkOwnerInit,STRING FkNamesInit)
  determ setpos_init(INTEGER OptionInit,INTEGER LockInit,INTEGER RowInit)
  determ scrollopt_init(INTEGER ConcurrencyInit,STRING CrowKeysetInit,INTEGER CrowRowsetInit)
  determ stmtopt_init(INTEGER OptionInit,STRING ParamInit)
  determ transact_init(INTEGER TypeInit)
  determ cursor_str(STRING ExecStr)
  determ procedure_init(STRING ProcQualifierInit,STRING ProcOwnerInit,
	STRING ProcNamesInit,STRING ColumnNamesInit)
  determ special_init(UNSIGNED ColTypeInit,UNSIGNED ScopeInit,UNSIGNED NullableInit)
  determ statistics_init(UNSIGNED UniqueInit,UNSIGNED AccuracyInit)
  determ connectopt_init(UNSIGNED OptionInit,STRING ParamInit)
  determ drvcon_init(STRING ConnStrInInit,UNSIGNED DriverCompletionInit)
  determ param_init(INTEGER IparInit,INTEGER ParamTypeInit,LONG ColDefInit,
  	INTEGER IbScaleInit)
  determ busize_init(INTEGER BuffInit)
  determ paramoptions_num(LONG CrowInit)
predicates
  consult_base()
  save_base()
clauses
  save_base():-
	trap(deletefile("ODBCLAB.DBA"),_,fail),
	trap(save("ODBCLAB.DBA",dialog_db),_,fail),!.
  save_base():-
	trap(save("ODBCLAB.DBA",dialog_db),_,fail),!.
  save_base().

  consult_base():-
	trap(consult("ODBCLAB.DBA",dialog_db),_,fail),!.
  consult_base():-
	assert(connect_str("","","")),
	assert(info_list(["odbc_active_connections","odbc_active_statements",
"odbc_data_source_name","odbc_driver_hdbc","odbc_driver_henv","odbc_driver_hlib","odbc_driver_hstmt",
"odbc_driver_name","odbc_driver_odbc_ver","odbc_driver_ver","odbc_fetch_direction","odbc_file_usage",
"odbc_getdata_extensions","odbc_lock_types","odbc_odbc_api_conformance","odbc_odbc_sag_cli_conformance",
"odbc_odbc_ver","odbc_pos_operations","odbc_row_updates","odbc_search_pattern_escape",
"odbc_server_name","odbc_database_name","odbc_dbms_name","odbc_dbms_ver","odbc_accessible_procedures",
"odbc_accessible_tables","odbc_bookmark_persistence","odbc_concat_null_behavior","odbc_cursor_commit_behavior",
"odbc_cursor_rollback_behavior","odbc_data_source_read_only","odbc_default_txn_isolation",
"odbc_mult_result_sets","odbc_multiple_active_txn","odbc_need_long_data_len","odbc_null_collation",
"odbc_owner_term","odbc_procedure_term","odbc_qualifier_term","odbc_scroll_concurrency",
"odbc_scroll_options","odbc_static_sensitivity","odbc_table_term","odbc_txn_capable",
"odbc_txn_isolation_option","odbc_user_name","odbc_alter_table","odbc_column_alias",
"odbc_correlation_name","odbc_expressions_in_orderby","odbc_group_by","odbc_identifier_case",
"odbc_identifier_quote_char","odbc_keywords","odbc_like_escape_clause","odbc_non_nullable_columns",
"odbc_odbc_sql_conformance","odbc_odbc_sql_opt_ief","odbc_order_by_columns_in_select",
"odbc_outer_joins","odbc_owner_usage","odbc_positioned_statements","odbc_procedures",
"odbc_qualifier_location","odbc_qualifier_name_separator","odbc_qualifier_usage","odbc_quoted_identifier_case",
"odbc_special_characters","odbc_subqueries","odbc_union","odbc_max_binary_literal_len",
"odbc_max_char_literal_len","odbc_max_column_name_len","odbc_max_columns_in_group_by",
"odbc_max_columns_in_order_by","odbc_max_columns_in_index","odbc_max_columns_in_select",
"odbc_max_columns_in_table","odbc_max_cursor_name_len","odbc_max_index_size",
"odbc_max_owner_name_len","odbc_max_procedure_name_len","odbc_max_qualifier_name_len",
"odbc_max_row_size","odbc_max_row_size_includes_long","odbc_max_statement_len",
"odbc_max_table_name_len","odbc_max_tables_in_select","odbc_max_user_name_len",
"odbc_convert_functions","odbc_numeric_functions","odbc_string_functions","odbc_system_functions",
"odbc_timedate_add_intervals","odbc_timedate_diff_intervals","odbc_timedate_functions",
"odbc_convert_bigint","odbc_convert_binary","odbc_convert_bit","odbc_convert_char",
"odbc_convert_date","odbc_convert_decimal","odbc_convert_double","odbc_convert_float","odbc_convert_integer",
"odbc_convert_longvarbinary","odbc_convert_longvarchar","odbc_convert_numeric",
"odbc_convert_real","odbc_convert_smallint","odbc_convert_time","odbc_convert_timestamp",
"odbc_convert_tinyint","odbc_convert_varbinary","odbc_convert_varchar"],0)),
	assert(func_list(["odbc_api_sqlallocconnect","odbc_api_sqlallocenv",
"odbc_api_sqlallocstmt","odbc_api_sqlbindcol","odbc_api_sqlcancel","odbc_api_sqlcolattributes",
"odbc_api_sqlconnect","odbc_api_sqldescribecol","odbc_api_sqldisconnect","odbc_api_sqlerror",
"odbc_api_sqlexecdirect","odbc_api_sqlexecute","odbc_api_sqlfetch","odbc_api_sqlfreeconnect",
"odbc_api_sqlfreeenv","odbc_api_sqlfreestmt","odbc_api_sqlgetcursorname",
"odbc_api_sqlnumresultcols","odbc_api_sqlprepare","odbc_api_sqlrowcount",
"odbc_api_sqlsetcursorname","odbc_api_sqlsetparam","odbc_api_sqltransact",
"odbc_api_sqlbindparameter","odbc_api_sqlcolumns","odbc_api_sqldriverconnect",
"odbc_api_sqlgetconnectoption","odbc_api_sqlgetdata","odbc_api_sqlgetfunctions",
"odbc_api_sqlgetinfo","odbc_api_sqlgetstmtoption","odbc_api_sqlgettypeinfo",
"odbc_api_sqlparamdata","odbc_api_sqlputdata","odbc_api_sqlsetconnectoption",
"odbc_api_sqlsetstmtoption","odbc_api_sqlspecialcolumns","odbc_api_sqlstatistics",
"odbc_api_sqltables","odbc_api_sqlbrowseconnect","odbc_api_sqlcolumnprivileges",
"odbc_api_sqldatasources","odbc_api_sqldescribeparam","odbc_api_sqldrivers",
"odbc_api_sqlextendedfetch","odbc_api_sqlforeignkeys","odbc_api_sqlmoreresults",
"odbc_api_sqlnativesql","odbc_api_sqlnumparams","odbc_api_sqlparamoptions",
"odbc_api_sqlprimarykeys","odbc_api_sqlprocedurecolumns","odbc_api_sqlprocedures",
"odbc_api_sqlsetpos","odbc_api_sqlsetscrolloptions","odbc_api_sqltableprivileges"],0)),
	assert(prepare_str("")),
	assert(column_num(1)),
	assert(freestmt_opt(0)),
	assert(extendedfetch_opt(0)),
	assert(datasources_init(0)),
	assert(datatype_init(0)),
	assert(colattr_init(0)),
	assert(catalog_init("","","","","","","","")),
	assert(setpos_init(0,0,0)),
	assert(scrollopt_init(0,"",0)),
	assert(stmtopt_init(0,"")),
	assert(transact_init(0)),
	assert(cursor_str("")),
	assert(procedure_init("","","","")),
	assert(special_init(0,0,0)),
	assert(statistics_init(0,0)),
	assert(connectopt_init(0,"")),
	assert(drvcon_init("",0)),
	assert(param_init(1,0,0,0)),
	assert(busize_init(256)),
	assert(paramoptions_num(0)),!.
/***************************************************************************
			dialog_move
***************************************************************************/
predicates
  dialog_move(WINDOW DlgWin)
clauses
  dialog_move(DlgWin):-
	RCT = win_GetClientRect(DlgWin),
	RCT = rct(_,_,R1,B1),
	Width = vpi_GetAttrVal(attr_screen_width),
	LR = (Width - R1) * 0.5,
	RR = LR + R1,
	Height = vpi_GetAttrVal(attr_screen_height),
	HeightTit = vpi_GetAttrVal(attr_title_height),
	TR = (Height - B1 - HeightTit) * 0.5,
	BR = TR + B1 + HeightTit,
	L = val(integer,LR),
	T = val(integer,TR),
	R = val(integer,RR),
	B = val(integer,BR),
	win_Move(DlgWin,rct(L,T,R,B)).

predicates
  dialog_eh	: EHANDLER
clauses
  dialog_eh(DlgWin,e_Create(_),0):-
	dialog_move(DlgWin),!.

/***************************************************************************
			dialog_connect
***************************************************************************/
predicates
  dialog_connect(WINDOW ParentWin,STRING BaseName,STRING UserId,STRING Password)
clauses
  dialog_connect(ParentWin,BaseName,UserId,Password):-
	connect_str(BaseNameInit,UserIdInit,PasswordInit),
	dialog_Create(ParentWin,[resdlg(idd_connect,wd_Modal)],
  		[
		df(idc_connect_1,editstr(BaseNameInit,[]),nopr),
		df(idc_connect_2,editstr(UserIdInit,[]),nopr),
		df(idc_connect_3,editstr(PasswordInit,[]),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	BaseName = dialog_VLGetStr(idc_connect_1,Vallist),
	UserId = dialog_VLGetStr(idc_connect_2,Vallist),
	Password = dialog_VLGetStr(idc_connect_3,Vallist),
	retract(connect_str(_,_,_)),
	assert(connect_str(BaseName,UserId,Password)),!.

/***************************************************************************
			dialog_datasources
***************************************************************************/
predicates
  dialog_datasources(WINDOW ParentWin,INTEGER Id)
clauses
  dialog_datasources(ParentWin,Id):-
	datasources_init(Init),
	dialog_Create(ParentWin,[resdlg(idd_datasources,wd_Modal)],
  		[
		df(idc_datasources_1,listbutton(["odbc_fetch_first","odbc_fetch_next"],Init),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	dialog_VLGetListButton(idc_datasources_1,Vallist,_,Id1),
	Id = Id1 + 1,
	retract(datasources_init(_)),
	assert(datasources_init(Id1)),!.

/***************************************************************************
			dialog_drivers
***************************************************************************/
predicates
  dialog_drivers(WINDOW ParentWin,INTEGER Id)
clauses
  dialog_drivers(ParentWin,Id):-
	datasources_init(Init),
	dialog_Create(ParentWin,[resdlg(idd_drivers,wd_Modal)],
  		[
		df(idc_drivers_1,listbutton(["odbc_fetch_first","odbc_fetch_next"],Init),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	dialog_VLGetListButton(idc_drivers_1,Vallist,_,Id1),
	Id = Id1 + 1,
	retract(datasources_init(_)),
	assert(datasources_init(Id1)),!.

/***************************************************************************
			dialog_getinfo
***************************************************************************/
predicates
  dialog_getinfo(WINDOW ParentWin,STRING Title,INTEGER Id)
clauses
  dialog_getinfo(ParentWin,Title,Id):-
	info_list(List,Init),
	dialog_Create(ParentWin,[resdlg(idd_getinfo,wd_Modal)],
  		[
		df(idc_getinfo_1,listbutton(List,Init),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	dialog_VLGetListButton(idc_getinfo_1,Vallist,Title,Id1),
	Id = Id1 + 1,
	retract(info_list(_,_)),
	assert(info_list(List,Id1)),!.

/***************************************************************************
			dialog_prepare
***************************************************************************/
predicates
  dialog_prepare(WINDOW ParentWin,STRING Str)
clauses
  dialog_prepare(ParentWin,Str):-
	prepare_str(InitStr),
	dialog_Create(ParentWin,[resdlg(idd_prepare,wd_Modal)],
  		[
		df(idc_prepare_1,editstr(InitStr,[]),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	Str = dialog_VLGetStr(idc_prepare_1,Vallist),
	retract(prepare_str(_)),
	assert(prepare_str(Str)),!.

/***************************************************************************
			dialog_nativesql
***************************************************************************/
predicates
  dialog_nativesql(WINDOW ParentWin,STRING Str)
clauses
  dialog_nativesql(ParentWin,Str):-
	prepare_str(InitStr),
	dialog_Create(ParentWin,[resdlg(idd_nativesql,wd_Modal)],
  		[
		df(idc_nativesql_1,editstr(InitStr,[]),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	Str = dialog_VLGetStr(idc_nativesql_1,Vallist),
	retract(prepare_str(_)),
	assert(prepare_str(Str)),!.

/***************************************************************************
			dialog_setcursorname
***************************************************************************/
predicates
  dialog_setcursorname(WINDOW ParentWin,STRING Str)
clauses
  dialog_setcursorname(ParentWin,Str):-
	cursor_str(InitStr),
	dialog_Create(ParentWin,[resdlg(idd_setcursorname,wd_Modal)],
  		[
		df(idc_setcursorname_1,editstr(InitStr,[]),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	Str = dialog_VLGetStr(idc_setcursorname_1,Vallist),
	retract(cursor_str(_)),
	assert(cursor_str(Str)),!.

/***************************************************************************
			dialog_getdata
***************************************************************************/
predicates
  dialog_getdata(WINDOW ParentWin,INTEGER Column,INTEGER Type,UNSIGNED Size)
clauses
  dialog_getdata(ParentWin,Column,Type,Size):-
	column_num(InitColumn),
	str_int(InitColumn1,InitColumn),
	datatype_init(Init),
	busize_init(BuffInit),
	str_int(BuffInit1,BuffInit),
	dialog_Create(ParentWin,[resdlg(idd_getdata,wd_Modal)],
  		[
		df(idc_getdata_1,listbutton(["odbc_string","odbc_bit","odbc_byte","odbc_integer",
			"odbc_float","odbc_long","odbc_real","odbc_date","odbc_time","odbc_timestamp",
			"odbc_binary","odbc_numeric","odbc_memo"],Init),nopr),
		df(idc_getdata_2,editstr(InitColumn1,[]),nopr),
		df(idc_getdata_3,editstr(BuffInit1,[]),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	dialog_VLGetListButton(idc_getdata_1,Vallist,_,Type1),
	Type = Type1 + 1,
	Column1 = dialog_VLGetStr(idc_getdata_2,Vallist),
	str_int(Column1,Column),
	Size1 = dialog_VLGetStr(idc_getdata_3,Vallist),
	str_int(Size1,Size),
	retract(column_num(_)),
	assert(column_num(Column)),
	retract(datatype_init(_)),
	assert(datatype_init(Type1)),
	retract(busize_init(_)),
	assert(busize_init(Size)),!.

/***************************************************************************
			dialog_gettypeinfo
***************************************************************************/
predicates
  dialog_gettypeinfo(WINDOW ParentWin,INTEGER Type)
clauses
  dialog_gettypeinfo(ParentWin,Type):-
	datatype_init(Init),
	dialog_Create(ParentWin,[resdlg(idd_gettypeinfo,wd_Modal)],
  		[
		df(idc_gettypeinfo_1,listbutton(["odbc_string","odbc_bit","odbc_byte","odbc_integer",
			"odbc_float","odbc_long","odbc_real","odbc_date","odbc_time","odbc_timestamp",
				"odbc_binary","odbc_numeric","odbc_memo"],Init),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	dialog_VLGetListButton(idc_gettypeinfo_1,Vallist,_,Type1),
	Type = Type1 + 1,
	retract(datatype_init(_)),
	assert(datatype_init(Type1)),!.

/***************************************************************************
			dialog_colattributes
***************************************************************************/
predicates
  dialog_colattributes(WINDOW ParentWin,INTEGER Column,INTEGER Id)
clauses
  dialog_colattributes(ParentWin,Column,Id):-
	column_num(InitColumn),
	str_int(InitColumn1,InitColumn),
	colattr_init(Init),
	dialog_Create(ParentWin,[resdlg(idd_colattributes,wd_Modal)],
  		[
		df(idc_colattributes_1,listbutton(["odbc_column_auto_increment",
"odbc_column_case_sensitive","odbc_column_count","odbc_column_display_size","odbc_column_label",
"odbc_column_length","odbc_column_money","odbc_column_name","odbc_column_nullable",
"odbc_column_owner_name","odbc_column_precision","odbc_column_qualifier_name",
"odbc_column_scale","odbc_column_searchable","odbc_column_table_name","odbc_column_type",
"odbc_column_type_name","odbc_column_unsigned","odbc_column_updatable"],Init),nopr),
		df(idc_colattributes_2,editstr(InitColumn1,[]),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	dialog_VLGetListButton(idc_colattributes_1,Vallist,_,Id1),
	Id = Id1 + 1,
	Column1 = dialog_VLGetStr(idc_colattributes_2,Vallist),
	str_int(Column1,Column),
	retract(column_num(_)),
	assert(column_num(Column)),
	retract(colattr_init(_)),
	assert(colattr_init(Id1)),!.

/***************************************************************************
			dialog_foreignkeys
***************************************************************************/
predicates
  dialog_foreignkeys(WINDOW ParentWin,STRING Qualifier,STRING Owner,STRING Names,
	STRING FkQualifier,STRING FkOwner,STRING FkNames)
clauses
  dialog_foreignkeys(ParentWin,Qualifier,Owner,Names,FkQualifier,FkOwner,FkNames):-
	catalog_init(QualifierInit,OwnerInit,NamesInit,TypesInit,ColumnNamesInit,FkQualifierInit,FkOwnerInit,FkNamesInit),
	dialog_Create(ParentWin,[resdlg(idd_foreignkeys,wd_Modal)],
  		[
		df(idc_foreignkeys_1,listedit([QualifierInit,"NULL_STRING","%"],QualifierInit),nopr),
		df(idc_foreignkeys_2,listedit([OwnerInit,"NULL_STRING","%"],OwnerInit),nopr),
		df(idc_foreignkeys_3,listedit([NamesInit,"NULL_STRING","%"],NamesInit),nopr),
		df(idc_foreignkeys_4,listedit([FkQualifierInit,"NULL_STRING","%"],FkQualifierInit),nopr),
		df(idc_foreignkeys_5,listedit([FkOwnerInit,"NULL_STRING","%"],FkOwnerInit),nopr),
		df(idc_foreignkeys_6,listedit([FkNamesInit,"NULL_STRING","%"],FkNamesInit),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	Qualifier = dialog_VLGetListEdit(idc_foreignkeys_1,Vallist),
	Owner = dialog_VLGetListEdit(idc_foreignkeys_2,Vallist),
	Names = dialog_VLGetListEdit(idc_foreignkeys_3,Vallist),
	FkQualifier = dialog_VLGetListEdit(idc_foreignkeys_4,Vallist),
	FkOwner = dialog_VLGetListEdit(idc_foreignkeys_5,Vallist),
	FkNames = dialog_VLGetListEdit(idc_foreignkeys_6,Vallist),
	retract(catalog_init(_,_,_,_,_,_,_,_)),
	assert(catalog_init(Qualifier,Owner,Names,TypesInit,ColumnNamesInit,FkQualifier,FkOwner,FkNames)),!.

/***************************************************************************
			dialog_primarykeys
***************************************************************************/
predicates
  dialog_primarykeys(WINDOW ParentWin,STRING Qualifier,STRING Owner,STRING Names)
clauses
  dialog_primarykeys(ParentWin,Qualifier,Owner,Names):-
	catalog_init(QualifierInit,OwnerInit,NamesInit,TypesInit,ColumnNamesInit,A,B,C),
	dialog_Create(ParentWin,[resdlg(idd_primarykeys,wd_Modal)],
  		[
		df(idc_primarykeys_1,listedit([QualifierInit,"NULL_STRING","%"],QualifierInit),nopr),
		df(idc_primarykeys_2,listedit([OwnerInit,"NULL_STRING","%"],OwnerInit),nopr),
		df(idc_primarykeys_3,listedit([NamesInit,"NULL_STRING","%"],NamesInit),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	Qualifier = dialog_VLGetListEdit(idc_primarykeys_1,Vallist),
	Owner = dialog_VLGetListEdit(idc_primarykeys_2,Vallist),
	Names = dialog_VLGetListEdit(idc_primarykeys_3,Vallist),
	retract(catalog_init(_,_,_,_,_,_,_,_)),
	assert(catalog_init(Qualifier,Owner,Names,TypesInit,ColumnNamesInit,A,B,C)),!.

/***************************************************************************
			dialog_tableprivileges
***************************************************************************/
predicates
  dialog_tableprivileges(WINDOW ParentWin,STRING Qualifier,STRING Owner,STRING Names)
clauses
  dialog_tableprivileges(ParentWin,Qualifier,Owner,Names):-
	catalog_init(QualifierInit,OwnerInit,NamesInit,TypesInit,ColumnNamesInit,A,B,C),
	dialog_Create(ParentWin,[resdlg(idd_tableprivileges,wd_Modal)],
  		[
		df(idc_tableprivileges_1,listedit([QualifierInit,"NULL_STRING","%"],QualifierInit),nopr),
		df(idc_tableprivileges_2,listedit([OwnerInit,"NULL_STRING","%"],OwnerInit),nopr),
		df(idc_tableprivileges_3,listedit([NamesInit,"NULL_STRING","%"],NamesInit),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	Qualifier = dialog_VLGetListEdit(idc_tableprivileges_1,Vallist),
	Owner = dialog_VLGetListEdit(idc_tableprivileges_2,Vallist),
	Names = dialog_VLGetListEdit(idc_tableprivileges_3,Vallist),
	retract(catalog_init(_,_,_,_,_,_,_,_)),
	assert(catalog_init(Qualifier,Owner,Names,TypesInit,ColumnNamesInit,A,B,C)),!.

/***************************************************************************
			dialog_specialcolumns
***************************************************************************/
predicates
  dialog_specialcolumns(WINDOW ParentWin,UNSIGNED ColType,STRING Qualifier,
	STRING Owner,STRING Names,UNSIGNED Scope,UNSIGNED Nullable)
clauses
  dialog_specialcolumns(ParentWin,ColType,Qualifier,Owner,Names,Scope,Nullable):-
	catalog_init(QualifierInit,OwnerInit,NamesInit,A,B,C,D,E),
	special_init(ColTypeInit,ScopeInit,NullableInit),
	dialog_Create(ParentWin,[resdlg(idd_specialcolumns,wd_Modal)],
  		[
		df(idc_specialcolumns_1,listedit([QualifierInit,"NULL_STRING","%"],QualifierInit),nopr),
		df(idc_specialcolumns_2,listedit([OwnerInit,"NULL_STRING","%"],OwnerInit),nopr),
		df(idc_specialcolumns_3,listedit([NamesInit,"NULL_STRING","%"],NamesInit),nopr),
		df(idc_specialcolumns_4,listbutton(["odbc_best_rowid","odbc_rowver"],ColTypeInit),nopr),
		df(idc_specialcolumns_5,listbutton(["odbc_scope_currow","odbc_scope_transaction",
			"odbc_scope_session"],ScopeInit),nopr),
		df(idc_specialcolumns_6,listbutton(["odbc_no_nulls","odbc_nullable"],NullableInit),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	Qualifier = dialog_VLGetListEdit(idc_specialcolumns_1,Vallist),
	Owner = dialog_VLGetListEdit(idc_specialcolumns_2,Vallist),
	Names = dialog_VLGetListEdit(idc_specialcolumns_3,Vallist),
	dialog_VLGetListButton(idc_specialcolumns_4,Vallist,_,ColType1),
	ColType = ColType1 + 1,
	dialog_VLGetListButton(idc_specialcolumns_5,Vallist,_,Scope1),
	Scope = Scope1 + 1,
	dialog_VLGetListButton(idc_specialcolumns_6,Vallist,_,Nullable1),
	Nullable = Nullable1 + 1,
	retract(catalog_init(_,_,_,_,_,_,_,_)),
	assert(catalog_init(Qualifier,Owner,Names,A,B,C,D,E)),
	retract(special_init(_,_,_)),
	assert(special_init(ColType1,Scope1,Nullable1)),!.

/***************************************************************************
			dialog_statistics
***************************************************************************/
predicates
  dialog_statistics(WINDOW ParentWin,STRING Qualifier,STRING Owner,STRING Names,
	UNSIGNED Unique,UNSIGNED Accuracy)
clauses
  dialog_statistics(ParentWin,Qualifier,Owner,Names,Unique,Accuracy):-
	catalog_init(QualifierInit,OwnerInit,NamesInit,A,B,C,D,E),
	statistics_init(UniqueInit,AccuracyInit),
	dialog_Create(ParentWin,[resdlg(idd_statistics,wd_Modal)],
  		[
		df(idc_statistics_1,listedit([QualifierInit,"NULL_STRING","%"],QualifierInit),nopr),
		df(idc_statistics_2,listedit([OwnerInit,"NULL_STRING","%"],OwnerInit),nopr),
		df(idc_statistics_3,listedit([NamesInit,"NULL_STRING","%"],NamesInit),nopr),
		df(idc_statistics_4,listbutton(["odbc_index_unique","odbc_index_all"],UniqueInit),nopr),
		df(idc_statistics_5,listbutton(["odbc_ensure","odbc_quick"],AccuracyInit),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	Qualifier = dialog_VLGetListEdit(idc_statistics_1,Vallist),
	Owner = dialog_VLGetListEdit(idc_statistics_2,Vallist),
	Names = dialog_VLGetListEdit(idc_statistics_3,Vallist),
	dialog_VLGetListButton(idc_statistics_4,Vallist,_,Unique1),
	Unique = Unique1 + 1,
	dialog_VLGetListButton(idc_statistics_5,Vallist,_,Accuracy1),
	Accuracy = Accuracy1 + 1,
	retract(catalog_init(_,_,_,_,_,_,_,_)),
	assert(catalog_init(Qualifier,Owner,Names,A,B,C,D,E)),
	retract(statistics_init(_,_)),
	assert(statistics_init(Unique1,Accuracy1)),!.

/***************************************************************************
			dialog_procedures
***************************************************************************/
predicates
  dialog_procedures(WINDOW ParentWin,STRING Qualifier,STRING Owner,STRING Names)
clauses
  dialog_procedures(ParentWin,Qualifier,Owner,Names):-
	procedure_init(QualifierInit,OwnerInit,NamesInit,ColumnNamesInit),
	dialog_Create(ParentWin,[resdlg(idd_procedures,wd_Modal)],
  		[
		df(idc_procedures_1,listedit([QualifierInit,"NULL_STRING","%"],QualifierInit),nopr),
		df(idc_procedures_2,listedit([OwnerInit,"NULL_STRING","%"],OwnerInit),nopr),
		df(idc_procedures_3,listedit([NamesInit,"NULL_STRING","%"],NamesInit),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	Qualifier = dialog_VLGetListEdit(idc_procedures_1,Vallist),
	Owner = dialog_VLGetListEdit(idc_procedures_2,Vallist),
	Names = dialog_VLGetListEdit(idc_procedures_3,Vallist),
	retract(procedure_init(_,_,_,_)),
	assert(procedure_init(Qualifier,Owner,Names,ColumnNamesInit)),!.

/***************************************************************************
			dialog_tables
***************************************************************************/
predicates
  dialog_tables(WINDOW ParentWin,STRING Qualifier,STRING Owner,STRING Names,STRING Types)
clauses
  dialog_tables(ParentWin,Qualifier,Owner,Names,Types):-
	catalog_init(QualifierInit,OwnerInit,NamesInit,TypesInit,ColumnNamesInit,A,B,C),
	dialog_Create(ParentWin,[resdlg(idd_tables,wd_Modal)],
  		[
		df(idc_tables_1,listedit([QualifierInit,"NULL_STRING","%"],QualifierInit),nopr),
		df(idc_tables_2,listedit([OwnerInit,"NULL_STRING","%"],OwnerInit),nopr),
		df(idc_tables_3,listedit([NamesInit,"NULL_STRING","%"],NamesInit),nopr),
		df(idc_tables_4,listedit([TypesInit,"NULL_STRING","%"],TypesInit),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	Qualifier = dialog_VLGetListEdit(idc_tables_1,Vallist),
	Owner = dialog_VLGetListEdit(idc_tables_2,Vallist),
	Names = dialog_VLGetListEdit(idc_tables_3,Vallist),
	Types = dialog_VLGetListEdit(idc_tables_4,Vallist),
	retract(catalog_init(_,_,_,_,_,_,_,_)),
	assert(catalog_init(Qualifier,Owner,Names,Types,ColumnNamesInit,A,B,C)),!.

/***************************************************************************
			dialog_describecol
***************************************************************************/
predicates
  dialog_describecol(WINDOW ParentWin,INTEGER Column)
clauses
  dialog_describecol(ParentWin,Column):-
	column_num(InitColumn),
	str_int(InitColumn1,InitColumn),
	dialog_Create(ParentWin,[resdlg(idd_describecol,wd_Modal)],
  		[
		df(idc_describecol_1,editstr(InitColumn1,[]),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	Column1 = dialog_VLGetStr(idc_describecol_1,Vallist),
	str_int(Column1,Column),
	retract(column_num(_)),
	assert(column_num(Column)),!.

/***************************************************************************
			dialog_getbindcol
***************************************************************************/
predicates
  dialog_getbindcol(WINDOW ParentWin,INTEGER Column)
clauses
  dialog_getbindcol(ParentWin,Column):-
	column_num(InitColumn),
	str_int(InitColumn1,InitColumn),
	dialog_Create(ParentWin,[resdlg(idd_getbindcol,wd_Modal)],
  		[
		df(idc_getbindcol_1,editstr(InitColumn1,[]),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	Column1 = dialog_VLGetStr(idc_getbindcol_1,Vallist),
	str_int(Column1,Column),
	retract(column_num(_)),
	assert(column_num(Column)),!.

/***************************************************************************
			dialog_getbindparameter
***************************************************************************/
predicates
  dialog_getbindparameter(WINDOW ParentWin,INTEGER IPar)
clauses
  dialog_getbindparameter(ParentWin,IPar):-
	param_init(IparInit1,ParamTypeInit,ColDefInit,IbScaleInit),
	str_int(IparInit,IparInit1),
	dialog_Create(ParentWin,[resdlg(idd_getbindparameter,wd_Modal)],
  		[
		df(idc_getbindparameter_1,editstr(IparInit,[]),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	IPar1 = dialog_VLGetStr(idc_getbindparameter_1,Vallist),
	str_int(IPar1,IPar),
	retract(param_init(_,_,_,_)),
	assert(param_init(Ipar,ParamTypeInit,ColDefInit,IbScaleInit)),!.

/***************************************************************************
			dialog_paramoptions
***************************************************************************/
predicates
  dialog_paramoptions(WINDOW ParentWin,LONG Crow)
clauses
  dialog_paramoptions(ParentWin,Crow):-
	paramoptions_num(CrowInit1),
	trap(term_str(long,CrowInit1,CrowInit),_,fail),
	dialog_Create(ParentWin,[resdlg(idd_paramoptions,wd_Modal)],
  		[
		df(idc_paramoptions_1,editstr(CrowInit,[]),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	Crow1 = dialog_VLGetStr(idc_paramoptions_1,Vallist),
	trap(term_str(long,Crow,Crow1),_,fail),
	retract(paramoptions_num(_)),
	assert(paramoptions_num(Crow)),!.

/***************************************************************************
			dialog_describeparam
***************************************************************************/
predicates
  dialog_describeparam(WINDOW ParentWin,INTEGER Param)
clauses
  dialog_describeparam(ParentWin,Param):-
	param_init(IparInit1,ParamTypeInit,ColDefInit,IbScaleInit),
	str_int(IparInit,IparInit1),
	dialog_Create(ParentWin,[resdlg(idd_describeparam,wd_Modal)],
  		[
		df(idc_describeparam_1,editstr(IparInit,[]),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	Param1 = dialog_VLGetStr(idc_describeparam_1,Vallist),
	str_int(Param1,Param),
	retract(param_init(_,_,_,_)),
	assert(param_init(Param,ParamTypeInit,ColDefInit,IbScaleInit)),!.

/***************************************************************************
			dialog_columnprivileges
***************************************************************************/
predicates
  dialog_columnprivileges(WINDOW ParentWin,STRING Qualifier,STRING Owner,STRING Names,STRING ColumnNames)
clauses
  dialog_columnprivileges(ParentWin,Qualifier,Owner,Names,ColumnNames):-
	catalog_init(QualifierInit,OwnerInit,NamesInit,TypesInit,ColumnNamesInit,A,B,C),
	dialog_Create(ParentWin,[resdlg(idd_columnprivileges,wd_Modal)],
  		[
		df(idc_columnprivileges_1,listedit([QualifierInit,"NULL_STRING","%"],QualifierInit),nopr),
		df(idc_columnprivileges_2,listedit([OwnerInit,"NULL_STRING","%"],OwnerInit),nopr),
		df(idc_columnprivileges_3,listedit([NamesInit,"NULL_STRING","%"],NamesInit),nopr),
		df(idc_columnprivileges_4,listedit([ColumnNamesInit,"NULL_STRING","%"],ColumnNamesInit),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	Qualifier = dialog_VLGetListEdit(idc_columnprivileges_1,Vallist),
	Owner = dialog_VLGetListEdit(idc_columnprivileges_2,Vallist),
	Names = dialog_VLGetListEdit(idc_columnprivileges_3,Vallist),
	ColumnNames = dialog_VLGetListEdit(idc_columnprivileges_4,Vallist),
	retract(catalog_init(_,_,_,_,_,_,_,_)),
	assert(catalog_init(Qualifier,Owner,Names,TypesInit,ColumnNames,A,B,C)),!.

/***************************************************************************
			dialog_columns
***************************************************************************/
predicates
  dialog_columns(WINDOW ParentWin,STRING Qualifier,STRING Owner,STRING Names,STRING ColumnNames)
clauses
  dialog_columns(ParentWin,Qualifier,Owner,Names,ColumnNames):-
	catalog_init(QualifierInit,OwnerInit,NamesInit,TypesInit,ColumnNamesInit,A,B,C),
	dialog_Create(ParentWin,[resdlg(idd_columns,wd_Modal)],
  		[
		df(idc_columns_1,listedit([QualifierInit,"NULL_STRING","%"],QualifierInit),nopr),
		df(idc_columns_2,listedit([OwnerInit,"NULL_STRING","%"],OwnerInit),nopr),
		df(idc_columns_3,listedit([NamesInit,"NULL_STRING","%"],NamesInit),nopr),
		df(idc_columns_4,listedit([ColumnNamesInit,"NULL_STRING","%"],ColumnNamesInit),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	Qualifier = dialog_VLGetListEdit(idc_columns_1,Vallist),
	Owner = dialog_VLGetListEdit(idc_columns_2,Vallist),
	Names = dialog_VLGetListEdit(idc_columns_3,Vallist),
	ColumnNames = dialog_VLGetListEdit(idc_columns_4,Vallist),
	retract(catalog_init(_,_,_,_,_,_,_,_)),
	assert(catalog_init(Qualifier,Owner,Names,TypesInit,ColumnNames,A,B,C)),!.

/***************************************************************************
			dialog_procedurecolumns
***************************************************************************/
predicates
  dialog_procedurecolumns(WINDOW ParentWin,STRING Qualifier,STRING Owner,STRING Names,STRING ColumnNames)
clauses
  dialog_procedurecolumns(ParentWin,Qualifier,Owner,Names,ColumnNames):-
	procedure_init(QualifierInit,OwnerInit,NamesInit,ColumnNamesInit),
	dialog_Create(ParentWin,[resdlg(idd_procedurecolumns,wd_Modal)],
  		[
		df(idc_procedurecolumns_1,listedit([QualifierInit,"NULL_STRING","%"],QualifierInit),nopr),
		df(idc_procedurecolumns_2,listedit([OwnerInit,"NULL_STRING","%"],OwnerInit),nopr),
		df(idc_procedurecolumns_3,listedit([NamesInit,"NULL_STRING","%"],NamesInit),nopr),
		df(idc_procedurecolumns_4,listedit([ColumnNamesInit,"NULL_STRING","%"],ColumnNamesInit),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	Qualifier = dialog_VLGetListEdit(idc_procedurecolumns_1,Vallist),
	Owner = dialog_VLGetListEdit(idc_procedurecolumns_2,Vallist),
	Names = dialog_VLGetListEdit(idc_procedurecolumns_3,Vallist),
	ColumnNames = dialog_VLGetListEdit(idc_procedurecolumns_4,Vallist),
	retract(procedure_init(_,_,_,_)),
	assert(procedure_init(Qualifier,Owner,Names,ColumnNames)),!.

/***************************************************************************
			dialog_bindcol
***************************************************************************/
predicates
  dialog_bindcol(WINDOW ParentWin,INTEGER Column,INTEGER DataType,INTEGER Len)
clauses
  dialog_bindcol(ParentWin,Column,DataType,Len):-
	column_num(InitColumn),
	str_int(InitColumn1,InitColumn),
	datatype_init(DataTypeInit),
	busize_init(BuffInit1),
	str_int(BuffInit,BuffInit1),
	dialog_Create(ParentWin,[resdlg(idd_bindcol,wd_Modal)],
  		[
		df(idc_bindcol_1,listbutton(["odbc_string","odbc_bit","odbc_byte","odbc_integer",
			"odbc_float","odbc_long","odbc_real","odbc_date","odbc_time","odbc_timestamp",
				"odbc_binary","odbc_numeric","odbc_memo"],DataTypeInit),nopr),
		df(idc_bindcol_2,editstr(InitColumn1,[]),nopr),
		df(idc_bindcol_3,editstr(BuffInit,[]),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	dialog_VLGetListButton(idc_bindcol_1,Vallist,_,DataType1),
	DataType = DataType1 + 1,
	Column1 = dialog_VLGetStr(idc_bindcol_2,Vallist),
	str_int(Column1,Column),
	Len1 = dialog_VLGetStr(idc_bindcol_3,Vallist),
	str_int(Len1,Len),
	retract(column_num(_)),
	assert(column_num(Column)),
	retract(busize_init(_)),
	assert(busize_init(Len)),
	retract(datatype_init(_)),
	assert(datatype_init(DataType1)),!.

/***************************************************************************
			dialog_bindparameter
***************************************************************************/
predicates
  dialog_bindparameter(WINDOW ParentWin,UNSIGNED Ipar,UNSIGNED ParamType,
	UNSIGNED DataType,LONG ColDef,INTEGER IbScale,UNSIGNED BufferLen)
clauses
  dialog_bindparameter(ParentWin,Ipar,ParamType,DataType,ColDef,IbScale,BufferLen):-
	param_init(IparInit1,ParamTypeInit,ColDefInit1,IbScaleInit1),
	str_int(IparInit,IparInit1),
	trap(term_str(long,ColDefInit1,ColDefInit),_,fail),
	str_int(IbScaleInit,IbScaleInit1),
	busize_init(BuffInit1),
	str_int(BuffInit,BuffInit1),
	datatype_init(DataTypeInit),
	dialog_Create(ParentWin,[resdlg(idd_bindparameter,wd_Modal)],
		[
		df(idc_bindparameter_1,listbutton(["odbc_string","odbc_bit","odbc_byte","odbc_integer",
			"odbc_float","odbc_long","odbc_real","odbc_date","odbc_time","odbc_timestamp",
			"odbc_binary","odbc_numeric","odbc_memo"],DataTypeInit),nopr),
		df(idc_bindparameter_2,editstr(IparInit,[]),nopr),
		df(idc_bindparameter_3,editstr(BuffInit,[]),nopr),
		df(idc_bindparameter_4,listbutton(["odbc_param_input",
			"odbc_param_input_output"],ParamTypeInit),nopr),
		df(idc_bindparameter_5,editstr(ColDefInit,[]),nopr),
		df(idc_bindparameter_6,editstr(IbScaleInit,[]),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	dialog_VLGetListButton(idc_bindparameter_1,Vallist,_,DataType1),
	DataType = DataType1 + 1,
	Ipar1 = dialog_VLGetStr(idc_bindparameter_2,Vallist),
	str_int(Ipar1,Ipar),
	BufferLen1 = dialog_VLGetStr(idc_bindparameter_3,Vallist),
	str_int(BufferLen1,BufferLen),
	dialog_VLGetListButton(idc_bindparameter_4,Vallist,_,ParamType1),
	ParamType = ParamType1 + 1,
	ColDef1 = dialog_VLGetStr(idc_bindparameter_5,Vallist),
	trap(term_str(long,ColDef,ColDef1),_,fail),
	IbScale1 = dialog_VLGetStr(idc_bindparameter_6,Vallist),
	str_int(IbScale1,IbScale),
	retract(param_init(_,_,_,_)),
	assert(param_init(Ipar,ParamType1,ColDef,IbScale)),
	retract(busize_init(_)),
	assert(busize_init(BufferLen)),
	retract(datatype_init(_)),
	assert(datatype_init(DataType1)),!.

/***************************************************************************
			dialog_driverconnect
***************************************************************************/
predicates
  dialog_driverconnect(WINDOW ParentWin,STRING ConnStrIn,UNSIGNED DriverCompletion)
clauses
  dialog_driverconnect(ParentWin,ConnStrIn,DriverCompletion):-
	drvcon_init(ConnStrInInit,DriverCompletionInit),
	dialog_Create(ParentWin,[resdlg(idd_driverconnect,wd_Modal)],
  		[
		df(idc_driverconnect_1,listbutton(["odbc_driver_prompt",
"odbc_driver_complete","odbc_driver_complete_required","odbc_driver_noprompt"],DriverCompletionInit),nopr),
		df(idc_driverconnect_2,editstr(ConnStrInInit,[]),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	dialog_VLGetListButton(idc_driverconnect_1,Vallist,_,DriverCompletion1),
	DriverCompletion = DriverCompletion1 + 1,
	ConnStrIn = dialog_VLGetStr(idc_driverconnect_2,Vallist),
	retract(drvcon_init(_,_)),
	assert(drvcon_init(ConnStrIn,DriverCompletion1)),!.

/***************************************************************************
			dialog_browseconnect
***************************************************************************/
predicates
  dialog_browseconnect(WINDOW ParentWin,STRING ConnStrIn)
clauses
  dialog_browseconnect(ParentWin,ConnStrIn):-
	drvcon_init(ConnStrInInit,DriverCompletionInit),
	dialog_Create(ParentWin,[resdlg(idd_browseconnect,wd_Modal)],
  		[
		df(idc_browseconnect_1,editstr(ConnStrInInit,[]),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	ConnStrIn = dialog_VLGetStr(idc_browseconnect_1,Vallist),
	retract(drvcon_init(_,_)),
	assert(drvcon_init(ConnStrIn,DriverCompletionInit)),!.

/***************************************************************************
			dialog_freestmt
***************************************************************************/
predicates
  dialog_freestmt(WINDOW ParentWin,INTEGER Option)
clauses
  dialog_freestmt(ParentWin,Option):-
	freestmt_opt(InitOption),
	dialog_Create(ParentWin,[resdlg(idd_freestmt,wd_Modal)],
  		[
		df(idc_freestmt_1,listbutton(["odbc_drop","odbc_close","odbc_unbind",
			"odbc_reset_params"],InitOption),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	dialog_VLGetListButton(idc_freestmt_1,Vallist,_,Option1),
	Option = Option1 + 1,
	retract(freestmt_opt(_)),
	assert(freestmt_opt(Option1)),!.

/***************************************************************************
			dialog_extendedfetch
***************************************************************************/
predicates
  dialog_extendedfetch(WINDOW ParentWin,INTEGER Type,LONG FetchRow)
clauses
  dialog_extendedfetch(ParentWin,Type,FetchRow):-
	extendedfetch_opt(InitType),
	dialog_Create(ParentWin,[resdlg(idd_extendedfetch,wd_Modal)],
  		[
		df(idc_extendedfetch_1,listbutton(["odbc_fetch_first","odbc_fetch_next",
			"odbc_fetch_last","odbc_fetch_prior","odbc_fetch_absolute",
			"odbc_fetch_relative","odbc_fetch_bookmark"],InitType),nopr),
		df(idc_extendedfetch_2,editstr("0",[]),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	dialog_VLGetListButton(idc_extendedfetch_1,Vallist,_,Type1),
	Type = Type1 + 1,
	FetchRow1 = dialog_VLGetStr(idc_extendedfetch_2,Vallist),
	trap(term_str(long,FetchRow,FetchRow1),_,fail),
	retract(extendedfetch_opt(_)),
	assert(extendedfetch_opt(Type1)),!.

/***************************************************************************
			dialog_setpos
***************************************************************************/
predicates
  dialog_setpos(WINDOW ParentWin,UNSIGNED Row,UNSIGNED Option,UNSIGNED Lock)
clauses
  dialog_setpos(ParentWin,Row,Option,Lock):-
	setpos_init(OptionInit,LockInit,RowInit),
	str_int(RowInit1,RowInit),
	dialog_Create(ParentWin,[resdlg(idd_setpos,wd_Modal)],
  		[
		df(idc_setpos_1,listbutton(["odbc_position","odbc_refresh",
			"odbc_update","odbc_delete","odbc_add"],OptionInit),nopr),
		df(idc_setpos_2,listbutton(["odbc_lock_no_change","odbc_lock_exclusive",
			"odbc_lock_unlock"],LockInit),nopr),
		df(idc_setpos_3,editstr(RowInit1,[]),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	dialog_VLGetListButton(idc_setpos_1,Vallist,_,Option1),
	Option = Option1 + 1,
	dialog_VLGetListButton(idc_setpos_2,Vallist,_,Lock1),
	Lock = Lock1 + 1,
	Row1 = dialog_VLGetStr(idc_setpos_3,Vallist),
	str_int(Row1,Row),
	retract(setpos_init(_,_,_)),
	assert(setpos_init(Option1,Lock1,Row)),!.

/***************************************************************************
			dialog_setscrolloptions
***************************************************************************/
predicates
  dialog_setscrolloptions(WINDOW ParentWin,UNSIGNED Concurrency,LONG CrowKeyset,UNSIGNED CrowRowset)
  get_CrowKeyset(STRING,LONG)
clauses
  dialog_setscrolloptions(ParentWin,Concurrency,CrowKeyset,CrowRowset):-
	scrollopt_init(ConcurrencyInit,CrowKeysetInit,CrowRowsetInit),
	str_int(CrowRowsetInit1,CrowRowsetInit),
	dialog_Create(ParentWin,[resdlg(idd_setscrolloptions,wd_Modal)],
  		[
		df(idc_setscrolloptions_1,listbutton(["odbc_concur_read_only",
			"odbc_concur_lock","odbc_concur_rowver","odbc_concur_values"],ConcurrencyInit),nopr),
		df(idc_setscrolloptions_2,listedit([CrowKeysetInit,"odbc_scroll_forward_only",
			"odbc_scroll_static","odbc_scroll_keyset_driven","odbc_scroll_dynamic"],CrowKeysetInit),nopr),
		df(idc_setscrolloptions_3,editstr(CrowRowsetInit1,[]),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	dialog_VLGetListButton(idc_setscrolloptions_1,Vallist,_,Concurrency1),
	Concurrency = Concurrency1 + 1,
	CrowKeysetS = dialog_VLGetListEdit(idc_setscrolloptions_2,Vallist),
	get_CrowKeyset(CrowKeysetS,CrowKeyset),
	CrowRowset1 = dialog_VLGetStr(idc_setscrolloptions_3,Vallist),
	str_int(CrowRowset1,CrowRowset),
	retract(scrollopt_init(_,_,_)),
	assert(scrollopt_init(Concurrency1,CrowKeysetS,CrowRowset)),!.

  get_CrowKeyset("odbc_scroll_forward_only",odbc_scroll_forward_only):-!.
  get_CrowKeyset("odbc_scroll_static",odbc_scroll_static):-!.
  get_CrowKeyset("odbc_scroll_keyset_driven",odbc_scroll_keyset_driven):-!.
  get_CrowKeyset("odbc_scroll_dynamic",odbc_scroll_dynamic):-!.
  get_CrowKeyset(CrowKeysetS,CrowKeyset):-
	trap(term_str(long,CrowKeyset,CrowKeysetS),_,fail),!.

/***************************************************************************
			dialog_setstmtoption
***************************************************************************/
predicates
  dialog_setstmtoption(WINDOW ParentWin,UNSIGNED Option,LONG Param)
  get_Param(STRING,LONG)
clauses
  dialog_setstmtoption(ParentWin,Option,Param):-
	stmtopt_init(OptionInit,ParamInit),
	dialog_Create(ParentWin,[resdlg(idd_setstmtoption,wd_Modal)],
  		[
		df(idc_setstmtoption_1,listbutton(["odbc_async_enable",
			"odbc_bind_type","odbc_concurrency","odbc_cursor_type",
			"odbc_keyset_size","odbc_max_length","odbc_max_rows",
			"odbc_noscan","odbc_query_timeout","odbc_retrieve_data",
			"odbc_rowset_size","odbc_simulate_cursor","odbc_use_bookmarks"],OptionInit),nopr),
		df(idc_setstmtoption_2,listedit([ParamInit,"odbc_async_enable_off",
			"odbc_async_enable_on","odbc_bind_by_column","odbc_concur_read_only",
			"odbc_concur_lock","odbc_concur_rowver","odbc_concur_values",
			"odbc_cursor_forward_only","odbc_cursor_static","odbc_cursor_keyset_driven",
			"odbc_cursor_dynamic","odbc_noscan_off","odbc_noscan_on",
			"odbc_rd_on","odbc_rd_off","odbc_sc_non_unique","odbc_sc_try_unique",
			"odbc_sc_unique","odbc_ub_off","odbc_ub_on"],ParamInit),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	dialog_VLGetListButton(idc_setstmtoption_1,Vallist,_,Option1),
	Option = Option1 + 1,
	ParamS = dialog_VLGetListEdit(idc_setstmtoption_2,Vallist),
	get_Param(ParamS,Param),
	retract(stmtopt_init(_,_)),
	assert(stmtopt_init(Option1,ParamS)),!.

  get_Param("odbc_async_enable_off",odbc_async_enable_off):-!.
  get_Param("odbc_async_enable_on",odbc_async_enable_on):-!.
  get_Param("odbc_bind_by_column",odbc_bind_by_column):-!.
  get_Param("odbc_concur_read_only",odbc_concur_read_only):-!.
  get_Param("odbc_concur_lock",odbc_concur_lock):-!.
  get_Param("odbc_concur_rowver",odbc_concur_rowver):-!.
  get_Param("odbc_concur_values",odbc_concur_values):-!.
  get_Param("odbc_cursor_forward_only",odbc_cursor_forward_only):-!.
  get_Param("odbc_cursor_static",odbc_cursor_static):-!.
  get_Param("odbc_cursor_keyset_driven",odbc_cursor_keyset_driven):-!.
  get_Param("odbc_cursor_dynamic",odbc_cursor_dynamic):-!.
  get_Param("odbc_noscan_off",odbc_noscan_off):-!.
  get_Param("odbc_noscan_on",odbc_noscan_on):-!.
  get_Param("odbc_rd_on",odbc_rd_on):-!.
  get_Param("odbc_rd_off",odbc_rd_off):-!.
  get_Param("odbc_sc_non_unique",odbc_sc_non_unique):-!.
  get_Param("odbc_sc_try_unique",odbc_sc_try_unique):-!.
  get_Param("odbc_sc_unique",odbc_sc_unique):-!.
  get_Param("odbc_ub_off",odbc_ub_off):-!.
  get_Param("odbc_ub_on",odbc_ub_on):-!.
  get_Param(ParamS,Param):-
	trap(term_str(long,Param,ParamS),_,fail),!.

/***************************************************************************
			dialog_getstmtoption
***************************************************************************/
predicates
  dialog_getstmtoption(WINDOW ParentWin,UNSIGNED Option)
clauses
  dialog_getstmtoption(ParentWin,Option):-
	stmtopt_init(OptionInit,ParamInit),
	dialog_Create(ParentWin,[resdlg(idd_getstmtoption,wd_Modal)],
  		[
		df(idc_getstmtoption_1,listbutton(["odbc_async_enable",
			"odbc_bind_type","odbc_concurrency","odbc_cursor_type",
			"odbc_keyset_size","odbc_max_length","odbc_max_rows",
			"odbc_noscan","odbc_query_timeout","odbc_retrieve_data",
			"odbc_rowset_size","odbc_simulate_cursor","odbc_use_bookmarks",
			"odbc_get_bookmark","odbc_row_number"],OptionInit),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	dialog_VLGetListButton(idc_getstmtoption_1,Vallist,_,Option1),
	Option = Option1 + 1,
	retract(stmtopt_init(_,_)),
	assert(stmtopt_init(Option1,ParamInit)),!.

/***************************************************************************
			dialog_setconnectoption
***************************************************************************/
predicates
  dialog_setconnectoption(WINDOW ParentWin,UNSIGNED Option,ODBC_CO_DATA Param)
  get_ConParam(UNSIGNED Option,STRING,ODBC_CO_DATA)
clauses
  dialog_setconnectoption(ParentWin,Option,Param):-
	connectopt_init(OptionInit,ParamInit),
	dialog_Create(ParentWin,[resdlg(idd_setconnectoption,wd_Modal)],
  		[
		df(idc_setconnectoption_1,listbutton(["odbc_access_mode","odbc_autocommit",
"odbc_current_qualifier","odbc_login_timeout","odbc_odbc_cursors","odbc_opt_trace",
"odbc_opt_tracefile","odbc_packet_size","odbc_quiet_mode","odbc_translate_dll",
"odbc_translate_option","odbc_txn_isolation"],OptionInit),nopr),
		df(idc_setconnectoption_2,listedit([ParamInit,"odbc_mode_read_only",
"odbc_mode_read_write","odbc_autocommit_off","odbc_autocommit_on","odbc_cur_use_if_needed",
"odbc_cur_use_odbc","odbc_cur_use_driver","odbc_opt_trace_off","odbc_opt_trace_on",
"odbc_txn_read_uncommitted","odbc_txn_read_committed","odbc_txn_repeatable_read",
"odbc_txn_serializable","odbc_txn_versioning"],ParamInit),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	dialog_VLGetListButton(idc_setconnectoption_1,Vallist,_,Option1),
	Option = Option1 + 1,
	ParamS = dialog_VLGetListEdit(idc_setconnectoption_2,Vallist),
	get_ConParam(Option,ParamS,Param),
	retract(connectopt_init(_,_)),
	assert(connectopt_init(Option1,ParamS)),!.

  get_ConParam(odbc_access_mode,"odbc_mode_read_only",l(odbc_mode_read_only)):-!.
  get_ConParam(odbc_access_mode,"odbc_mode_read_write",l(odbc_mode_read_write)):-!.
  get_ConParam(odbc_autocommit,"odbc_autocommit_off",l(odbc_autocommit_off)):-!.
  get_ConParam(odbc_autocommit,"odbc_autocommit_on",l(odbc_autocommit_on)):-!.
  get_ConParam(odbc_login_timeout,ParamS,l(Param)):-
	trap(term_str(long,Param,ParamS),_,fail),!.
  get_ConParam(odbc_odbc_cursors,"odbc_cur_use_if_needed",l(odbc_cur_use_if_needed)):-!.
  get_ConParam(odbc_odbc_cursors,"odbc_cur_use_odbc",l(odbc_cur_use_odbc)):-!.
  get_ConParam(odbc_odbc_cursors,"odbc_cur_use_driver",l(odbc_cur_use_driver)):-!.
  get_ConParam(odbc_opt_trace,"odbc_opt_trace_off",l(odbc_opt_trace_off)):-!.
  get_ConParam(odbc_opt_trace,"odbc_opt_trace_on",l(odbc_opt_trace_on)):-!.
  get_ConParam(odbc_packet_size,ParamS,l(Param)):-
	trap(term_str(long,Param,ParamS),_,fail),!.
  get_ConParam(odbc_quiet_mode,ParamS,l(Param)):-
	trap(term_str(long,Param,ParamS),_,fail),!.
  get_ConParam(odbc_translate_option,ParamS,l(Param)):-
	trap(term_str(long,Param,ParamS),_,fail),!.
  get_ConParam(odbc_txn_isolation,"odbc_txn_read_uncommitted",l(odbc_txn_read_uncommitted)):-!.
  get_ConParam(odbc_txn_isolation,"odbc_txn_read_committed",l(odbc_txn_read_committed)):-!.
  get_ConParam(odbc_txn_isolation,"odbc_txn_repeatable_read",l(odbc_txn_repeatable_read)):-!.
  get_ConParam(odbc_txn_isolation,"odbc_txn_serializable",l(odbc_txn_serializable)):-!.
  get_ConParam(odbc_txn_isolation,"odbc_txn_versioning",l(odbc_txn_versioning)):-!.
  get_ConParam(_,ParamS,s(ParamS)):-!.

/***************************************************************************
			dialog_getconnectoption
***************************************************************************/
predicates
  dialog_getconnectoption(WINDOW ParentWin,UNSIGNED Option)
clauses
  dialog_getconnectoption(ParentWin,Option):-
	connectopt_init(OptionInit,ParamInit),
	dialog_Create(ParentWin,[resdlg(idd_getconnectoption,wd_Modal)],
  		[
		df(idc_getconnectoption_1,listbutton(["odbc_access_mode","odbc_autocommit",
"odbc_current_qualifier","odbc_login_timeout","odbc_odbc_cursors","odbc_opt_trace",
"odbc_opt_tracefile","odbc_packet_size","odbc_quiet_mode","odbc_translate_dll",
"odbc_translate_option","odbc_txn_isolation"],OptionInit),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	dialog_VLGetListButton(idc_getconnectoption_1,Vallist,_,Option1),
	Option = Option1 + 1,
	retract(connectopt_init(_,_)),
	assert(connectopt_init(Option1,ParamInit)),!.

/***************************************************************************
			dialog_execdirect
***************************************************************************/
predicates
  dialog_execdirect(WINDOW ParentWin,STRING Str)
clauses
  dialog_execdirect(ParentWin,Str):-
	prepare_str(InitStr),
	dialog_Create(ParentWin,[resdlg(idd_execdirect,wd_Modal)],
  		[
		df(idc_execdirect_1,editstr(InitStr,[]),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	Str = dialog_VLGetStr(idc_execdirect_1,Vallist),
	retract(prepare_str(_)),
	assert(prepare_str(Str)),!.

/***************************************************************************
			dialog_transact
***************************************************************************/
predicates
  dialog_transact(WINDOW ParentWin,UNSIGNED Type)
clauses
  dialog_transact(ParentWin,Type):-
	transact_init(TypeInit),
	dialog_Create(ParentWin,[resdlg(idd_transact,wd_Modal)],
  		[
		df(idc_transact_1,listbutton(["odbc_commit","odbc_rollback"],TypeInit),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	dialog_VLGetListButton(idc_transact_1,Vallist,_,Type1),
	Type = Type1 + 1,
	retract(transact_init(_)),
	assert(transact_init(Type1)),!.

/***************************************************************************
			dialog_getfunctions
***************************************************************************/
predicates
  dialog_getfunctions(WINDOW ParentWin,STRING Title,INTEGER Id)
clauses
  dialog_getfunctions(ParentWin,Title,Id):-
	func_list(List,Init),
	dialog_Create(ParentWin,[resdlg(idd_getfunctions,wd_Modal)],
  		[
		df(idc_getfunctions_1,listbutton(List,Init),nopr)
  		],
		dialog_eh,0,Vallist,Answer),
	Answer = idc_ok,
	dialog_VLGetListButton(idc_getfunctions_1,Vallist,Title,Id1),
	Id = Id1 + 1,
	retract(func_list(_,_)),
	assert(func_list(List,Id1)),!.

