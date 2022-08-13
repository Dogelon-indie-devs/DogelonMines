unit FrameCredits;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Effects, FMX.Ani;

type
  TCreditsFrame = class(TFrame)
    MainRectangle: TRectangle;
    BottomRectangle: TRectangle;
    BackRectangle: TRectangle;
    ColorAnimation3: TColorAnimation;
    ShadowEffect6: TShadowEffect;
    Text3: TText;
    procedure BackRectangleClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
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

end.
