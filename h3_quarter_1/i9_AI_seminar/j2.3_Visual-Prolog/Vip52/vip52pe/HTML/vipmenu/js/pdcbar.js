/*
Copyright (c) 2000 Prolog Development Center A/S
Written by: Andrey Basukinsky (ab@pdc.spb.su)
*/

var netNav = (document.layers)? true:false;
var msExpl = (document.all)? true:false;
var isWin  = (navigator.userAgent.toLowerCase().indexOf("win")!=-1)? true:false;

if( isWin  && (netNav || msExpl)){
	var barL, barT, barH, barW, barId, barCnt = 0; barBG = '';
	var mnuL, mnuT, mnuH, mnuW, mnuId, mnuCnt = 0; mnuBC = '',mnuSep = '', mnuW = 0;
	var subL, subT, subH, subW, subId, subCnt = 0; subOffs = -6; subOpnd = null;
	var itmL, itmT, itmCnt = 0, itmId, itmOffs = 12;
	var imgCnt  = 0;
	var pdcScr	=  true;
	var currSub = null; currItm = null; currLnk = null; 
	var cssStr	= '\n<style type="text/css">';
	var barStr	= '', mnuStr = '', subStr = '', runStr = '';
	var bgName	= 'background-image:URL';
	var bcName	= 'background-color:'
		if(netNav){	
	bgName = 'layer-' + bgName;
	bcName = 'layer-' + bcName;
	var winW =  window.innerWidth - 26; 
	var winH =  window.innerHeight;
		}
		else
	var winW =  document.body.clientWidth; 
	window.onresize=redraw;
}

function barStart(left,top,height,rel_url){
	bgImg = formURL(rel_url);
	barL=left; barT=top; barH=height; barBG=bgImg;
	barId = 'pdcBar'+barCnt;
	barStr += '\n<div id="'+barId+'"></div>';
	attachEhndl(null,barId,'mouseover','subHide');
}

function barEnd(space){
	barW = (winW > mnuL + itmL)? winW - barL : mnuL + itmL - barL;
	addCss(barId,barL,barT,barH,barW,null,barBG,'z-index:0;');
	barStr += '\n'+space+'\n';
	barCnt ++;
}

function mnuImage(rel_url,imgW){
	imgUrl = formURL(rel_url);
	imgId = "img" + imgCnt;
	subStr += '\n<div id="'+imgId+'"></div>';
	imgL = mnuL + itmL; 
	addCss(imgId,imgL,8,mnuH,imgW,null,imgUrl,'z-index:9;');
	imgCnt ++;
	mnuL += imgW + itmOffs; 
}

function mnuStyle(font,size,style,weight,color,over){
	var mnuStyle = 'font-family:'+font+';font-size:'+size+'px;font-style:'+style+';font-weight:'+weight+';text-decoration:none;';
	cssStr += '\n.itmOut  {color:'+color+';'+mnuStyle+'}'; 
	cssStr += '\n.itmOver {color:'+over +';'+mnuStyle+'}';
}

function mnuSeparator(){
	sepId = "mnuSep" + itmCnt;
	mnuStr += '<span id="'+sepId+'" class=itmOut>|</span>';
	cssStr +='\n#'+sepId+' {position:absolute;top:0px;height:'+mnuH+'px;left:'+itmL+'px;}';
	itmL += 12;
}

function mnuStart(left,top,height,bgColor){
	mnuL=left; mnuT=top; mnuH=height; mnuBC=bgColor; 
	itmL	= itmOffs;
	mnuId   = 'mnuLin' + mnuCnt;
	mnuStr += '\n<table border=0 cellpadding=0 cellspacing=0><tr><td nowrap>';
	mnuStr += '<div id="'+mnuId+'">';
		if(mnuCnt == 0){ 
	cssStr  += '\n.mnuItm {position:absolute;top:0px;height:'+mnuH+'px;}';
	cssStr  += '\n.subItm {position:absolute;left:6px;height:'+mnuH+'px;}';
		}
}

function mnuEnd(fitToWin){
		if(fitToWin)
	mnuW = (winW > itmL + mnuL)? winW - mnuL : itmL;
		else
	mnuW	= itmL;
	addCss(mnuId,mnuL,mnuT,mnuH,mnuW,mnuBC,null,'z-index:1;');
	mnuStr += '</div>';
	mnuStr += '</td></tr></table>';
	mnuCnt ++;
}

function mnuItem(title,rel_url,width,haveSubMnu){
	url = formURL(rel_url);
	itmId = 'mnuItm' + itmCnt;
	subId = haveSubMnu ? 'subMnu' + itmCnt : null;
	var itmEH  = ' onMouseOver="mnuOver('+subId+','+itmId+',this'+')"';
		if(msExpl)
	itmEH += ' onMouseOut="mnuOut('+subId+','+itmId+',this'+')"'; 
	var itmHtm ='<span id="'+itmId+'" class="mnuItm">'+
			    '<a class="itmOut" href="'+url+'"'+itmEH+'>'+title+'</a>'+
				'</span>';
	mnuStr += itmHtm;
	cssStr +='\n#'+itmId+' {left:'+itmL+'px;}';
	subL	= mnuL + itmL + subOffs;
	itmL   += width; itmCnt++;
}

function subMnuStart(subWidth){
	subW  = subWidth;
	subT  = mnuT + mnuH; subItmT = 0;
	subH  = 0; subCnt = 0
	subStr +='\n<div id="'+subId+'">';
	attachEhndl(null,subId,'mouseout','subHide');
	subSep(0,5);
}

function subMnuEnd(){
	subH += 6;
	subStr += '\n</div>';
	addCss(subId,subL,subT,subH,subW,"#003399",null,"visibility:hidden;z-index:1;");
}

function subItem(title,rel_url){
	url = formURL(rel_url);
	var itmId  = 'subItm' + itmCnt + subCnt;
	var itmEH  = ' onMouseOver="mnuOver(null,'+itmId+',this'+')"';
		if(msExpl)
	itmEH += ' onMouseOut="mnuOut(null,'+itmId+',this'+')"'; 
	var itmHtm ='\n<span id="'+itmId+'" class="subItm">'+
			    '<a class="itmOut" href="'+url+'"'+itmEH+'>'+title+'</a>'+
				'</span>';
	subStr += itmHtm;
	cssStr +='\n#'+itmId+' {top:'+subItmT+'px;}'
	subItmT += mnuH; subCnt++;
	subH += mnuH;
}

function subSeparator(){
	subSep(6,6);
}
function subSep(topOffs,nextOffs){
	var offs = topOffs + nextOffs + 1;
	var sepT = subItmT + topOffs;
	var sepId = "subSep" + itmCnt + subCnt;
	subStr +='\n<span id="'+sepId+'"></span>';
	addCss(sepId,0,sepT,1,subW,"#FFFFFF",null,"");
	subH += offs;
	subItmT += offs;
}

function mnuOver(sub,itm,lnk){
	mnuOut(currSub,currItm,currLnk);
 	subShow(sub,itm);
		if(netNav){
	var parId  = (sub == null) ? null : sub.id;
	var itmEH  = ' onMouseOut="mnuOut('+parId+','+itm.id+',this'+')"';
	var itmLnk = '<a class="itmOver" href="'+lnk.href+'"'+itmEH+'>'+lnk.text+'</a>';
	itm.document.open();itm.document.write(itmLnk);itm.document.close();
	}
		else{
	lnk.className = 'itmOver';
	event.cancelBubble = true;
	}
    currSub = sub; currItm = itm; currLnk = lnk;
}

function mnuOut(sub,itm,lnk){
		if(itm != null){
		if(netNav){
	var parId  = (sub == null) ? null : sub.id;
	var itmEH  = ' onMouseOver="mnuOver('+parId+','+itm.id+',this'+')"';
	var itmLnk = '<a class="itmOut" href="'+lnk.href+'"'+itmEH+'>'+lnk.text+'</a>';
	itm.document.open();itm.document.write(itmLnk);itm.document.close();
		}
		else{
	lnk.className = 'itmOut';
	event.cancelBubble = true;
		}
    currSub = null; currItm = null; currLnk = null;
	}
}

function subShow(sub,itm){
	if(itm.id.search("mnuItm")==0)
	subHide();
	if(sub != null){
		if(netNav)
	sub.visibility='show';
		else{
	sub.style.visibility='visible'; 
	event.cancelBubble = true;
		}
	subOpnd = sub;
	}
}	

function subHide(){
	if(subOpnd != null){
		if(netNav){
	subOpnd.visibility='hide';
	subOpnd = null;
		}
		else 
	if( ! (subOpnd.contains(event.toElement))){
	subOpnd.style.visibility='hidden'; 
	event.cancelBubble = true;
	subOpnd = null;
		}
	}
}

function allDraw(){
	cssStr +='\n</style>\n';
	document.write(cssStr);
	document.write(mnuStr);
	document.write(subStr);
	document.write(barStr);
	eval(runStr);
}

function cssClass(className,rules){
	cssStr += '\n.'+className+' {'+rules+'}'; 
}

function addCss(itmId,l,t,h,w,bc,bg,other){
	cssStr += '\n#'+itmId+' {position:absolute;';
	cssStr += 'left:'+l+'px;top:'+t+'px;';
		if(h != null){
	cssStr += 'height:'+h+'px;width:'+w+'px;';
	cssStr += 'clip:rect(0px,'+w+'px,'+h+'px,0px);';
		}
		if(bc != null)
	cssStr += bcName+bc+';';
		if(bg != null)
	cssStr += bgName+'('+bg+');';
	cssStr += other + '}';
}

function attachEhndl(parId,elmId,evnt,ehndl){
	var par = (parId == null)? '' : 'document.'+parId+'.';
		if(netNav){
	var obj = par+'document.'+elmId;
	runStr += obj+'.captureEvents(Event.'+evnt+');';
	}
		else
	var obj = elmId;
	runStr += obj+'.on'+evnt+'='+ehndl+';';
	
}

function redraw(){
	if ((netNav && (winW != (window.innerWidth - 26) || winH!=window.innerHeight)) || msExpl)
	history.go(0);
}

function formURL(url){
	var lowUrl = url.toLowerCase();
		if(
	lowUrl.search("mailto:") != -1 ||
	lowUrl.search("http:") != -1 ||
	lowUrl.search("javascript:") != -1
		)
	return url;
		else 
	return toRoot + url;
}
