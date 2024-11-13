<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<title></title>
<base target="main">




<meta name="Microsoft Theme" content="prolog2 000, default">
<meta name="Microsoft Border" content="none">
</head>
<!--body link="#C0C0C0" alink="#C0C0C0" vlink="#C0C0C0"-->

<body bgcolor="#FFFFFF" text="#333333" link="#0000FF" vlink="#008080" alink="#00FFFF"><!--mstheme--><font face="verdana, Arial, Helvetica">

<p>Session : <%=Session.SessionID%><br>
</p>

<form action="w3esta.dll?EstaStartPage" method="POST">
  <input type="hidden" name="SessionID" value="<%=Session.SessionID%>"><input type="hidden" name="APP_PATH" value="<%=Request.ServerVariables("PATH_TRANSLATED")%>"><p>Select theme:<br>
  <select name="KbSelection" size="4">
    <option value="car.kb"> Car fault diagnosis </option>
    <option value="sanocor.kb"> Sanocor Helth Hazardous System </option>
    <option value="1aid.kb"> Simple 1st Aid </option>
    <option value="psoriasis.kb"> Psoriasis </option>
  </select> </p>
  <p><!--input type="submit" name="Load" value="Load"--> <!--input type="submit" name="BeginConsult" value="Begin Consultation"--> <!--input type="submit" name="LastAdvice" value="Show Last Advice"--> <input type="image" name="Load" src="images/grayload.gif" alt="Load Selected Knowledge Base" WIDTH="110" HEIGHT="28"> <input type="image" name="BeginConsult" src="images/graybegn.gif" alt="Begin Consultation" WIDTH="110" HEIGHT="28"> <a href="/esta/pdcindex.htm"><img src="images/grayhelp.gif" WIDTH="110" HEIGHT="28"> </a></p>
</form>

<p>&nbsp;</p>

<p>&nbsp;</p>

<p>&nbsp;</p>

<p>&nbsp;</p>

<p>&nbsp;</p>

<p>&nbsp;</p>

<p align="center"><a href="/vip/pdcindex.htm">Back to Home</a></p>
<!--mstheme--></font></body>
</html>
