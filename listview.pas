unit ListView;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, DB, FileUtil, Forms, Controls, Graphics, Dialogs,
  DBGrids, Menus, DBCtrls, StdCtrls, MetaData, SQLGenerationQuery;

type

  { TListForm }

  TListForm = class(TForm)
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    ImageList1: TImageList;
    SQLQuery1: TSQLQuery;
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure GridAdd(Table: TTable);
    procedure DoSQLQuery(SQLText: string);
    procedure AssignmentProperty(EditTable: Ttable);
  public
    { public declarations }
    ConformityItemInDir: TmenuItem;
    SortTable: TTable;
    ClickCheck: boolean;
    SQLTextForSort: string;
  end;

var
  ListForm: TListForm;

implementation

{$R *.lfm}

{ TListForm }

procedure TListForm.DoSQLQuery(SQLText: string);
begin
  SQLQuery1.SQL.Clear;
  SQLQuery1.SQL.Add(SQLText);
  SQLQuery1.Close;
  SQLQuery1.Open;
end;

procedure TListForm.AssignmentProperty(EditTable: Ttable);
var
  i: integer;
begin
  with DBGrid1 do
  begin
    for i := 0 to high(EditTable.Fields) do
    begin
      Columns[i].Width := EditTable.fields[i].PWidth;
      Columns[i].Title.Caption := EditTable.fields[i].PCaption;
      Columns[i].Visible := EditTable.fields[i].PVisible;
    end;
  end;
end;

procedure TListForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  ConformityItemInDir.Checked := False;
end;

procedure TListForm.DBGrid1TitleClick(Column: TColumn);
var
  IndexForImage: integer;
begin
  IndexForImage := Column.Index;
  if ClickCheck then
  begin
    SQLTextForSort := SQLQuery1.SQL.Text;
    Delete(SQLTextForSort, length(SQLTextForSort) - 5, 5);
    DoSQLQuery(SQLTextForSort);
    DBGrid1.Columns[IndexForImage].title.ImageIndex := 1;
    ClickCheck := False;
  end
  else
  begin
    SQLTextForSort := SQLQuery1.SQL.Text;
    if pos('ORDER', SQLTextForSort) <> 0 then
    begin
      Delete(SQLTextForSort, pos('ORDER', SQLTextForSort),
        length(SQLTextForSort) - pos('ORDER', SQLTextForSort));
      DoSQLQuery(SQLTextForSort);
      DBGrid1.Columns[IndexForImage].title.ImageIndex := -1;
      ClickCheck := False;
      AssignmentProperty(SortTable);
      exit;
    end
    else
      SQLTextForSort := SQLQuery1.SQL.Text;
    SQLTextForSort += 'ORDER BY ' + Column.FieldName + ' DESC';
    DoSQLQuery(SQLTextForSort);
    DBGrid1.Columns[IndexForImage].title.ImageIndex := 0;
    ClickCheck := True;
  end;
  AssignmentProperty(SortTable);
end;


procedure TListForm.GridAdd(Table: TTable);
begin
  DoSQLQuery('SELECT ' + SQLSelectCreate(Table) + ' FROM ' +
    SQLJoinCreate(Table));
  AssignmentProperty(Table);
  SortTable := Table;
end;

end.
