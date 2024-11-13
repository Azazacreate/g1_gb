<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<html>

<head>
<meta http-equiv="Content-Type"
content="text/html; charset=iso-8859-1">
<meta name="GENERATOR" content="Microsoft FrontPage 2.0">
<title></title>
<base target="main">
</head>

<!--body link="#C0C0C0" alink="#C0C0C0" vlink="#C0C0C0"-->
<body background="images/grytxtr5.jpg" link="#C0C0C0" alink="#C0C0C0" vlink="#C0C0C0">

<p>Session : <%=Session.SessionID%><br>
</p>

<form action="W3ESTA.DLL?EstaStartPage" method="POST">
    <input type="hidden" name="SessionID"
    value="<%=Session.SessionID%>">
    <input type="hidden" name="ESTAcommand" value="EstaStartPage">
   <!-- <input type="hidden" name="APP_PATH" value="<%=Request.ServerVariables("PATH_TRANSLATED")%>"> -->
   <p>Select theme:<br>
    <select name="KbSelection" size="4">
        <option value="car.kb"> Car fault diagnosis </option>
        <option value="demo.kb"> ESTA Demo </option>
        <option value="sanocor.kb"> Sanocor Helth Hazardous System </option>
        <option value="1aid.kb"> Simple 1st Aid </option>
    </select> </p>
    <hr>
    <p>
       <!--input type="submit" name="Load" value="Load"--> 
       <!--input type="submit" name="BeginConsult" value="Begin Consultation"-->
       <!--input type="submit" name="LastAdvice" value="Show Last Advice"--> 
       <input type="image"  name="Load" src="images/grayload.gif" alt="Load Selected Knowledge Base"> 
       <input type="image"  name="BeginConsult" src="images/graybegn.gif" alt="Begin Consultation">
       <a href="help/The_ESTA.htm">
          <img src="images/grayhelp.gif">
       </a> </p>
</form>
</body>
</html>
