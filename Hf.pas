unit Hf;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Clipbrd, ExtCtrls;

type
  TForm1 = class(TForm)
    Image1: TImage;
    // это просто кнопка на форме - для демонстрации
  protected
    procedure RebuildWindowRgn;
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  Form1 : TForm1;
implementation

// ресурс этой формы
{$R *.DFM}

{ Прозрачная форма }
constructor TForm1.Create(AOwner: TComponent);
begin
  inherited;
  // убираем сколлбары, чтобы не мешались
  // при изменении размеров формы
  HorzScrollBar.Visible:=false;
  VertScrollBar.Visible:=false;
  // строим новый регион
  RebuildWindowRgn;
end;

procedure TForm1.Resize;
begin
  inherited;
  // строим новый регион
  RebuildWindowRgn;
end;

procedure TForm1.RebuildWindowRgn;
var
  FullRgn, Rgn: THandle;
  ClientX, ClientY, I: Integer;
begin
  // определяем относительные координаты клиенской части
  ClientX:=(Width-ClientWidth) div 2;
  ClientY:=Height-ClientHeight-ClientX;
  // создаем регион для всей формы
  FullRgn:=CreateRectRgn(0, 0, Width, Height);
  // создаем регион для клиентской части формы
  // и вычитаем его из FullRgn
  Rgn:=CreateRectRgn(ClientX, ClientY, ClientX+ClientWidth,
                                            ClientY+ClientHeight);
  CombineRgn(FullRgn, FullRgn, Rgn, rgn_Diff);
  // теперь добавляем к FullRgn регионы каждого контрольного элемента
  for i:=0 to ControlCount-1 do
   with Controls[i] do begin
    Rgn:=CreateRectRgn(ClientX+Left, ClientY+Top, ClientX+Left+Width, ClientY+Top+Height);
    CombineRgn(FullRgn, FullRgn, Rgn, rgn_Or);
   end;
  // устанавливаем новый регион окна
  SetWindowRgn(Handle, FullRgn, True);
end;

end.



