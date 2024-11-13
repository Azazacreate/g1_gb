/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  license
 FileName: license.PRO
******************************************************************************/

include "license.inc"
include "include\\pdcrunt.pre"
include "www\\include\\cgi\\cgitools.pre"
include "database.pre"
include "www\\include\\cgi\\cgitools.pro"

/*****************************************************************************
  Generate some common links
*****************************************************************************/

predicates
  procedure write_common_links()

clauses
  write_common_links():-
	  write("<P>\n"),
	  write("<A HREF=\"license.exe?action=show_all_users\">Users</A> | \n"),
	  write("<A HREF=\"license.exe?action=show_all_software\">Software</A> | \n"),
	  write("<A HREF=\"license.exe?action=show_user_fields\">UserFields</A> | \n"),
	  write("<A HREF=\"license.exe?action=show_software_fields\">SoftwareFields</A>\n"),
	  write("</P>\n").

/*****************************************************************************
  Write Common page start
*****************************************************************************/

predicates
  procedure write_common_page_start(string Title)

clauses
  write_common_page_start(Title):-
	write("<head></head>\n"),
	write("<body>\n"),
	write("<H1>",Title,"</H1>\n"),
	write("<HR>\n"),
	write_common_links().

/*****************************************************************************
  Write Page with errormessage !
*****************************************************************************/

predicates
  procedure error_page(string Title)

clauses
  error_page(Title):-
	concat("Error: ",Title,Title1),
	write_common_page_start(Title1),
	write("<p><b>Use Browsers Back button to correct mistake !</b></p>\n").

/*****************************************************************************
	Membership of a Field in a Field List
*****************************************************************************/

predicates
  determ member(field,fieldList)-(i,i)

clauses
  member(X,[X|_]):-!.
  member(X,[_|L]):-
	member(X,L).

/*****************************************************************************
	Handling of list of generic fields for a Form
  Passing in a list of Field Specifiers with Parameter names, and a list
  of actual prameter values. Write the FORM elements for this.
*****************************************************************************/

predicates
  procedure write_FieldList(fieldList,parmList)-(i,i)
  procedure write_Field(string Title,string FieldName,fieldSpec,string Value)-(i,i,i,i)

clauses
  write_Field(Title,FieldName,text(Size),Value):-
	write("<td>",Title," <td><input type=\"text\" name=\"",FieldName,"\" VALUE=\"",Value,"\" size=\"",Size,"\">\n").
  write_Field(Title,FieldName,textarea(Rows,Cols),Value):-
	write("<td>",Title," <td><textarea name=\"",FieldName,"\" Rows=\"",Rows,"\" Cols=\"",Cols,"\">",Value,"</textarea>\n").

  write_FieldList([],_).
  write_FieldList([field(_,FieldName,Title,FieldSpec)|FieldList],ParmList):-
	lookupParm(FieldName,ParmList,"",Value),
	write("<tr>"),
	write_Field(Title,FieldName,FieldSpec,Value),
	write("</tr>"),
	write_FieldList(FieldList,ParmList).


/*****************************************************************************
  Generate the inputform for Users/users
*****************************************************************************/

predicates
  procedure write_user_form(string Title,string Action,userId,string UserName,parmList)
  procedure write_user_form_id(userId)

clauses
  write_user_form(Title,Action,UserId,UserName,ParmList):-
	FieldList  = get_user_field_list(),
	write("<form method=\"POST\" action=\"license.exe\">\n"),
	write("<p><b>",Title,"</b></p>\n"),
	write("<input TYPE=\"hidden\" name=\"action\" VALUE=\"",Action,"\">\n"),
	write_user_form_id(UserId), % For the updating, the ID is needed !
	write("<table>\n"),
	write("<tr><td>Name: <td><input type=\"text\" name=\"name\" VALUE=\"",UserName,"\" size=\"40\"></tr>\n"),
	write_FieldList(FieldList,ParmList),
	write("</table>\n"),
	write("<p>\n<input type=\"submit\" VALUE=\"Submit\">\n"),
	write("<input type=\"reset\" VALUE=\"Reset\">\n"),
	write("</p>\n</form>\n").

  write_user_form_id(0):-!.
  write_user_form_id(UserId):-  
	write("<input TYPE=\"hidden\" NAME=\"id\" VALUE=\"",UserId,"\">\n").

/*****************************************************************************
  Generate the inputform for Software
*****************************************************************************/

predicates
  procedure write_software_form(string Title,string Action,softwareId,string SoftwareName,integer LegalNoOfLicenses,integer UsedNoOfLicenses,parmList)
  procedure write_software_form_id(softwareId)

clauses
  write_software_form(Title,Action,SoftwareId,SoftwareName,LegalNoOfLicenses,UsedNoOfLicenses,ParmList):-
	FieldList  = get_software_field_list(),
	write("<form method=\"POST\" action=\"license.exe\">\n"),
	write("<p><b>",Title,"</b></p>\n"),
	write("<input TYPE=\"hidden\" name=\"action\" VALUE=\"",Action,"\">\n"),
	write_software_form_id(SoftwareId),
	write("<table>\n"),
	write("<tr><td>Name: <td><input type=\"text\" name=\"name\" VALUE=\"",SoftwareName,"\" size=\"40\"></tr>\n"),
	write("<tr><td>Number of Licenses: <td><input type=\"text\" name=\"nooflicenses\" VALUE=\"",LegalNoOfLicenses,"\" size=\"3\">\n"),
	write(" (Used Licenses: ",UsedNoOfLicenses,")</tr>\n"),
	write_FieldList(FieldList,ParmList),
	write("</table>\n"),
	write("<p>\n<input type=\"submit\" VALUE=\"Submit\">\n"),
	write("<input type=\"reset\" VALUE=\"Reset\">\n"),
	write("</p>\n</form>\n").

  write_software_form_id(0):-!.
  write_software_form_id(SoftwareId):-  
	write("<input TYPE=\"hidden\" NAME=\"id\" VALUE=\"",SoftwareId,"\">\n").


/*****************************************************************************
	Writing the collumnlist for a table, based on the generic values
*****************************************************************************/

predicates
  procedure write_ColList(fieldList,parmList)-(i,i)

clauses
  write_ColList([],_).
  write_ColList([field("ON",ParmName,_,_)|Rest],ParmList):-!,
	lookupParm(ParmName,ParmList,"<BR>",Value),
	write("<td>"), % align=right
	write(Value),
	write_ColList(Rest,ParmList).
  write_ColList([_|Rest],ParmList):-
	write_ColList(Rest,ParmList).

/*****************************************************************************
	Writing the headings of the table
*****************************************************************************/

predicates
  procedure write_headings(fieldList)-(i)

clauses
  write_headings([]).
  write_headings([field("ON",_,Title,_)|Rest]):-!,
	write("<Th>",Title,"</TD>\n"),
	write_headings(Rest).
  write_headings([_|Rest]):-
	write_headings(Rest).

/*****************************************************************************
  Command: Show Page with list of ALL users
*****************************************************************************/

predicates
  procedure show_all_users()
  procedure write_user_table(fieldList)

clauses
  show_all_users():-
	write_common_page_start("Workstations & Servers"),
	FieldList = get_user_field_list(),
	write("<p><table border=1>\n"),
	write("<TR><th>Name"),
	write_headings(FieldList),
	write("</tr>\n"),
	write_user_table(FieldList),
	write("</table></p>\n"),
	write("<table bgcolor=yellow border=1><tr><td>\n"),
	write_user_form("Add User or Server","add_new_user",0,"",[]),
	write("</td></tr></table>\n").

  write_user_table(FieldList):-
	user(UserId,FullName,ParmList),
	  write("<TR><TD><A HREF=\"license.exe?action=show_user&user=",
		UserId,"\">",FullName,"</A>"),
	  write_ColList(FieldList,ParmList),
	  write("</TR>\n"),
	  fail.
  write_user_table(_).

/*****************************************************************************
  Command: Show page with all software
*****************************************************************************/

predicates
  procedure show_all_software()
  procedure show_licensestable(fieldList)-(i)
  procedure conditional_coloredtd(integer,integer)-(i,i)

clauses
  show_all_software():-
	write_common_page_start("Software"),
	FieldList = get_software_field_list(),
	show_licensestable(FieldList),
	write("<p><b>Add New Software</b></p>\n"),
	write("<table border=1 bgcolor=\"#FFFF00\"><tr><td>"),
	write_software_form("","add_new_software",0,"",0,0,[]),
	write("</td></tr></table>").

  show_licensestable(FieldList):-
	write("</p><table border=1>\n"),
	write("<tr><th>Software<th>Actual Licenses<th>Used Licenses"),
	write_headings(FieldList),
	write("</tr>\n"),
	  software(SoftwareId,NameOfSoftware,LegalNoOfLicenses,UsedNoOfLicenses,ParmList),
	  write("<tr><td>"),
	  write("<A HREF=\"license.exe?action=show_software&software=",
				SoftwareId,"\">",NameOfSoftware,"</A><BR>\n"),
	  write("<td>"),
	  write(LegalNoOfLicenses),
	  conditional_coloredtd(LegalNoOfLicenses,UsedNoOfLicenses),
	  write(UsedNoOfLicenses),
	  write_ColList(FieldList,ParmList),
	  write("</tr>\n"),
	fail.
  show_licensestable(_):-
	write("</table></p>\n").

  conditional_coloredtd(ActualNoOfLicenses,UsedNoOfLicenses):-
	ActualNoOfLicenses>=UsedNoOfLicenses,!,
	write("<td>").
  conditional_coloredtd(_,_):-
	write("<td bgcolor=\"#FF0000\">").

/*****************************************************************************
  Command: Show Page for given User
*****************************************************************************/

predicates
  procedure show_user(userId)
  procedure show_softwareforusertable(userId)
  procedure write_adduseoflicense_form(userId)
  procedure write_addsoftw_options(userId)
  procedure cond_write_heading(userId)

clauses
  show_user(UserId):-
	user(UserId,UserName,ParmList),!,
	write_common_page_start(UserName),
	write("<P>\n"),
	cond_write_heading(UserId), % Write only heading if some software are registered
	show_softwareforusertable(UserId),
	write("</P>\n"),
	write("<p><table bgcolor=gray border=1>\n"),
	write("<tr><td><A HREF=\"license.exe?action=delete_user&user=",UserId,"\">Delete ",UserName,"</A></tr>\n"),
	write("</table></p>\n"),
	write("\n<table bgcolor=yellow border=1>\n<tr><td>\n\n"),
	write_adduseoflicense_form(UserId),
	write("\n<td>\n\n"),
	write_user_form("Update Information","renameuser",UserId,UserName,ParmList),
	write("</table>\n\n").
  show_user(_):-
	write_common_page_start("Error: User NOT found!").

  show_softwareforusertable(UserId):-
	user_software(UserId,SoftwareId,SoftwareName,LicenseProblem),
	  write("<A HREF=\"license.exe?action=delete_userforsoftware&user=",
			UserId,"&software=",SoftwareId,"\">Del</A>--> \n"),
	  write("<A HREF=\"license.exe?action=show_software&software=",
			SoftwareId,"\">",SoftwareName,"</A>",LicenseProblem),
	  write("<BR>\n"),
	fail.
  show_softwareforusertable(_).
	
  write_adduseoflicense_form(UserId):-
	write("<form method=\"POST\" action=\"license.exe\">\n"),
	write("<p><b>Add new licenses</b><br>\n"),
	write("(Multiple selection is possible)</p>\n"),
	write("<input TYPE=\"hidden\" name=\"action\" VALUE=\"add_software_to_user\">\n"),
	write("<input TYPE=\"hidden\" NAME=\"name\" VALUE=\"",UserId,"\">\n"),
	write("<p><select name=\"LIST\" size=\"16\" multiple>\n"),
	write_addsoftw_options(UserId),
	write("</select></p>\n"),
	write("<p>\n<input type=\"submit\" VALUE=\"Register\" name=\"B1\">\n"),
	write("<input type=\"reset\" VALUE=\"Reset\" name=\"B2\">\n</p>\n"),
	write("</form>\n").

  write_addsoftw_options(UserId):-
	software(SoftwareId,SoftwareDescription),
	  not(license(UserId,SoftwareId)),
	  write("<option VALUE=\"",SoftwareId,"\">",SoftwareDescription,"</option>\n"),
	fail.
  write_addsoftw_options(_).
         
  cond_write_heading(UserId):-
	license(UserId,_),!, % write heading if at least one software registered !
	write("<b>Licenses already registered:</b><BR>\n").
  cond_write_heading(_).

/*****************************************************************************
  Command: Show Page for a given Software
*****************************************************************************/

predicates
  procedure show_software(softwareId)
  procedure show_usersforsoftwaretable(softwareId)
  procedure write_adduseoflicense_software_form(softwareId)
  procedure write_addusers_options(softwareId)
  procedure getmaillistforsoftware(softwareId,string MailList)

clauses
  show_software(SoftwareId):-
	software(SoftwareId,SoftwareName,LegalNoOfLicenses,UsedNoOfLicenses,ParmList),!,
	write_common_page_start(SoftwareName),
	write("<P><b>",UsedNoOfLicenses," Users:</b><br>\n"),
	show_usersforsoftwaretable(SoftwareId),
	write("</P>\n"),
	write("<p><table bgcolor=gray border=1>\n"),
	write("<tr><td><A HREF=\"license.exe?action=delete_software&software=",SoftwareId,"\">Delete ",SoftwareName,"</A></tr>\n"),
	write("</table></p>\n"),
	write("<p><table bgcolor=gray border=1>\n"),
	getmaillistforsoftware(SoftwareId,MailList),
	write("<tr><td><A HREF=\"mailto:",MailList,"\">Mail to the list of users</A></tr>\n"),
	write("</table></p>\n"),
	write("\n<table bgcolor=yellow border=1>\n<tr><td>\n\n"),
	write_adduseoflicense_software_form(SoftwareId),
	write("\n<td>\n\n"),
	write_software_form("Update","updatesoftware",SoftwareId,SoftwareName,LegalNoOfLicenses,UsedNoOfLicenses,ParmList),
	write("</table>\n\n").
  show_software(_):-
	write_common_page_start("Error: Software NOT found!").

  show_usersforsoftwaretable(SoftwareId):-
	software_user(SoftwareId,UserId,FullName),
	  write("<A HREF=\"license.exe?action=delete_softwareforuser&user=",
		UserId,"&software=",SoftwareId,"\">Del</A>--> "),
	  write("<A HREF=\"license.exe?action=show_user&user=",
		UserId,"\">",FullName,"</A><BR>\n"),
	fail.
  show_usersforsoftwaretable(_).

  write_adduseoflicense_software_form(SoftwareId):-
	write("<form method=\"POST\" action=\"license.exe\">\n"),
	write("<p><b>Register new users</b><br>\n"),
	write("(Multiple selection is possible)</p>\n"),
	write("<input TYPE=\"hidden\" name=\"action\" VALUE=\"add_user_to_software\">\n"),
	write("<input TYPE=\"hidden\" NAME=\"name\" VALUE=\"",SoftwareId,"\">\n"),
	write("<p><select name=\"LIST\" size=\"20\" multiple>\n"),
	write_addusers_options(SoftwareId),
	write("</select></p>\n"),
	write("<p>\n<input type=\"submit\" VALUE=\"Register\" name=\"B1\">\n"),
	write("<input type=\"reset\" VALUE=\"Reset\" name=\"B2\">\n</p>\n"),
	write("</form>\n").

  write_addusers_options(SoftwareId):-
	user(UserId,UserName),
	  not(license(UserId,SoftwareId)),
	  write("<option VALUE=\"",UserId,"\">",UserName,"</option>\n"),
	fail.
  write_addusers_options(_).


  getmaillistforsoftware(SoftwareId,MailList):-
	findall(User,software_user(SoftwareId,_,User),UserList),
	list_to_string(UserList,";",MailList).


/*****************************************************************************
  Command: Add new User
*****************************************************************************/

predicates
  procedure add_new_user(string Name,parmList)

clauses
  add_new_user("",_):-!,
	error_page("User Name MUST be specified").
  add_new_user(Name,ParmList):-
	not(user(Name)),!,
	ID = getnewid(),
	remove_empty_params(ParmList,Filtered),
	add_user(Id,Name,Filtered),
	show_all_users().
  add_new_user(Name,_):-
	format(Msg,"Error: % is already defined",Name),
	error_page(Msg).

/*****************************************************************************
  Command: Delete User - has been confirmed
*****************************************************************************/

predicates
  procedure confirmed_delete_user(userId)

clauses
  confirmed_delete_user(User):-
	remove_user(User),
	show_all_users().
	
/*****************************************************************************
  Command: Request to delete user
*****************************************************************************/

predicates
  procedure delete_user(userId)

clauses
  delete_user(UserId):-
	user(UserId,UserName),!,
	write_common_page_start("Are you Sure ?"),
	write("<p><A HREF=\"license.exe?action=confirmed_delete_user&user=",UserId,"\">Yes, Please Delete ",UserName,"</A></p>\n"),
	write("<p><A HREF=\"license.exe?action=show_all_users\">UPS That was a mistake</A></p>\n").
  delete_user(_):-
	write_common_page_start("Error: User NOT found").
	
/*****************************************************************************
  Command: Add new licenses for a user
*****************************************************************************/

predicates
  procedure add_software_to_user(userId,parmList)

clauses
  add_software_to_user(UserId,[parm("B1",_)|_]):-!,
	show_user(UserId).
  add_software_to_user(UserId,[parm("LIST",X)|LIST]):-
	str_int(X,SoftwareId),
	trap(add_license(UserId,SoftwareId),_,fail),!,
	add_software_to_user(UserId,LIST).
  add_software_to_user(_,_):-
	write_common_page_start("Error: SoftwareID NOT found").

/*****************************************************************************
  Command: Delete a license for a User - from the User's page
*****************************************************************************/

predicates
  procedure delete_userforsoftware(userId,softwareId)

clauses
  delete_userforsoftware(UserId,Software):-
	remove_license(UserId,Software),
	show_user(UserId).

/*****************************************************************************
  Command: Rename user
*****************************************************************************/

predicates
  procedure renameuser(userId,string Name,parmList)

clauses
  renameuser(UserId,UserName,ParmList):-
	remove_empty_params(ParmList,Filtered),
	update_user(UserId,UserName,Filtered),
	show_user(UserId).
	
/*****************************************************************************
  Command: Add new user for a given software
*****************************************************************************/

predicates
  procedure add_user_to_software(softwareId,parmlist)
  procedure wr_list_of_users(parmlist)

clauses
  add_user_to_software(Software,[parm("B1",_)|_]):-!,
	show_software(Software).
  add_user_to_software(Software,LIST):-
	software(Software,SoftwareName,LegalNoOfLicenses,UsedNoOfLicenses),
	1+UsedNoOfLicenses > LegalNoOfLicenses,!,
	write_common_page_start("Not enough licenses"),
	write("<H2>All licenses of ",SoftwareName," are currently reserved !</H2>"),
	write("<p>Discuss with your leader whether you do need the license. "),
	write("If permission is given contact the some of the others on the list or the "),
	write("product koordinator or Leo to release a license or buy a new one.</p>"),
	write("<p>It is only allowed to register anyay if permission is given !</p>"),
	write("<form method=\"POST\" action=\"license.exe\">\n"),
	write("<input TYPE=\"hidden\" name=\"action\" VALUE=\"add_user_to_software_confirmed\">\n"),
	write("<input TYPE=\"hidden\" NAME=\"name\" VALUE=\"",Software,"\">\n"),
	wr_list_of_users(LIST),
	write("<p>\n<input type=\"submit\" VALUE=\"Register Anyway\" name=\"B1\">\n"),
	write("<input type=\"reset\" VALUE=\"Reset\" name=\"B2\">\n</p>\n"),
	write("</form>\n").
  add_user_to_software(Software,[parm("LIST",User)|LIST]):-
	str_int(User,UserId),
	trap(add_license(UserId,Software),_,fail),!,
	add_user_to_software(Software,LIST).
  add_user_to_software(_,_):-
	write_common_page_start("Error: UserID NOT found").

  wr_list_of_users([parm("LIST",Val)|Rest]):-!,
	write("<input TYPE=\"hidden\" NAME=\"LIST\" VALUE=\"",Val,"\">\n"),
	wr_list_of_users(Rest).
  wr_list_of_users(_).


/*****************************************************************************
  Command: Add new user for a given software confirmed even that the number
  of licenses are actually used !
*****************************************************************************/

predicates
  procedure add_user_to_software_confirmed(softwareId,parmlist)

clauses
  add_user_to_software_confirmed(Software,[parm("B1",_)|_]):-!,
	show_software(Software).
  add_user_to_software_confirmed(Software,[parm("LIST",User)|LIST]):-
	str_int(User,UserId),
	trap(add_license(UserId,Software),_,fail),!,
	add_user_to_software(Software,LIST).
  add_user_to_software_confirmed(_,_):-
	write_common_page_start("Error: UserID NOT found").

/*****************************************************************************
  Command: Delete a software for a user
*****************************************************************************/

predicates
  procedure delete_softwareforuser(userId,softwareId)

clauses
  delete_softwareforuser(User,Software):-
	remove_license(User,Software),
	show_software(Software).

/*****************************************************************************
  Command: Rename software
*****************************************************************************/

predicates
  procedure updatesoftware(softwareId,string Name,integer NoOfLicenses,parmList)

clauses
  updatesoftware(SoftwareId,SoftwareName,NoOfLicenses,ParmList):-
	remove_empty_params(ParmList,Filtered),
	update_software(SoftwareId,SoftwareName,NoOfLicenses,Filtered),
	show_software(SoftwareId).

/*****************************************************************************
  Command: Add new software
*****************************************************************************/

predicates
  procedure add_new_software(string Name,integer NoOfLicenses,parmList)

clauses
  add_new_software("",_,_):-!,
	error_page("Software Name MUST be specified").
  add_new_software(Name,_,_):-
	software(_,Name),!,
	error_page("Error: Software name already used").
  add_new_software(Name,NoOfLicenses,ParmList):-
	Id = getnewid(),
	remove_empty_params(ParmList,Filtered),
	add_software(Id,Name,NoOfLicenses,Filtered),
	show_all_software().

/*****************************************************************************
  Command: Delete a software - has been confirmed
*****************************************************************************/

predicates
  procedure confirmed_delete_software(softwareId)

clauses
  confirmed_delete_software(SoftwareId):-
	remove_software(SoftwareId),
	show_all_software().

/*****************************************************************************
  Command: Request to delete software
*****************************************************************************/

predicates
  procedure delete_software(softwareId)

clauses
  delete_software(SoftwareId):-
	software(SoftwareId,SoftwareName),!,
	write_common_page_start("Are you Sure ?"),
	write("<p><A HREF=\"license.exe?action=confirmed_delete_software&software=",SoftwareId,"\">Yes, Please Delete ",SoftwareName,"</A></p>\n"),
	write("<p><A HREF=\"license.exe?action=show_all_software\">UPS That was a mistake</A></p>\n").
  delete_software(_):-
	write_common_page_start("Error: Software NOT found !").

/*****************************************************************************
  Command: Show User Fields
*****************************************************************************/

predicates
  procedure show_user_fields()
  procedure show_software_fields()
  procedure show_customizable_fields(fieldList,string Title,string NextCommand)-(i,i,i)
  procedure write_rowof_field_list(fieldList)-(i)
  procedure getchecked(string OnOff,string Checked)-(i,o)
  procedure getrowscols(fieldSpec,string Rows,string Cols)-(i,o,o)

clauses
  show_user_fields():-
	FieldList = get_user_field_list(),
	show_customizable_fields(FieldList,"Customizable fields for Users","update_user_field_information").

  show_software_fields():-
	FieldList = get_software_field_list(),
	show_customizable_fields(FieldList,"Customizable fields for Software","update_software_field_information").

  show_customizable_fields(FieldList,Title,Command):-
	write_common_page_start(Title),
	write("<p>It is possible to specify what information to record.\n"),
	write("It is possible to Add new fields, delete fields or change the title.\n"),
	write("Also it can be selected which fields to show in the table.\n"),
	write("Changes does not affect the data already recorded.</p>\n"),
	write("<form method=\"POST\" action=\"license.exe\">\n"),
	write("<input TYPE=\"hidden\" name=\"action\" VALUE=\"",Command,"\">\n"),
	write("<p><table  bgcolor=yellow border=1>\n"),
	write("<tr><td>Field Name<td>Col. Heading<td>Rows<td>Cols<td>Show<br>in table</tr>\n"),
	write_rowof_field_list(FieldList),
	% Add 5 empty !
	write_rowof_field_list([field("","","",text(40))]),
	write_rowof_field_list([field("","","",text(40))]),
	write_rowof_field_list([field("","","",text(40))]),
	write_rowof_field_list([field("","","",text(40))]),
	write_rowof_field_list([field("","","",text(40))]),
	write("<tr><td align=center colspan=\"5\"><input type=\"submit\" VALUE=\"Update\" name=\"B1\">\n"),
	write("<input type=\"reset\" VALUE=\"Reset\" name=\"B2\"></tr>\n\n"),
	write("</form>\n"),
	write("</table></p>\n").

  write_rowof_field_list([]).
  write_rowof_field_list([field(OnOff,FieldName,Title,FieldSpec)|FieldList]):-
	getchecked(OnOff,Checked),
	getrowscols(FieldSpec,Rows,Cols),
	write("<tr>\n"),
	write("<td><input type=\"text\" name=\"name$",FieldName,"\" value=\"",FieldName,"\" size=\"10\"></td>\n"),
	write("<td><input type=\"text\" name=\"title$",FieldName,"\" value=\"",Title,"\" size=\"30\"></td>\n"),
	write("<td><input type=\"text\" name=\"rows$",FieldName,"\" value=\"",Rows,"\" size=\"4\"></td>\n"),
	write("<td><input type=\"text\" name=\"cols$",FieldName,"\" value=\"",Cols,"\" size=\"4\"></td>\n"),
	write("<td><input type=\"checkbox\" name=\"onoff$",FieldName,"\" value=\"ON\" ",Checked,"></td>\n"),
	write("</tr>\n"),
	write_rowof_field_list(FieldList).

  getchecked("ON","checked"):-!.
  getchecked(_,"").

  getrowscols(text(Size),"",Cols):-
	str_int(Cols,Size).
  getrowscols(textarea(Rows,Cols),RowsStr,ColsStr):-
	str_int(RowsStr,Rows),
	str_int(ColsStr,Cols).

/*****************************************************************************
  Command: Update customizable Fields
*****************************************************************************/

predicates
  procedure update_software_field_information(parmlist)-(i)
  procedure update_user_field_information(parmlist)-(i)
  procedure parmlist2fieldlist(parmList,FieldList)-(i,o)
  procedure getName(parmList,string FieldName,parmList)-(i,o,o)
  procedure getTitle(parmList,string FieldName,string Title,parmList)-(i,i,o,o)
  procedure getFieldSpec(parmList,string FieldName,fieldSpec,parmList)-(i,i,o,o)
  procedure getOnOff(parmList,string OnOff,parmList)-(i,o,o)
  erroneous returnerror()
  procedure check_new_Fieldlist(fieldlist,fieldlist)-(i,o)

clauses
  update_software_field_information(Parmlist):-
	write_common_page_start("Updating Software Information"),
	trap(parmlist2fieldlist(Parmlist,Fieldlist),_,returnerror()),
	trap(check_new_Fieldlist(Fieldlist,Fieldlist1),_,returnerror()),
	set_software_field_list(FieldList1),
	write("<h2>Fields successfully Updated</h2>\n").

  update_user_field_information(Parmlist):-
	write_common_page_start("Updating User Information"),
	trap(parmlist2fieldlist(Parmlist,Fieldlist),_,returnerror()),
	trap(check_new_Fieldlist(Fieldlist,Fieldlist1),_,returnerror()),
	set_user_field_list(FieldList1),
	write("<h2>Fields successfully Updated</h2>\n").

  returnerror():-
	write("<p>Use Back button and correct mistake !</p>\n"),
	exit().

  parmlist2fieldlist([],[]):-!.
  parmlist2fieldlist([parm("B1",_)],[]):-!.
  parmlist2fieldlist(ParmList,[field(OnOff,FieldName,Title,FieldSpec)|FieldList]):-
	getName(ParmList,FieldName,List1),
	getTitle(List1,FieldName,Title,List2),
	getFieldSpec(List2,FieldName,FieldSpec,List3),
	getOnOff(List3,OnOff,RestParmList),
	parmlist2fieldlist(RestParmList,FieldList).

  getName([parm(SS,FieldName)|Rest],FieldName,Rest):-
	concat("name$",_,SS),!.
  getName(PArmList,_,_):-
	write("<p>Error in input argument? ",ParmList,"</p>"),
	errorexit().

  getTitle([parm(SS,Title)|Rest],_,Title,Rest):-
	concat("title$",_,SS),!.
  getTitle(_,FieldName,_,_):-
	write("<p>Error in Title for: ",FieldName,"</p>"),
	errorexit().

  getOnOff([parm(SS,_)|Rest],"ON",Rest):-
	concat("onoff$",_,SS),!.
  getOnOff(Rest,"",Rest).

  getFieldSpec([parm(SS1,RowsStr),parm(SS2,ColsStr)|Rest],_,textarea(Rows,Cols),Rest):-
	concat("rows$",_,SS1),
	concat("cols$",_,SS2),
	str_int(RowsStr,Rows),
	str_int(ColsStr,Cols),
	Rows>1,Rows<100,          % Very arbitrary - but this is just a demo !!
	Cols>0,Cols<1000,
	!.
  getFieldSpec([parm(SS1,_),parm(SS2,ColsStr)|Rest],_,text(Cols),Rest):-
	concat("rows$",_,SS1),
	concat("cols$",_,SS2),
	str_int(ColsStr,Cols),
	Cols>0,Cols<1000,	 % So Rows was Bad, try Cols 
	!.
  getFieldSpec(_,FieldName,_,_):-
	write("<p>Error in Rows/Cols for: ",FieldName,"</p>"),
	errorexit().

  check_new_Fieldlist([],[]).
  check_new_Fieldlist([field(_,"",_,_)|FieldList],Checked):-!, % Drop the not named !
	check_new_Fieldlist(FieldList,Checked).
  check_new_Fieldlist([field(OnOff,FieldName,Title,FieldSpec)|FieldList],_):-
	member(field(OnOff,FieldName,Title,FieldSpec),FieldList),!,
	write("<p>Error Duplicated field: ",FieldName,"</p>"),
	errorexit().
  check_new_Fieldlist([H|Rest],[H|Checked]):-
	check_new_Fieldlist(Rest,Checked).

/*****************************************************************************
	Report error if untrapped error occurs!
*****************************************************************************/
predicates
 handle_error() - erroneous ()
clauses
  handle_error():-
	lasterror(ErrorNo,FileName,_IncludeFileName,Position),
	write("<h1>Runtime Error</h1><p>Error Code=",ErrorNo,"<br>\n"),
	write("FileName=",FileName,"<br>\n"),
	write("Position=",Position,"<p>\n"),
	write("<p>Please report to <a href=mailto:leo@pdc.dk>leo@pdc.dk</a>\n"),
	write("</body>\n"),
	write("</html>\n"),
	exit.


/*****************************************************************************
	Select Action !

 Based on the first parameter value in the ParmList, Select which action to
 perform !
*****************************************************************************/

predicates
  procedure select_action(parmlist)-(i)
  procedure convNoOfLicenses(string,integer)-(i,o) % Returns 0 if string invalid

clauses
  select_action([]):-!,
	show_all_users().
  select_action([parm("action","show_all_users")]):-!,
	show_all_users().
  select_action([parm("action","show_all_software")]):-!,
	show_all_software().
  select_action([parm("action","show_user_fields")]):-!,
	show_user_fields().
  select_action([parm("action","show_software_fields")]):-!,
	show_software_fields().
  select_action([parm("action","update_user_field_information")|ParmList]):-!,
	update_user_field_information(Parmlist),
	db_save().
  select_action([parm("action","update_software_field_information")|ParmList]):-!,
	update_software_field_information(Parmlist),
	db_save().
  select_action([parm("action","show_user"),parm("user",User)]):-
	str_int(User,UserId),!,
	show_user(UserId).
  select_action([parm("action","show_software"),parm("software",Software)]):-
	str_int(Software,SoftwareId),!,
	show_software(SoftwareId).
  select_action([parm("action","add_new_software"),parm("name",Name),parm("nooflicenses",SNo)|ParmList]):-
	convNoOfLicenses(SNo,NoOfLicenses),!,
	add_new_software(Name,NoOfLicenses,ParmList),
	db_save().
  select_action([parm("action","add_new_user"),parm("name",Name)|ParmList]):-!,
	add_new_user(Name,ParmList),
	db_save().
  select_action([parm("action","add_user_to_software"),parm("name",Software)|List]):-
	str_int(Software,SoftwareId),!,
	add_user_to_software(SoftwareId,List),
	db_save().
  select_action([parm("action","add_user_to_software_confirmed"),parm("name",Software)|List]):-
	str_int(Software,SoftwareId),!,
	add_user_to_software_confirmed(SoftwareId,List),
	db_save().
  select_action([parm("action","add_software_to_user"),parm("name",User)|List]):-
	str_int(User,UserID),!,
	add_software_to_user(UserId,List),
	db_save().
  select_action([parm("action","renameuser"),parm("id",User),parm("name",Name)|ParmList]):-
	str_int(User,UserID),!,
	renameuser(UserID,Name,ParmList),
	db_save().
  select_action([parm("action","updatesoftware"),parm("id",Software),parm("name",Name),parm("nooflicenses",SNo)|ParmList]):-
	str_int(Software,SoftwareId),
	convNoOfLicenses(SNo,NoOfLicenses),!,
	updatesoftware(SoftwareId,Name,NoOfLicenses,ParmList),
	db_save().
  select_action([parm("action","delete_softwareforuser"),parm("user",User),parm("software",Software)]):-
	str_int(User,UserID),str_int(Software,SoftwareId),!,
	delete_softwareforuser(UserID,SoftwareId),
	db_save().
  select_action([parm("action","delete_userforsoftware"),parm("user",User),parm("software",Software)]):-
	str_int(User,UserID),str_int(Software,SoftwareId),!,
	delete_userforsoftware(UserId,SoftwareId),
	db_save().
  select_action([parm("action","confirmed_delete_software"),parm("software",Software)]):-
	str_int(Software,SoftwareId),!,
	confirmed_delete_software(SoftwareId),
	db_save().
  select_action([parm("action","delete_software"),parm("software",Software)]):-
	str_int(Software,SoftwareId),!,
	delete_software(SoftwareId),
	db_save().
  select_action([parm("action","delete_user"),parm("user",User)]):-
	str_int(User,UserID),!,
	delete_user(UserID),
	db_save().
  select_action([parm("action","confirmed_delete_user"),parm("user",User)]):-
	str_int(User,UserID),!,
	confirmed_delete_user(UserID),
	db_save().
  select_action(List):-
	write_common_page_start("Unknown input argument for licenseViewer"),
	write("<p>",List,"</p>\n").

  convNoOfLicenses(SNo,NoOfLicenses):-
	trap(str_int(SNo,NoOfLicenses),_,fail),!.
  convNoOfLicenses(_,0).

/*****************************************************************************
	Main Goal
*****************************************************************************/

goal	write("Content-type: text/html\n\n"),
	write("<html>\n"),
	db_load("license.pdb"),
	ParmList = cgi_GetParmList(),
%	write("<PRE>Command: ",ParmList,"</PRE>\n"),
	trap(select_action(ParmList),_,handle_error()),
	write("</body>\n"),
	write("</html>\n").
