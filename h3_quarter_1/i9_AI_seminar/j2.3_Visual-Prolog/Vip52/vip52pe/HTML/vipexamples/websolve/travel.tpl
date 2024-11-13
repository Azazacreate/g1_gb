<HTML>

<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=windows-1251">
<META NAME="Generator" CONTENT="Microsoft Word 97">
<TITLE>Travel</TITLE>
</HEAD>

<BODY LINK="#0000ff" VLINK="#800080" BACKGROUND="Image1.gif">
<DIR>
<B><FONT SIZE=5><P>The Travel Expenses Model</P>
<FORM ACTION="solver32.exe" METHOD="POST"></DIR>
</B></FONT>
<TABLE CELLSPACING=0 BORDER=0 CELLPADDING=7 WIDTH=576>
<TR><TD WIDTH="30%" VALIGN="TOP">
<P ALIGN="CENTER"><A HREF="TravelMdl.html">The Travel Expenses Model</A></TD>
<TD WIDTH="33%" VALIGN="TOP">
<P ALIGN="CENTER"><A HREF="ShowTravelStart.html">Travel HTML Start Page Code</A></TD>
<TD WIDTH="38%" VALIGN="TOP">
<P ALIGN="CENTER"><A HREF="ShowTravelTamplate.html">Travel HTML Template Page Code</A></TD>
</TR>
</TABLE>

<FONT FACE="Arial"><P>&nbsp;</P></FONT>
<TABLE BORDER CELLSPACING=2 BORDERCOLOR="#000000" CELLPADDING=3 WIDTH=378 ALIGN="LEFT" HSPACE=12>
<TR><TD WIDTH="70%" VALIGN="TOP" HEIGHT=36>
<B><FONT FACE="Arial"><P>Distance</B></FONT></TD>
<TD WIDTH="30%" VALIGN="TOP"  $cDist$  HEIGHT=36>
<FONT FACE="Arial"><P ALIGN="RIGHT">
<INPUT TYPE="TEXT" MAXLENGTH="30" NAME="Dist" VALUE="$vDist$">
</FONT></TD>
</TR>
<TR><TD WIDTH="70%" VALIGN="TOP">
<B><FONT FACE="Arial"><P>Travel Time</B></FONT></TD>
<TD WIDTH="30%" VALIGN="TOP" $cTime$>
<FONT FACE="Arial"><P ALIGN="RIGHT">
<INPUT TYPE="TEXT" MAXLENGTH="30" NAME="Time" VALUE="$vTime$">
</FONT></TD>
</TR>
<TR><TD WIDTH="70%" VALIGN="TOP">
<B><FONT FACE="Arial"><P>Travel Speed</B></FONT></TD>
<TD WIDTH="30%" VALIGN="TOP" $cSpeed$>
<FONT FACE="Arial"><P ALIGN="RIGHT">
<INPUT TYPE="TEXT" MAXLENGTH="30" NAME="Speed" VALUE="$vSpeed$">
</FONT></TD>
</TR>
<TR><TD WIDTH="70%" VALIGN="TOP">
<B><FONT FACE="Arial"><P>Gasoline / Dist. Unit</B></FONT></TD>
<TD WIDTH="30%" VALIGN="TOP" $cGasPU$>
<FONT FACE="Arial"><P ALIGN="RIGHT">
<INPUT TYPE="TEXT" MAXLENGTH="30" NAME="GasPU" VALUE="$vGasPU$">
</FONT></TD>
</TR>
<TR><TD WIDTH="70%" VALIGN="TOP">
<B><FONT FACE="Arial"><P>Amount of gasoline</B></FONT></TD>
<TD WIDTH="30%" VALIGN="TOP" $cGasTot$>
<FONT FACE="Arial"><P ALIGN="RIGHT">
<INPUT TYPE="TEXT" MAXLENGTH="30" NAME="GasTot" VALUE="$vGasTot$">
</FONT></TD>
</TR>
<TR><TD WIDTH="70%" VALIGN="TOP">
<B><FONT FACE="Arial"><P>Gas's price / Vol. Unit</B> </FONT></TD>
<TD WIDTH="30%" VALIGN="TOP" $cGasPrice$>
<FONT FACE="Arial"><P ALIGN="RIGHT">
<INPUT TYPE="TEXT" MAXLENGTH="30" NAME="GasPrice" VALUE="$vGasPrice$">
</FONT></TD>
</TR>
<TR><TD WIDTH="70%" VALIGN="TOP">
<B><FONT FACE="Arial"><P>Total cost of Gasoline</B></FONT></TD>
<TD WIDTH="30%" VALIGN="TOP" $cGasCost$>
<FONT FACE="Arial"><P ALIGN="RIGHT">
<INPUT TYPE="TEXT" MAXLENGTH="30" NAME="GasCost" VALUE="$vGasCost$">
</FONT></TD>
</TR>
</TABLE>

<INPUT TYPE="HIDDEN" NAME="usrOnSrcConflict" VALUE="BGCOLOR=#008000">
<INPUT TYPE="HIDDEN" NAME="usrOnResConflict" VALUE="BGCOLOR=#ffff00">
<INPUT TYPE="HIDDEN" NAME="usrOnPreset" VALUE="">
<INPUT TYPE="HIDDEN" NAME="usrOnVoid" VALUE="">
<INPUT TYPE="HIDDEN" NAME="usrOnSolved" VALUE="BGCOLOR=#00ffff">
<INPUT TYPE="HIDDEN" NAME="usrOnNotSolved" VALUE="BGCOLOR=#00800f">
<INPUT TYPE="HIDDEN" NAME="usrOnInvalidData" VALUE="BGCOLOR=#0080ff">
<INPUT TYPE="HIDDEN" NAME="slvTEMPL" VALUE="TRAVEL.TPL">
<INPUT TYPE="HIDDEN" NAME="slvRULE"
VALUE="Speed*Time+(-1)*Dist,
Dist*GasPU+(-1)*GasTot,
GasTot*GasPrice+(-1)*GasCost">

<FONT FACE="Arial"><P>
<INPUT TYPE="SUBMIT" VALUE="Resolve">
</P>
<DIR>
<P>
<TEXTAREA ROWS="3" COLS="40" NAME="slvMSG">
$mMsg$
</TEXTAREA>
</P>
<P>
<TEXTAREA ROWS="6" COLS="40" NAME="slvINFO">
Sorry, this Model can not be edited.
All changes will be ignored!
=========================
 Dist=Speed*Time,
 GasTot=Dist*GasPU,
 GasCost=GasTot*GasPrice
</TEXTAREA>
</P></DIR>
</FORM>
</FONT></BODY>
</HTML>
