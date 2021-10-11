unit Hf;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Clipbrd, ExtCtrls;

type
  TForm1 = class(TForm)
    Image1: TImage;
    // ��� ������ ������ �� ����� - ��� ������������
  protected
    procedure RebuildWindowRgn;
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  Form1 : TForm1;
implementation

// ������ ���� �����
{$R *.DFM}

{ ���������� ����� }
constructor TForm1.Create(AOwner: TComponent);
begin
  inherited;
  // ������� ���������, ����� �� ��������
  // ��� ��������� �������� �����
  HorzScrollBar.Visible:=false;
  VertScrollBar.Visible:=false;
  // ������ ����� ������
  RebuildWindowRgn;
end;

procedure TForm1.Resize;
begin
  inherited;
  // ������ ����� ������
  RebuildWindowRgn;
end;

procedure TForm1.RebuildWindowRgn;
var
  FullRgn, Rgn: THandle;
  ClientX, ClientY, I: Integer;
begin
  // ���������� ������������� ���������� ��������� �����
  ClientX:=(Width-ClientWidth) div 2;
  ClientY:=Height-ClientHeight-ClientX;
  // ������� ������ ��� ���� �����
  FullRgn:=CreateRectRgn(0, 0, Width, Height);
  // ������� ������ ��� ���������� ����� �����
  // � �������� ��� �� FullRgn
  Rgn:=CreateRectRgn(ClientX, ClientY, ClientX+ClientWidth,
                                            ClientY+ClientHeight);
  CombineRgn(FullRgn, FullRgn, Rgn, rgn_Diff);
  // ������ ��������� � FullRgn ������� ������� ������������ ��������
  for i:=0 to ControlCount-1 do
   with Controls[i] do begin
    Rgn:=CreateRectRgn(ClientX+Left, ClientY+Top, ClientX+Left+Width, ClientY+Top+Height);
    CombineRgn(FullRgn, FullRgn, Rgn, rgn_Or);
   end;
  // ������������� ����� ������ ����
  SetWindowRgn(Handle, FullRgn, True);
end;

end.



