
unit Constants;

interface

const
{ Image name format }
  FMT = 'image_%0.3d.png';
{ Image width }
  IW = 128;
{ Image height }
  IH = IW;
{ Palette }
(*
  PAL: array[0..3, 0..2] of single = (
    (1.000, 0.502, 1.000), { LightMagenta }
    (0.565, 0.933, 0.565), { LightGreen }
    (1.000, 0.714, 0.757), { LightPink }
    (0.678, 0.847, 0.902)  { LightBlue }
  );
*)
(*
  PAL: array[0..3, 0..2] of single = (
    (0.588, 0.808, 0.706),
    (1.000, 0.933, 0.678),
    (1.000, 0.800, 0.361),
    (1.000, 0.435, 0.412)
  );
*)
  PAL: array[0..3, 0..2] of single = (
    (0.345, 0.549, 0.494),
    (0.949, 0.890, 0.580),
    (0.949, 0.682, 0.447),
    (0.851, 0.392, 0.349)
  );

implementation

end.
