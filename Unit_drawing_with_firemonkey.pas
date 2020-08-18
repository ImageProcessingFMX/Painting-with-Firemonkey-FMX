unit Unit_drawing_with_firemonkey;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.UIConsts,
  System.Classes,
  System.Variants,

  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, System.Math.Vectors;

type
  TForm1 = class(TForm)
    image1: TImage;
    rctngl_left1: TRectangle;
    btn__draw_filledpolygon: TButton;
    btn_draw_arc: TButton;
    btn_draw_ellipse: TButton;
    btn_draw_lines: TButton;
    btn_draw_Polygon: TButton;
    btn_draw_clear: TButton;
    procedure btn_draw_arcClick(Sender: TObject);
    procedure btn_draw_ellipseClick(Sender: TObject);
    procedure btn_draw_linesClick(Sender: TObject);
    procedure btn_draw_PolygonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn__draw_filledpolygonClick(Sender: TObject);
    procedure btn_draw_clearClick(Sender: TObject);
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
  localBMP.Canvas.DrawArc(p1, p2, 90, 230, 20);
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
  localBMP.Canvas.DrawEllipse(MyRect, 40);
  localBMP.Canvas.EndScene;
  // updates the bitmap
  // Image1.Bitmap.BitmapChanged;

  LoadBMP2GUI(nil);

end;

function randomColor: TColor;
var
  rec: TAlphaColorRec;
begin
  with rec do
  begin

    A := Random(255);
    R := Random(255);
    G := Random(255);
    B := Random(255);
  end;

  Result := rec.Color;
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

  end;
end;

procedure TForm1.btn_draw_clearClick(Sender: TObject);
begin
  localBMP.Canvas.Clear(clablack);

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
    localBMP.Canvas.DrawPolygon(MyPolygon, 50);
    localBMP.Canvas.EndScene;
    // updates the bitmap
    // Image1.Bitmap.BitmapChanged;

    LoadBMP2GUI(nil);

    Brush.Free;
  end;
end;

procedure TForm1.btn__draw_filledpolygonClick(Sender: TObject);
var
  i: Integer;
  MyPolygon: TPolygon;
  Brush: TBrush;
begin
  // sets the ends of the line to be drawed
  FOpacity := 50;

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
end;

end.
