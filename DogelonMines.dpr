program DogelonMines;



uses
  System.StartUpCopy,
  FMX.Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  FrameSplash in 'FrameSplash.pas' {SplashFrame: TFrame},
  MusicUnit in 'MusicUnit.pas',
  FrameStory in 'FrameStory.pas' {StoryFrame: TFrame},
  FrameCredits in 'FrameCredits.pas' {CreditsFrame: TFrame};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
