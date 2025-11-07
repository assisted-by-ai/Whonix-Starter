(*
 * Whonix Starter ( whonixstarter_main.pas )
 *
 * Copyright: 2012 - 2025 ENCRYPTED SUPPORT LLC <adrelanos@riseup.net>
 * Author: einsiedler90@protonmail.com
 * License: See the file COPYING for copying conditions.
 *)

unit WhonixStarter_Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, Process, WhonixStarterAppConfig;

type

  { TMainForm }

  TMainForm = class(TForm)
    ButtonStartStop: TButton;
    ButtonAdvanced: TButton;
    procedure ButtonAdvancedClick(Sender: TObject);
    procedure ButtonStartStopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  MainForm: TMainForm;

implementation

uses WhonixStarter_Error;

{$R *.lfm}

{ TMainForm }

procedure TMainForm.ButtonAdvancedClick(Sender: TObject);
var
  Process: TProcess;
begin
  if not FileExists(AppConfig.VirtualBoxPath) then
  begin
    ErrorForm.MemoError.Lines.Text := 'binary "VirtualBox" not found';
    ErrorForm.ShowModal;
  end;

  Process := TProcess.Create(nil);
  try
    Process.Executable := AppConfig.VirtualBoxPath;
    Process.Execute;
  finally
    Process.Free;
  end;
end;

procedure TMainForm.ButtonStartStopClick(Sender: TObject);
var
  ProcessA, ProcessB: TProcess;
begin
  if not FileExists(AppConfig.VBoxManagePath) then
  begin
    ErrorForm.MemoError.Lines.Text := 'binary "VBoxManage" not found';
    ErrorForm.ShowModal;
  end;

  if (ButtonStartStop.Caption = 'Start Whonix') then
  begin
    ProcessA := TProcess.Create(nil);
    try
      ProcessA.Executable := AppConfig.VBoxManagePath;
      ProcessA.Parameters.Clear;
      ProcessA.Parameters.Add('startvm');
      ProcessA.Parameters.Add('Whonix-Workstation-Xfce');
      ProcessA.Execute;
    finally
      ProcessA.Free;
    end;
    ProcessB := TProcess.Create(nil);
    try
      ProcessB.Executable := AppConfig.VBoxManagePath;
      ProcessB.Parameters.Clear;
      ProcessB.Parameters.Add('startvm');
      ProcessB.Parameters.Add('Whonix-Gateway-Xfce');
      ProcessB.Execute;
    finally
      ProcessB.Free;
    end;
    ButtonStartStop.Caption := 'Stop Whonix';
  end
  else
  if (ButtonStartStop.Caption = 'Stop Whonix') then
  begin
    ProcessA := TProcess.Create(nil);
    try
      ProcessA.Executable := AppConfig.VBoxManagePath;
      ProcessA.Parameters.Clear;
      ProcessA.Parameters.Add('controlvm');
      ProcessA.Parameters.Add('Whonix-Workstation-Xfce');
      ProcessA.Parameters.Add('poweroff');
      ProcessA.Execute;
    finally
      ProcessA.Free;
    end;
    ProcessB := TProcess.Create(nil);
    try
      ProcessB.Executable := AppConfig.VBoxManagePath;
      ProcessB.Parameters.Clear;
      ProcessB.Parameters.Add('controlvm');
      ProcessB.Parameters.Add('Whonix-Gateway-Xfce');
      ProcessB.Parameters.Add('poweroff');
      ProcessB.Execute;
    finally
      ProcessB.Free;
    end;
    ButtonStartStop.Caption := 'Start Whonix';
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  MainForm.Icon.LoadFromResourceName(Hinstance, 'MAINICON');
end;

end.
