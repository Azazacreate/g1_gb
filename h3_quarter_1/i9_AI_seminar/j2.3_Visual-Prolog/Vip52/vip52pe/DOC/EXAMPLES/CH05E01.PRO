/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH05E01.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  person                 = person(name,address)
  name                   = name(first,last)
  address                = addr(street,city,state)
  street                 = street(number,street_name)
  city,state,street_name = string
  first,last             = string
  number                 = integer

goal
  P1 = person(name("jim","mos"),addr(street(5,"1st st"),"igo","CA")),
  P1 = person(name(_,"mos"),Address),
  P2 = person(name("jane","mos"),Address),
  write("P1=",P1),nl,
  write("P2=",P2),nl.