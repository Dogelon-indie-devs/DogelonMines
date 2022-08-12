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
        LoopTimer   : TTimer;
        MusicPlayer : TMediaPlayer;
        function IsMusicPlaying : Boolean;
        function ExtractMusicFromResource(ResourceID : String) : String;
      public
        procedure PlayMusic(ResourceID : String);
        procedure StopMusic;
        constructor Create;
        destructor Destroy; override;
    end;

implementation

{ TMusicEngine }

constructor TMusicEngine.Create;
begin
  LoopTimer   := TTimer.Create(Nil);
  MusicPlayer := TMediaPlayer.Create(Nil);
end;

destructor TMusicEngine.Destroy;
begin
  LoopTimer.Free;
  MusicPlayer.Free;
  inherited;
end;

function TMusicEngine.ExtractMusicFromResource(ResourceID: String): String;
begin
  Result := '';
  var ResStream := TResourceStream.Create(HInstance, ResourceID, RT_RCDATA);
  try
    {$IFDEF MSWINDOWS}
    var FileName := System.SysUtils.GetCurrentDir + '\' + 'tmp.3gp';
    {$ENDIF}
    {$IFDEF ANDROID}
    var FileName := System.IOUtils.TPath.Combine(System.IOUtils.TPath.GetDocumentsPath, 'tmp.3gp');
    {$ENDIF}
    ResStream.Position := 0;
    ResStream.SaveToFile(FileName);
    Result := FileName;
  finally
    ResStream.Free;
  end;
end;

function TMusicEngine.IsMusicPlaying: Boolean;
begin
  Result := MusicPlayer.State = TMediaState.Playing;
end;

procedure TMusicEngine.PlayMusic(ResourceID : String);
begin

end;

procedure TMusicEngine.StopMusic;
begin

end;

end.
