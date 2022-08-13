unit FrameStory;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Effects, FMX.Ani, System.ImageList, FMX.ImgList;

type
  TStoryFrame = class(TFrame)
    MainRectangle: TRectangle;
    BottomRectangle: TRectangle;
    BackRectangle: TRectangle;
    ColorAnimation3: TColorAnimation;
    ShadowEffect6: TShadowEffect;
    Text3: TText;
    ImageList1: TImageList;
    Image1: TImage;
    SlidesRectangle: TRectangle;
    NextButton: TRectangle;
    ColorAnimation1: TColorAnimation;
    ShadowEffect1: TShadowEffect;
    Text1: TText;
    Text2: TText;
    StoryRectangle: TRectangle;
    Text4: TText;
    Text5: TText;
    CenterRectangle: TRectangle;
    FloatAnimation1: TFloatAnimation;
    procedure BackRectangleClick(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  MainUnit;

{$R *.fmx}

procedure TStoryFrame.BackRectangleClick(Sender: TObject);
begin
  MainForm.MainRectangle.Visible := True;
  MainForm.StoryRectangle.Visible := False;
end;

procedure TStoryFrame.NextButtonClick(Sender: TObject);
begin
  with Sender as TRectangle do
    begin
      if Image1.Opacity = 0 then
        begin
          Tag := 0;
          Image1.Opacity:= 1;
          StoryRectangle.Opacity:= 0;
          FloatAnimation1.Enabled := False;
          var next_image:= ImageList1.Source[tag].MultiResBitmap[0];
          Image1.MultiResBitmap[0].Assign(next_image);
          FloatAnimation1.Enabled := True;
          Text1.Text := 'Next »';
        end;
      if tag <= 8 then
        begin
          FloatAnimation1.Enabled := False;
          var next_image:= ImageList1.Source[Tag].MultiResBitmap[0];
          Image1.MultiResBitmap[0].Assign(next_image);
          tag:= tag + 1;
          FloatAnimation1.Enabled := True;
        end
      else
        begin
          Image1.Opacity:= 0;
          StoryRectangle.Opacity:= 1;
          Text1.Text := '« Back';
        end;
    end;
end;

end.
