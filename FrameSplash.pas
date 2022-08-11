unit FrameSplash;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Ani, FMX.Effects;

type
  TSplashFrame = class(TFrame)
    MainRectangle: TRectangle;
    BottomRectangle: TRectangle;
    DogelonIndieDevsSubText: TText;
    TopRectangle: TRectangle;
    DogelonIndieDevsLabsImage: TImage;
    DogelonIndieDevsLabsImageFloatAnimation: TFloatAnimation;
    CenterRectangle: TRectangle;
    DogelonIndieDevsLabsText: TText;
    DogelonIndieDevsLabsTextFloatAnimation: TFloatAnimation;
    procedure DogelonIndieDevsLabsImageFloatAnimationFinish(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses MainUnit;

{$R *.fmx}

procedure TSplashFrame.DogelonIndieDevsLabsImageFloatAnimationFinish(Sender: TObject);
begin
  if not DebugMode then
    Sleep(1000);

  MainForm.HomeRectangle.Visible   := True;
  MainForm.SplashRectangle.Visible := False;
end;

end.
