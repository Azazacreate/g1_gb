/*
	Copyright (c) 2000 Prolog Development Center A/S
*/

if( pdcScr ){

//	cssClass(className,rules);
	cssClass('scrElem','display:none;');

//	mnuStyle(font-family,font-size,font-style,font-weight;color,over-color)
	mnuStyle("Verdana",12,"normal","bold","#FFFFFF","#FFCC00");

//  barStart(left,top,height,bg-image)
	barStart(0,0,130,"vipmenu/images/topbar-alt.gif");	

//		mnuStart(left,top,height,bg-color)


		mnuStart(260,85,18,"#003399");

			mnuItem("Visual Prolog","javascript:void(null)",95,true);
				subMnuStart(224);
					subItem("Product Info","viptechinfo/pdcindex.htm");
					subItem("What's New","vip/vipinfo/news.htm");
					subItem("Articles","vip/vipinfo/articles.htm");
						subSeparator();
					subItem("FAQ","vip/vipinfo/faq.htm");
					subItem("3'rd Party Products","vipexamples/third_party_tools_and_libraries.htm");
					subItem("Course at PDC","vip/vipinfo/course.htm"); 
					subItem("Recommended Links","vip/vipinfo/business_links.htm"); 
					subItem("VIP Best Practice","vipbestpractice/pdcindex.htm");

				subMnuEnd();

mnuSeparator();
			mnuItem("Support","javascript:void(null)",60,true);
                               subMnuStart(186);	
					subItem("Support Home Page","vipsupport/pdcindex.htm");
					subItem("Knowledge Base","vipsupport/knownbugs/pdcindex.htm");
					subItem("Support FAQ","vipsupport/faq/pdcindex.htm"); 
					subItem("Contact Support Team","vipsupport/write_us/pdcindex.htm");
						subSeparator();
					subItem("Discussion Forum","http://discuss.visual-prolog.com/ubbcgi/forumdisplay.cgi?action=topics&number=1&start=here");


				subMnuEnd();
		


				

mnuSeparator();
			mnuItem("Demos & Applications","javascript:void(null)",150,true);
	subMnuStart(186);
					subItem("Visual Prolog Demos","vipexamples/pdcindex.htm");
					subItem("End User Applications","vipexamples/applications.htm");
				subMnuEnd();
mnuSeparator();
			mnuItem("Downloads","javascript:void(null)",80,true);
	subMnuStart(222);
					subItem("Visual Prolog Personal Edition","vip/vipinfo/freeware_version.htm");
					subItem("Patches","vipsupport/patches/pdcindex.htm");
					subItem("Demo Programs","vipexamples/pdcindex.htm");
					
				subMnuEnd();
mnuSeparator();
			mnuItem("Prices & Ordering","javascript:void(null)",125,true);
				subMnuStart(194);
					subItem("Order Form","vip/vipinfo/ordrfrm1.htm");
					subItem("Distributors","vip/vipinfo/distrib.htm");

				subMnuEnd();
mnuSeparator();
			mnuItem("About PDC","javascript:void(null)",75,true);
				subMnuStart(194);
					subItem("The Company","vip/vipinfo/company.htm");
					subItem("E-mail to PDC","mailTo:sales@visual-prolog.com");
					subItem("Web Site in US","http://www.visual-prolog.com");
					subItem("Web Site in Europe","http://www.pdc.dk/vip/");

				subMnuEnd();


mnuSeparator();
			mnuItem("Home","vip/pdcindex.htm",92,false);
		


mnuEnd(true);
//	barEnd(topOffsetOfHeader);
	barEnd('<br><br><br><br><br><br>');

	allDraw();
}