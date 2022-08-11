unit MainUnit;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Rtti,
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
  FrameSplash;

type
  TMainForm = class(TForm)
    Header: TToolBar;
    Footer: TToolBar;
    HeaderLabel: TLabel;
    Label1: TLabel;
    Button1: TButton;
    StringGrid1: TStringGrid;
    StringColumn1: TStringColumn;
    StringColumn2: TStringColumn;
    StringColumn3: TStringColumn;
    StringColumn4: TStringColumn;
    StringColumn5: TStringColumn;
    HomeRectangle: TRectangle;
    SplashRectangle: TRectangle;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Generate_grid_values;
    procedure Place_hints;
    procedure Game_start;
    procedure Clean_up;
    procedure Visualize_in_grid;
    var SplashFrame : TSplashFrame;
  end;

const
  desired_grid_size = 5;
  grid_size = desired_grid_size - 1;
  DebugMode = {$IFDEF DEBUG}True{$ELSE}False{$ENDIF};

var
  MainForm: TMainForm;
  mines: array of array of boolean;
  hints: array of array of integer;
  start_timestamp: TDateTime;

implementation

{$R *.fmx}

procedure TMainForm.Visualize_in_grid;
begin
  for var x := 0 to grid_size do
  for var y := 0 to grid_size do
    begin
      var mine_on_tile:= mines[x,y];
      if mine_on_tile then
        begin
          StringGrid1.Cells[y,x]:= '💣';
          continue;
        end;

      StringGrid1.Cells[y,x]:= hints[x,y].ToString;
    end;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  Clean_up;
  Game_start;
  Visualize_in_grid;
end;

procedure TMainForm.Clean_up;
begin
  for var x := 0 to grid_size do
  for var y := 0 to grid_size do
    begin
      mines[x,y]:= false;
      hints[x,y]:= 0;
    end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  SetLength(mines, desired_grid_size, desired_grid_size);
  SetLength(hints, desired_grid_size, desired_grid_size);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  SplashFrame.Free;
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
end;

procedure TMainForm.Game_start;
begin
  Generate_grid_values;
  Place_hints;

  start_timestamp:= Now;
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

procedure TMainForm.Generate_grid_values;
begin
  randomize;
  var mines_to_distribute:= 6;

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
