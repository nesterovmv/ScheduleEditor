unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  Menus, StdCtrls, MetaData, ListView;

type

  { TMainForm }

  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    Directory: TMenuItem;
    CloseProgram: TMenuItem;
    AboutProgram: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure DirectoryClick(Sender: TObject);
    procedure AboutProgramClick(Sender: TObject);
    procedure CloseProgramClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
var
  MenuItem: TMenuItem;
  i: integer;
begin
  for i := 0 to High(Tables) do
  begin
    MenuItem := TMenuItem.Create(Self);
    Directory.Add(MenuItem);
    MenuItem.Caption := Tables[i].PCaption;
    MenuItem.Tag := i;
    MenuItem.OnClick := @DirectoryClick;
  end;
end;

procedure TMainForm.DirectoryClick(Sender: TObject);
var
  i: integer;
  MenuItem: TMenuItem;
  DirForm: TListForm;
begin
  MenuItem := TMenuItem(Sender);
  with Screen do
    for i := 0 to FormCount - 1 do
    begin
      if Forms[i].Caption = MenuItem.Caption then
      begin
        if MenuItem.Checked then
        begin
          Forms[i].SetFocus;
          exit;
        end;
      end;
    end;
  begin
    DirForm := TListForm.Create(MenuItem);
    MenuItem.Checked := true;
    DirForm.Caption := MenuItem.Caption;
    DirForm.Show;
    DirForm.ConformityItemInDir := MenuItem;
    DirForm.GridAdd(Tables[MenuItem.Tag]);
  end;
end;

procedure TMainForm.AboutProgramClick(Sender: TObject);
begin
  ShowMessage('Программу создал Нестеров М.В. под руководством Кленина А.С.');
end;

procedure TMainForm.CloseProgramClick(Sender: TObject);
begin
  Application.Terminate;
end;

end.
