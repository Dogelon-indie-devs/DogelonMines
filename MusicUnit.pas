unit MusicUnit;

interface

uses
  System.Classes,
  System.IOUtils,
  System.Types,
  System.SysUtils,
  FMX.Types,
  FMX.Media;

  type
    TMusicEngine = class
      private
        FVolume      : Single;
        FMusicToLoop : String;
        LoopTimer    : TTimer;
        MusicPlayer  : TMediaPlayer;
        function MusicIsPlaying : Boolean;
        function ExtractMusicFromResource(ResourceID : String; LoopFile : Boolean = False) : String;
        procedure OnLoopTimer(Sender: TObject);
        procedure SetFVolume(Value: Single);
      public
        property Volume : Single write SetFVolume;
        procedure LoopMusic(ResourceID : String);
        procedure StopLoop;
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
    var FileName := '';

    {$IFDEF MSWINDOWS}
    if LoopFile then
      FileName := System.SysUtils.GetCurrentDir + '\' + 'loop_tmp.mp3'
    else
      FileName := System.SysUtils.GetCurrentDir + '\' + 'tmp.mp3';
    {$ENDIF}

    {$IFDEF ANDROID}
    if LoopFile then
      FileName := System.IOUtils.TPath.Combine(System.IOUtils.TPath.GetDocumentsPath, LoopFileName + '.3gp')
    else
      FileName := System.IOUtils.TPath.Combine(System.IOUtils.TPath.GetDocumentsPath, 'tmp.3gp');
    {$ENDIF}

    ResStream.Position := 0;
    ResStream.SaveToFile(FileName);
    Result := FileName;
  finally
    ResStream.Free;
  end;
end;

procedure TMusicEngine.LoopMusic(ResourceID: String);
begin
  MusicPlayer.Stop;
  MusicPlayer.Clear;
  FMusicToLoop := ResourceID;
  LoopTimer.Enabled := True;
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
        MusicPlayer.Clear;
        var FileName := ExtractMusicFromResource(FMusicToLoop, True);
        MusicPlayer.FileName := FileName;
        MusicPlayer.Play;
      finally
        loopTimer.Enabled := True;
      end;
    end;
end;

procedure TMusicEngine.PlayMusic(ResourceID : String);
begin
  StopMusic;
  var FileName := ExtractMusicFromResource(ResourceID);
  MusicPlayer.FileName := FileName;
  MusicPlayer.Play;
end;

procedure TMusicEngine.SetFVolume(Value: Single);
begin
  if FVolume <> Value then
   begin
     FVolume := Value;
     MusicPlayer.Volume := FVolume;
   end;
end;

procedure TMusicEngine.StopLoop;
begin
  LoopTimer.Enabled := False;
  MusicPlayer.Stop;
  MusicPlayer.Clear;
end;

procedure TMusicEngine.StopMusic;
begin
  StopLoop;
end;

end.
