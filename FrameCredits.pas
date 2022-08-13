unit FrameCredits;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Effects, FMX.Ani, FMX.Controls.Presentation, FMX.Layouts,
  {$IFDEF MSWINDOWS}
  Winapi.ShellAPI, Winapi.Windows
  {$ENDIF}
  {$IFDEF ANDROID}
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Net,
  Androidapi.JNI.App,
  Androidapi.helpers
  {$ENDIF};

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
    procedure Label2Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure Label8Click(Sender: TObject);
    procedure Label10Click(Sender: TObject);
    procedure Label12Click(Sender: TObject);
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

procedure Open_URL(URL : String);
begin
{$IFDEF ANDROID}
  var Intent := TJIntent.Create;
  Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);
  Intent.setData(StrToJURI(URL));
  tandroidhelper.Activity.startActivity(Intent);
{$ENDIF}
  // SharedActivity.startActivity(Intent);
{$IFDEF MSWINDOWS}
  ShellExecute(0, 'OPEN', PWideChar(URL), nil, nil, SW_SHOWNORMAL);
{$ENDIF}
end;

procedure TCreditsFrame.BackRectangleClick(Sender: TObject);
begin
  MainForm.MainRectangle.Visible    := True;
  MainForm.CreditsRectangle.Visible := False;
end;

procedure TCreditsFrame.Label10Click(Sender: TObject);
begin
  Open_URL('https://discord.gg/elongevity')
end;

procedure TCreditsFrame.Label12Click(Sender: TObject);
begin
  Open_URL('https://opensea.io/collection/dogelon-mars-comic-series')
end;

procedure TCreditsFrame.Label2Click(Sender: TObject);
begin
  Open_URL('https://dogelon.dev/')
end;

procedure TCreditsFrame.Label4Click(Sender: TObject);
begin
  Open_URL('https://github.com/Dogelon-indie-devs/DogelonMines')
end;

procedure TCreditsFrame.Label6Click(Sender: TObject);
begin
  Open_URL('https://soundcloud.com/user-882723147')
end;

procedure TCreditsFrame.Label8Click(Sender: TObject);
begin
  Open_URL('https://play.google.com/store/apps/details?id=org.dogelon_indie_devs.DogelonMines')
end;

procedure TCreditsFrame.ResizeGridElements;
begin
  GridLayout1.ItemWidth:= round(GridLayout1.Width/2);
end;

end.
