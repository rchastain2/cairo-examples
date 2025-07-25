
unit colors;

interface

type
  TColorName = (
    AliceBlue,
    AlizarinCrimson,
    Amber,
    Amethyst,
    AntiqueWhite,
    Aquamarine,
    Asparagus,
    Azure,
    Beige,
    Bisque,
    Bistre,
    BitterLemon,
    Black,
    BlanchedAlmond,
    BlazeOrange,
    Blue,
    BlueViolet,
    BondiBlue,
    Brass,
    BrightGreen,
    BrightTurquoise,
    BrightViolet,
    Bronze,
    Brown,
    Buff,
    Burgundy,
    BurlyWood,
    BurntOrange,
    BurntSienna,
    BurntUmber,
    CadetBlue,
    CamouflageGreen,
    Cardinal,
    Carmine,
    Carrot,
    Casper,
    Celadon,
    Cerise,
    Cerulean,
    CeruleanBlue,
    Chartreuse,
    Chocolate,
    Cinnamon,
    Cobalt,
    Copper,
    Coral,
    Corn,
    CornflowerBlue,
    Cornsilk,
    Cream,
    Crimson,
    Cyan,
    DarkBlue,
    DarkBrown,
    DarkCerulean,
    DarkChestnut,
    DarkCoral,
    DarkCyan,
    DarkGoldenrod,
    DarkGray,
    DarkGreen,
    DarkIndigo,
    DarkKhaki,
    DarkMagenta,
    DarkOlive,
    DarkOliveGreen,
    DarkOrange,
    DarkOrchid,
    DarkPastelGreen,
    DarkPink,
    DarkRed,
    DarkSalmon,
    DarkScarlet,
    DarkSeaGreen,
    DarkSlateBlue,
    DarkSlateGray,
    DarkSpringGreen,
    DarkTan,
    DarkTangerine,
    DarkTeaGreen,
    DarkTerraCotta,
    DarkTurquoise,
    DarkViolet,
    DeepPink,
    DeepSkyBlue,
    Denim,
    DimGray,
    DodgerBlue,
    Emerald,
    Eggplant,
    FernGreen,
    FireBrick,
    Flax,
    FloralWhite,
    ForestGreen,
    Fractal,
    Fuchsia,
    Gainsboro,
    Gamboge,
    GhostWhite,
    Gold,
    Goldenrod,
    Gray,
    GrayAsparagus,
    GrayTeaGreen,
    Green,
    GreenYellow,
    Heliotrope,
    Honeydew,
    HotPink,
    IndianRed,
    Indigo,
    InternationalKleinBlue,
    InternationalOrange,
    Ivory,
    Jade,
    Khaki,
    Lavender,
    LavenderBlush,
    LawnGreen,
    Lemon,
    LemonChiffon,
    LightBlue,
    LightBrown,
    LightCoral,
    LightCyan,
    LightGoldenrodYellow,
    LightGray,
    LightGreen,
    LightMagenta,
    LightPink,
    LightRed,
    LightSalmon,
    LightSeaGreen,
    LightSkyBlue,
    LightSlateGray,
    LightSteelBlue,
    LightYellow,
    Lilac,
    Lime,
    LimeGreen,
    Linen,
    Magenta,
    Malachite,
    Maroon,
    Mauve,
    MediumAquamarine,
    MediumBlue,
    MediumOrchid,
    MediumPurple,
    MediumSeaGreen,
    MediumSlateBlue,
    MediumSpringGreen,
    MediumTurquoise,
    MediumVioletRed,
    MidnightBlue,
    MintCream,
    MistyRose,
    Moccasin,
    MoneyGreen,
    Monza,
    MossGreen,
    MountbattenPink,
    Mustard,
    NavajoWhite,
    Navy,
    Ochre,
    OldGold,
    OldLace,
    Olive,
    OliveDrab,
    Orange,
    OrangeRed,
    Orchid,
    PaleBrown,
    PaleCarmine,
    PaleChestnut,
    PaleCornflowerBlue,
    PaleGoldenrod,
    PaleGreen,
    PaleMagenta,
    PaleMauve,
    PalePink,
    PaleSandyBrown,
    PaleTurquoise,
    PaleVioletRed,
    PapayaWhip,
    PastelGreen,
    PastelPink,
    Peach,
    PeachOrange,
    PeachPuff,
    PeachYellow,
    Pear,
    Periwinkle,
    PersianBlue,
    Peru,
    PineGreen,
    Pink,
    PinkOrange,
    Plum,
    PowderBlue,
    PrussianBlue,
    Puce,
    Pumpkin,
    Purple,
    RawUmber,
    Red,
    Reef,
    RobinEggBlue,
    RosyBrown,
    RoyalBlue,
    Russet,
    Rust,
    SaddleBrown,
    Saffron,
    Salmon,
    SandyBrown,
    Sangria,
    Sapphire,
    Scarlet,
    SchoolBusYellow,
    SeaGreen,
    SeaShell,
    SelectiveYellow,
    Sepia,
    Sienna,
    Silver,
    SkyBlue,
    SlateBlue,
    SlateGray,
    Snow,
    SpringGreen,
    SteelBlue,
    SwampGreen,
    Taupe,
    Tangerine,
    Teal,
    TeaGreen,
    Tenne,
    TerraCotta,
    Thistle,
    Tomato,
    Turquoise,
    Ultramarine,
    Vermilion,
    Violet,
    VioletEggplant,
    Viridian,
    Wheat,
    White,
    WhiteSmoke,
    Wisteria,
    Yellow,
    YellowGreen,
    Zinnwaldite
  );
  TColorData = record
    name: string;
    value: longword;
  end;

const
  DATA: array[TColorName] of TColorData = (
    (name: 'AliceBlue'; value: $F0F8FF),
    (name: 'AlizarinCrimson'; value: $E32636),
    (name: 'Amber'; value: $FFBF00),
    (name: 'Amethyst'; value: $9966CC),
    (name: 'AntiqueWhite'; value: $FAEBD7),
    (name: 'Aquamarine'; value: $7FFFD4),
    (name: 'Asparagus'; value: $7BA05B),
    (name: 'Azure'; value: $F0FFFF),
    (name: 'Beige'; value: $F5F5DC),
    (name: 'Bisque'; value: $FFE4C4),
    (name: 'Bistre'; value: $3D2B1F),
    (name: 'BitterLemon'; value: $CAE00D),
    (name: 'Black'; value: $000000),
    (name: 'BlanchedAlmond'; value: $FFEBCD),
    (name: 'BlazeOrange'; value: $FF9900),
    (name: 'Blue'; value: $0000FF),
    (name: 'BlueViolet'; value: $8A2BE2),
    (name: 'BondiBlue'; value: $0095B6),
    (name: 'Brass'; value: $B5A642),
    (name: 'BrightGreen'; value: $66FF00),
    (name: 'BrightTurquoise'; value: $08E8DE),
    (name: 'BrightViolet'; value: $CD00CD),
    (name: 'Bronze'; value: $CD7F32),
    (name: 'Brown'; value: $A52A2A),
    (name: 'Buff'; value: $F0DC82),
    (name: 'Burgundy'; value: $900020),
    (name: 'BurlyWood'; value: $DEB887),
    (name: 'BurntOrange'; value: $CC5500),
    (name: 'BurntSienna'; value: $E97451),
    (name: 'BurntUmber'; value: $8A3324),
    (name: 'CadetBlue'; value: $5F9EA0),
    (name: 'CamouflageGreen'; value: $78866B),
    (name: 'Cardinal'; value: $C41E3A),
    (name: 'Carmine'; value: $960018),
    (name: 'Carrot'; value: $ED9121),
    (name: 'Casper'; value: $ADBED1),
    (name: 'Celadon'; value: $ACE1AF),
    (name: 'Cerise'; value: $DE3163),
    (name: 'Cerulean'; value: $007BA7),
    (name: 'CeruleanBlue'; value: $2A52BE),
    (name: 'Chartreuse'; value: $7FFF00),
    (name: 'Chocolate'; value: $D2691E),
    (name: 'Cinnamon'; value: $7B3F00),
    (name: 'Cobalt'; value: $0047AB),
    (name: 'Copper'; value: $B87333),
    (name: 'Coral'; value: $FF7F50),
    (name: 'Corn'; value: $FBEC5D),
    (name: 'CornflowerBlue'; value: $6495ED),
    (name: 'Cornsilk'; value: $FFF8DC),
    (name: 'Cream'; value: $FFFDD0),
    (name: 'Crimson'; value: $DC143C),
    (name: 'Cyan'; value: $00FFFF),
    (name: 'DarkBlue'; value: $00008B),
    (name: 'DarkBrown'; value: $654321),
    (name: 'DarkCerulean'; value: $08457E),
    (name: 'DarkChestnut'; value: $986960),
    (name: 'DarkCoral'; value: $CD5B45),
    (name: 'DarkCyan'; value: $008B8B),
    (name: 'DarkGoldenrod'; value: $B8860B),
    (name: 'DarkGray'; value: $545454),
    (name: 'DarkGreen'; value: $006400),
    (name: 'DarkIndigo'; value: $310062),
    (name: 'DarkKhaki'; value: $BDB76B),
    (name: 'DarkMagenta'; value: $8B008B),
    (name: 'DarkOlive'; value: $556832),
    (name: 'DarkOliveGreen'; value: $556B2F),
    (name: 'DarkOrange'; value: $FF8C00),
    (name: 'DarkOrchid'; value: $9932CC),
    (name: 'DarkPastelGreen'; value: $03C03C),
    (name: 'DarkPink'; value: $E75480),
    (name: 'DarkRed'; value: $8B0000),
    (name: 'DarkSalmon'; value: $E9967A),
    (name: 'DarkScarlet'; value: $560319),
    (name: 'DarkSeaGreen'; value: $8FBC8F),
    (name: 'DarkSlateBlue'; value: $483D8B),
    (name: 'DarkSlateGray'; value: $2F4F4F),
    (name: 'DarkSpringGreen'; value: $177245),
    (name: 'DarkTan'; value: $918151),
    (name: 'DarkTangerine'; value: $FFA812),
    (name: 'DarkTeaGreen'; value: $BADBAD),
    (name: 'DarkTerraCotta'; value: $CC4E5C),
    (name: 'DarkTurquoise'; value: $00CED1),
    (name: 'DarkViolet'; value: $9400D3),
    (name: 'DeepPink'; value: $FF1493),
    (name: 'DeepSkyBlue'; value: $00BFFF),
    (name: 'Denim'; value: $1560BD),
    (name: 'DimGray'; value: $696969),
    (name: 'DodgerBlue'; value: $1E90FF),
    (name: 'Emerald'; value: $50C878),
    (name: 'Eggplant'; value: $990066),
    (name: 'FernGreen'; value: $4F7942),
    (name: 'FireBrick'; value: $B22222),
    (name: 'Flax'; value: $EEDC82),
    (name: 'FloralWhite'; value: $FFFAF0),
    (name: 'ForestGreen'; value: $228B22),
    (name: 'Fractal'; value: $808080),
    (name: 'Fuchsia'; value: $F400A1),
    (name: 'Gainsboro'; value: $DCDCDC),
    (name: 'Gamboge'; value: $E49B0F),
    (name: 'GhostWhite'; value: $F8F8FF),
    (name: 'Gold'; value: $FFD700),
    (name: 'Goldenrod'; value: $DAA520),
    (name: 'Gray'; value: $7E7E7E),
    (name: 'GrayAsparagus'; value: $465945),
    (name: 'GrayTeaGreen'; value: $CADABA),
    (name: 'Green'; value: $008000),
    (name: 'GreenYellow'; value: $ADFF2F),
    (name: 'Heliotrope'; value: $DF73FF),
    (name: 'Honeydew'; value: $F0FFF0),
    (name: 'HotPink'; value: $FF69B4),
    (name: 'IndianRed'; value: $CD5C5C),
    (name: 'Indigo'; value: $4B0082),
    (name: 'InternationalKleinBlue'; value: $002FA7),
    (name: 'InternationalOrange'; value: $FF4F00),
    (name: 'Ivory'; value: $FFFFF0),
    (name: 'Jade'; value: $00A86B),
    (name: 'Khaki'; value: $F0E68C),
    (name: 'Lavender'; value: $E6E6FA),
    (name: 'LavenderBlush'; value: $FFF0F5),
    (name: 'LawnGreen'; value: $7CFC00),
    (name: 'Lemon'; value: $FDE910),
    (name: 'LemonChiffon'; value: $FFFACD),
    (name: 'LightBlue'; value: $ADD8E6),
    (name: 'LightBrown'; value: $D2B48C),
    (name: 'LightCoral'; value: $F08080),
    (name: 'LightCyan'; value: $E0FFFF),
    (name: 'LightGoldenrodYellow'; value: $FAFAD2),
    (name: 'LightGray'; value: $A8A8A8),
    (name: 'LightGreen'; value: $90EE90),
    (name: 'LightMagenta'; value: $FF80FF),
    (name: 'LightPink'; value: $FFB6C1),
    (name: 'LightRed'; value: $FF8080),
    (name: 'LightSalmon'; value: $FFA07A),
    (name: 'LightSeaGreen'; value: $20B2AA),
    (name: 'LightSkyBlue'; value: $87CEFA),
    (name: 'LightSlateGray'; value: $778899),
    (name: 'LightSteelBlue'; value: $B0C4DE),
    (name: 'LightYellow'; value: $FFFFE0),
    (name: 'Lilac'; value: $C8A2C8),
    (name: 'Lime'; value: $00FF00),
    (name: 'LimeGreen'; value: $32CD32),
    (name: 'Linen'; value: $FAF0E6),
    (name: 'Magenta'; value: $FF00FF),
    (name: 'Malachite'; value: $0BDA51),
    (name: 'Maroon'; value: $800000),
    (name: 'Mauve'; value: $E0B0FF),
    (name: 'MediumAquamarine'; value: $66CDAA),
    (name: 'MediumBlue'; value: $0000CD),
    (name: 'MediumOrchid'; value: $BA55D3),
    (name: 'MediumPurple'; value: $9370DB),
    (name: 'MediumSeaGreen'; value: $3CB371),
    (name: 'MediumSlateBlue'; value: $7B68EE),
    (name: 'MediumSpringGreen'; value: $00FA9A),
    (name: 'MediumTurquoise'; value: $48D1CC),
    (name: 'MediumVioletRed'; value: $C71585),
    (name: 'MidnightBlue'; value: $191970),
    (name: 'MintCream'; value: $F5FFFA),
    (name: 'MistyRose'; value: $FFE4E1),
    (name: 'Moccasin'; value: $FFE4B5),
    (name: 'MoneyGreen'; value: $C0DCC0),
    (name: 'Monza'; value: $C7031E),
    (name: 'MossGreen'; value: $ADDFAD),
    (name: 'MountbattenPink'; value: $997A8D),
    (name: 'Mustard'; value: $FFDB58),
    (name: 'NavajoWhite'; value: $FFDEAD),
    (name: 'Navy'; value: $000080),
    (name: 'Ochre'; value: $CC7722),
    (name: 'OldGold'; value: $CFB53B),
    (name: 'OldLace'; value: $FDF5E6),
    (name: 'Olive'; value: $808000),
    (name: 'OliveDrab'; value: $6B8E23),
    (name: 'Orange'; value: $FFA500),
    (name: 'OrangeRed'; value: $FF4500),
    (name: 'Orchid'; value: $DA70D6),
    (name: 'PaleBrown'; value: $987654),
    (name: 'PaleCarmine'; value: $AF4035),
    (name: 'PaleChestnut'; value: $DDADAF),
    (name: 'PaleCornflowerBlue'; value: $ABCDEF),
    (name: 'PaleGoldenrod'; value: $EEE8AA),
    (name: 'PaleGreen'; value: $98FB98),
    (name: 'PaleMagenta'; value: $F984E5),
    (name: 'PaleMauve'; value: $996666),
    (name: 'PalePink'; value: $FADADD),
    (name: 'PaleSandyBrown'; value: $DABDAB),
    (name: 'PaleTurquoise'; value: $AFEEEE),
    (name: 'PaleVioletRed'; value: $DB7093),
    (name: 'PapayaWhip'; value: $FFEFD5),
    (name: 'PastelGreen'; value: $77DD77),
    (name: 'PastelPink'; value: $FFD1DC),
    (name: 'Peach'; value: $FFE5B4),
    (name: 'PeachOrange'; value: $FFCC99),
    (name: 'PeachPuff'; value: $FFDAB9),
    (name: 'PeachYellow'; value: $FADFAD),
    (name: 'Pear'; value: $D1E231),
    (name: 'Periwinkle'; value: $CCCCFF),
    (name: 'PersianBlue'; value: $6600FF),
    (name: 'Peru'; value: $CD853F),
    (name: 'PineGreen'; value: $01796F),
    (name: 'Pink'; value: $FFC0CB),
    (name: 'PinkOrange'; value: $FF9966),
    (name: 'Plum'; value: $DDA0DD),
    (name: 'PowderBlue'; value: $B0E0E6),
    (name: 'PrussianBlue'; value: $003153),
    (name: 'Puce'; value: $CC8899),
    (name: 'Pumpkin'; value: $FF7518),
    (name: 'Purple'; value: $800080),
    (name: 'RawUmber'; value: $734A12),
    (name: 'Red'; value: $FF0000),
    (name: 'Reef'; value: $C9FFA2),
    (name: 'RobinEggBlue'; value: $00CCCC),
    (name: 'RosyBrown'; value: $BC8F8F),
    (name: 'RoyalBlue'; value: $4169E1),
    (name: 'Russet'; value: $80461B),
    (name: 'Rust'; value: $B7410E),
    (name: 'SaddleBrown'; value: $8B4513),
    (name: 'Saffron'; value: $F4C430),
    (name: 'Salmon'; value: $FA8072),
    (name: 'SandyBrown'; value: $F4A460),
    (name: 'Sangria'; value: $92000A),
    (name: 'Sapphire'; value: $082567),
    (name: 'Scarlet'; value: $FF2400),
    (name: 'SchoolBusYellow'; value: $FFD800),
    (name: 'SeaGreen'; value: $2E8B57),
    (name: 'SeaShell'; value: $FFF5EE),
    (name: 'SelectiveYellow'; value: $FFBA00),
    (name: 'Sepia'; value: $704214),
    (name: 'Sienna'; value: $A0522D),
    (name: 'Silver'; value: $C0C0C0),
    (name: 'SkyBlue'; value: $87CEEB),
    (name: 'SlateBlue'; value: $6A5ACD),
    (name: 'SlateGray'; value: $708090),
    (name: 'Snow'; value: $FFFAFA),
    (name: 'SpringGreen'; value: $00FF7F),
    (name: 'SteelBlue'; value: $4682B4),
    (name: 'SwampGreen'; value: $ACB78E),
    (name: 'Taupe'; value: $BC987E),
    (name: 'Tangerine'; value: $FFCC00),
    (name: 'Teal'; value: $008080),
    (name: 'TeaGreen'; value: $D0F0C0),
    (name: 'Tenne'; value: $CD5700),
    (name: 'TerraCotta'; value: $E2725B),
    (name: 'Thistle'; value: $D8BFD8),
    (name: 'Tomato'; value: $FF6347),
    (name: 'Turquoise'; value: $40E0D0),
    (name: 'Ultramarine'; value: $120A8F),
    (name: 'Vermilion'; value: $FF4D00),
    (name: 'Violet'; value: $EE82EE),
    (name: 'VioletEggplant'; value: $991199),
    (name: 'Viridian'; value: $40826D),
    (name: 'Wheat'; value: $F5DEB3),
    (name: 'White'; value: $FFFFFF),
    (name: 'WhiteSmoke'; value: $F5F5F5),
    (name: 'Wisteria'; value: $C9A0DC),
    (name: 'Yellow'; value: $FFFF00),
    (name: 'YellowGreen'; value: $9ACD32),
    (name: 'Zinnwaldite'; value: $EBC2AF)
  );

implementation

end.
