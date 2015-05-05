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
      AMyType: TFieldType; AVisible: boolean; ANeedForJoin: boolean = False;
      AMyTableName: string = ''; AJoinOfField: string = '');
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
  TableForAdd: TTable;

implementation

{ TTable }

class procedure TTable.AddTable(AName, ACaption: string);
var
  CurrentTable: TTable;
begin
  CurrentTable := TTable.Create;
  CurrentTable.Name := AName;
  CurrentTable.Caption := ACaption;
  TableForAdd := CurrentTable;
  Setlength(Tables, length(Tables) + 1);
  Tables[high(Tables)] := TableForAdd;
end;

{ TField }

class procedure TField.AddField(AName, ACaption: string; AWidth: integer;
  AMyType: TFieldType; AVisible: boolean; ANeedForJoin: boolean = False;
  AMyTableName: string = ''; AJoinOfField: string = '');
var
  CurrentField: TField;
begin
  SetLength(TableForAdd.Fields, length(TableForAdd.Fields) + 1);
  TableForAdd.Fields[High(TableForAdd.Fields)] := TField.Create;
  with TableForAdd.Fields[High(TableForAdd.Fields)] do
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
  TField.AddField('STUDENTID', 'ID', 50, FTInteger, False, False, 'STUDENTS');
  TField.AddField('STUDENTINITIALS', 'ФИО', 200, FTString, True, False, 'STUDENTS');
  TField.AddField('GROUPID', 'Номер Группы', 100, FTInteger, False, True,
    'GROUPS', 'GROUPID');
  TField.AddField('GROUPNUMBER', 'Номер Группы', 100, FTInteger, True, False, 'GROUPS');

  TTable.AddTable('Teachers', 'Преподаватели');
  TField.AddField('TEACHERID', 'ID', 100, FTInteger, False, False, 'TEACHERS');
  TField.AddField('TEACHERINITIALS', 'Преподаватель', 200, FTString,
    True, False, 'TEACHERS');

  TTable.AddTable('EducActivities', 'Тип занятия');
  TField.AddField('EDUCID', 'ID', 100, FTInteger, False, False, 'EDUCACTIVITIES');
  TField.AddField('EDUCNAME', 'Тип занятия', 100, FTString, True,
    False, 'EDUCACTIVITIES');

  TTable.AddTable('Groups', 'Группы');
  TField.AddField('GROUPID', 'ID', 30, FTInteger, False, False, 'GROUPS');
  TField.AddField('GROUPNUMBER', 'Номер группы', 80, FTInteger, True, False, 'GROUPS');
  TField.AddField('GROUPNAME', 'Название группы', 300, FTString, True, False, 'GROUPS');

  TTable.AddTable('SUBJECTS', 'Предмет');
  TField.AddField('SUBJECTID', 'ID', 100, FTInteger, False, False, 'SUBJECTS');
  TField.AddField('SUBJECTNAME', 'Название предмета', 350, FTString,
    True, False, 'SUBJECTS');

  TTable.AddTable('Audiences', 'Аудитория');
  TField.AddField('AUDIENCEID', 'ID', 100, FTInteger, False, False, 'AUDIENCES');
  TField.AddField('AUDIENCENUMBER', 'Номер аудитории', 200, FTString,
    True, False, 'AUDIENCES');

  TTable.AddTable('Pairs', 'Занятие');
  TField.AddField('PAIRID', 'ID', 100, FTInteger, False, False, 'PAIRS');
  TField.AddField('PAIRBEGIN', 'Начало', 150, FTString, True, False, 'PAIRS');
  TField.AddField('PAIREND', 'Конец', 150, FTString, True, False, 'PAIRS');
  TField.AddField('PAIRNUMBER', 'Номер пары', 100, FTString, True, False, 'PAIRS');

  TTable.AddTable('WeekDays', 'День недели');
  TField.AddField('WEEKDAYID', 'ID', 100, FTInteger, False, False, 'WEEKDAYS');
  TField.AddField('WEEKDAYNAME', 'День недели', 150, FTString, True, False, 'WEEKDAYS');
  TField.AddField('WEEKDAYNUMBER', 'Номер дня', 100, FTString, True, False, 'WEEKDAYS');

  TTable.AddTable('Schedules', 'Расписание');
  TField.AddField('RECORDID', 'ID', 100, FTInteger, False, False, 'SCHEDULES');
  TField.AddField('GROUPID', 'ID', 100, FTInteger, False, True, 'GROUPS',
    'GROUPID');
  TField.AddField('GROUPNUMBER', 'Номер Группы', 100, FTInteger, True, False, 'GROUPS');
  TField.AddField('WEEKDAYID', 'ID', 100, FTInteger, False, True,
    'WEEKDAYS', 'WEEKDAYID');
  TField.AddField('WEEKDAYNAME', 'День недели', 150, FTString, True, False, 'WEEKDAYS');
  TField.AddField('PAIRID', 'ID', 100, FTInteger, False, True,
    'PAIRS', 'PAIRID');
  TField.AddField('PAIRNUMBER', 'Номер пары', 100, FTString, True, False, 'PAIRS');
  TField.AddField('SUBJECTID', 'ID', 100, FTInteger, False, True,
    'SUBJECTS', 'SUBJECTID');
  TField.AddField('SUBJECTNAME', 'Название предмета', 350, FTString,
    True, False, 'SUBJECTS');
  TField.AddField('EDUCID', 'ID', 100, FTInteger, False, True,
    'EDUCACTIVITIES', 'EducID');
  TField.AddField('EducName', 'Тип занятия', 100, FTString, True,
    False, 'EDUCACTIVITIES');
  TField.AddField('TeacherID', 'Преподаватель', 100, FTInteger, False, True,
    'TEACHERS', 'TEACHERID');
  TField.AddField('TEACHERINITIALS', 'Преподаватель', 200, FTString,
    True, False, 'TEACHERS');
  TField.AddField('AUDIENCEID', 'ID', 100, FTInteger, False, True,
    'AUDIENCES', 'AUDIENCEID');
  TField.AddField('AUDIENCENUMBER', 'Номер аудитории', 200, FTString,
    True, False, 'AUDIENCES');

  TTable.AddTable('Teachers_Subjects', 'Преподователь-Предмет');
  TField.AddField('RECORDID', 'ID', 100, FTInteger, False, False, 'TEACHERS_SUBJECTS');
  TField.AddField('TEACHERID', 'ID', 100, FTInteger, False, True,
    'TEACHERS', 'TEACHERID');
  TField.AddField('TEACHERINITIALS', 'Преподаватель', 200, FTString,
    True, False, 'TEACHERS');
  TField.AddField('SUBJECTID', 'ID', 100, FTInteger, False, True,
    'SUBJECTS', 'SUBJECTID');
  TField.AddField('SUBJECTNAME', 'Название предмета', 350, FTString,
    True, False, 'SUBJECTS');

  TTable.AddTable('Group_Subjects', 'Группа-Предмет');
  TField.AddField('RECORDID', 'ID', 100, FTInteger, False, False, 'GROUP_SUBJECTS');
  TField.AddField('GROUPID', 'ID', 100, FTInteger, False, True, 'GROUPS',
    'GROUPID');
  TField.AddField('GROUPNUMBER', 'Номер Группы', 100, FTInteger, True, False, 'GROUPS');
  TField.AddField('SUBJECTID', 'ID', 100, FTInteger, False, True,
    'SUBJECTS', 'SUBJECTID');
  TField.AddField('SUBJECTNAME', 'Название предмета', 350, FTString,
    True, False, 'SUBJECTS');
end.
