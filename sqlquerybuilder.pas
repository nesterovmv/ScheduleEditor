unit SQLQueryBuilder;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, MetaData;

function SQLJoinCreate(TableForAdd: TTable): string;
function SQLSelectCreate(TableForAdd: TTable): string;
function SQLQueryForPrivateCard(EditTable: TTable; ID: integer): string;
function SQLQueryForDelete(EditTable: TTable): string;
function SQLQueryForUpdate(EditTable: TTable; ID: integer; FieldPos: integer): string;
function SQLQueryForInsert(EditTable: TTable; ParamIndex: integer): string;

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
          Result += ' INNER JOIN ' + Fields[i].PMyTableName + ' ON ' +
            PName + '.' + Fields[i].PName + ' = ' + Fields[i].PMyTableName +
            '.' + Fields[i].PJoinOfField;
      end;
    end;
  end;
end;

function SQLSelectCreate(TableForAdd: TTable): string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to High(TableForAdd.Fields) do
  begin
    Result += TableForAdd.Fields[i].PMyTableName;
    Result += '.' + TableForAdd.Fields[i].PName;
    if i <= High(TableForAdd.Fields) - 1 then
      Result += ', ';
  end;
end;

function SQLQueryForPrivateCard(EditTable: TTable; ID: integer): string;
begin
  Result := 'SELECT ' + SQLSelectCreate(EditTable) + ' FROM ' +
    SQLJoinCreate(EditTable) + ' WHERE ' + EditTable.Fields[0].PName +
    ' = ' + IntToStr(ID);
end;

function SQLQueryForDelete(EditTable: TTable): string;
begin
  Result := 'DELETE FROM ' + EditTable.PName + ' WHERE ' +
    EditTable.Fields[0].PName + ' = :param0';
end;

function SQLQueryForUpdate(EditTable: TTable; ID: integer; FieldPos: integer): string;
begin
  if FieldPos = 0 then
    Result := 'UPDATE ' + EditTable.PName + ' SET ' + EditTable.PName +
      '.' + EditTable.Fields[FieldPos].PName + ' = :param0'
  else
    Result := ', ' + EditTable.PName + '.' + EditTable.Fields[FieldPos].PName +
      ' = :param' + IntToStr(FieldPos);
end;

function SQLQueryForInsert(EditTable: TTable; ParamIndex: integer): string;
begin
  if ParamIndex = 0 then
    Result := 'INSERT INTO ' + EditTable.PName + ' VALUES (:param0'
  else
    Result := ':param' + IntToStr(ParamIndex);

end;

end.

