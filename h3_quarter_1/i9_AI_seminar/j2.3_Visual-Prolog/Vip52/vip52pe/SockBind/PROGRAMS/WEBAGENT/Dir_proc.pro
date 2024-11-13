/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  WEBAGENT
 FileName: DIR_PROC.PRO
 Purpose: Example of HTTP Layer
 Written by: Konstantin Ivanov
 Comments:
******************************************************************************/

include "webagent.inc"
include "webagent.con"
include "hlptopic.con"

DOMAINS
  STAMP=s(UNSIGNED Hour,UNSIGNED Min,UNSIGNED Sec,UNSIGNED Year,UNSIGNED Month,UNSIGNED Day,ULONG Size);dir
  
DATABASE - dirs_base
  all_dirs(STRING,BOOLEAN Tested)
  all_files(STRING)
  
PREDICATES
  get_cur_dirs(STRING) - (i)
  get_all_dirs()
  delete_files(STRING) - (i)
  get_cur_dirs_f(STRING) - (i)
  get_all_dirs_f()  
  del_spec_dir(STRING) - (i)   
CLAUSES
  check_row_dir():-
  	options(_,_,_,_,_,1),
  	uri_entry(_,_,_,_,setts(_,_,_,Dir,_),_,_,_),
  		format(P,"%s",Dir),
  		del_dirry(P),
  		
  	fail.
  check_row_dir():-
  	options(_,_,_,_,RS,1),
  	retractall(done_lst(_,_)),
  	trap(deletefile(RS),_,true),
  	!.
  check_row_dir().
  	
  del_dirry(Path_u):-
  	upper_lower(Path_u,Path),
        delete_files(Path),
        delete_dirs(Path),
        !.
  del_dirry(_).
   
  del_spec_dir(Path):-trap(rmdir(Path),_,true),!.
  	 
  delete_dirs(PathBeg):-
  	asserta(all_dirs(PathBeg,0)), % begin
  	get_all_dirs(),
  	retract(all_dirs(PathBeg,_)),
  	retract(all_dirs(Name,_)),
  		trap(rmdir(Name),_,true),
  	fail.
  delete_dirs(_).
  
  delete_files(PathBeg):-
  	asserta(all_dirs(PathBeg,0)), % begin
  	get_all_dirs_f(),
  	retract(all_dirs(PathBeg,_)),
  	retractall(all_dirs(_,_)),
	retract(all_files(Name)),
	        trap(deletefile(Name),_,true),
	fail.
  delete_files(_).
  
  get_cur_dirs(""):-!.
  get_cur_dirs(Path):-
  	concat(PATH,"\\*.*",PP),
        trap(dirfiles(PP,0x10,SUBDIR,_,_,_,_,_,_,_,_),_,true),
        	SUBDIR >< ".",
	       	SUBDIR >< "..",
		upper_lower(SUBDIR,SUBDIR_l),
		upper_lower(PATH,PATH_l),
		PATH_l <> SUBDIR_l,
	       	format(NEWPATH,"%\\%",PATH,SUBDIR),
	       	asserta(all_dirs(NEWPATH,0)),
	fail.
  get_cur_dirs(_).

  get_all_dirs():-
  	retract(all_dirs(Dir,0)),
	asserta(all_dirs(Dir,1)),
	get_cur_dirs(Dir),!,
	get_all_dirs().
  get_all_dirs().
  
  get_cur_dirs_f(""):-!.
  get_cur_dirs_f(Path):-
  	concat(PATH,"\\*.*",PP),
        trap(dirfiles(PP,0x10,SUBDIR,_,_,_,_,_,_,_,_),_,true),
        	SUBDIR >< ".",
	       	SUBDIR >< "..",
		upper_lower(SUBDIR,SUBDIR_l),
		upper_lower(PATH,PATH_l),
		PATH_l <> SUBDIR_l,
	       	format(NEWPATH,"%\\%",PATH,SUBDIR),
	       	asserta(all_dirs(NEWPATH,0)),
	fail.
  get_cur_dirs_f(Path):-
        concat(PATH,"\\*.*",PP),
        trap(dirfiles(PP,0x40,FName,_,_,_,_,_,_,_,_),_,true),
                format(FullName,"%\\%",PATH,FName),
                assert(all_files(FullName)),
	fail.
  get_cur_dirs_f(_).

  get_all_dirs_f():-
  	retract(all_dirs(Dir,0)),
	asserta(all_dirs(Dir,1)),
	get_cur_dirs_f(Dir),!,
	get_all_dirs_f().
  get_all_dirs_f().