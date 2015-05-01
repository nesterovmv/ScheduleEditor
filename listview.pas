unit ListView;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, DB, FileUtil, Forms, Controls, Graphics, Dialogs,
  DBGrids, Menus, DBCtrls, StdCtrls, Buttons, MetaData, SQLQueryBuilder,
  FilterPanelGenerator;

type

  { TListForm }

  TListForm = class(TForm)
    AddFilter: TButton;
    ClearFiltersList: TButton;
    DataSource: TDataSource;
    DBGrid: TDBGrid;
    DBNavigator1: TDBNavigator;
    ImageList: TImageList;
    ScrollBox: TScrollBox;
    FiltersApply: TSpeedButton;
    SQLQuery: TSQLQuery;
    procedure AddFilterClick(Sender: TObject);
    procedure ClearFiltersListClick(Sender: TObject);
    procedure FilterConditionsChange(Sender: TObject);
    procedure DBGridTitleClick(Column: TColumn);
    procedure DeleteFilterMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure FiltersApplyClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure GridAdd(Table: TTable);
    procedure DoSQLQuery(SQLText: string);
    procedure AssignmentProperty(EditTable: TTable);
    procedure ParamsAdd(FilterPanels: array of FilterPanel);
  public
    { public declarations }
    ConformityItemInDir: TmenuItem;
    NowEditTable: TTable;
    ClickCheck: boolean;
    ArrayForColumnsComparison: array of integer;
    SQLTextForSort: string;
    SortColumnIndex: integer;
    PanelsArray: array of FilterPanel;
    Params: array of string;
    SaveSort: string;
    SortImage: integer;
  end;

var
  ListForm: TListForm;

implementation

{$R *.lfm}

{ TListForm }

procedure TListForm.DoSQLQuery(SQLText: string);
begin
  SQLQuery.SQL.Text := SQLText;
  SQLQuery.Close;
  SQLQuery.Open;
end;

procedure TListForm.AssignmentProperty(EditTable: Ttable);
var
  i: integer;
begin
  with DBGrid do
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

procedure TListForm.DBGridTitleClick(Column: TColumn);
var
  IndexForImage: integer;
begin
  Setlength(ArrayForColumnsComparison, length(ArrayForColumnsComparison) + 1);
  ArrayForColumnsComparison[high(ArrayForColumnsComparison)] := Column.Index;
  if length(ArrayForColumnsComparison) <> 1 then
    if ArrayForColumnsComparison[high(ArrayForColumnsComparison)] =
      ArrayForColumnsComparison[high(ArrayForColumnsComparison) - 1] then
      Setlength(ArrayForColumnsComparison, length(ArrayForColumnsComparison) - 1)
    else
    begin
      ClickCheck := False;
      Setlength(ArrayForColumnsComparison, 0);
    end;
  begin
    IndexForImage := Column.Index;
    SortColumnIndex := Column.Index;
    if ClickCheck then
    begin
      SQLTextForSort := SQLQuery.SQL.Text;
      if pos(' DESC', SQLTextForSort) <> 0 then
        Delete(SQLTextForSort, length(SQLTextForSort) - 5, 5);
      DoSQLQuery(SQLTextForSort);
      DBGrid.Columns[IndexForImage].title.ImageIndex := 1;
      ClickCheck := False;
    end
    else
    begin
      SQLTextForSort := SQLQuery.SQL.Text;
      if pos('ORDER', SQLTextForSort) <> 0 then
      begin
        Delete(SQLTextForSort, pos('ORDER', SQLTextForSort),
          length(SQLTextForSort) - pos('ORDER', SQLTextForSort));
        DoSQLQuery(SQLTextForSort);
        DBGrid.Columns[IndexForImage].title.ImageIndex := -1;
        ClickCheck := False;
        AssignmentProperty(NowEditTable);
        exit;
      end
      else
        SQLTextForSort := SQLQuery.SQL.Text;
      SQLTextForSort += 'ORDER BY ' + Column.FieldName + ' DESC';
      DoSQLQuery(SQLTextForSort);
      DBGrid.Columns[IndexForImage].title.ImageIndex := 0;
      ClickCheck := True;
    end;
    AssignmentProperty(NowEditTable);
  end;
end;

procedure TListForm.GridAdd(Table: TTable);
begin
  DoSQLQuery('SELECT ' + SQLSelectCreate(Table) + ' FROM ' + SQLJoinCreate(Table));
  AssignmentProperty(Table);
  NowEditTable := Table;
end;

procedure TListForm.AddFilterClick(Sender: TObject);
var
  i: integer;
begin
  Setlength(PanelsArray, length(PanelsArray) + 1);
  PanelsArray[high(PanelsArray)] := FilterPanel.Create(self);
  with PanelsArray[high(PanelsArray)] do
  begin
    Parent := ScrollBox;
    Top := 26 * high(PanelsArray);
    Left := 24;

    if high(PanelsArray) <> 0 then
    begin
      with CBoxOfFilterContact do
      begin
        Items[0] := 'И';
        Items[1] := 'ИЛИ';
        ItemIndex := 0;
        OnChange := @FilterConditionsChange;
      end;
    end
    else
      CBoxOfFilterContact.Visible := False;

    with CBoxOfFields do
    begin
      for i := 0 to (DBGrid.Columns.Count - 1) do
        if DBGrid.Columns.Items[i].Visible then
          Items.Add(DBGrid.Columns.Items[i].Title.Caption);
      ItemIndex := 0;
      OnChange := @FilterConditionsChange;
    end;
    with CBoxOfConditions do
    begin
      Items[0] := '=';
      Items[1] := '>';
      Items[2] := '<';
      Items[3] := 'содержит';
      Items[4] := 'начинается с';
      ItemIndex := 0;
      OnChange := @FilterConditionsChange;
    end;
    EditConst.OnChange := @FilterConditionsChange;
    with DeleteFilter do
    begin
      Tag := high(PanelsArray);
      OnMouseDown := @DeleteFilterMouseDown;
    end;
  end;
  ScrollBox.BorderStyle := bsSingle;
  FiltersApply.Enabled := True;
end;

procedure TListForm.ClearFiltersListClick(Sender: TObject);
var
  i: integer;
  SQLQueryText: string;
begin
  if length(PanelsArray) <> 0 then
  begin
    SQLQueryText := SQLQuery.SQL.Text;

    if pos('ORDER', SQLQueryText) <> 0 then
    begin
      SortImage := DBGrid.Columns[SortColumnIndex].title.ImageIndex;
      SaveSort := copy(SQLQueryText, pos('ORDER', SQLQueryText),
        length(SQLQueryText) - pos('ORDER', SQLQueryText));
    end
    else
      SaveSort := '';

    if pos('where', SQLQueryText) <> 0 then
      Delete(SQLQueryText, pos('where', SQLQueryText),
        length(SQLQueryText) - pos('where', SQLQueryText));

    //Сделать процедуру генерирующую запрос заного

    if length(PanelsArray) <> 0 then
    begin
      for i := 0 to high(PanelsArray) do
        PanelsArray[i].Free;
      Setlength(PanelsArray, 0);
    end;

    if SaveSort <> '' then
      SQLQueryText += SaveSort;

    DoSQLQuery(SQLQueryText);

    if SaveSort <> '' then
      DBGrid.Columns[SortColumnIndex].title.ImageIndex := SortImage;

    AssignmentProperty(NowEditTable);
  end;
  ScrollBox.BorderStyle := bsNone;
  FiltersApply.Enabled := False;
end;

procedure TListForm.DeleteFilterMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  i: integer;
begin
  PanelsArray[TButton(Sender).Tag].Free;
  if (TButton(Sender).Tag = 0) and (TButton(Sender).Tag <> high(PanelsArray)) then
    PanelsArray[1].CBoxOfFilterContact.Visible := False;
  if TButton(Sender).Tag <> high(PanelsArray) then
    for i := TButton(Sender).Tag to (high(PanelsArray) - 1) do
    begin
      PanelsArray[i] := PanelsArray[i + 1];
      with PanelsArray[i] do
      begin
        Top := 26 * i;
        DeleteFilter.Tag := i;
      end;
    end;
  Setlength(PanelsArray, length(PanelsArray) - 1);
  if length(PanelsArray) = 0 then
    ScrollBox.BorderStyle := bsNone;
  FiltersApply.Enabled := True;
end;

procedure TListForm.FiltersApplyClick(Sender: TObject);
var
  i, j: integer;
  SQLQueryText: string;
  IsEditEmpty: boolean;
begin
  IsEditEmpty := False;
  for i := 0 to high(PanelsArray) do
    if PanelsArray[i].EditConst.Text = '' then
    begin
      IsEditEmpty := True;
      break;
    end;
  if IsEditEmpty then
    ShowMessage('Все поля фильтров должны быть заполнены')
  else
  begin
    FiltersApply.Enabled := False;
    SQLQueryText := SQLQuery.SQL.Text;

    if pos('ORDER', SQLQueryText) <> 0 then
    begin
      SortImage := DBGrid.Columns[SortColumnIndex].title.ImageIndex;
      SaveSort := copy(SQLQueryText, pos('ORDER', SQLQueryText),
        length(SQLQueryText) - pos('ORDER', SQLQueryText));
      Delete(SQLQueryText, pos('ORDER', SQLQueryText),
        length(SQLQueryText) - pos('ORDER', SQLQueryText));
    end
    else
      SaveSort := '';

    if pos('where', SQLQueryText) <> 0 then
      Delete(SQLQueryText, pos('where', SQLQueryText),
        length(SQLQueryText) - pos('where', SQLQueryText));

    //Сделать процедуру генерирующую запрос заного

    for i := 0 to high(PanelsArray) do
    begin
      if i = 0 then
        SQLQueryText += ' where';
      for j := 0 to (DBGrid.Columns.Count - 1) do
        if PanelsArray[i].CBoxOfFields.Items[PanelsArray[i].CBoxOfFields.ItemIndex] =
          DBGrid.Columns.Items[j].Title.Caption then
        begin
          if DBGrid.Columns.Items[j].Visible = True then
          begin
            SQLQueryText += ' (' + DBGrid.Columns.Items[j].FieldName;
            case PanelsArray[i].CBoxOfConditions.ItemIndex of
              0: SQLQueryText += ' = ';
              1: SQLQueryText += ' > ';
              2: SQLQueryText += ' < ';
              3: SQLQueryText += ' Containing ';
              4: SQLQueryText += ' Starting with ';
            end;
            SQLQueryText += ':param' + IntToStr(i) + ' )';
            if i <> high(PanelsArray) then
            begin
              case PanelsArray[i + 1].CBoxOfFilterContact.ItemIndex of
                0: SQLQueryText += ' and ';
                1: SQLQueryText += ' or ';
              end;
            end;
          end;
        end;
    end;

    if SaveSort <> '' then
      SQLQueryText += SaveSort;

    ParamsAdd(PanelsArray);
    DoSQLQuery(SQLQueryText);

    if SaveSort <> '' then
      DBGrid.Columns[SortColumnIndex].title.ImageIndex := SortImage;

    AssignmentProperty(NowEditTable);
  end;
end;

procedure TListForm.FilterConditionsChange(Sender: TObject);
begin
  FiltersApply.Enabled := True;
end;

procedure TListForm.ParamsAdd(FilterPanels: array of FilterPanel);
var
  i, j, k: integer;
begin
  Setlength(Params, length(FilterPanels));
  for k := 0 to high(FilterPanels) do
  begin
    Params[k] := Format('param%d', [k]);
    for i := 0 to (DBGrid.Columns.Count - 1) do
      if FilterPanels[k].CBoxOfFields.Items[FilterPanels[k].CBoxOfFields.ItemIndex] =
        DBGrid.Columns.Items[i].Title.Caption then
        for j := 0 to high(NowEditTable.Fields) do
          if NowEditTable.Fields[j].PName = DBGrid.Columns.Items[i].FieldName then
            case NowEditTable.Fields[j].PMyType of
              ftString:
              begin
                SQLQuery.Params.CreateParam(ftstring, Params[k], PTInput);
                SQLQuery.ParamByName(Params[k]).AsString :=
                  FilterPanels[k].EditConst.Text;
              end;
              ftInteger:
              begin
                SQLQuery.Params.CreateParam(ftinteger, Params[k], PTInput);
                SQLQuery.ParamByName(Params[k]).AsInteger :=
                  StrToInt(FilterPanels[k].EditConst.Text);
              end;
            end;
  end;
end;

end.
