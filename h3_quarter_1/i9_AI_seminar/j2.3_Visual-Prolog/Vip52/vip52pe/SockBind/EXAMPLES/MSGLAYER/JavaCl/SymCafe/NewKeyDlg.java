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

    NewKeyDlg theNewKeyDlg;
    theNewKeyDlg = new NewKeyDlg(this);
    theNewKeyDlg.show();

    You can add controls to AboutBox with Cafe Studio.
    (Menus can be added only to subclasses of Frame.)
 */

import java.awt.*;

public class NewKeyDlg extends Dialog {

    JavaClient Papa;

    public NewKeyDlg( JavaClient AppletPar, Frame parent ) {

	    super(parent, "New Key", true);

	    Papa = AppletPar;

	    //{{INIT_CONTROLS
        setLayout(null);
        addNotify();
        resize(insets().left + insets().right + 374, insets().top + insets().bottom + 180);
        OkB=new Button("OK");
        add(OkB);
        OkB.reshape(insets().left + 259,insets().top + 7,98,19);
        CnlB=new Button("Cancel");
        add(CnlB);
        CnlB.reshape(insets().left + 259,insets().top + 33,98,19);
        label1=new Label("Key Name:");
        add(label1);
        label1.reshape(insets().left + 16,insets().top + 11,77,21);
        label2=new Label("Key Value:");
        add(label2);
        label2.reshape(insets().left + 16,insets().top + 46,77,19);
        keyname=new TextField(15);
        add(keyname);
        keyname.reshape(insets().left + 98,insets().top + 11,126,22);
        keyval=new TextArea(4,40);
        add(keyval);
        keyval.reshape(insets().left + 14,insets().top + 72,336,71);
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
    	    String KeyName = keyname.getText();
    	    String KeyVal = keyval.getText();
    	    dispose();
    	    hide();
    	    Papa.addNewKey( KeyName, KeyVal );
    	    return true;
    	}
    	else

    	if (event.id == Event.WINDOW_DESTROY) {
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
    TextField keyname;
    TextArea keyval;
    //}}
}


