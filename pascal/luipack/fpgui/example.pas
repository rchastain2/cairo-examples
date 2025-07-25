program example;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils,
  fpg_base, fpg_main, fpg_form, fpg_imgfmt_bmp, CairofpGui, CairoClasses, CairoUtils, Cairo;

type

  { TMainForm }

  TMainForm = class(TfpgForm)
  private
  protected
    procedure HandleKeyPress(var keycode: word; var shiftstate: TShiftState; var consumed: boolean); override;
  public
    PaintBox: TCairoPaintBox;
    constructor Create(AOwner: TComponent); override;
    procedure AfterCreate; override;
    procedure PaintBoxDraw(Sender: TObject);
  end;

procedure TMainForm.HandleKeyPress(var keycode: word; var shiftstate: TShiftState; var consumed: boolean);
begin
  if keycode = keyEscape then
  begin
    consumed := True;
    Close;
  end;
  inherited HandleKeyPress(keycode, shiftstate, consumed);
end;

constructor TMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  PaintBox := TCairoPaintBox.Create(Self);
  with PaintBox do
  begin
    Parent := Self;
    Left := 0;
    Top := 0;
    Width := Self.Width;
    Height := Self.Height;
    Visible := True;
    Align := alClient;
    OnDraw := @PaintBoxDraw;
  end;
end;

procedure TMainForm.PaintBoxDraw(Sender: TObject);
var
  Extents: cairo_text_extents_t;
  AText: string;
begin
  with PaintBox, Context do
  begin
    SetSourceRgb(0.0, 0.0, 0.5);
    Paint;
    
    SetSourceRgba(1.0, 1.0, 1.0, 0.5);
    Arc(128, 128, 96, 0, 3 * PI / 2);
    LineWidth := 4;
    Stroke;
    
    RoundedRectangle(Context, 288, 32, 192, 192, 8);
    Stroke;

    AText := 'Welcome To Cairo + FpGui';
    FontSize := 20;
    SelectFontFace('Sans', CAIRO_FONT_SLANT_ITALIC, CAIRO_FONT_WEIGHT_NORMAL);
    SetSourceRgb(1, 0, 0);
    TextExtents(AText, @Extents);
    MoveTo((Width - Extents.Width) / 2, ((Height - Extents.Height) / 2) + Extents.Height);
    ShowText(AText);
  end;
end;

procedure TMainForm.AfterCreate;
begin
  Name := 'MainForm';
  SetPosition(316, 186, 512, 512);
  WindowTitle := 'Basic Cairo Demo';
  WindowPosition := wpScreenCenter;
end;

var
  frm: TMainForm;
begin
  fpgApplication.Initialize;
  frm := TMainForm.Create(nil);
  try
    frm.Show;
    fpgApplication.Run;
  finally
    frm.Free;
  end;
end.
