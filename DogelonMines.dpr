program DogelonMines;

{$R *.dres}

uses
  System.StartUpCopy,
  FMX.Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  FrameSplash in 'FrameSplash.pas' {SplashFrame: TFrame},
  MusicUnit in 'MusicUnit.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
