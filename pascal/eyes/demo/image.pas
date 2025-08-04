
unit Image;

(*
  Image for Cairo and [ptc]Graph, by PascalDragon.
  https://forum.lazarus.freepascal.org/index.php/topic,59894.0.html
  https://forum.lazarus.freepascal.org/index.php/topic,59894.msg450696.html#msg450696
  https://forum.lazarus.freepascal.org/index.php/topic,59894.msg450796.html#msg450796
*)

interface

type
  THeader = packed record
    Width, Height, Reserved: longint;
  end;
 
  TImage = packed record
    Header: THeader;
    Data: array[0..0] of byte;
  end;
  
  PImage = ^TImage;

function CreateImage(const AWidth, AHeight: integer): PImage;
procedure FreeImage(const AImage: PImage; const AWidth, AHeight: integer);

implementation

const
  COLOR_WIDTH = 4;

function CreateImage(const AWidth, AHeight: integer): PImage;
begin
  result := PImage(GetMem(SizeOf(THeader) + COLOR_WIDTH * AWidth * AHeight));
  result^.Header.Width  := AWidth;
  result^.Header.Height := AHeight;
end;

procedure FreeImage(const AImage: PImage; const AWidth, AHeight: integer);
begin
  FreeMem(AImage, SizeOf(THeader) + COLOR_WIDTH * AWidth * AHeight);
end;

end.
