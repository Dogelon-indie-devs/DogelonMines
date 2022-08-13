unit FrameCredits;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Effects, FMX.Ani, FMX.Controls.Presentation, FMX.Layouts;

type
  TCreditsFrame = class(TFrame)
    MainRectangle: TRectangle;
    BottomRectangle: TRectangle;
    BackRectangle: TRectangle;
    ColorAnimation3: TColorAnimation;
    ShadowEffect6: TShadowEffect;
    Text3: TText;
    CenterRectangle: TRectangle;
    Text1: TText;
    Text2: TText;
    GridLayout1: TGridLayout;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    procedure BackRectangleClick(Sender: TObject);
    procedure URLClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ResizeGridElements;
  end;

implementation
               
uses
  MainUnit;

{$R *.fmx}

procedure TCreditsFrame.BackRectangleClick(Sender: TObject);
begin
  MainForm.MainRectangle.Visible    := True;
  MainForm.CreditsRectangle.Visible := False;
end;

procedure TCreditsFrame.ResizeGridElements;
begin
  GridLayout1.ItemWidth:= round(GridLayout1.Width/2);
end;

procedure TCreditsFrame.URLClick(Sender: TObject);

  procedure Open_URL(URL:string);
  begin
    // how?
  end;

begin
  with Sender as TLabel do
  case Tag of
  1: Open_URL('https://dogelon.dev/');
  2: Open_URL('https://github.com/Dogelon-indie-devs/DogelonMines');
  3: Open_URL('https://soundcloud.com/user-882723147');
  4: Open_URL('https://discord.gg/elongevity');
  5: Open_URL('https://opensea.io/collection/dogelon-mars-comic-series');
  end;
end;

end.
