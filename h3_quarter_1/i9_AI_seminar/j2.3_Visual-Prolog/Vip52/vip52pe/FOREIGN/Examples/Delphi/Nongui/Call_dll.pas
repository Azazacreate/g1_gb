unit Call_dll;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Button2: TButton;
    Edit2: TEdit;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit6: TEdit;
    Edit5: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure getInteger(var Value: Integer); stdcall; external 'TESTDLL.DLL' name 'getInteger';

procedure TForm1.Button1Click(Sender: TObject);
var
  ValueI: Integer;
begin
  getInteger(ValueI);
  Edit5.Text := IntToStr(ValueI);
end;

procedure setInteger(Value: Integer); stdcall; external 'TESTDLL.DLL' name 'setInteger';

procedure TForm1.Button4Click(Sender: TObject);
var
  ValueIS: Integer;
begin
  if Edit6.Text <> '' then
    ValueIS := StrToInt(Edit6.Text)
  else
    ValueIS := 0;
  setInteger(ValueIS);
end;

procedure getReal(var Value: Double); stdcall; external 'TESTDLL.DLL' name 'getReal';

procedure TForm1.Button2Click(Sender: TObject);
var
  ValueR: Double;
begin
  getReal(ValueR);
  Edit3.Text := FloatToStr(ValueR);
end;

procedure setReal(Value: Double); stdcall; external 'TESTDLL.DLL' name 'setReal';

procedure TForm1.Button5Click(Sender: TObject);
var
  ValueRS: Double;
begin
  if Edit4.Text <> '' then
    ValueRS := StrToFloat(Edit4.Text)
  else
    ValueRS := 0.0;
  setReal(ValueRS);
end;

procedure getString(var Value: PChar); stdcall; external 'TESTDLL.DLL' name 'getString';
procedure dll_mark_gstack(var Stack: Longint); stdcall; external 'TESTDLL.DLL' name 'dll_mark_gstack';
procedure dll_release_gstack(Stack: Longint); stdcall; external 'TESTDLL.DLL' name 'dll_release_gstack';

procedure TForm1.Button3Click(Sender: TObject);
var
  OutStr: PChar;
  Stack: Longint;
  S: array[0..120] of Char;
begin
  dll_mark_gstack(Stack);
  getString(OutStr);
  StrCopy(S,OutStr);
  dll_release_gstack(Stack);
  Edit2.Text := S;
end;

procedure setString(Value: TCaption); stdcall; external 'TESTDLL.DLL' name 'setString';

procedure TForm1.Button6Click(Sender: TObject);
var
  ValueSS: TCaption;
  SetStr: TCaption;
begin
  ValueSS := Edit1.Text;
  if ValueSS <> '' then
    SetStr := ValueSS
  else
    SetStr := 'Empty';
  setString(SetStr);
end;

end.
