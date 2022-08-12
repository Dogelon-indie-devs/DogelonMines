unit MusicUnit;

interface

uses
  System.Classes,
  System.IOUtils,
  System.Types,    fmx.dialogs,
  System.SysUtils,
  FMX.Types,
  FMX.Media;

  type
    TMusicEngine = class
      private
        FMusicToLoop : String;
        LoopTimer   : TTimer;
        MusicPlayer : TMediaPlayer;
        function MusicIsPlaying : Boolean;
        function ExtractMusicFromResource(ResourceID : String; LoopFile : Boolean = False) : String;
        procedure OnLoopTimer(Sender: TObject);
      public
        property MusicNameToLoop : String write FMusicToLoop;
        procedure PlayMusic(ResourceID : String);
        procedure StopMusic;
        constructor Create;
        destructor Destroy; override;
    end;

implementation

{ TMusicEngine }

constructor TMusicEngine.Create;
begin
  MusicPlayer := TMediaPlayer.Create(Nil);
  LoopTimer   := TTimer.Create(Nil);
  LoopTimer.Enabled  := False;
  LoopTimer.Interval := 30;
  LoopTimer.OnTimer  := OnLoopTimer;
end;

destructor TMusicEngine.Destroy;
begin
  LoopTimer.Free;
  MusicPlayer.Free;
  inherited;
end;

function TMusicEngine.ExtractMusicFromResource(ResourceID: String; LoopFile : Boolean = False): String;
begin
  var ResStream := TResourceStream.Create(HInstance, ResourceID, RT_RCDATA);
  try
    const LoopFileName = 'loop_tmp';
    var FileName := '';

    {$IFDEF MSWINDOWS}
    if LoopFile then
      begin
        FileName := System.SysUtils.GetCurrentDir + '\' + LoopFileName + '.mp3';
        if Not FileExists(LoopFileName + '.mp3') then
          begin
            ResStream.Position := 0;
            ResStream.SaveToFile(FileName);
          end;
      end
    else
      FileName := System.SysUtils.GetCurrentDir + '\' + 'tmp.mp3';
    {$ENDIF}

    {$IFDEF ANDROID}
    if LoopFile then
      begin
        FileName := System.IOUtils.TPath.Combine(System.IOUtils.TPath.GetDocumentsPath, LoopFileName + '.3gp');
        if Not FileExists(LoopFileName + '.3gp') then
          begin
            ResStream.Position := 0;
            ResStream.SaveToFile(FileName);
          end;
      end
    else
      FileName := System.IOUtils.TPath.Combine(System.IOUtils.TPath.GetDocumentsPath, 'tmp.3gp');
    {$ENDIF}

    Result := FileName;
  finally
    ResStream.Free;
  end;
end;

function TMusicEngine.MusicIsPlaying: Boolean;
begin
  Result := MusicPlayer.State = TMediaState.Playing;
end;

procedure TMusicEngine.OnLoopTimer(Sender: TObject);
begin
  if Not MusicIsPlaying then
    begin
      LoopTimer.Enabled := False;
      try
        var FileName := ExtractMusicFromResource(FMusicToLoop, True);
        MusicPlayer.FileName := FileName;
        MusicPlayer.Play;
      finally
        LoopTimer.Enabled := True;
      end;
    end;
end;

procedure TMusicEngine.PlayMusic(ResourceID : String);
begin
  if MusicIsPlaying then StopMusic;
  var FileName := ExtractMusicFromResource(ResourceID);
  MusicPlayer.FileName := FileName;
  MusicPlayer.Play;
  LoopTimer.Enabled := True;
end;

procedure TMusicEngine.StopMusic;
begin
  LoopTimer.Enabled := False;
  MusicPlayer.Stop;
  MusicPlayer.Clear;
end;

end.
