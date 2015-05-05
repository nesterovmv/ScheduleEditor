unit CardForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, sqldb, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, MetaData, SQLQueryBuilder, Windows, ConnectionModule;

type

  { TCardForEdit }

  TCardForEdit = class(TForm)
    Apply: TButton;
    Cancel: TButton;
    CardDataSource: TDataSource;
    CardSQLQuery: TSQLQuery;
    procedure ApplyClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RefreshCards;
    procedure DoSQLQueryForCard;
  private
    { private declarations }
    Labels: array of TLabel;
    Objects: array of TControl;
  public
    { public declarations }
    CurrentTable: TTable;
    ID: integer;
  end;

  TEvent = procedure of object;

var
  CardForEdit: TCardForEdit;
  EventRefreshForms: TEvent;


implementation

{$R *.lfm}

{ TCardForEdit }

procedure TCardForEdit.FormShow(Sender: TObject);
var
  i, j: integer;
  IDForCBoxItem: TStringList;
begin
  for i := 0 to high(CurrentTable.Fields) do
    if CurrentTable.Fields[i].PVisible then
    begin
      setlength(Labels, length(Labels) + 1);
      Labels[high(Labels)] := TLabel.Create(Self);
      with Labels[high(Labels)] do
      begin
        Parent := Self;
        Width := 110;
        Height := 26;
        Left := 10;
        Top := 19 + 29 * high(Labels);
        Caption := CurrentTable.Fields[i].PCaption;
      end;
    end;

  for i := 0 to high(CurrentTable.Fields) do
  begin
    if CurrentTable.Fields[i].PNeedForJoin then
    begin
      Setlength(Objects, length(Objects) + 1);
      Objects[high(Objects)] := TComboBox.Create(Self);
      with TComboBox(Objects[high(Objects)]) do
      begin
        Parent := CardForEdit;
        Width := 204;
        Height := 26;
        Left := 130;
        Top := 15 + 29 * high(Objects);
        ReadOnly := True;
        Style := csOwnerDrawVariable;
      end;
      if i <> high(CurrentTable.Fields) then
      begin
        with CardSQLQuery do
        begin
          Close;
          SQL.Text := 'SELECT * FROM ' + CurrentTable.Fields[i].PMyTableName;
          Open;
          while not CardSQLQuery.EOF do
          begin
            IDForCBoxItem := TStringList.Create;
            IDForCBoxItem.Add(FieldByName(CurrentTable.Fields[i].PName).Value);
            TComboBox(Objects[high(Objects)]).Items.AddObject(
              FieldByName(CurrentTable.Fields[i + 1].PName).Value,
              IDForCBoxItem);
            Next;
          end;
          CardSQLQuery.Close;
        end;
      end;
    end
    else
    if (CurrentTable.Fields[i].PVisible) and not
      (CurrentTable.Fields[i - 1].PNeedForJoin) then
    begin
      Setlength(Objects, length(Objects) + 1);
      Objects[high(Objects)] := TEdit.Create(Self);
      with TEdit(Objects[high(Objects)]) do
      begin
        Parent := CardForEdit;
        Width := 204;
        Height := 26;
        Left := 130;
        Top := 15 + 29 * high(Objects);
        case CurrentTable.Fields[i].PMyType of
          ftstring: Tag := 0;
          ftinteger: Tag := 1;
        end;
      end;
    end;
  end;

  DoSQLQueryForCard;

  if ID > 0 then
  begin
    i := 0;
    for j := 0 to high(CurrentTable.Fields) do
      if CurrentTable.Fields[j].PVisible then
      begin
        if not (CurrentTable.Fields[j - 1].PNeedForJoin) then
        begin
          TEdit(Objects[i]).Text :=
            CardSQLQuery.FieldByName(CurrentTable.Fields[j].PName).Value;
          Inc(i);
        end;
      end
      else
      if CurrentTable.Fields[j].PNeedForJoin then
      begin
        TComboBox(Objects[i]).Text :=
          CardSQLQuery.FieldByName(CurrentTable.Fields[j + 1].PName).Value;
        Inc(i);
      end;
  end;
end;

procedure TCardForEdit.CancelClick(Sender: TObject);
begin
  Close;
end;

procedure TCardForEdit.ApplyClick(Sender: TObject);
var
  i: integer;
  SQLQueryUpdate: string;
  SQLQueryInsert: string;
  Params: array of string;
begin
  if MessageBox(Handle, PChar(Utf8ToAnsi('Вы уверены?')), '', MB_YESNO) = mrYes then
  begin
    setlength(Params, length(Objects) + 1);
    Params[0] := 'param0';
    CardSQLQuery.Params.CreateParam(FTInteger, Params[0], ptInput);
    CardSQLQuery.ParamByName(Params[0]).AsInteger := ID;
    for i := 1 to length(Objects) do
    begin
      Params[i] := 'param' + IntToStr(i);
      CardSQLQuery.Params.CreateParam(FTInteger, Params[i], ptInput);
      if Objects[i - 1] is TComboBox then
        CardSQLQuery.ParamByName(Params[i]).AsInteger :=
          StrToInt(TComboBox(Objects[i - 1]).Items.Objects[TComboBox(
          Objects[i - 1]).ItemIndex].ToString)
      else
        case TEdit(Objects[i - 1]).Tag of
          0: CardSQLQuery.ParamByName(Params[i]).AsString := TEdit(Objects[i - 1]).Text;
          1: CardSQLQuery.ParamByName(Params[i]).AsInteger :=
              StrToInt(TEdit(Objects[i - 1]).Text);
        end;
    end;
    if ID > 0 then
    begin
      SQLQueryUpdate := '';
      for i := 0 to length(Objects) do
        SQLQueryUpdate += SQLQueryForUpdate(CurrentTable, ID, i);
      SQLQueryUpdate += ' WHERE ' + CurrentTable.Fields[0].PName + ' = :param0';
      CardSQLQuery.SQL.Text := SQLQueryUpdate;
    end
    else
    begin
      SQLQueryInsert := '';
      for i := 0 to length(Objects) do
      begin
        SQLQueryInsert += SQLQueryForInsert(CurrentTable, i);
        if i <> length(Objects) then
          SQLQueryInsert += ', '
        else
          SQLQueryInsert += ')';
      end;
      CardSQLQuery.SQL.Text := SQLQueryInsert;
    end;
  end;
  CardSQLQuery.ExecSQL;
  ConnectionModule.DataModule1.SQLTransaction1.Commit;
  EventRefreshForms;
  Close;
end;

procedure TCardForEdit.RefreshCards;
var
  i, j: integer;
  IDForCBoxItem: TStringList;
  CBoxItemsSave: array of string;
begin
  j := 0;
  for i := 0 to high(CurrentTable.Fields) do
  begin
    if CurrentTable.Fields[i].PNeedForJoin then
    begin
      setlength(CBoxItemsSave, length(CBoxItemsSave) + 1);
      CBoxItemsSave[high(CBoxItemsSave)] := TComboBox(Objects[j]).Text;
      TComboBox(Objects[j]).Items.Clear;
      if i <> high(CurrentTable.Fields) then
      begin
        with CardSQLQuery do
        begin
          Close;
          SQL.Text := 'SELECT * FROM ' + CurrentTable.Fields[i].PMyTableName;
          Open;
          while not CardSQLQuery.EOF do
          begin
            IDForCBoxItem := TStringList.Create;
            IDForCBoxItem.Add(FieldByName(CurrentTable.Fields[i].PName).Value);
            TComboBox(Objects[j]).Items.AddObject(
              FieldByName(CurrentTable.Fields[i + 1].PName).Value,
              IDForCBoxItem);
            Next;
          end;
          CardSQLQuery.Close;
        end;
      end;
    end;
    if CurrentTable.Fields[i].PVisible then
      Inc(j);
  end;

  DoSQLQueryForCard;

  //СОХРАНЕНИЕ КОМБОБОХОВ
  j := 0;
  for i := 0 to high(Objects) do
    if Objects[i] is TComboBox then
    begin
      //Showmessage(CBoxItemsSave[j]);
      TComboBox(Objects[i]).Text := CBoxItemsSave[j];
      Inc(j);
    end;
  Setlength(CBoxItemsSave, 0);
end;

procedure TCardForEdit.DoSQLQueryForCard;
begin
  with CardSQLQuery do
  begin
    Close;
    SQL.Text := SQLQueryForPrivateCard(CurrentTable, ID);
    Open;
  end;
end;

end.
