<html>

<head>
<meta HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=windows-1251">
<meta NAME="GENERATOR" CONTENT="Microsoft FrontPage 3.0">
<title>Travel</title>
</head>

<body LINK="#0000ff" VLINK="#800080" BACKGROUND="Image1.gif">

<dir>
  <font SIZE="5"><b><p>The Travel Expenses Model!</p>
  <form ACTION="http://195.97.146.68/vipexamples/websolve/solver32.exe" METHOD="POST">
  </form>
</dir>
</b></font>

<table CELLSPACING="0" BORDER="0" CELLPADDING="7" WIDTH="576">
  <tr>
    <td WIDTH="30%" VALIGN="TOP"><p ALIGN="CENTER"><a HREF="TravelMdl.html">The Travel
    Expenses Model</a></td>
    <td WIDTH="33%" VALIGN="TOP"><p ALIGN="CENTER"><a HREF="ShowTravelStart.html">Travel HTML
    Start Page Code</a></td>
    <td WIDTH="38%" VALIGN="TOP"><p ALIGN="CENTER"><a HREF="ShowTravelTemplate.html">Travel
    HTML Template Page Code</a></td>
  </tr>
</table>
<font FACE="Arial">

<p>&nbsp;</p>
</font>

<table BORDER="1" CELLSPACING="2" BORDERCOLOR="#000000" CELLPADDING="3" WIDTH="378"
ALIGN="LEFT" HSPACE="12">
  <tr>
    <td WIDTH="70%" VALIGN="TOP" HEIGHT="36"><font FACE="Arial"><b>Distance</b></font></td>
    <td WIDTH="30%" VALIGN="TOP" $cDist$ HEIGHT="36"><font FACE="Arial"><p ALIGN="RIGHT"><input
    TYPE="TEXT" MAXLENGTH="30" NAME="Dist" VALUE="$vDist$" size="20"> </font></td>
  </tr>
  <tr>
    <td WIDTH="70%" VALIGN="TOP"><font FACE="Arial"><b>Travel Time</b></font></td>
    <td WIDTH="30%" VALIGN="TOP" $cTime$><font FACE="Arial"><p ALIGN="RIGHT"><input
    TYPE="TEXT" MAXLENGTH="30" NAME="Time" VALUE="$vTime$" size="20"> </font></td>
  </tr>
  <tr>
    <td WIDTH="70%" VALIGN="TOP"><font FACE="Arial"><b>Travel Speed</b></font></td>
    <td WIDTH="30%" VALIGN="TOP" $cSpeed$><font FACE="Arial"><p ALIGN="RIGHT"><input
    TYPE="TEXT" MAXLENGTH="30" NAME="Speed" VALUE="$vSpeed$" size="20"> </font></td>
  </tr>
  <tr>
    <td WIDTH="70%" VALIGN="TOP"><font FACE="Arial"><b>Gasoline / Dist. Unit</b></font></td>
    <td WIDTH="30%" VALIGN="TOP" $cGasPU$><font FACE="Arial"><p ALIGN="RIGHT"><input
    TYPE="TEXT" MAXLENGTH="30" NAME="GasPU" VALUE="$vGasPU$" size="20"> </font></td>
  </tr>
  <tr>
    <td WIDTH="70%" VALIGN="TOP"><font FACE="Arial"><b>Amount of gasoline</b></font></td>
    <td WIDTH="30%" VALIGN="TOP" $cGasTot$><font FACE="Arial"><p ALIGN="RIGHT"><input
    TYPE="TEXT" MAXLENGTH="30" NAME="GasTot" VALUE="$vGasTot$" size="20"> </font></td>
  </tr>
  <tr>
    <td WIDTH="70%" VALIGN="TOP"><font FACE="Arial"><b>Gas's price / Vol. Unit</b> </font></td>
    <td WIDTH="30%" VALIGN="TOP" $cGasPrice$><font FACE="Arial"><p ALIGN="RIGHT"><input
    TYPE="TEXT" MAXLENGTH="30" NAME="GasPrice" VALUE="$vGasPrice$" size="20"> </font></td>
  </tr>
  <tr>
    <td WIDTH="70%" VALIGN="TOP"><font FACE="Arial"><b>Total cost of Gasoline</b></font></td>
    <td WIDTH="30%" VALIGN="TOP" $cGasCost$><font FACE="Arial"><p ALIGN="RIGHT"><input
    TYPE="TEXT" MAXLENGTH="30" NAME="GasCost" VALUE="$vGasCost$" size="20"> </font></td>
  </tr>
</table>
<!--webbot bot="HTMLMarkup" startspan TAG="XBOT" --><INPUT TYPE="HIDDEN" NAME="usrOnSrcConflict" VALUE="BGCOLOR=#008000"><!--webbot bot="HTMLMarkup" endspan
-->
<!--webbot bot="HTMLMarkup" startspan TAG="XBOT" --><INPUT TYPE="HIDDEN" NAME="usrOnResConflict" VALUE="BGCOLOR=#ffff00"><!--webbot bot="HTMLMarkup"
endspan -->
<!--webbot bot="HTMLMarkup" startspan TAG="XBOT" --><INPUT TYPE="HIDDEN" NAME="usrOnPreset" VALUE><!--webbot
bot="HTMLMarkup" endspan -->
<!--webbot bot="HTMLMarkup" startspan TAG="XBOT" --><INPUT TYPE="HIDDEN" NAME="usrOnVoid" VALUE><!--webbot
bot="HTMLMarkup" endspan -->
<!--webbot bot="HTMLMarkup" startspan TAG="XBOT" --><INPUT TYPE="HIDDEN" NAME="usrOnSolved" VALUE="BGCOLOR=#00ffff"><!--webbot
bot="HTMLMarkup" endspan -->
<!--webbot bot="HTMLMarkup" startspan TAG="XBOT" --><INPUT TYPE="HIDDEN" NAME="usrOnNotSolved" VALUE="BGCOLOR=#00800f"><!--webbot
bot="HTMLMarkup" endspan -->
<!--webbot bot="HTMLMarkup" startspan TAG="XBOT" --><INPUT TYPE="HIDDEN" NAME="usrOnInvalidData" VALUE="BGCOLOR=#0080ff"><!--webbot
bot="HTMLMarkup" endspan -->
<!--webbot bot="HTMLMarkup" startspan TAG="XBOT" --><INPUT TYPE="HIDDEN" NAME="slvTEMPL" VALUE="TRAVEL.TPL"><!--webbot
bot="HTMLMarkup" endspan -->
<!--webbot bot="HTMLMarkup" startspan TAG="XBOT" --><INPUT TYPE="HIDDEN" NAME="slvRULE" VALUE="Speed*Time+(-1)*Dist,
Dist*GasPU+(-1)*GasTot,
GasTot*GasPrice+(-1)*GasCost"><!--webbot
bot="HTMLMarkup" endspan -->
<font FACE="Arial">

<p><input TYPE="SUBMIT" VALUE="Resolve"> 

<dir>
  <p><textarea ROWS="3" COLS="60" NAME="slvMSG">$mMsg$</textarea> </p>
</dir>

<dir>
  <p><textarea ROWS="5" COLS="60" NAME="slvINFO">Sorry, this is the Model which can not be edited.
All changes will be ignored!
=====================================
Dist=Speed*Time,
GasTot=Dist*GasPU,
GasCost=GasTot*GasPrice</textarea> </p>
</dir>
</font>
</body>
</html>
