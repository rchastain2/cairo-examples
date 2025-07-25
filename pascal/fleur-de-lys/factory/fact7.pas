
uses
  Classes, SysUtils, RegExpr, StrUtils;

function ReadAllText(const AFileName: string): string;
var
  LStrm: TFileStream;
begin
  LStrm := TFileStream.Create(AFileName, fmOpenRead);
  try
    SetLength(result, LStrm.Size div SizeOf(AnsiChar));
    LStrm.ReadBuffer(PAnsiChar(result)^, LStrm.Size);
  finally
    LStrm.Free;
  end;
end;

{ 
  https://fr.wikipedia.org/wiki/Fleur_de_lys
  https://developer.mozilla.org/fr/docs/Web/SVG/Tutorial/Paths
}

const
  //relstr: array[boolean] of string = ('', '_rel');
  scale = 4;

var
  ga, gb: double;
  
procedure BuildCmdMove(const a, b: string; const rel: boolean);
var
  fa, fb: double;
begin
  fa := {scale * }StrToFloat(a) / 110;
  fb := {scale * }StrToFloat(b) / 120;
  ga := fa;
  gb := fb;
  if rel then
    Halt
  else
    //WriteLn(Format('cairo_move_to(context, %.5f, %.5f);', [fa, fb]));
    WriteLn(Format('  %.5f, %.5f,', [fa, fb]));
end;

procedure BuildCmdCurve(const a, b, c, d, e, f: string; const rel: boolean);
var
  fa, fb, fc, fd, fe, ff: double;
begin
  fa := {scale * }StrToFloat(a) / 110; if rel then fa := ga + fa;
  fb := {scale * }StrToFloat(b) / 120; if rel then fb := gb + fb;
  fc := {scale * }StrToFloat(c) / 110; if rel then fc := ga + fc;
  fd := {scale * }StrToFloat(d) / 120; if rel then fd := gb + fd;
  fe := {scale * }StrToFloat(e) / 110; if rel then fe := ga + fe;
  ff := {scale * }StrToFloat(f) / 120; if rel then ff := gb + ff;
  //WriteLn(Format('cairo_line_to(context, %.5f, %.5f);', [fa, fb]));
  //WriteLn(Format('cairo_line_to(context, %.5f, %.5f);', [fc, fd]));
  //WriteLn(Format('cairo_line_to(context, %.5f, %.5f);', [fe, ff]));
  WriteLn(Format('  %.5f, %.5f, %.5f, %.5f, %.5f, %.5f,', [fa, fb, fc, fd, fe, ff]));
  ga := fe;
  gb := ff;
end;

var
  LSvgText: string;
  LPathList, LCmdList: TStringList;
  LPath, LCmd: string;
  LExprM, LExprC: TRegExpr;
  
begin
  LPathList := TStringList.Create;
  LCmdList := TStringList.Create;
  LExprM := TRegExpr.Create('([Mm])(\-)?([\d\.]+)([\-,])([\d\.]+)');
  LExprC := TRegExpr.Create('([Cc])(\-)?([\d\.]+)([\-,])([\d\.]+)([\-,])([\d\.]+)([\-,])([\d\.]+)([\-,])([\d\.]+)([\-,])([\d\.]+)');
  
{ Lecture du fichier SVG }

  LSvgText := ReadAllText('lys.svg');

{ Extraction des chemins }

  with TRegExpr.Create('path d="([^"]+)"') do
  try
    if Exec(LSvgText) then 
      repeat 
        LPathList.Append(Match[1]);
      until not ExecNext;
  finally
    Free;
  end;

{ Extraction des commandes }

  for LPath in LPathList do
    with TRegExpr.Create('[MmLlHhVvZzCcSs]([\d\.,\-]+)?') do
    try
      if Exec(LPath) then 
        repeat 
          LCmdList.Append(Match[0]);
        until not ExecNext;
    finally
      Free;
    end;
  
{ Conversion des commandes en Pascal }

  for LCmd in LCmdList do
    if LExprM.Exec(LCmd) then
      with LExprM do BuildCmdMove(Match[2] + Match[3], IfThen(Match[4] = '-', '-', EmptyStr) + Match[5], Match[1] = 'm')
    else
      if LExprC.Exec(LCmd) then
        with LExprC do BuildCmdCurve(
          Match[2] + Match[3],
          IfThen(Match[04] = '-', '-', EmptyStr) + Match[05],
          IfThen(Match[06] = '-', '-', EmptyStr) + Match[07],
          IfThen(Match[08] = '-', '-', EmptyStr) + Match[09],
          IfThen(Match[10] = '-', '-', EmptyStr) + Match[11],
          IfThen(Match[12] = '-', '-', EmptyStr) + Match[13],
          Match[1] = 'c'
        )
      else
        if (LCmd = 'Z') or (LCmd = 'z') then
          //WriteLn('cairo_close_path(context);')
          WriteLn
        else
          WriteLn(ErrOutput, 'Ignored: ', LCmd);
    
  LExprM.Free;
  LExprC.Free;
  LPathList.Free;
  LCmdList.Free;
end.
