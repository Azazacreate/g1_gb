/*****************************************************************************

		Copyright (c) 1984 - 1999 Prolog Development Center A/S

 Project:  JavaClient
 FileName:
 Purpose: Example of communication between Java-written applet and Prolog-written program
 Written by: Konstantin Ivanov
 Comments:
******************************************************************************/
/*
    This class is a basic extension of the Dialog class.  It can be used
    by subclasses of Frame.  To use it, create a reference to the class,
    then instantiate an object of the class (pass 'this' in the constructor),
    and call the show() method.

    example:

    ConnectionDlg theConnectionDlg;
    theConnectionDlg = new ConnectionDlg(this);
    theConnectionDlg.show();

    You can add controls to AboutBox with Cafe Studio.
    (Menus can be added only to subclasses of Frame.)
 */

import java.awt.*;

public class ConnectionDlg extends Dialog {

    JavaClient Papa;

    public ConnectionDlg(JavaClient AppletPar, Frame parent) {

        super(parent, "Connect to:", true);

        Papa = AppletPar;

	    //{{INIT_CONTROLS
        setLayout(null);
        addNotify();
        resize(insets().left + insets().right + 379, insets().top + insets().bottom + 114);
        OkB=new Button("OK");
        add(OkB);
        OkB.reshape(insets().left + 266,insets().top + 7,98,19);
        CnlB=new Button("Cancel");
        add(CnlB);
        CnlB.reshape(insets().left + 266,insets().top + 33,98,19);
        label1=new Label("Hostname:");
        add(label1);
        label1.reshape(insets().left + 7,insets().top + 10,77,19);
        label2=new Label("Port:");
        add(label2);
        label2.reshape(insets().left + 7,insets().top + 46,77,19);
        host=new TextField(15);
        add(host);
        host.reshape(insets().left + 96,insets().top + 10,126,19);
        port=new TextField(15);
        add(port);
        port.reshape(insets().left + 96,insets().top + 46,126,21);
        //}}

    	setResizable(false);
    }

    public synchronized void show() {

    	Rectangle bounds = getParent().bounds();
    	move(bounds.x + 50,bounds.y + 50);
    	super.show();
    }

    public synchronized void wakeUp() {
    	notify();
    }

    public boolean handleEvent(Event event) {
    	if (event.id == Event.ACTION_EVENT && event.target == CnlB) {
    	        dispose();
    	    	hide();
    	    	return true;
    	}
    	else
    	if (event.id == Event.ACTION_EVENT && event.target == OkB) {
                String Host = host.getText();
                Integer P_num = new Integer(port.getText());
                int Port = P_num.intValue();
                dispose();
                hide();
                Papa.setConnection( Host, Port );
    	    	return true;
    	}
    	else

    	if (event.id == Event.WINDOW_DESTROY) {
    	    dispose();
    	    hide();
    	    return true;
    	}
    	return super.handleEvent(event);
    }

    //{{DECLARE_CONTROLS
    Button OkB;
    Button CnlB;
    Label label1;
    Label label2;
    TextField host;
    TextField port;
    //}}

}


