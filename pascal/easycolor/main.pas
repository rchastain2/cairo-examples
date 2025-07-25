unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    BTCopy: TButton;
    CBAutoCopy: TCheckBox;
    EDColor: TLabeledEdit;
    EDResult: TLabeledEdit;
    LBPredefined: TLabel;
    LBPredefinedColors: TListBox;
    procedure ButtonConvertClick(Sender: TObject);
    procedure BTCopyClick(Sender: TObject);
    procedure CBAutoCopyClick(Sender: TObject);
    procedure EDColorKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure LBPredefinedColorsClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses
  colors, clipbrd;

type
  TCairoColor = record
    r, g, b: double;
  end;

function GetCairoColor(const AColor: longword): TCairoColor;
begin
  with result do
  begin
    r := (aColor and $FF0000) / $FF0000;
    g := (aColor and $00FF00) / $00FF00;
    b := (aColor and $0000FF) / $0000FF;
  end;
end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  LName: TColorName;
begin
  for LName := Low(TColorName) to High(TColorName) do
    LBPredefinedColors.Items.Append(DATA[LName].name);
  FormatSettings.DecimalSeparator := '.';
end;

procedure TForm1.LBPredefinedColorsClick(Sender: TObject);
begin
  EDColor.Text := '$' + IntToHex(DATA[TColorName(LBPredefinedColors.ItemIndex)].value, 6);
  ButtonConvertClick(nil);
  EDColor.Hint := LBPredefinedColors.Items[LBPredefinedColors.ItemIndex];
  EDResult.Hint := EDColor.Hint;
end;

procedure TForm1.ButtonConvertClick(Sender: TObject);
const
  D = 3;
var
  LColor: longword;
  LCairoColor: TCairoColor;
begin
  LColor := StrToInt(EDColor.Text);
  //Color := RGBToColor((LColor and $FF0000) shr 16, (LColor and $FF00) shr 8, LColor and $FF);
  LCairoColor := GetCairoColor(LColor);

  with LCairoColor do
    EDResult.Text := Format('%.*f, %.*f, %.*f', [D, r, D, g, D, b]);

  if CBAutoCopy.Checked then
    BTCopyClick(nil);
end;

procedure TForm1.BTCopyClick(Sender: TObject);
begin
  Clipboard.AsText := EDResult.Text;
end;

procedure TForm1.CBAutoCopyClick(Sender: TObject);
begin
  BTCopy.Enabled := not CBAutoCopy.Checked;
end;

procedure TForm1.EDColorKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
    ButtonConvertClick(nil);
end;

end.

