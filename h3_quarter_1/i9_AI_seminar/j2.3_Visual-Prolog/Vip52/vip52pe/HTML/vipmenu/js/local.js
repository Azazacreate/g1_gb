//!  var ToolBar_Supported = ToolBar_Supported ;
if (ToolBar_Supported != null && ToolBar_Supported == true)
{
  //To Turn on/off Frame support, set Frame_Supported = true/false.
//  Frame_Supported = false;

  // Customize default ICP menu color - bgColor, fontColor, mouseoverColor
     setDefaultICPMenuColor("#003399", "white", "ffcc00");

  // Customize toolbar background color
//   setToolbarBGColor("white");

  //***** Add ICP menus *****
  //Company
  addICPMenu("DAMenu", "The Company", "","");
  addICPSubMenu("DAMenu","Company Profile","/pdc-uk/html/company-profile.htm");
  addICPSubMenu("DAMenu","How to Find PDC","/pdc-uk/html/pdc-info.htm");
  addICPSubMenu("DAMenu","Contact Persons","/pdc-uk/html/pdc-info.htm#contact_persons");
  addICPSubMenuLine("DAMenu");
  addICPSubMenu("DAMenu","Useful Information about Denmark and Copenhagen","/pdc-uk/html/pdc-info.htm#Usefull information about Copenhagen and Denmark");


  //Products
  addICPMenu("ProductMenu", "Products & Services", "","");
  addICPSubMenu("ProductMenu","Intelligent Scheduling - CAPS","/caps/index.htm");
  addICPSubMenu("ProductMenu","Staff Scheduling - StaffPlan","/pdc-uk/html/staff.htm");
  addICPSubMenu("ProductMenu","Development Tool - Visual Prolog","/vip/pdcindex.htm");
  addICPSubMenuLine("ProductMenu");
  addICPSubMenu("ProductMenu","Turn-key Software Development","/pdc-uk/html/turnkey.htm");
  addICPSubMenu("ProductMenu","Outsourcing of Development","/pdc-uk/html/outsourcing.htm");


  //Selling Solutions
  addICPMenu("SSMenu", "Solutions", "","");
  addICPSubMenu("SSMenu","Airlines / Airports","/pdc-uk/html/airline.htm");
  addICPSubMenu("SSMenu","Industry / Trade","/pdc-uk/html/industry.htm");
  addICPSubMenu("SSMenu","Public","/pdc-uk/html/public.htm");




  //Tech Support
  addICPMenu("TSMenu", "EU Research", "","");
addICPSubMenu("TSMenu","Home Information Centre","/pdc-uk/html/flex.htm");
addICPSubMenu("TSMenu","Supply Chain Management","/pdc-uk/html/chaman.htm");
addICPSubMenu("TSMenu","Hospital Ressource Management","/pdc-uk/html/realise.htm");
addICPSubMenu("TSMenu","Shop Floor Scheduling","/pdc-uk/html/cimreflex.htm");


 
  //Contact Us
  addICPMenu("contMenu", "Home", "","/pdc-uk/index.htm");

}
