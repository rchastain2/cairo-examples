
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
      with LExprM do WriteLn(Format('cairo%s_move_to(context, %s, %s);', [IfThen(Match[1] = 'm', '_rel', ''), Match[2] + Match[3], IfThen(Match[4] = '-', '-', '') + Match[5]]))
    else
      if LExprC.Exec(LCmd) then
        with LExprC do WriteLn(Format('cairo%s_curve_to(context, %s, %s, %s, %s, %s, %s);', [IfThen(Match[1] = 'c', '_rel', ''), Match[2] + Match[3], IfThen(Match[4] = '-', '-', '') + Match[5], IfThen(Match[6] = '-', '-', '') + Match[7], IfThen(Match[8] = '-', '-', '') + Match[9], IfThen(Match[10] = '-', '-', '') + Match[11], IfThen(Match[12] = '-', '-', '') + Match[13]]))
      else
        if (LCmd = 'Z') or (LCmd = 'z') then
          WriteLn('cairo_close_path(context);')
        else
          WriteLn(ErrOutput, 'Ignored: ', LCmd);
    
  LExprM.Free;
  LExprC.Free;
  LPathList.Free;
  LCmdList.Free;
end.
