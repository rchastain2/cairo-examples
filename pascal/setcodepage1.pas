var 
  s: rawbytestring;
 
begin
  s := FormatDateTime('dddd dd mmmm', Date());
  SetCodePage(s, CP_UTF8, TRUE);
