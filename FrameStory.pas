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

procedure TStoryFrame.BackRectangleClick(Sender: TObject);
begin
  with Sender as TRectangle do
    begin
      var next_image:= ImageList1.Source[Tag].MultiResBitmap[0];
      Image1.MultiResBitmap[0].Assign(next_image);
      tag:= tag + 1;
    end;

  exit;

  MainForm.MainRectangle.Visible := True;
  MainForm.StoryRectangle.Visible := False;
end;

end.
