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
      if tag <= 9 then
        begin
          var next_image:= ImageList1.Source[Tag].MultiResBitmap[0];
          Image1.MultiResBitmap[0].Assign(next_image);
          tag:= tag + 1;
        end
      else
        begin
          Image1.Opacity:= 0;
          StoryRectangle.Opacity:= 1;
        end;
    end;
end;

end.
