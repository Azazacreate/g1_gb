/*****************************************************************************

		Copyright (c) 1984 - 1999 Prolog Development Center A/S

 Project:  JavaClient
 FileName: 
 Purpose: Example of communication between Java-written applet and Prolog-written program
 Written by: Konstantin Ivanov
 Comments: MS J++ build of an example fine works in Netscape Navigator and J++ Execute command
			but not under MS IE
******************************************************************************/
import java.awt.*;
import java.applet.*;
import java.awt.*;
import java.net.*;
import java.io.*;
import java.lang.*;
import java.util.StringTokenizer;

public class JavaClient extends Applet {

    public Socket Sock = null;
    public BufferedInputStream in;
    public DataOutputStream out;
    public ReadDataTh ReadData = null;

    public void init() {

        super.init();

        //{{INIT_CONTROLS
        setLayout(null);
        addNotify();
        resize(insets().left + insets().right + 554, insets().top + insets().bottom + 347);
        label1=new Label("Status:");
        add(label1);
        label1.reshape(insets().left + 14,insets().top + 19,49,17);
        state=new Label("");
        add(state);
        state.reshape(insets().left + 67,insets().top + 19,353,17);
        conn=new Button("Connect");
        add(conn);
        conn.reshape(insets().left + 434,insets().top + 4,98,22);
        disconn=new Button("Disconnect");
        disconn.disable();
        add(disconn);
        disconn.reshape(insets().left + 434,insets().top + 32,98,22);
        label3=new Label("Database name:");
        add(label3);
        label3.reshape(insets().left + 14,insets().top + 75,98,15);
        dbs1= new Choice();
        add(dbs1);
        dbs1.reshape(insets().left + 142,insets().top + 75,227,68);
        keys1=new List();
        add(keys1);
        keys1.reshape(insets().left + 142,insets().top + 116,227,92);
        label4=new Label("Key:");
        add(label4);
        label4.reshape(insets().left + 14,insets().top + 116,63,23);
        NewBut1=new Button("New");
        NewBut1.disable();
        add(NewBut1);
        NewBut1.reshape(insets().left + 434,insets().top + 75,98,23);
        edit2=new Button("Edit");
        edit2.disable();
        add(edit2);
        edit2.reshape(insets().left + 434,insets().top + 116,98,23);
        save1=new Button("Save");
        save1.disable();
        add(save1);
        save1.reshape(insets().left + 434,insets().top + 191,98,23);
        label5=new Label("Value:");
        add(label5);
        label5.reshape(insets().left + 14,insets().top + 233,105,22);
        Desc=new TextArea(4,47);
        add(Desc);
        Desc.reshape(insets().left + 138,insets().top + 233,394,78);
        cancledt=new Button("Cancel Edit");
        cancledt.disable();
        add(cancledt);
        cancledt.reshape(insets().left + 434,insets().top + 148,98,25);
        //}}
        Desc.setEditable(false);
    }

    public boolean handleEvent(Event event) {
        if (event.id == Event.ACTION_EVENT && event.target == cancledt) {
                clickedCancledt();
                return true;
        }
        else
        if (event.id == Event.ACTION_EVENT && event.target == save1) {
                clickedSave1();
                return true;
        }
        else
        if (event.id == Event.ACTION_EVENT && event.target == edit2) {
                clickedEdit2();
                return true;
        }
        else
        if (event.id == Event.ACTION_EVENT && event.target == NewBut1) {
                clickedNewBut1();
                return true;
        }
        else
        if (event.id == Event.LIST_SELECT && event.target == keys1) {
                selChangeKeys1();
                return true;
        }
        else
        if (event.id == Event.ACTION_EVENT && event.target == dbs1) {
                selectedDbs1();
                return true;
        }
        else
        if (event.id == Event.ACTION_EVENT && event.target == disconn) {
                clickedDisconn();
                return true;
        }
        else
        if (event.id == Event.ACTION_EVENT && event.target == conn) {
                clickedConn();
                return true;
        }
        else
        if (event.id == Event.WINDOW_DESTROY) {
    	        if( Sock != null ){
    	            try{
    	                Sock.close();
    	            }catch( IOException e ){
    	                state.setText("Exception occurred " + e );
    	            }
    	        }
    	        if( ReadData != null ){
    	            ReadData.stop();
    	        }
                return false;
        }

        return super.handleEvent(event);
    }
    //{{DECLARE_CONTROLS
    Label label1;
    Label state;
    Button conn;
    Button disconn;
    Label label3;
    Choice dbs1;
    List keys1;
    Label label4;
    Button NewBut1;
    Button edit2;
    Button save1;
    Label label5;
    TextArea Desc;
    Button cancledt;
    //}}

    public Choice clearChoice(){

        //I don't know other way to clear Choice control
        dbs1.hide();
        dbs1 = new Choice();
        add(dbs1);
        dbs1.reshape(insets().left + 133,insets().top + 75,245,68);
        return dbs1;
    }

    public void sendRequest( String Request, int ReqLen ){

        byte buf[] = new byte[ ReqLen + 1 ];
        Request.getBytes(0, ReqLen, buf, 0 );
        try{
            out.write(buf, 0, ReqLen+1 );
        }catch( IOException e ){
            state.setText( "Exception occurred " + e );
        }
    }

    public void setConnection( String HostName, int Port ){

        try{
            Sock = new Socket( HostName, Port );
            disconn.enable();
            NewBut1.enable();
            edit2.enable();
            conn.disable();
            state.setText("Connection with " + HostName + ":" + Port + " established");
            in  = new BufferedInputStream(Sock.getInputStream());
            out  = new DataOutputStream(Sock.getOutputStream());
            ReadData = new ReadDataTh(in, dbs1, keys1, Desc, NewBut1, edit2, save1, cancledt, state, this );
            ReadData.start();
        }catch( IOException e ){
            state.setText( "Exception occurred " + e );
        }

    }
    public void addNewKey( String KeyName, String KeyVal ){

        String Sel_db = dbs1.getSelectedItem();
        String Request = "req_add(\"" + Sel_db + "\",\"" + KeyName + "\",\"" + KeyVal + "\")";
        sendRequest( Request, Request.length() );
//        ReadData.resume();
    }
    public void clickedConn() {

        Frame DlgPar = new Frame();

        ConnectionDlg theConnectionDlg;
        theConnectionDlg = new ConnectionDlg( this, DlgPar );
        theConnectionDlg.show();
    }

    public void clickedDisconn() {

        state.setText("Not connected");
/*        try{
            in.close();
            out.close();
        }catch( IOException e ){
        }*/
        ReadData.stop();
        try{
            ReadData.join();
        }catch( InterruptedException e ){
            state.setText( "Exception occurred " + e );
        }
        try{
            Sock.close();
        }catch( IOException e ){
            state.setText( "Exception occurred " + e );
        }
        disconn.disable();
        NewBut1.disable();
        edit2.disable();
        cancledt.disable();
        save1.disable();
        conn.enable();
        keys1.clear();
        keys1.enable();
        Desc.setText("");
        Desc.setEditable(false);

        clearChoice();
    }

    public void selectedDbs1() {

        String Sel_db = dbs1.getSelectedItem();
        Desc.setText("");
        String Request = "req_key_list(\"" + Sel_db + "\")";
        sendRequest( Request, Request.length() );
//        ReadData.resume();
    }

    public void selChangeKeys1() {

        String Sel_db = dbs1.getSelectedItem();
        String Sel_key = keys1.getSelectedItem();
        Desc.setText("");
        String Request = "req_find(\"" + Sel_db + "\",\"" + Sel_key + "\")";
        sendRequest( Request, Request.length() );
//        ReadData.resume();
    }

    public void clickedNewBut1() {

        Frame DlgPar = new Frame();

        NewKeyDlg theNewKeyDlg;
        theNewKeyDlg = new NewKeyDlg( this, DlgPar );
        theNewKeyDlg.show();
    }

    public void clickedEdit2() {

        String Sel_db = dbs1.getSelectedItem();
        String Sel_key = keys1.getSelectedItem();
        String Request = "req_ed(\"" + Sel_db + "\",\"" + Sel_key + "\")";
        sendRequest( Request, Request.length() );
//        ReadData.resume();
    }

    public void clickedSave1() {

        String Sel_db = dbs1.getSelectedItem();
        String Sel_key = keys1.getSelectedItem();
        String NewDesc = Desc.getText();
        String Request = "req_save(\"" + Sel_db + "\",\"" + Sel_key + "\",\"" + NewDesc + "\")";
        sendRequest( Request, Request.length() );
//        ReadData.resume();
    }

    public void clickedCancledt() {

        String Sel_db = dbs1.getSelectedItem();
        String Sel_key = keys1.getSelectedItem();
        String Request = "req_removelock(\"" + Sel_db + "\",\"" + Sel_key + "\")";
        sendRequest( Request, Request.length() );
        Desc.setEditable(false);
        keys1.enable();
        dbs1.enable();
        NewBut1.enable();
        save1.disable();
        cancledt.disable();
        edit2.enable();

        selChangeKeys1();   //to return to prev. value of key
    }
}

class ReadDataTh extends Thread{

    BufferedInputStream in;
    Choice Db_lst;
    List Keys;
    TextArea Desc;
    StringTokenizer st;
    Button NewB;
    Button EditB;
    Button SaveB;
    Button CnlEdtB;
    Label state;
    JavaClient Papa;

    public ReadDataTh( BufferedInputStream in, Choice Db_lst, List keys, TextArea Descr,
                        Button NewB, Button EditB, Button SaveB, Button CnlEdtB, Label state,
                        JavaClient AppletPar ) {
        this.in     = in;
        this.Db_lst = Db_lst;
        this.Keys   = keys;
        this.Desc   = Descr;
        this.NewB   = NewB;
        this.EditB  = EditB;
        this.SaveB  = SaveB;
        this.CnlEdtB = CnlEdtB;
        this.state  = state;
        this.Papa   = AppletPar;
    }

    public void readDblist(){

        Db_lst = Papa.clearChoice();
        Keys.clear();
        Desc.setText("");
        while( st.hasMoreTokens() ){
            String s = st.nextToken();
            Db_lst.addItem(s);
        }
//        this.suspend();
    }
    public void readKeyVal(){

        String s;

        s = st.nextToken(); //pass Db_name
        s = st.nextToken(); //pass Key_name
        s = st.nextToken( "\")" ); //pass ,
        while( st.hasMoreTokens() ){
            s = st.nextToken();
            String s1 = Desc.getText();
            Desc.setText( s );
        }
//        this.suspend();
    }
    public void readKeyValEd(){

        String s;

        s = st.nextToken(); //pass Db_name
        s = st.nextToken(); //pass Key_name
        s = st.nextToken( "\")" ); //pass ,
        while( st.hasMoreTokens() ){
            s = st.nextToken();
            String s1 = Desc.getText();
            Desc.setText( s );
        }
        Desc.setEditable(true);
        Keys.disable();
        Db_lst.disable();
        NewB.disable();
        SaveB.enable();
        CnlEdtB.enable();
        EditB.disable();
//        this.suspend();
    }
    public void readKeylist(){

        String s;

        Keys.clear();
        s = st.nextToken(); //pass Db_name
        while( st.hasMoreTokens() ){
            s = st.nextToken();
            Keys.addItem(s);
        }
//        this.suspend();
    }

    public void run() {

        for(;;){
            String content = "";
            try {
                int Avail;
/*                do{
                    Avail = in.available();
                    if ( Avail != 0 ){
                        byte buf[] = new byte[ Avail ];
                        int N_b = in.read( buf, 0, Avail );
                        content = new String( buf, 0 );
                        break;
                    }
                }while( Avail == 0 );*/

                byte bf_tmp[] = new byte[ 1 ];
                int N_b = in.read();  //blocks until some incoming data comes
                if ( N_b != -1 ){
                    Avail = in.available();
                    byte buf[] = new byte[ Avail + 1 ];
                    buf[0] = ( byte ) N_b;
                    if( Avail != 0 ){
                       N_b = in.read( buf, 1, Avail );
                    }
                    content = new String( buf, 0 );
                }else{
                    break;
                }
                content = content.trim();
                st = new StringTokenizer(content,"\",[]\\()",false);
                if( st.hasMoreTokens() ){
                    String s = st.nextToken();
                    if( s.equalsIgnoreCase( "res_db_list" ) ){
                        readDblist();
                    }
                    if( s.equalsIgnoreCase( "res_key_list" ) ){
                        readKeylist();
                    }
                    if( s.equalsIgnoreCase( "res_find_failed" ) ){
                        state.setText("KEY NOT FOUND");
//                        this.suspend();
                    }
                    if( s.equalsIgnoreCase( "res_find" ) ){
                        readKeyVal();
                    }
                    if( s.equalsIgnoreCase( "res_ed" ) ){
                        readKeyValEd();
                    }
                    if( s.equalsIgnoreCase( "res_ed_failed" ) ){
                        state.setText("KEY NOT FOUND");
//                        this.suspend();
                    }
                    if( s.equalsIgnoreCase( "res_ed_locked" ) ){
                        state.setText("KEY LOCKED");
//                        this.suspend();
                    }
                    if( s.equalsIgnoreCase( "res_save" ) ){
                        state.setText("Key value was saved");
                        Desc.setEditable(false);
                        Keys.enable();
                        Db_lst.enable();
                        NewB.enable();
                        SaveB.disable();
                        CnlEdtB.disable();
                        EditB.enable();
//                        this.suspend();
                    }
                    if( s.equalsIgnoreCase( "res_add_succes" ) ){
                        state.setText("Key was added");
                        //no suspend because key list will follow
                    }
                    if( s.equalsIgnoreCase( "res_add_failed" ) ){
                        state.setText("KEY NOT FOUND");
//                        this.suspend();
                    }
                }
            }catch (IOException e) {
                state.setText( "Exception occurred " + e );
            }
        }//end of for
   }
}
