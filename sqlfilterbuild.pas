unit SQLFilterBuild;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type
  FilterPanel = class(TPanel)
    CBoxOfFields: TComboBox;
    CBoxOfConditions: TComboBox;
    EditConst: TEdit;
    DeleteFilter: TButton;
    constructor Create(TheOwner: TComponent);
  end;

implementation

constructor FilterPanel.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  Width := 900;
  Height := 26;
  Visible := True;
  BevelOuter := bvNone;

  CBoxOfFields := TComboBox.Create(self);
  with CBoxOfFields do
  begin
   Parent := self;
   Width := 171;
   Height := 26;
   Left := 24;
   Visible := True;
   ReadOnly := True;
  end;

  CBoxOfConditions := TComboBox.Create(self);
  with CBoxOfConditions do
  begin
   Parent := self;
   Width := 171;
   Height := 26;
   Left := 205;
   Visible := True;
   ReadOnly := True;
  end;

  EditConst := TEdit.Create(self);
  with EditConst do
  begin
   Parent := self;
   Caption := '';
   Width := 171;
   Height := 26;
   Left := 386;
   Visible := True;
  end;

  DeleteFilter := TButton.Create(self);
  with DeleteFilter do
  begin
   Parent := self;
   Caption := 'удалить';
   Width := 100;
   Height := 26;
   Left := 567;
   Visible := true;
  end;
end;

end.
