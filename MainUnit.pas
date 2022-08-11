unit MainUnit;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Rtti,
  DateUtils,

  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Controls.Presentation,
  FMX.Grid.Style,
  FMX.Grid,
  FMX.ScrollBox,
  FMX.Objects,
  FMX.Effects,
  FMX.Filter.Effects,
  FMX.Ani,
  FMX.Layouts,

  FrameSplash;

type
  TMainForm = class(TForm)
    HomeRectangle: TRectangle;
    SplashRectangle: TRectangle;
    TopRectangle: TRectangle;
    CenterRectangle: TRectangle;
    BottomRectangle: TRectangle;
    ScoreRectangle: TRectangle;
    ScoreShadowEffect: TShadowEffect;
    TimeRectangle: TRectangle;
    ShadowEffect1: TShadowEffect;
    DogelonImage: TImage;
    PlayRectangle: TRectangle;
    PlayText: TText;
    PlayColorAnimation: TColorAnimation;
    PlayShadowEffect: TShadowEffect;
    DogelonImageFloatAnimation: TFloatAnimation;
    ScoreText: TText;
    TimeText: TText;
    MineImage: TImage;
    GameGridPanelLayout: TGridPanelLayout;
    Button_uncover_grid: TButton;
    Timer_game: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PlayRectangleClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button_uncover_gridClick(Sender: TObject);
    procedure Timer_gameTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Generate_grid_values;
    procedure Place_hints;
    procedure Game_start;
    procedure Clean_up;
    procedure Uncover_tile(x,y:integer);
    procedure CreateGameElements;
    procedure DestroyGameElements;
    function Stepped_on_a_mine(x, y: integer): boolean;
    procedure TileClick(Sender: TObject);
    procedure Initial_free_hint;
    var SplashFrame : TSplashFrame;
  end;

 type
   TGameCaseRec = Record
     MineImage      : TImage;
     HintText       : TText;
     ColorAnimation : TColorAnimation;
     Background     : TRectangle;
   End;

const
  mines_in_the_grid = 5;
  desired_grid_size = 5;
  grid_size = desired_grid_size - 1;
  DebugMode = {$IFDEF DEBUG}True{$ELSE}False{$ENDIF};

var
  MainForm: TMainForm;
  game_running: boolean;
  start_timestamp: TDateTime;
  mines:      array of array of boolean;
  hints:      array of array of integer;
  GameArray : array of array of TGameCaseRec;

implementation

{$R *.fmx}

procedure TMainForm.Uncover_tile(x,y:integer);

  function Hint_color(mines_around_tile:integer):TAlphaColor;
  begin
    case mines_around_tile of
    0: result:= TAlphaColors.Gray;
    1: result:= TAlphaColors.Blue;
    2: result:= TAlphaColors.Green;
    3: result:= TAlphaColors.Red;
    4: result:= TAlphaColors.Darkblue;
    5: result:= TAlphaColors.Darkred;
    else result:= TAlphaColors.Black;
    end;
  end;

begin
  var mine_on_tile:= mines[x,y];
  if mine_on_tile then
    begin
  //  StringGrid1.Cells[y,x]:= '💣';
      GameArray[X,Y].MineImage.Bitmap.Assign(MineImage.Bitmap);
      GameArray[X,Y].MineImage.Margins.Top    := 10;
      GameArray[X,Y].MineImage.Margins.Left   := 10;
      GameArray[X,Y].MineImage.Margins.Right  := 10;
      GameArray[X,Y].MineImage.Margins.Bottom := 10;
      GameArray[X,Y].HintText.Text    := '';
      exit;
    end;

//StringGrid1.Cells[y,x]:= hints[x,y].ToString;
  var mines_around_tile:= hints[x,y];
  GameArray[X,Y].HintText.TextSettings.FontColor:= Hint_color(mines_around_tile);
  GameArray[X,Y].HintText.Text := mines_around_tile.ToString;
  GameArray[X,Y].MineImage.Bitmap.Assign(Nil);
end;

procedure TMainForm.Button_uncover_gridClick(Sender: TObject);
begin
  for var x := 0 to grid_size do
  for var y := 0 to grid_size do
    Uncover_tile(x,y);
end;

procedure TMainForm.Initial_free_hint;
begin
  randomize;
  var found_safe_spot:= false;

  while not found_safe_spot do
    begin
      var x:= random(desired_grid_size);
      var y:= random(desired_grid_size);
      var unsafe_spot:= mines[x,y];
      if unsafe_spot then continue;

      GameArray[X,Y].HintText.Text := 'SAFE';
      found_safe_spot:= true;
    end;
end;

procedure TMainForm.Clean_up;
begin
  DestroyGameElements;

  for var x := 0 to grid_size do
  for var y := 0 to grid_size do
    begin
      mines[x,y]:= false;
      hints[x,y]:= 0;
    end;
end;

function TMainForm.Stepped_on_a_mine(x, y: integer): boolean;
begin
  result:= mines[x,y];
end;

procedure TMainForm.TileClick(Sender: TObject);
var tile_index: integer;
begin
  if not game_running then exit;

  with Sender AS TRectangle do
    tile_index:= tag;

  var x:= tile_index div 5;
  var y:= tile_index mod 5;
  Uncover_tile(x,y);

  if Stepped_on_a_mine(x,y) then
    begin
      game_running:= false;

    end;
end;

procedure TMainForm.Timer_gameTimer(Sender: TObject);
begin
  var elapsed_seconds:= SecondsBetween(Now,start_timestamp);
  var elapsed_minutes:= MinutesBetween(Now,start_timestamp);

  TimeText.Text:= elapsed_minutes.ToString +':'+ elapsed_seconds.ToString;
end;

procedure TMainForm.CreateGameElements;
begin
  var index:= 0;

  for var x := 0 to grid_size do
  for var y := 0 to grid_size do
    begin
      GameArray[X,Y].Background := TRectangle.Create(Nil);
      GameArray[X,Y].Background.Align := TAlignLayout.Client;
      GameArray[X,Y].Background.Fill.Color := TAlphaColors.Alpha OR TAlphaColor($FDE25F);
      GameArray[X,Y].Background.Fill.Kind  := TBrushKind.Solid;
      GameArray[X,Y].Background.Stroke.Color := TAlphaColors.Black;
      GameArray[X,Y].Background.Stroke.Kind  := TBrushKind.None;
      GameArray[X,Y].Background.Stroke.Thickness := 1;
      GameArray[X,Y].Background.XRadius := 12;
      GameArray[X,Y].Background.YRadius := 12;
      GameArray[X,Y].Background.Margins.Top    := 3;
      GameArray[X,Y].Background.Margins.Left   := 3;
      GameArray[X,Y].Background.Margins.Right  := 3;
      GameArray[X,Y].Background.Margins.Bottom := 3;
      GameArray[X,Y].Background.Cursor := crHandPoint;
      GameArray[X,Y].Background.HitTest := True;

      GameArray[X,Y].Background.Tag:= index;
      GameArray[X,Y].Background.OnClick := TileClick;

      GameArray[X,Y].MineImage := TImage.Create(GameArray[X,Y].Background);
      GameArray[X,Y].MineImage.Parent := GameArray[X,Y].Background;
      GameArray[X,Y].MineImage.Align  := TAlignLayout.Client;
      GameArray[X,Y].MineImage.HitTest := False;

      GameArray[X,Y].HintText  := TText.Create(GameArray[X,Y].Background);
      GameArray[X,Y].HintText.Parent := GameArray[X,Y].Background;
      GameArray[X,Y].HintText.Align  := TAlignLayout.Client;
      GameArray[X,Y].HintText.TextSettings.FontColor := TAlphaColors.Alpha OR TAlphaColor($111422);
      GameArray[X,Y].HintText.TextSettings.Font.Family := 'Roboto';
      GameArray[X,Y].HintText.TextSettings.Font.Size := 20;
      GameArray[X,Y].HintText.TextSettings.Font.Style := [TFontStyle.fsBold];
      GameArray[X,Y].HintText.Text := '';
      GameArray[X,Y].HintText.HitTest := False;

      GameArray[X,Y].ColorAnimation := TColorAnimation.Create(GameArray[X,Y].Background);
      GameArray[X,Y].ColorAnimation.Parent := GameArray[X,Y].Background;
      GameArray[X,Y].ColorAnimation.Enabled := True;
      GameArray[X,Y].ColorAnimation.Delay := 0;
      GameArray[X,Y].ColorAnimation.Duration := 0.2;
      GameArray[X,Y].ColorAnimation.Inverse := True;
      GameArray[X,Y].ColorAnimation.Interpolation := TInterpolationType.Linear;
      GameArray[X,Y].ColorAnimation.PropertyName := 'Fill.Color';
      GameArray[X,Y].ColorAnimation.StartValue := TAlphaColors.Alpha OR TAlphaColor($FDE25F);
      GameArray[X,Y].ColorAnimation.StopValue  := TAlphaColors.Alpha OR TAlphaColor($F9D527);
      GameArray[X,Y].ColorAnimation.Trigger := 'IsMouseOver=true';
      GameArray[X,Y].ColorAnimation.TriggerInverse := 'IsMouseOver=false';

      GameGridPanelLayout.AddObject(GameArray[X,Y].Background);
      inc(index);
    end;
end;

procedure TMainForm.DestroyGameElements;
begin
  for var x := 0 to grid_size do
  for var y := 0 to grid_size do
    begin
      GameGridPanelLayout.RemoveObject(GameArray[X,Y].Background);
      GameArray[X,Y].Background.Free;
    end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  SetLength(mines, desired_grid_size, desired_grid_size);
  SetLength(hints, desired_grid_size, desired_grid_size);
  SetLength(GameArray, desired_grid_size, desired_grid_size);
  CreateGameElements;
  {$IFDEF MSWINDOWS}
    MainForm.Constraints.MinWidth := 310;
  {$ENDIF}

  if DebugMode then
    Button_uncover_grid.Visible:= true;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  DestroyGameElements;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  SplashRectangle.Visible := True;
  HomeRectangle.Visible   := False;
  var SplashFrame := TSplashFrame.Create(SplashRectangle);
      SplashFrame.Parent := SplashRectangle;
      SplashFrame.Align  := TAlignLayout.Client;
      SplashFrame.DogelonIndieDevsLabsImageFloatAnimation.Enabled := True;
      SplashFrame.DogelonIndieDevsLabsTextFloatAnimation.Enabled  := True;
  DogelonImageFloatAnimation.Enabled := True;
end;

procedure TMainForm.Game_start;
begin
  Generate_grid_values;
  Place_hints;
  Initial_free_hint;

  start_timestamp:= Now;
  game_running:= true;
  Timer_game.Enabled:= true;
end;

procedure TMainForm.Place_hints;

  function Tile_exists(x,y:integer):boolean;
  begin
    var x_coords_valid:= (x>=0) AND (x<=grid_size);
    var y_coords_valid:= (y>=0) AND (y<=grid_size);
    result:= x_coords_valid AND y_coords_valid;
  end;

  function Count_mines_around_tile(x_origin,y_origin:integer):integer;
  begin
    result:= 0;

    for var x := x_origin-1 to x_origin+1 do
    for var y := y_origin-1 to y_origin+1 do
      begin
        var checking_the_origin_tile_itself:= (x_origin=x) AND (y_origin=y);
        if checking_the_origin_tile_itself then continue;

        if not Tile_exists(x,y) then continue;

        var mine_found:= mines[x,y];
        if mine_found then
          inc(result);
      end;
  end;

begin
  for var x := 0 to grid_size do
  for var y := 0 to grid_size do
    hints[x,y]:= Count_mines_around_tile(x,y);
end;

procedure TMainForm.PlayRectangleClick(Sender: TObject);
begin
  Clean_up;
  CreateGameElements;
  Game_start;
  PlayText.Text:= 'Restart';
end;

procedure TMainForm.Generate_grid_values;
begin
  randomize;
  var mines_to_distribute:= mines_in_the_grid;

  while mines_to_distribute>0 do
    begin
      var x:= random(desired_grid_size);
      var y:= random(desired_grid_size);
      var already_placed:= mines[x,y];
      if already_placed then continue;

      mines[x,y]:= true;
      dec(mines_to_distribute);
    end;
end;

end.
