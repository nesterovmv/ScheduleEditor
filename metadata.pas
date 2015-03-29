unit MetaData;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB;

type

  { TField }

  TField = class
  private
    Name: string;
    Caption: string;
    Width: integer;
    MyType: TFieldType;
  public
    class procedure AddField(AName, ACaption: string; AWidth: integer;
      AMyType: TFieldType);
    property PName: string read Name;
    property PCaption: string read Caption;
    property PWidth: integer read Width;
    property PMyType: TFieldType read MyType;
  end;

  { TTable }

  TTable = class
  private
    Name: string;
    Caption: string;
  public
    Fields: array of TField;
    class  procedure AddTable(AName, ACaption: string);
    class procedure AddIntoArray(AATable: TTable);
    property PName: string read Name;
    property PCaption: string read Caption;
  end;

var
  Tables: array of TTable;
  CurrentTableG: TTable;

implementation

{ TTable }

class procedure TTable.AddTable(AName, ACaption: string);
var
  CurrentTable: TTable;
begin
  CurrentTable := TTable.Create;
  CurrentTable.Name := AName;
  CurrentTable.Caption := ACaption;
  CurrentTableG := CurrentTable;
end;

class procedure TTable.AddIntoArray(AATable: TTable);
begin
  Setlength(Tables, length(Tables) + 1);
  Tables[high(Tables)] := AATable;
end;

{ TField }

class procedure TField.AddField(AName, ACaption: string; AWidth: integer;
  AMyType: TFieldType);
var
  CurrentField: TField;
begin
  SetLength(CurrentTableG.Fields, length(CurrentTableG.Fields) + 1);
  CurrentTableG.Fields[High(CurrentTableG.Fields)] := TField.Create;
  CurrentTableG.Fields[High(CurrentTableG.Fields)].Name := AName;
  CurrentTableG.Fields[High(CurrentTableG.Fields)].Caption := ACaption;
  CurrentTableG.Fields[High(CurrentTableG.Fields)].Width := AWidth;
  CurrentTableG.Fields[High(CurrentTableG.Fields)].MyType := AMyType;
end;

initialization
  TTable.AddTable('Students', 'Студенты');
  TField.AddField('StudentID', 'ID', 100, FTInteger);
  TField.AddField('StudentInitials', 'ФИО', 200, FTString);
  TField.AddField('GroupID', 'группа', 100, FTInteger);
  TTable.AddIntoArray(CurrentTableG);
  TTable.AddTable('Teachers', 'Преподаватели');
  TField.AddField('TeacherID', 'ID', 100, FTInteger);
  TField.AddField('TeacherInitials', 'ФИО', 200, FTString);
  TTable.AddIntoArray(CurrentTableG);
  TTable.AddTable('EducActivities', 'Вид занятия');
  TField.AddField('EducID', 'ID', 100, FTInteger);
  TField.AddField('EducName', 'Название', 100, FTString);
  TTable.AddIntoArray(CurrentTableG);
  TTable.AddTable('Groups', 'Группы');
  TField.AddField('GroupID', 'ID', 100, FTInteger);
  TField.AddField('GroupNumber', 'Номер', 100, FTInteger);
  TField.AddField('GroupName', 'Название', 200, FTString);
  TTable.AddIntoArray(CurrentTableG);
  TTable.AddTable('Subjects', 'Предмет');
  TField.AddField('SubjectID', 'ID', 100, FTInteger);
  TField.AddField('SubjectName', 'Название', 350, FTString);
  TTable.AddIntoArray(CurrentTableG);
  TTable.AddTable('Audiences', 'Аудитория');
  TField.AddField('AudiencesID', 'ID', 100, FTInteger);
  TField.AddField('AudiencesNumber', 'Номер', 200, FTString);
  TTable.AddIntoArray(CurrentTableG);
  TTable.AddTable('Pairs', 'Занятие');
  TField.AddField('PairsID', 'ID', 100, FTInteger);
  TField.AddField('PairsBegin', 'Начало', 150, FTString);
  TField.AddField('PairsEnd', 'Конец', 150, FTString);
  TField.AddField('PairsNumber', 'Номер', 100, FTString);
  TTable.AddIntoArray(CurrentTableG);
  TTable.AddTable('WeekDays', 'День недели');
  TField.AddField('WeekDaysID', 'ID', 100, FTInteger);
  TField.AddField('WeekDaysName', 'Название', 150, FTString);
  TField.AddField('WeekDaysNumber', 'Номер', 100, FTString);
  TTable.AddIntoArray(CurrentTableG);
  TTable.AddTable('Schedules', 'Расписание');
  TField.AddField('GroupID', 'ID Группа', 100, FTInteger);
  TField.AddField('WeekDayID', 'ID День', 100, FTInteger);
  TField.AddField('PairID', 'ID Занятие', 100, FTInteger);
  TField.AddField('SubjectID', 'ID Предмета', 100, FTInteger);
  TField.AddField('EducID', 'ID Направления', 100, FTInteger);
  TField.AddField('TeacherID', 'ID Преподователя', 100, FTInteger);
  TField.AddField('AudienceID', 'ID Аудитории', 100, FTInteger);
  TTable.AddIntoArray(CurrentTableG);
  TTable.AddTable('Teachers_Subjects', 'Предмет преподователя');
  TField.AddField('TeacherID', 'ID Преподователя', 100, FTInteger);
  TField.AddField('SubjectID', 'ID Предмета', 100, FTInteger);
  TTable.AddIntoArray(CurrentTableG);
  TTable.AddTable('Group_Subjects', 'Предмет группы');
  TField.AddField('GroupID', 'ID Группы', 100, FTInteger);
  TField.AddField('SubjectID', 'ID Предмета', 100, FTInteger);
  TTable.AddIntoArray(CurrentTableG);

end.
