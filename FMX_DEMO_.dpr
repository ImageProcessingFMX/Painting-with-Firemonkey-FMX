program FMX_DEMO_;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit_drawing_with_firemonkey in 'Unit_drawing_with_firemonkey.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
