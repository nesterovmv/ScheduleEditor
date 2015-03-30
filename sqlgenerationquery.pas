unit SQLGenerationQuery;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, MetaData;

function SQLJoinCreate(CurrentTableG: TTable): string;
function SQLSelectCreate(CurrentTableG: TTable): string;

implementation

function SQLJoinCreate(CurrentTableG: TTable): string;
var
 i: integer;
 begin
    with CurrentTableG do
    begin
     Result := PName;
     begin
       for i := 0 to High(CurrentTableG.Fields) do
       begin
         if Fields[i].PNeedForJoin then
         Result += ' INNER JOIN ' + Fields[i].PMyTableName + ' ON '
         + PName + '.' + Fields[i].PName + ' = '
         + Fields[i].PMyTableName + '.' + Fields[i].PJoinOfField;
       end;
     end;
   end;
 end;

function SQLSelectCreate(CurrentTableG: TTable): string;
var
 i: integer;
 begin
    Result := '';
     for i:= 0 to High(CurrentTableG.Fields) do
     begin
      Result += CurrentTableG.Fields[i].PMyTableName;
      Result += '.' + CurrentTableG.Fields[i].PName;
      if i <= High(CurrentTableG.Fields)-1 then
      Result += ', ';
     end;
    end;

end.

