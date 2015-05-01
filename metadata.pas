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
  AMyType: TFieldType; AVisible: boolean; ANeedForJoin: boolean = false; AMyTableName: string = '';
  AJoinOfField: string = '');
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
    //MyTableName := TableForAdd.Name;
    MyTableName := AMyTableName;
    JoinOfField := AJoinOfField;
  end;
end;

initialization
  TTable.AddTable('Students', 'Студенты');
  TField.AddField('STUDENTINITIALS', 'ФИО', 200, FTString, true, false, 'STUDENTS');
  //TField.AddField('STUDENTINITIALS', 'ФИО', 200, FTString, true, false);БЕЗ АРГУМЕНТА МАЙТЭЙБЛ ПУСТ
  TField.AddField('GROUPID', 'Номер Группы', 100, FTInteger, false, true,
                  'GROUPS', 'GROUPID');
  TField.AddField('GROUPNUMBER', 'Номер Группы', 100, FTInteger, true, false, 'GROUPS');

  TTable.AddTable('Teachers', 'Преподаватели');
  TField.AddField('TEACHERID', 'ID', 100, FTInteger, false, false, 'TEACHERS');
  TField.AddField('TEACHERINITIALS', 'Преподаватель', 200, FTString, true, false, 'TEACHERS');

  TTable.AddTable('EducActivities', 'Тип занятия');
  TField.AddField('EDUCID', 'ID', 100, FTInteger, false, false, 'EDUCACTIVITIES');
  TField.AddField('EDUCNAME', 'Тип занятия', 100, FTString, true, false, 'EDUCACTIVITIES');

  TTable.AddTable('Groups', 'Группы');
  TField.AddField('GROUPID', 'ID', 30, FTInteger, false, false, 'GROUPS');
  TField.AddField('GROUPNUMBER', 'Номер группы', 80, FTInteger, true, false, 'GROUPS');
  TField.AddField('GROUPNAME', 'Название группы', 300, FTString, true, false, 'GROUPS');

  TTable.AddTable('SUBJECTS', 'Предмет');
  TField.AddField('SUBJECTID', 'ID', 100, FTInteger, false, false, 'SUBJECTS');
  TField.AddField('SUBJECTNAME', 'Название предмета', 350, FTString, true, false, 'SUBJECTS');

  TTable.AddTable('Audiences', 'Аудитория');
  TField.AddField('AUDIENCEID', 'ID', 100, FTInteger, false, false, 'AUDIENCES');
  TField.AddField('AUDIENCENUMBER', 'Номер аудитории', 200, FTString, true, false, 'AUDIENCES');

  TTable.AddTable('Pairs', 'Занятие');
  TField.AddField('PAIRSID', 'ID', 100, FTInteger, false, false, 'PAIRS');
  TField.AddField('PAIRSBEGIN', 'Начало', 150, FTString, true, false, 'PAIRS');
  TField.AddField('PAIRSEND', 'Конец', 150, FTString, true, false, 'PAIRS');
  TField.AddField('PAIRNUMBER', 'Номер пары', 100, FTString, true, false, 'PAIRS');

  TTable.AddTable('WeekDays', 'День недели');
  TField.AddField('WEEKDAYID', 'ID', 100, FTInteger, false, false, 'WEEKDAYS');
  TField.AddField('WEEKDAYNAME', 'День недели', 150, FTString, true, false, 'WEEKDAYS');
  TField.AddField('WEEKDAYNUMBER', 'Номер дня', 100, FTString, false, false, 'WEEKDAYS');

  TTable.AddTable('Schedules', 'Расписание');
  TField.AddField('GROUPID', 'ID Группы', 100, FTInteger, false, true, 'GROUPS',
                  'GROUPID');
  TField.AddField('GROUPNUMBER', 'Номер Группы', 100, FTInteger, true, false, 'GROUPS');
  TField.AddField('WEEKDAYID', 'ID', 100, FTInteger, false, true,
                  'WEEKDAYS', 'WEEKDAYID');
  TField.AddField('WEEKDAYNAME', 'День недели', 150, FTString, true, false, 'WEEKDAYS');
  TField.AddField('PAIRID', 'Номер пары', 100, FTInteger, false, true,
                  'PAIRS', 'PAIRID');
  TField.AddField('PAIRBEGIN', 'Начало', 150, FTString, true, false, 'PAIRS');
  TField.AddField('PAIREND', 'Конец', 150, FTString, true, false, 'PAIRS');
  TField.AddField('PAIRNUMBER', 'Номер пары', 100, FTString, true, false, 'PAIRS');
  TField.AddField('SUBJECTID', 'ID', 100, FTInteger, false, true,
                  'SUBJECTS', 'SUBJECTID');
  TField.AddField('SUBJECTNAME', 'Название предмета', 350, FTString, true, false, 'SUBJECTS');
  TField.AddField('EDUCID', 'Тип занятия', 100, FTInteger, false, true,
                  'EDUCACTIVITIES', 'EducID');
  TField.AddField('EducName', 'Тип занятия', 100, FTString, true, false, 'EDUCACTIVITIES');
  TField.AddField('TeacherID', 'Преподаватель', 100, FTInteger, false, true,
                  'TEACHERS', 'TEACHERID');
  TField.AddField('TEACHERINITIALS', 'Преподаватель', 200, FTString, true, false, 'TEACHERS');
  TField.AddField('AUDIENCEID', 'Номер аудитории', 100, FTInteger, false, true,
                  'AUDIENCES', 'AUDIENCEID');
  TField.AddField('AUDIENCENUMBER', 'Номер аудитории', 200, FTString, true, false, 'AUDIENCES');

  TTable.AddTable('Teachers_Subjects', 'Преподователь-Предмет');
  TField.AddField('TEACHERID', 'Преподаватель', 100, FTInteger, false, true,
                  'TEACHERS', 'TEACHERID');
  TField.AddField('TEACHERSINITIALS', 'Преподаватель', 200, FTString, true, false, 'TEACHERS');
  TField.AddField('SUBJECTID', 'ID', 100, FTInteger, false, true,
                  'SUBJECT', 'SUBJECTID');
  TField.AddField('SUBJECTNAME', 'Название предмета', 350, FTString, true, false, 'SUBJECTS');

  TTable.AddTable('Group_Subjects', 'Группа-Предмет');
  TField.AddField('GROUPID', 'ID Группа', 100, FTInteger, false, true, 'GROUPS',
                  'GROUPID');
  TField.AddField('GROUPNUMBER', 'Номер Группы', 100, FTInteger, true, false, 'GROUPS');
  TField.AddField('SUBJECTID', 'ID', 100, FTInteger, false, true,
                  'SUBJECTS', 'SUBJECTID');
  TField.AddField('SUBJECTNAME', 'Название предмета', 350, FTString, true, false, 'SUBJECTS');
end.
