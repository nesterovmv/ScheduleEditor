unit ListView;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, DB, FileUtil, Forms, Controls, Graphics, Dialogs,
  DBGrids, Menus, DbCtrls, metadata;

type

  { TListForm }

  TListForm = class(TForm)
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    SQLQuery1: TSQLQuery;

    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure GridAdd(Table: TTable);
  public
    { public declarations }
    ApporpriateItem: TmenuItem;
  end;

var
  ListForm: TListForm;

implementation

{$R *.lfm}

{ TListForm }

procedure TListForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  ApporpriateItem.Checked := False;
end;

procedure TListForm.GridAdd(Table: TTable);
var
  i: integer;
begin
  SQLQuery1.Close;
  SQLQuery1.SQL.Clear;
  SQLQuery1.SQL.Add('Select * FROM ' + table.PName);
  SQLQuery1.Open;

  with DBGrid1 do
  begin
  for i := 0 to high(Table.Fields) do
    begin
      Columns[i].Width := Table.fields[i].PWidth;
      Columns[i].Title.Caption := Table.fields[i].PCaption;
    end;
  end;
end;

end.
