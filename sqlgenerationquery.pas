unit SQLGenerationQuery;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, MetaData;

function SQLJoinCreate(TableForAdd: TTable): string;
function SQLSelectCreate(TableForAdd: TTable): string;

implementation

function SQLJoinCreate(TableForAdd: TTable): string;
var
 i: integer;
 begin
    with TableForAdd do
    begin
     Result := PName;
     begin
       for i := 0 to High(TableForAdd.Fields) do
       begin
         if Fields[i].PNeedForJoin then
         Result += ' INNER JOIN ' + Fields[i].PMyTableName + ' ON '
         + PName + '.' + Fields[i].PName + ' = '
         + Fields[i].PMyTableName + '.' + Fields[i].PJoinOfField;
       end;
     end;
   end;
 end;

function SQLSelectCreate(TableForAdd: TTable): string;
var
 i: integer;
 begin
    Result := '';
     for i:= 0 to High(TableForAdd.Fields) do
     begin
      Result += TableForAdd.Fields[i].PMyTableName;
      Result += '.' + TableForAdd.Fields[i].PName;
      if i <= High(TableForAdd.Fields)-1 then
      Result += ', ';
     end;
    end;

end.

