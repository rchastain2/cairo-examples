
unit image_u;

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type
  { TForm1 }
  TForm1 = class(TForm)
    btSave: TButton;
    btDraw: TButton;
    btQuit: TButton;
    cbBorder: TCheckBox;
    edEpd: TEdit;
    pbChessboard: TPaintBox;
    procedure btDrawClick(Sender: TObject);
    procedure btQuitClick(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pbChessboardPaint(Sender: TObject);
  private
    { private declarations }
    FText: array[1..8] of string;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses
  Cairo, CairoWin32, StrUtils;

{ TForm1 }
  
procedure TForm1.pbChessboardPaint(Sender: TObject);
const
  CBorder: array[0..9] of string = (
    '1222222223',
    'Ç',
    'Æ',
    'Å',
    'Ä',
    'Ã',
    'Â',
    'Á',
    'À',
    '6ÈÉÊËÌÍÎÏ8'
  );
var
  LSurf: Pcairo_surface_t;
  LCairo: Pcairo_t;
  FBitmap: TBitmap;
  w, h, i, n: integer;
  LText: array of string;
begin
  w := pbChessboard.Width;
  h := pbChessboard.Height;
  FBitmap := TBitmap.Create;
  FBitmap.SetSize(w, h);
  LSurf := cairo_win32_surface_create(FBitmap.Canvas.Handle);
  LCairo := cairo_create(LSurf);
  cairo_set_source_rgb(LCairo, 1, 1, 1);
  cairo_paint(LCairo);
  
  if cbBorder.Checked then
  begin
    SetLength(LText, 10);
    LText[0] := CBorder[0];
    LText[9] := CBorder[9];
    for i := 1 to 8 do
      LText[i] := CBorder[i] + FText[i] + '5';
    n := 10;
  end else
  begin
    SetLength(LText, 8);
    for i := 1 to 8 do
      LText[Pred(i)] := FText[i];
    n := 8;
  end;
  
  cairo_select_font_face(LCairo, 'Chess Alpha', CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL);
  cairo_set_font_size(LCairo, w div n);
  cairo_set_source_rgb(LCairo, 0.0, 0.0, 0.0);
  
  for i := 1 to Length(LText) do
  begin
    cairo_move_to(LCairo, 0, w div n * i);
    cairo_show_text(LCairo, @LText[Pred(i)][1]);
  end;
  
  pbChessboard.Canvas.Draw(0, 0, FBitmap);
  cairo_destroy(LCairo);
  cairo_surface_destroy(LSurf);
  FBitmap.Destroy;
end;

procedure TForm1.btSaveClick(Sender: TObject);
var
  LBitmap: TBitmap;
  LSrc, LDst: TRect;
begin
  LBitmap := TBitmap.Create;
  try
    with LBitmap do
    begin
      Width := pbChessboard.Width;
      Height := pbChessboard.Height;
      LDst := Rect(0, 0, Width, Height);
    end;
    with pbChessboard do
      LSrc := Rect(0, 0, Width, Height);
    LBitmap.Canvas.CopyRect(LDst, pbChessboard.Canvas, LSrc);
    LBitmap.SaveToFile('image.bmp');
  finally
    LBitmap.Free;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  if ParamCount = 1 then
    edEpd.Text := ParamStr(1);
  btDraw.Click;
end;

procedure TForm1.btDrawClick(Sender: TObject);
var
  LEpd, s: string;
  i, j, k: integer;
begin
  LEpd := ExtractWord(1, edEpd.Text, [' ']);
  for i := 1 to 8 do
  begin
    s := ExtractWord(i, LEpd, ['/']);
    j := 1;
    while j <= Length(s) do
      if s[j] in ['1'..'8'] then
      begin
        k := Ord(s[j]) - Ord('0');
        Delete(s, j, 1);
        Insert(StringOfChar(' ', k), s, j);
      end else
        Inc(j);
    Assert(Length(s) = 8);
    for j := 1 to 8 do
    begin
      case s[j] of
        'P': s[j] := 'p';
        'R': s[j] := 'r';
        'N': s[j] := 'h';
        'B': s[j] := 'b';
        'Q': s[j] := 'q';
        'K': s[j] := 'k';
        'p': s[j] := 'o';
        'r': s[j] := 't';
        'n': s[j] := 'j';
        'b': s[j] := 'n';
        'q': s[j] := 'w';
        'k': s[j] := 'l';
      end;
      if (j + 9 - i) mod 2 = 0 then
        if s[j] = ' ' then
          s[j] := '+'
        else
          s[j] := UpCase(s[j]);
    end;
    FText[i] := s;
  end;
  Invalidate;
end;

procedure TForm1.btQuitClick(Sender: TObject);
begin
  Close;
end;

end.
