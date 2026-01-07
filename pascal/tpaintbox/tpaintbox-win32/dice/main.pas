{ |========================================================================|
  |                                                                        |
  |                  Projet : Aller plus loin avec Lazarus                 |
  |                  Description : POO - Programme exemple 32              |
  |                  Unité : main.pas                                      |
  |                  Site : www.developpez.net                             |
  |                  Copyright : © Roland CHASTAIN & Gilles VASSEUR 2016   |
  |                  d'après une idée originale de Jean-Luc GOFFLOT        |
  |                  Date:    31/08/2016 17:27:10                          |
  |                  Version : 1.0.0                                       |
  |                                                                        |
  |========================================================================| }

// HISTORIQUE
// 31/08/2016 17:27:10 - 1.0.0 - première version opérationnelle

// MAIN - part of "Aller plus loin avec Lazarus"
// Copyright © Roland CHASTAIN & Gilles VASSEUR 2016
//
// This program is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the
// Free Software Foundation, either version 3 of the License,
// or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY;
// without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE.
// See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.
// If not, see <http://www.gnu.org/licenses/>.

unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, ExtCtrls, dice;

type

  { TMainForm }

  TMainForm = class(TForm)
    btnRollDice: TButton;
    btnDiceKeep: TButton;
    btnFlipCoin: TButton;
    btnFlipCoinKeep: TButton;
    btn2DDice: TButton;
    btn2DDiceKeep: TButton;
    pnl2DDice: TPanel;
    pnlFlipCoin: TPanel;
    pnlDice: TPanel;
    StatusBar: TStatusBar;
    procedure btn2DDiceClick(Sender: TObject);
    procedure btn2DDiceKeepClick(Sender: TObject);
    procedure btnFlipCoinClick(Sender: TObject);
    procedure btnDiceKeepClick(Sender: TObject);
    procedure btnFlipCoinKeepClick(Sender: TObject);
    procedure btnRollDiceClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { private declarations }
    MyDice: TDice;
    MyFlipCoin: TFlipCoinCairo; // ### 1
    My2DDice: TDice2DCairo; // ### 2
  public
    { public declarations }
    procedure Changed(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

uses
  strutils;

{$R *.lfm}

resourcestring
  rsValues = 'Valeur du dé : %d - Garder : %s || Valeur de la pièce : '
    +'%s - Garder : %s || Valeur du dé 2D : %d - Garder : %s';
  rsYes = 'OUI';
  rsNo = 'NON';
  rsTails = 'PILE';
  rsHeads = 'FACE';

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
// *** création de la fiche et des jeux ***
begin
  Randomize;
  MyDice := TDice.Create(pnlDice);
  MyDice.Parent := pnlDice;
  MyDice.OnChange := @Changed;
  MyFlipCoin := TFlipCoinCairo.Create(pnlFlipCoin); // ### 3
  MyFlipCoin.Parent := pnlFlipCoin;
  MyFlipCoin.OnChange := @Changed;
  My2DDice := TDice2DCairo.Create(pnl2DDice); // ### 4
  My2DDice.Parent := pnl2DDice;
  My2DDice.OnChange := @Changed;
end;

procedure TMainForm.btnRollDiceClick(Sender: TObject);
// *** nouvelle valeur du dé ***
begin
  MyDice.RandomValue.NewValue;
end;

procedure TMainForm.btnDiceKeepClick(Sender: TObject);
// *** valeur du dé conservée ? ***
begin
  MyDice.RandomValue.Keep := not MyDice.RandomValue.Keep;
end;

procedure TMainForm.btnFlipCoinKeepClick(Sender: TObject);
// *** valeur de la pièce conservée ?
begin
  MyFlipCoin.RandomValue.Keep := not MyFlipCoin.RandomValue.Keep;
end;

procedure TMainForm.btnFlipCoinClick(Sender: TObject);
// *** jet de la pièce ***
begin
  MyFlipCoin.RandomValue.NewValue;
end;

procedure TMainForm.btn2DDiceKeepClick(Sender: TObject);
// *** valeur du dé 2D conservée ? ***
begin
  My2DDice.RandomValue.Keep := not My2DDice.RandomValue.Keep;
end;

procedure TMainForm.btn2DDiceClick(Sender: TObject);
// *** jet du dé 2D ***
begin
  My2DDice.RandomValue.NewValue;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
// *** destruction de la fiche et de ses éléments ***
begin
  MyDice.Free;
  MyFlipCoin.Free;
  My2DDice.Free;
end;

procedure TMainForm.Changed(Sender: TObject);
// *** changement d'un élément ***
begin
  StatusBar.SimpleText := Format(rsValues, [MyDice.RandomValue.Value,
    ifthen(MyDice.RandomValue.Keep, rsYes, rsNo),
    ifthen(MyFlipCoin.RandomValue.Value = 0, rsTails, rsHeads),
    ifthen(MyFlipCoin.RandomValue.Keep, rsYes, rsNo),
    My2DDice.RandomValue.Value,
    ifthen(My2DDice.RandomValue.Keep, rsYes, rsNo)]);
end;

end.

