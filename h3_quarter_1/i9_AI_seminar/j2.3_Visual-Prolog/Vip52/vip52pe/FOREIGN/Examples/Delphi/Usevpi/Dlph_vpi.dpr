program Dlph_vpi;

uses
  Forms,
  Call_dll in 'Call_dll.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
