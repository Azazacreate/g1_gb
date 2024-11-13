unit Call_dll;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    CheckBox1: TCheckBox;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Control: HWND;

implementation

{$R *.DFM}

procedure dll2_getString(var Value: PChar); stdcall; external 'DLL2.DLL' name 'dll2_getstring';
procedure dll2_mark_gstack(var Stack: Longint); stdcall; external 'DLL2.DLL' name 'dll2_mark_gstack';
procedure dll2_release_gstack(Stack: Longint); stdcall; external 'DLL2.DLL' name 'dll2_release_gstack';

procedure TForm1.Button2Click(Sender: TObject);
const
  Head: PChar = 'From Prolog DLL: ';
 var
  S: array[0..50] of Char;
  ValueS: PChar;
  Stack: Longint;
begin
  dll2_mark_gstack(Stack);
  dll2_getString(ValueS);
  StrCopy(S, Head);
  StrCat(S, ValueS);
  dll2_release_gstack(Stack);
  ShowMessage(String(S));
end;

function MyCallback1(InpString: PChar): Longint; stdcall;
const
  HeadC: PChar = 'In Callback: ';
 var
  SC: array[0..50] of Char;
begin
  StrCopy(SC, HeadC);
  StrCat(SC, InpString);
  ShowMessage(String(SC));
end;

procedure dll2_callCallback(Funct: Longint); stdcall; external 'DLL2.DLL' name 'dll2_callCallback';

procedure TForm1.Button1Click(Sender: TObject);
var
  Funct: Longint;
begin
  Funct := Longint(@MyCallback1);
  dll2_callCallback(Funct);
end;

type
  Rct = record
        L, T, R, B: Longint
        end;
const
  RctCtrl : Rct = (L: 5; T: 40; R: 210; B: 190);

function dll1_custom_Create(Parent: HWND;var Rect: Rct; Ident: Integer): HWND; stdcall; external 'DLL1.DLL' name 'dll1_custom_Create';
procedure dll1_custom_Destroy(Control: HWND); stdcall; external 'DLL1.DLL' name 'dll1_custom_Destroy';

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then
    begin
    Control := dll1_custom_Create(Form1.Handle, RctCtrl, 100)
    end
  else
    dll1_custom_Destroy( Control );
end;

end.
