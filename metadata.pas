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
    Visible: boolean;
    NeedForJoin: boolean;
    MyTableName: string;
    JoinOfField: string;
  public
    class procedure AddField(AName, ACaption: string; AWidth: integer;
      AMyType: TFieldType; AVisible: boolean; ANeedForJoin: boolean = false; AMyTableName: string = '';
      AJoinOfField: string = '');
    property PName: string read Name;
    property PCaption: string read Caption;
    property PWidth: integer read Width;
    property PMyType: TFieldType read MyType;
    property PVisible: boolean read Visible;
    property PNeedForJoin: boolean read NeedForJoin;
    property PMyTableName: string read MyTableName;
    property PJoinOfField: string read JoinOfField;
  end;

  { TTable }

  TTable = class
  private
    Name: string;
    Caption: string;
  public
    Fields: array of TField;
    class  procedure AddTable(AName, ACaption: string);
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
  Setlength(Tables, length(Tables) + 1);
  Tables[high(Tables)] := CurrentTableG;
end;

{ TField }

class procedure TField.AddField(AName, ACaption: string; AWidth: integer;
  AMyType: TFieldType; AVisible: boolean; ANeedForJoin: boolean = false; AMyTableName: string = '';
  AJoinOfField: string = '');
var
  CurrentField: TField;
begin
  SetLength(CurrentTableG.Fields, length(CurrentTableG.Fields) + 1);
  CurrentTableG.Fields[High(CurrentTableG.Fields)] := TField.Create;
  with CurrentTableG.Fields[High(CurrentTableG.Fields)] do
  begin
    Name := AName;
    Caption := ACaption;
    Width := AWidth;
    MyType := AMyType;
    Visible := AVisible;
    NeedForJoin := ANeedForJoin;
    MyTableName := AMyTableName;
    JoinOfField := AJoinOfField;
  end;
end;

initialization
  TTable.AddTable('Students', 'Студенты');
  TField.AddField('StudentInitials', 'ФИО', 200, FTString, true, false, 'STUDENTS');
  TField.AddField('GroupID', 'Номер Группы', 100, FTInteger, false, true, 'GROUPS',
                  'GROUPID');
  TField.AddField('GroupNumber', 'Номер Группы', 100, FTInteger, true, false, 'GROUPS');

  TTable.AddTable('Teachers', 'Преподаватели');
  TField.AddField('TeacherID', 'ID', 100, FTInteger, false, false, 'TEACHERS');
  TField.AddField('TeacherInitials', 'ФИО', 200, FTString, true, false, 'TEACHERS');

  TTable.AddTable('EducActivities', 'Тип занятия');
  TField.AddField('EducID', 'ID', 100, FTInteger, false, false, 'EducActivities');
  TField.AddField('EducName', 'Название', 100, FTString, true, false, 'EducActivities');

  TTable.AddTable('Groups', 'Группы');
  TField.AddField('GroupID', 'ID', 30, FTInteger, false, false, 'Groups');
  TField.AddField('GroupNumber', 'Номер группы', 80, FTInteger, true, false, 'Groups');
  TField.AddField('GroupName', 'Название', 300, FTString, true, false, 'Groups');

  TTable.AddTable('Subjects', 'Предмет');
  TField.AddField('SubjectID', 'ID', 100, FTInteger, false, false, 'Subjects');
  TField.AddField('SubjectName', 'Название', 350, FTString, true, false, 'Subjects');

  TTable.AddTable('Audiences', 'Аудитория');
  TField.AddField('AudienceID', 'ID', 100, FTInteger, false, false, 'Audiences');
  TField.AddField('AudienceNumber', 'Номер аудитории', 200, FTString, true, false, 'Audiences');

  TTable.AddTable('Pairs', 'Занятие');
  TField.AddField('PairID', 'ID', 100, FTInteger, false, false, 'Pairs');
  TField.AddField('PairBegin', 'Начало', 150, FTString, true, false, 'Pairs');
  TField.AddField('PairEnd', 'Конец', 150, FTString, true, false, 'Pairs');
  TField.AddField('PairNumber', 'Номер', 100, FTString, true, false, 'Pairs');

  TTable.AddTable('WeekDays', 'День недели');
  TField.AddField('WeekDayID', 'ID', 100, FTInteger, false, false, 'WeekDays');
  TField.AddField('WeekDayName', 'Название', 150, FTString, true, false, 'WeekDays');
  TField.AddField('WeekDayNumber', 'Номер', 100, FTString, false, false, 'WeekDays');

  TTable.AddTable('Schedules', 'Расписание');
  TField.AddField('GroupID', 'ID Группа', 100, FTInteger, false, true, 'GROUPS',
                  'GROUPID');
  TField.AddField('GroupNumber', 'Номер Группы', 100, FTInteger, true, false, 'GROUPS');
  TField.AddField('WeekDayID', 'ID', 100, FTInteger, false, true,
                  'WEEKDAYS', 'WEEKDAYID');
  TField.AddField('WeekDayName', 'Название', 150, FTString, true, false, 'WeekDays');
  TField.AddField('PairID', 'Номер пары', 100, FTInteger, false, true,
                  'PAIRS', 'PAIRID');
  TField.AddField('PairBegin', 'Начало', 150, FTString, true, false, 'Pairs');
  TField.AddField('PairEnd', 'Конец', 150, FTString, true, false, 'Pairs');
  TField.AddField('PairNumber', 'Номер', 100, FTString, true, false, 'Pairs');
  TField.AddField('SubjectID', 'Предмет', 100, FTInteger, false, true,
                  'SUBJECTS', 'SUBJECTID');
  TField.AddField('SubjectName', 'Название', 350, FTString, true, false, 'Subjects');
  TField.AddField('EducID', 'Тип занятия', 100, FTInteger, false, true,
                  'EDUCACTIVITIES', 'EDUCID');
  TField.AddField('EducName', 'Название', 100, FTString, true, false, 'EducActivities');
  TField.AddField('TeacherID', 'Преподаватель', 100, FTInteger, false, true,
                  'TEACHERS', 'TEACHERID');
  TField.AddField('TeacherInitials', 'ФИО', 200, FTString, true, false, 'TEACHERS');
  TField.AddField('AudienceID', 'Номер аудитории', 100, FTInteger, false, true,
                  'AUDIENCES', 'AUDIENCEID');
  TField.AddField('AudienceNumber', 'Номер аудитории', 200, FTString, true, false, 'Audiences');

  TTable.AddTable('Teachers_Subjects', 'Преподователь-Предмет');
  TField.AddField('TeacherID', 'Преподаватель', 100, FTInteger, false, true,
                  'TEACHERS', 'TEACHERID');
  TField.AddField('TeacherInitials', 'ФИО', 200, FTString, true, false, 'TEACHERS');
  TField.AddField('SubjectID', 'Предмет', 100, FTInteger, false, true,
                  'SUBJECTS', 'SUBJECTID');
  TField.AddField('SubjectName', 'Название', 350, FTString, true, false, 'Subjects');

  TTable.AddTable('Group_Subjects', 'Группа-Предмет');
  TField.AddField('GroupID', 'ID Группа', 100, FTInteger, false, true, 'GROUPS',
                  'GROUPID');
  TField.AddField('GroupNumber', 'Номер Группы', 100, FTInteger, true, false, 'GROUPS');
  TField.AddField('SubjectID', 'Предмет', 100, FTInteger, false, true,
                  'SUBJECTS', 'SUBJECTID');
  TField.AddField('SubjectName', 'Название', 350, FTString, true, false, 'Subjects');
end.
