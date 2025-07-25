{ |========================================================================|
  |                                                                        |
  |                  Projet : Aller plus loin avec Lazarus                 |
  |                  Description : POO - Programme exemple 32              |
  |                  Unité : dice.pas                                      |
  |                  Site : www.developpez.net                             |
  |                  Copyright : © Roland CHASTAIN & Gilles VASSEUR 2016   |
  |                  d'après une idée originale de Jean-Luc GOFFLOT        |
  |                  Date:    31/08/2016 17:27:10                          |
  |                  Version : 1.0.0                                       |
  |                                                                        |
  |========================================================================| }

// HISTORIQUE
// 31/08/2016 17:27:10 - 1.0.0 - première version opérationnelle

// DICE - part of "Aller plus loin avec Lazarus"
// Copyright © Roland CHASTAIN & Gilles VASSEUR 2016
//
// This program is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the
// Free Software Foundation, either version 3 of the License,
// or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY;
// without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE.
// See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.
// If not, see <http://www.gnu.org/licenses/>.

unit dice;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ExtCtrls, Graphics;

const
  CHeads = 1;
  CTails = 0;

type

  TDiceValueRange= 1..6;

  { TRandomValue }

  TRandomValue = class
  strict private
    fValue: Integer;
    fKeep: Boolean;
    fOnChange: TNotifyEvent;
    fHighValue: Integer;
    fLowValue: Integer;
  private
    function GetValue: Integer;
    procedure SetKeep(AValue: Boolean);
    procedure SetValue(AValue: Integer);
  protected
    procedure Change;
  public
    constructor Create; overload;
    constructor Create(ALow, AHigh: Integer); overload;
    // nouvelle valeur
    procedure NewValue;
    // changement de bornes
    procedure SetBounds(ALow, AHigh: Integer);
  published
    // valeur actuelle
    property Value: Integer read GetValue write SetValue;
    // faut-il garder sa valeur ?
    property Keep: Boolean read fKeep write SetKeep default False;
    // valeur inférieure
    property LowValue: Integer read fLowValue;
    // valeur supérieure
    property HighValue: Integer read fHighValue;
    // notification d'un changement du dé
    property OnChange: TNotifyEvent read fOnChange write fOnChange;
  end;

  { TCustomRandomStuff }

  TCustomRandomStuff = class(TPaintBox)
  strict private
    fRandomValue: TRandomValue;
    fDefaultColor: TColor;
    fKeepColor: TColor;
    fOnChange: TNotifyEvent;
  private
    procedure SetDefaultColor(AValue: TColor);
    procedure SetKeepColor(AValue: TColor);
    procedure ValueChanged(Sender: TObject);
  protected
    procedure Change; virtual;
    property KeepColor: TColor read fKeepColor write SetKeepColor default clMoneyGreen;
    property DefaultColor: TColor read fDefaultColor write SetDefaultColor default clDefault;
    property RandomValue: TRandomValue read fRandomValue;
    property OnChange: TNotifyEvent read fOnChange write fOnChange;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  end;

  { TDice }

  TDice = class(TCustomRandomStuff)
  strict private
    fBitmap: array[TDiceValueRange] of TBitmap;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  published
    property KeepColor;
    property DefaultColor;
    property RandomValue;
    property OnChange;
  end;

  { TDice2D }

  TDice2D = class(TCustomRandomStuff)
  strict private
    fBackgroundColor: TColor;
    fDotColor: TColor;
  private
    procedure SetBackgroundColor(AValue: TColor);
    procedure SetDotColor(AValue: TColor);
  public
    constructor Create(AOwner: TComponent); override;
    procedure Paint; override;
  published
    property KeepColor;
    property DefaultColor;
    property RandomValue;
    property OnChange;
    // couleur de fond de dé
    property BackgroundColor: TColor read fBackgroundColor write SetBackgroundColor default clCream;
    // couleur des points du dé
    property DotColor: TColor read fDotColor write SetDotColor default clGray;
  end;

  { TDice2DCairo }

  TDice2DCairo = class(TDice2D)
  public
    procedure Paint; override;
  end;

  { TFlipCoin }

  TFlipCoin = class(TCustomRandomStuff)
  strict private
    fHeadsColor: TColor;
    fTailsColor: TColor;
  private
    procedure SetHeadsColor(AValue: TColor);
    procedure SetTailsColor(AValue: TColor);
  public
    constructor Create(AOwner: TComponent); override;
    procedure Paint; override;
  published
    property KeepColor;
    property DefaultColor;
    property RandomValue;
    property OnChange;
    // couleur côté face
    property HeadsColor: TColor read fHeadsColor write SetHeadsColor default clBlue;
    // couleur côté pile
    property TailsColor: TColor read fTailsColor write SetTailsColor default clRed;
  end;

  { TFlipCoinCairo }

  TFlipCoinCairo = class(TFlipCoin)
  public
    procedure Paint; override;
  end;


implementation

uses
  Types, // pour InflateRect
  Cairo, CairoWin32;

{$R dice.res }

resourcestring
  rsLimit = 'La limite inférieure %d est supérieure ou égale à la '
    + 'limite supérieure %d.';
  rsDD = 'D%d';

procedure DecodeColor(const aColor: TColor; out r, g, b: Double);
// *** décodage d'une couleur pour CAIRO ***
begin
  b := (aColor and $FF0000) / $FF0000;
  g := (aColor and $00FF00) / $00FF00;
  r := (aColor and $0000FF) / $0000FF;
end;

{ TFlipCoinCairo }

procedure TFlipCoinCairo.Paint;
// *** dessin de la pièce avec CAIRO ***
var
  LBitmap: TBitmap;
  LR: TRect;
  surface: pcairo_surface_t;
  cr: pcairo_t;
  w, h: Integer;
  r, g, b: Double;
begin
  inherited Paint;

  LR := ClientRect;

  w := LR.Right - LR.Left;;
  h := LR.Bottom - LR.Top;

  LBitmap := TBitmap.Create;
  try
    LBitmap.SetSize(ClientWidth, ClientHeight);
    LBitmap.Canvas.Brush.Color := self.GetColorResolvingParent;
    LBitmap.Canvas.FillRect(LR);

    surface := cairo_win32_surface_create(LBitmap.Canvas.Handle);
    cr := cairo_create(surface);

    cairo_scale(cr, w, h);

    if RandomValue.Value = CHeads then
      DecodeColor(HeadsColor, r, g, b)
    else
      DecodeColor(TailsColor, r, g, b);

    cairo_set_source_rgb(cr, r, g, b);

    cairo_arc(cr, 1 / 2, 1 / 2, 2 / 5, 0, 2 * PI);
    cairo_fill(cr);

    cairo_destroy(cr);
    cairo_surface_destroy(surface);

    Canvas.Draw(0, 0, LBitmap);
  finally
    LBitmap.Free;
  end;
end;

{ TDice2DCairo }

procedure TDice2DCairo.Paint;
// *** dessin du dé en 2D avec CAIRO ***
var
  LR: TRect;
  surface: pcairo_surface_t;
  cr: pcairo_t;
  LBitmap: TBitmap;
  w, h: Integer;
  r, g, b: Double;
  procedure Point_UpL;
  begin
    cairo_arc(cr, 1 / 4, 1 / 4, 1 / 10, 0, 2 * PI); cairo_fill(cr);
  end;

  procedure Point_MiL;
  begin
    cairo_arc(cr, 1 / 4, 2 / 4, 1 / 10, 0, 2 * PI); cairo_fill(cr);
  end;

  procedure Point_DnL;
  begin
    cairo_arc(cr, 1 / 4, 3 / 4, 1 / 10, 0, 2 * PI); cairo_fill(cr);
  end;

  procedure Point_Mid;
  begin
    cairo_arc(cr, 1 / 2, 1 / 2, 1 / 10, 0, 2 * PI); cairo_fill(cr);
  end;

  procedure Point_UpR;
  begin
    cairo_arc(cr, 3 / 4, 1 / 4, 1 / 10, 0, 2 * PI); cairo_fill(cr);
  end;

  procedure Point_MiR;
  begin
    cairo_arc(cr, 3 / 4, 2 / 4, 1 / 10, 0, 2 * PI); cairo_fill(cr);
  end;

  procedure Point_DnR;
  begin
    cairo_arc(cr, 3 / 4, 3 / 4, 1 / 10, 0, 2 * PI); cairo_fill(cr);
  end;

begin
  inherited Paint; // on récupère le dessin de l'ancêtre

  LR := ClientRect;

  w := LR.Right - LR.Left;;
  h := LR.Bottom - LR.Top;

  LBitmap := TBitmap.Create;
  try
    LBitmap.SetSize(w, h);

    surface := cairo_win32_surface_create(LBitmap.Canvas.Handle);
    cr := cairo_create(surface);

    cairo_scale(cr, w, h);

    if RandomValue.Keep then
      DecodeColor(KeepColor, r, g, b)
    else
      DecodeColor(BackgroundColor, r, g, b);
    cairo_set_source_rgb(cr, r, g, b);

    cairo_paint(cr);

    DecodeColor(DotColor, r, g, b);
    cairo_set_source_rgb(cr, r, g, b);
    case RandomValue.Value of
      1: Point_Mid;
      2: begin
           Point_UpL;
           Point_DnR;
      end;
      3: begin
          Point_UpL;
          Point_Mid;
          Point_DnR;
      end;
      4: begin
           Point_UpL;
           Point_UpR;
           Point_DnL;
           Point_DnR;
      end;
      5: begin
           Point_UpL;
           Point_UpR;
           Point_DnL;
           Point_DnR;
           Point_Mid;
      end;
      6: begin
           Point_UpL;
           Point_UpR;
           Point_DnL;
           Point_DnR;
           Point_MiL;
           Point_MiR;
      end;
    end;

    cairo_destroy(cr);
    cairo_surface_destroy(surface);

    Canvas.Draw(0, 0, LBitmap);
  finally
    LBitmap.free;
  end;
end;

{ TDice2D }

procedure TDice2D.SetBackgroundColor(AValue: TColor);
// *** couleur de fond du dé 2D ***
begin
  if fBackgroundColor = AValue then
    Exit;
  fBackgroundColor := AValue;
  RandomValue.Change;
end;

procedure TDice2D.SetDotColor(AValue: TColor);
// *** couleur d'un point du dé 2D ***
begin
  if fDotColor = AValue then
    Exit;
  fDotColor := AValue;
  RandomValue.Change;
end;

constructor TDice2D.Create(AOwner: TComponent);
// *** création du dé 2D ***
begin
  inherited;
  RandomValue.SetBounds(Low(TDiceValueRange), High(TDiceValueRange));
  fBackgroundColor := clCream;
  fDotColor := clGray;
end;

procedure TDice2D.Paint;
// *** dessin d'un dé en 2D ***
const
  COffset = 4; // décalage
var
  LDelta: Integer; // proportion
  LR: TRect;

  // les 6 points possibles du dé
  procedure Point_UpL;
  begin
    Canvas.Ellipse(COffset, COffset, (LDelta shl 1) + COffset, (LDelta shl 1)
      + COffset);
  end;

  procedure Point_MiL;
  begin
    Canvas.Ellipse(COffset, Height div 2 - LDelta, (LDelta shl 1) + COffset,
      Height div 2 + LDelta);
  end;

  procedure Point_DnL;
  begin
    Canvas.Ellipse(COffset, Height - (LDelta shl 1) - COffset, (LDelta shl 1) +
      COffset, Height - COffset);
  end;

  procedure Point_Mid;
  begin
    Canvas.Ellipse(Width div 2 - LDelta, Height div 2 - LDelta, Width div 2
      + LDelta, Height div 2 + LDelta);
  end;

  procedure Point_UpR;
  begin
    Canvas.Ellipse(Width - (LDelta shl 1) - COffset, COffset, Width - COffset,
      (LDelta shl 1) + COffset);
  end;

  procedure Point_MiR;
  begin
    Canvas.Ellipse(Width - (LDelta shl 1) - COffset, Height div 2 - LDelta,
      Width - COffset, Height div 2 + LDelta);
  end;

  procedure Point_DnR;
  begin
    Canvas.Ellipse(Width - (LDelta shl 1) - COffset, Height - (LDelta shl 1)
      - COffset, Width - COffset, Height - COffset);
  end;

begin
  inherited Paint; // on récupère le dessin de l'ancêtre
  LDelta := Width div 10;
  if RandomValue.Keep then
    Canvas.Brush.Color := KeepColor
  else
    Canvas.Brush.Color := BackgroundColor;
  Canvas.Pen.Color := clBlack;
  LR := ClientRect;
  InflateRect(LR, -1, -1);
  Canvas.RoundRect(0, 0, LR.Right, LR.Bottom, LDelta, LDelta);
  Canvas.Brush.Color := DotColor;
  case RandomValue.Value of
    1: Point_Mid;
    2: begin
         Point_UpL;
         Point_DnR;
    end;
    3: begin
        Point_UpL;
        Point_Mid;
        Point_DnR;
    end;
    4: begin
         Point_UpL;
         Point_UpR;
         Point_DnL;
         Point_DnR;
    end;
    5: begin
         Point_UpL;
         Point_UpR;
         Point_DnL;
         Point_DnR;
         Point_Mid;
    end;
    6: begin
         Point_UpL;
         Point_UpR;
         Point_DnL;
         Point_DnR;
         Point_MiL;
         Point_MiR;
    end;
  end;
end;

{ TFlipCoin }

procedure TFlipCoin.SetHeadsColor(AValue: TColor);
// *** la couleur face change ***
begin
  if fHeadsColor = AValue then
    Exit;
  fHeadsColor := AValue;
  RandomValue.Change;
end;

procedure TFlipCoin.SetTailsColor(AValue: TColor);
// *** la couleur pile change ***
begin
  if fTailsColor = AValue then
    Exit;
  fTailsColor := AValue;
  RandomValue.Change;
end;

constructor TFlipCoin.Create(AOwner: TComponent);
// *** création de la pièce ***
begin
  inherited Create(AOwner);
  RandomValue.SetBounds(CTails, CHeads);
  fHeadsColor := clBlue;
  fTailsColor := clRed;
end;

procedure TFlipCoin.Paint;
// *** dessin de la pièce suivant sa valeur ***
var
  LBitmap: TBitmap;
  LR: TRect;
begin
  inherited Paint;
  LR := ClientRect;
  LBitmap := TBitmap.Create;
  try
    LBitmap.SetSize(ClientWidth, ClientHeight);
    LBitmap.Transparent := True;
    LBitmap.TransparentColor := clFuchsia;
    LBitmap.Canvas.Brush.Color := clFuchsia;
    LBitmap.Canvas.FillRect(LR);
    // couleurs adaptées
    if RandomValue.Value = CHeads then
      LBitmap.Canvas.Brush.Color := HeadsColor
    else
      LBitmap.Canvas.Brush.Color := TailsColor;
    // ajustement de la taille de l'ellipse
    InflateRect(LR, -1, -1);
    LBitmap.Canvas.Ellipse(LR);
    Canvas.StretchDraw(LR, LBitmap);
  finally
    LBitmap.Free;
  end;
end;

{ TDice }

procedure TDice.Paint;
// *** dessin du dé ***
var
  LBitmap: TBitmap;
begin
  inherited Paint;
  LBitmap := TBitmap.Create;
  try
    LBitmap.SetSize(ClientWidth, ClientHeight);
    LBitmap.Transparent := True;
    LBitmap.TransparentColor := clFuchsia;
    LBitmap.Canvas.StretchDraw(ClientRect, fBitmap[RandomValue.Value]);
    Canvas.StretchDraw(ClientRect, LBitmap);
  finally
    LBitmap.Free;
  end;
end;

constructor TDice.Create(AOwner: TComponent);
// *** création d'un dé ***
var
  Li: Integer;
begin
  inherited Create(AOwner);
  RandomValue.SetBounds(Low(TDiceValueRange), High(TDiceValueRange));
  for Li := RandomValue.LowValue to RandomValue.HighValue do
  begin
    fBitmap[Li] := TBitmap.Create;
    fBitmap[Li].LoadFromResourceName(HInstance, Format(rsDD, [Li]));
  end;
end;

destructor TDice.Destroy;
// *** destruction du dé ***
var
  Li: TDiceValueRange;
begin
  for Li := RandomValue.LowValue to RandomValue.HighValue do
    fBitmap[Li].Free;
  inherited Destroy;
end;

{ TRandomStuff }

procedure TCustomRandomStuff.SetDefaultColor(AValue: TColor);
// *** couleur de fond par défaut ***
begin
  if fDefaultColor = AValue then
    Exit;
  fDefaultColor := AValue;
  Change;
end;

procedure TCustomRandomStuff.SetKeepColor(AValue: TColor);
// *** couleur si le dé est conservé ***
begin
  if fKeepColor = AValue then
    Exit;
  fKeepColor := AValue;
  Change;
end;

procedure TCustomRandomStuff.ValueChanged(Sender: TObject);
// *** la valeur a changé ***
begin
  Change;
end;

procedure TCustomRandomStuff.Change;
// *** changement notifié ***
begin
  Invalidate;
  if Assigned(OnChange) then
    OnChange(Self);
end;

constructor TCustomRandomStuff.Create(AOwner: TComponent);
// création d'un dé ***
begin
  inherited Create(AOwner);
  fRandomValue := TRandomValue.Create;
  fKeepColor := clMoneyGreen;
  fDefaultColor := clDefault;
  fRandomValue.OnChange := @ValueChanged;
end;

destructor TCustomRandomStuff.Destroy;
// *** destruction du dé ***
begin
  fRandomValue.Free;
  inherited Destroy;
end;

procedure TCustomRandomStuff.Paint;
// *** dessin du composant ***
begin
  inherited Paint;
  if RandomValue.Keep then
    Canvas.Brush.Color := KeepColor
  else
    Canvas.Brush.Color := DefaultColor;
  Canvas.FillRect(ClientRect);
end;

{ TRandomValue }

function TRandomValue.GetValue: Integer;
// *** renvoie la valeur ***
begin
  Result := fValue;
end;

procedure TRandomValue.SetKeep(AValue: Boolean);
// *** fixe la conservation de la valeur ***
begin
  if (fKeep = AValue) then
    Exit;
  fKeep := AValue;
  Change;
end;

procedure TRandomValue.SetValue(AValue: Integer);
// *** fixe la valeur ***
begin
  if (fValue = AValue) or Keep then
    Exit;
  fValue := AValue;
  Change;
end;

procedure TRandomValue.Change;
// *** gestionnaire de changement ***
begin
  if Assigned(fOnChange) then
    fOnChange(Self);
end;

procedure TRandomValue.NewValue;
// *** nouvelle valeur ***
begin
  Value := Random(HighValue - LowValue + 1) + LowValue;
end;

procedure TRandomValue.SetBounds(ALow, AHigh: Integer);
// *** nouvelles bornes pour la valeur ***
begin
  // mauvaises bornes ?
  if (ALow >= AHigh) then
    raise ERangeError.CreateFmt(rsLimit, [ALow, AHigh]);
  // contrôle de la borne inférieure
  if (fLowValue <> ALow) then
  begin
    if (ALow > fValue) then
    begin
      fKeep := False;
      fValue := ALow;
    end;
    fLowValue := ALow;
  end;
  // contrôle de la borne supérieure
  if (fHighValue <> AHigh) then
  begin
    if (fHighValue < fValue) then
    begin
      fKeep := False;
      fValue := AHigh;
    end;
    fHighValue := AHigh;
  end;
  Change;
end;

constructor TRandomValue.Create;
// *** création ***
begin
  inherited Create;
  fKeep := False;
end;

constructor TRandomValue.Create(ALow, AHigh: Integer);
// *** création avec des bornes ***
begin
  inherited Create;
  fKeep := False;
  if (ALow >= AHigh) then
    raise ERangeError.CreateFmt(rsLimit, [ALow, AHigh]);
  fLowValue := ALow;
  fHighValue := AHigh;
end;

end.

