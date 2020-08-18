unit Unit_drawing_with_firemonkey;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.UIConsts,
  System.Classes,
  System.Variants,

  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, System.Math.Vectors;

type
  TRadioGroupHelper = class helper for TGroupBox
    // Setzt voraus, dass die TAG-Werte der TRadioButton manuell zuvor auf 0..x durchnumeriert wurden
    function ItemIndex: Integer;
    procedure SetItemIndex(NewIndex: Integer);
  end;

type
  TForm1 = class(TForm)
    image1: TImage;
    rctngl_left1: TRectangle;
    btn__draw_filledpolygon: TButton;
    btn_draw_arc: TButton;
    btn_draw_ellipse: TButton;
    btn_draw_lines: TButton;
    btn_draw_Polygon: TButton;
    clear_color: TButton;
    trckbr_opacity: TTrackBar;
    lbl_opacity: TLabel;
    rb_blue: TRadioButton;
    grp_Radio: TGroupBox;
    rb_black: TRadioButton;
    rb_white: TRadioButton;
    btn_draw_circles: TButton;
    btn_draw_rect: TButton;
    btn_draw_datapath: TButton;
    procedure btn_draw_arcClick(Sender: TObject);
    procedure btn_draw_ellipseClick(Sender: TObject);
    procedure btn_draw_circlesClick(Sender: TObject);
    procedure btn_draw_PolygonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn__draw_filledpolygonClick(Sender: TObject);
    procedure clear_colorClick(Sender: TObject);
    procedure trckbr_opacityChange(Sender: TObject);
    procedure btn_draw_linesClick(Sender: TObject);
    procedure btn_draw_rectClick(Sender: TObject);
    procedure btn_draw_datapathClick(Sender: TObject);
  private
    { Private declarations }

    FOpacity: Single;
    FPolygonArray: array of TPolygon;
    procedure MakeRandomPolygons(Sender: TObject);

  public
    { Public declarations }
    localBMP: TBitmap;

    procedure LoadBMP2GUI(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

function TRadioGroupHelper.ItemIndex: Integer;
var
  L: Integer;
begin
  Result := -1;

  for L := 0 to ChildrenCount - 1 do
  begin
    if Children[L] is TRadioButton then
    begin
      if (Children[L] as TRadioButton).IsChecked then
      begin
        Result := (Children[L] as TRadioButton).Tag;
      end;
    end;
  end;
end;

procedure TRadioGroupHelper.SetItemIndex(NewIndex: Integer);
var
  L: Integer;
begin
  for L := 0 to ChildrenCount - 1 do
  begin
    if Children[L] is TRadioButton then
    begin
      if (Children[L] as TRadioButton).Tag = NewIndex then
      begin
        (Children[L] as TRadioButton).IsChecked := True;
      end;
    end;
  end;
end;

function randomColor: TColor;
var
  rec: TAlphaColorRec;
begin
  with rec do
  begin

    A := random(255);
    R := random(255);
    G := random(255);
    B := random(255);
  end;

  Result := rec.Color;
end;

procedure TForm1.MakeRandomPolygons(Sender: TObject);
var
  i: Integer;
  MyPolygon: TPolygon;
  p1, p2, p3, p4, p5: TPointF;
begin

  SetLength(FPolygonArray, 10);

  for i := Low(FPolygonArray) to High(FPolygonArray) do
  begin
    // sets the points that define the polygon
    p1 := TPointF.Create(200 + Random(150), 220 + Random(150));
    p2 := TPointF.Create(250 + Random(150), 360 + Random(150));
    p3 := TPointF.Create(280 + Random(150), 260 + Random(150));
    p4 := TPointF.Create(200 + Random(150), 180 + Random(150));
    p5 := TPointF.Create(100 + Random(150), 160 + Random(150));
    // creates the polygon
    SetLength(MyPolygon, 5);
    MyPolygon[0] := p1;
    MyPolygon[1] := p2;
    MyPolygon[2] := p3;
    MyPolygon[3] := p4;
    MyPolygon[4] := p5;

    FPolygonArray[i] := MyPolygon;
  end;

end;

procedure TForm1.trckbr_opacityChange(Sender: TObject);
begin
  FOpacity := trckbr_opacity.Value;

  lbl_opacity.Text := 'opacity:' + FloatToStr(FOpacity);
end;

procedure TForm1.LoadBMP2GUI(Sender: TObject);
var
  p1, p2, p3, p4, p5: TPointF;
begin

  image1.Bitmap.Assign(localBMP);

end;

procedure TForm1.btn_draw_arcClick(Sender: TObject);

var
  p1, p2: TPointF;
begin
  // Sets the center of the arc
  p1 := TPointF.Create(200, 200);
  // sets the radius of the arc
  p2 := TPointF.Create(150, 150);

  localBMP.Canvas.BeginScene;
  // draws the arc on the canvas
  localBMP.Canvas.DrawArc(p1, p2, 90, 230, FOpacity);
  // updates the bitmap to show the arc
  localBMP.Canvas.EndScene;
  // Image1.Bitmap.BitmapChanged;

  LoadBMP2GUI(nil);

end;

procedure TForm1.btn_draw_ellipseClick(Sender: TObject);
var
  MyRect: TRectF;
begin
  // set the circumscribed rectangle of the ellipse
  MyRect := TRectF.Create(50, 40, 200, 270);
  // draws the ellipse om the canvas
  localBMP.Canvas.BeginScene;
  localBMP.Canvas.DrawEllipse(MyRect, FOpacity);
  localBMP.Canvas.EndScene;
  // updates the bitmap
  // Image1.Bitmap.BitmapChanged;

  LoadBMP2GUI(nil);

end;

procedure TForm1.btn_draw_linesClick(Sender: TObject);
var
  p1, p2: TPointF;
  i, j: Integer;
  Brush: TStrokeBrush;
begin
      for i := 1 to 100 do
  begin

    Brush := TStrokeBrush.Create(TBrushKind.Solid, randomColor);
    Brush.Thickness := 2;
    // Brush.Kind := Solid;
    p1 := TPointF.Create(2, 2);
    p2 := TPointF.Create(Random(400), Random(400));

    localBMP.Canvas.BeginScene;

    // draw lines on the canvas

    localBMP.Canvas.DrawLine(p1, p2, 1, Brush);

    localBMP.Canvas.EndScene;

    LoadBMP2GUI(nil);

    Brush.Free;

  end
end;



procedure TForm1.btn_draw_circlesClick(Sender: TObject);
var
  p1, p2: TPointF;
  i, j: Integer;
  Brush: TStrokeBrush;
   MyRect: TRectF;
begin

 ///  5 circles
 ///

    localBMP.Canvas.BeginScene;


   MyRect := TRectF.Create(25, 100, 125, 200);
  // draws the ellipse om the canvas
  localBMP.Canvas.DrawEllipse(MyRect, FOpacity);
   localBMP.Canvas.Stroke.Color := Randomcolor;


      MyRect := TRectF.Create(150, 100, 250, 200);
  // draws the ellipse om the canvas
  localBMP.Canvas.DrawEllipse(MyRect, FOpacity);
   localBMP.Canvas.Stroke.Color := Randomcolor;



         MyRect := TRectF.Create(275, 100, 375, 200);
  // draws the ellipse om the canvas
  localBMP.Canvas.DrawEllipse(MyRect, FOpacity);
   localBMP.Canvas.Stroke.Color := Randomcolor;


      MyRect := TRectF.Create(75, 150, 175, 250);
  // draws the ellipse om the canvas
  localBMP.Canvas.DrawEllipse(MyRect, FOpacity);
   localBMP.Canvas.Stroke.Color := Randomcolor;


         MyRect := TRectF.Create(200, 150, 300, 250);
  // draws the ellipse om the canvas
  localBMP.Canvas.DrawEllipse(MyRect, FOpacity);
   localBMP.Canvas.Stroke.Color := Randomcolor;


  localBMP.Canvas.EndScene;
  // updates the bitmap
  // Image1.Bitmap.BitmapChanged;

  LoadBMP2GUI(nil);
end;









procedure TForm1.btn_draw_datapathClick(Sender: TObject);
var
  path: TPathData;
  MyRect1, MyRect2: TRectF;
begin
  // set the circumscribed rectangle of the ellipse to be add in the path
  MyRect1 := TRectF.Create(90, 100, 230, 300);
  /// sets the rectangle to be add in the path
  MyRect2 := TRectF.Create(70, 90, 220, 290);
  // initializes and creates the path to be drawn
  path := TPathData.Create;
  path.AddEllipse(MyRect1);
  path.AddRectangle(MyRect2, 0, 0, AllCorners);
  localBMP.Canvas.BeginScene;
  // draws the path on the canvas
  localBMP.Canvas.DrawPath(path, 200);
  localBMP.Canvas.EndScene;
      LoadBMP2GUI(nil);

end;


procedure TForm1.clear_colorClick(Sender: TObject);
begin

  case grp_Radio.ItemIndex of
    1:
      localBMP.Canvas.Clear(clawhite);
    2:
      localBMP.Canvas.Clear(clablack);
    3:
      localBMP.Canvas.Clear(clablue);
  else
    localBMP.Canvas.Clear(clawhite);
  end;

  LoadBMP2GUI(nil);
end;

procedure TForm1.btn_draw_PolygonClick(Sender: TObject);
var

  MyPolygon: TPolygon;
  i: Integer;
  Brush: TStrokeBrush;
begin

  for i := Low(FPolygonArray) to High(FPolygonArray) do
  begin
    MyPolygon := FPolygonArray[i];

    Brush := TStrokeBrush.Create(TBrushKind.Solid, randomColor);
    Brush.Thickness := 2;


    // localBMP.Canvas.Stroke := Brush;

    localBMP.Canvas.BeginScene;
    // draws the polygon on the canvas
    localBMP.Canvas.DrawPolygon(MyPolygon, FOpacity);
    localBMP.Canvas.EndScene;
    // updates the bitmap
    // Image1.Bitmap.BitmapChanged;

    LoadBMP2GUI(nil);

    Brush.Free;
  end;
end;

procedure TForm1.btn_draw_rectClick(Sender: TObject);
begin
     ///
     ///
     ///
      localBMP.Canvas.BeginScene;
       localBMP.Canvas.Stroke.Color := claBlue;
  localBMP.Canvas.Stroke.Kind:= TBrushKind.bkSolid;
  localBMP.Canvas.DrawRect(RectF(0,0,50,50),0,0,AllCorners,1);

      localBMP.Canvas.EndScene;
    // updates the bitmap
    // Image1.Bitmap.BitmapChanged;

    LoadBMP2GUI(nil);



end;

procedure TForm1.btn__draw_filledpolygonClick(Sender: TObject);
var
  i: Integer;
  MyPolygon: TPolygon;
  Brush: TBrush;
begin

  Brush := TBrush.Create(TBrushKind.Solid, TAlphaColors.red);

  for i := Low(FPolygonArray) to High(FPolygonArray) do
  begin
    MyPolygon := FPolygonArray[i];

    Brush.Color := randomColor;

    localBMP.Canvas.BeginScene;
    // draws the polygon on the canvas
    localBMP.Canvas.Fill := Brush;
    localBMP.Canvas.FillPolygon(MyPolygon, FOpacity);
    localBMP.Canvas.EndScene;
    // updates the bitmap
    // Image1.Bitmap.BitmapChanged;
  end;

  LoadBMP2GUI(nil);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  localBMP.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  localBMP := TBitmap.Create;
  localBMP.Width := 500;
  localBMP.Height := 500;

  localBMP.Clear(clawhite);

  LoadBMP2GUI(nil);

  MakeRandomPolygons(nil);

  FOpacity := 50;
  trckbr_opacity.Value := FOpacity;

end;

end.
