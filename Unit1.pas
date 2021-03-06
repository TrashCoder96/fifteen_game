unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Forms, Buttons, jpeg, mmsystem,
  ExtCtrls, StdCtrls, Controls;
type
 TMas = array of array of integer;
 TArrayMas = array of TMas;
type
  TField = class(TObject)
  Access: boolean;
  Size: integer;
  Mas: TMas;
  Image: TBitmap;
  constructor CreateField(S: integer);
  procedure DrawField;
  procedure Move(X1, Y1, X2, Y2: integer);
  procedure ClickField(X, Y: integer);
  end;

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    Image1: TImage;
    Button1: TButton;
    Timer1: TTimer;
    Image2: TImage;
    Button2: TButton;
    Timer2: TTimer;
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Field: TField; //������� ����
  Way: array of integer; //������ ����
  WayCount: integer; //���������� ����� � ����
implementation

{$R *.dfm}
{$R PerfWorld.res}

procedure TField.ClickField(X, Y: integer);//���������� ���� �� image
var a, b, Step: integer;
begin
if (Field.Access = false) or not ((X >= 0) and (X <= 500) and (Y >= 0) and (Y <= 500)) then Exit;
Step := Round(500/Size);
//��������� ����������
//������ a
a := 0;
while a * Step < X do
 a := a + 1;

//������ b
b := 0;
while b * Step < Y do
 b := b + 1;

a := a - 1;
b := b - 1;

//a, b - ���������� ������, ���� �� ��������

if Mas[a, b] <> 0 then
 begin
 if (a + 1 >= 0) and (a + 1 < Size) and (b >= 0) and (b < Size) and (Mas[a + 1, b] = 0) then Move(a, b, a + 1, b);
 if (a - 1 >= 0) and (a - 1 < Size) and (b >= 0) and (b < Size) and (Mas[a - 1, b] = 0) then Move(a, b, a - 1, b);
 if (a >= 0) and (a < Size) and (b + 1 >= 0) and (b + 1 < Size) and (Mas[a, b + 1] = 0) then Move(a, b, a, b + 1);
 if (a >= 0) and (a < Size) and (b - 1 >= 0) and (b - 1 < Size) and (Mas[a, b - 1] = 0) then Move(a, b, a, b - 1);
 end;
DrawField;

end;

function MID(a, b: integer): integer;
begin
if a < b then MID := a else MID := b;
end;

function BID(a, b: integer): integer;
begin
if a > b then BID := a else BID := b;
end;


procedure TField.Move(X1, Y1, X2, Y2: integer);
var P: integer;
    Picture, Pic1, Pic2: TBitmap;
    Step, StepM: integer;

    RectA, RectO, Rect1O, Rect2O, RectOi: TRect;
begin
P := Mas[X1, Y1];
Mas[X1, Y1] := Mas[X2, Y2];
Mas[X2, Y2] := P;

Step := Round(500/Size);
StepM := Round(Step/25 + 1);
Picture := TBitmap.Create;

Pic1 := TBitmap.Create;
Pic1.Height := Step - 6;
Pic1.Width := Step - 6;

Pic2 := TBitmap.Create;
Pic2.Height := Step - 6;
Pic2.Width := Step - 6;

if X1 = X2 then
 begin
 Picture.Height := 2*Step;
 Picture.Width := Step;

 RectA.Top := MID(Y1, Y2) * Step;
 RectA.Left := X1*Step;
 RectA.Bottom := MID(Y1, Y2) * Step + 2*Step;
 RectA.Right := X1*Step + Step;;

 RectO.Top := 0;
 RectO.Left := 0;
 RectO.Bottom := 2*Step;
 RectO.Right := Step;

 Rect1O.Top := 3;
 Rect1O.Left := 3;
 Rect1O.Bottom := Step - 3;
 Rect1O.Right := Step - 3;

 RectOi.Top := 0;
 RectOi.Left := 0;
 RectOi.Bottom := Step - 6;
 RectOi.Right := Step - 6;


 Rect2O.Top := Step + 3;
 Rect2O.Left := 3;
 Rect2O.Bottom := 2*Step - 3;
 Rect2O.Right := Step - 3;


 Picture.Canvas.CopyRect(RectO, Form1.Image1.Canvas, RectA);

 Pic1.Canvas.CopyRect(RectOi, Picture.Canvas, Rect1O);
 Pic2.Canvas.CopyRect(RectOi, Picture.Canvas, Rect2O);

 //��������� �����������
 While P <= Step do
  begin
  P := P + StepM;
  //������� picture
  Picture.Canvas.Brush.Color := clWhite;
  Picture.Canvas.FillRect(Rect(0, 0, Picture.Width, Picture.Height));
  if Y1 < Y2 then
  Picture.Canvas.Draw(3, 3 + P, Pic1)
  else
  Picture.Canvas.Draw(3, Step + 3 - P, Pic2);

  Form1.Image1.Canvas.Draw(Step*X1, MID(Y1, Y2)*Step, Picture);
  Form1.Image1.Refresh;
  end;
 end
else if (Y1 = Y2) then
 begin
 Picture.Height := Step;
 Picture.Width := Step *2;
 P := 0;

 RectA.Top := Y1 * Step;
 RectA.Left := MID(X1, X2)*Step;
 RectA.Bottom := Y1 * Step + Step;
 RectA.Right := RectA.Left + 2*Step;

 RectO.Top := 0;
 RectO.Left := 0;
 RectO.Bottom := Step;
 RectO.Right := Step*2;

 Rect1O.Top := 3;
 Rect1O.Left := 3;
 Rect1O.Bottom := Step - 3;
 Rect1O.Right := Step - 3;

 RectOi.Top := 0;
 RectOi.Left := 0;
 RectOi.Bottom := Step - 6;
 RectOi.Right := Step - 6;


 Rect2O.Top := 3;
 Rect2O.Left := Step + 3;
 Rect2O.Bottom := Step - 3;
 Rect2O.Right := 2*Step - 3;


 Picture.Canvas.CopyRect(RectO, Form1.Image1.Canvas, RectA);

 Pic1.Canvas.CopyRect(RectOi, Picture.Canvas, Rect1O);
 Pic2.Canvas.CopyRect(RectOi, Picture.Canvas, Rect2O);

 //��������� �����������
 While P <= Step do
  begin
  P := P + StepM;
  //������� picture
  Picture.Canvas.Brush.Color := clWhite;
  Picture.Canvas.FillRect(Rect(0, 0, Picture.Width, Picture.Height));
  if X2 > X1 then
  Picture.Canvas.Draw(3 + P, 3, Pic1)
  else
  Picture.Canvas.Draw(Step + 3 - P, 3, Pic2);

  Form1.Image1.Canvas.Draw(Step*MID(X1, X2), Y1*Step, Picture);
  Form1.Image1.Refresh;
  end;
 end;
Picture.Free;
Pic1.Free;
Pic2.Free;
end;

constructor TField.CreateField(S: integer);
var i, j: integer;
begin
Size := S;
Access := true;
SetLength(Mas, S, S);
Image := TBitmap.Create;
Image.Height := 500;
Image.Width := 500;
//������������� �����
for i := 1 to Size do
 for j := 1 to Size do
  Mas[i - 1, j - 1] := (j - 1)* Size + i;
  Mas[Size - 1, Size - 1] := 0;
DrawField;
end;

procedure TField.DrawField;
var i, j: integer;
    Step: integer;
begin
Step := Round(500/Size);
Image.Canvas.Brush.Color := clWhite;
Image.Canvas.Pen.Color := clWhite;

Image.Canvas.Rectangle(0, 0, 500, 500);

Image.Canvas.Pen.Color := clBlack;
Image.Canvas.Font.Color := RGB(255, 45, 0);
Image.Canvas.Font.Size := Round((Step)/3);
for i := 1 to Size do
 for j := 1 to Size do
 if Mas[i - 1, j - 1] <> 0 then
  begin
  Image.Canvas.Brush.Color := RGB(255, 255, 254);
  Image.Canvas.Rectangle(i*Step - Step + 3, j*Step - Step + 3, i*Step - 3, j*Step - 3);
  Image.Canvas.TextOut(i*Step - Round(2* Step/3), j*Step - Round(2* Step/3), IntToStr(Mas[i - 1, j - 1]));
  end;

Form1.Image1.Picture.Bitmap := Image;
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if Field <> nil then
Field.ClickField(X, Y);
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
PlaySound('PerfectWorld', 0, SND_RESOURCE or SND_LOOP or SND_ASYNC);
Field := TField.CreateField(4);
Image1.Transparent := true;
BitBtn1.Enabled := false;
Button1.Enabled := true;
Button2.Enabled := true;
end;

procedure TForm1.FormCreate(Sender: TObject);
 var i: integer;
begin
Field := nil;
Form1.DoubleBuffered := true;
Button1.Enabled := false;
Button2.Enabled := false;
Form1.AlphaBlend := true;
Form1.AlphaBlendValue := 0;
Timer2.Enabled := true;
end;


procedure A;
type TMasArray = array of TMas;
var i, j, k, l, r, p: integer; //���������� ��� ������ �� ���������
    ClosedArray, OpenArray: TMasArray; //�������� � �������� �������
    ClosedCount, OpenCount: integer; //���������� ��������� � �������� � �������� �������
    ClosedGrand, OpenGrand: array of integer; //�������������� ������ � �������� � �������� ��������
    ClosedLavels, OpenLavels: array of integer; //������ ������ � �������� � �������� �������
    FOpen: array of integer; //������ ������ ��� OpenArray
    X, Y, X1, Y1: integer; //���������� ������ ������

    i1, j1: integer; //���������� ��� ������������� ����������

    New: TMas; //����� �������
    FN: integer; //� ������
    Min: integer; //����������� ������

    C, O, T, IFL: boolean; //���������� ����������
    Grand: integer; //������ ������������ �������
    E: integer;
    pot: integer;
    label Reinstatement;
begin

OpenCount := 1;
SetLength(OpenArray, OpenCount);
SetLength(OpenLavels, OpenCount);

SetLength(OpenArray[0], Field.Size, Field.Size);
OpenArray[0] := Field.Mas;
SetLength(FOpen, 1);
FOpen[0] := 0;

SetLength(OpenGrand, 1);
OpenGrand[0] := 5;

//������ ��������� ���������
for i := 0 to Field.Size - 1 do
   for j := 0 to Field.Size - 1 do
    if OpenArray[0][i, j] <> 0 then
     begin
      //� ��� ������� ���������� i, j ������ � ����� � ���� ������
       i1 := OpenArray[0][i, j] mod Field.Size;
       j1 := OpenArray[0][i, j] div Field.Size;
       if i1 = 0 then i1 := Field.Size
       else
       j1 := j1 + 1;

       i1 := i1 - 1;
       j1 := j1 - 1;
       //����������� ������������ ���������� ����� i1, j1 � i, j � ��������� � ������

       FOpen[0] := FOpen[0] + Abs(i1 - i) + Abs(j1 - j);
     end;

OpenLavels[0] := 0;
ClosedCount := 0;
if FOpen[0] = 0 then begin Form1.Button1.Enabled := true; Form1.Button2.Enabled := true; Field.Access := true; Exit; end;
while OpenCount > 0 do
 begin
 //� ��� ������� ������ OpenArray, ���������� ������������� �������
 //� ClosedArray, ���������� �����������
 //������ ���������� Min

 Min := FOpen[0];

 for k := 1 to OpenCount - 1 do
  if Min > FOpen[k] then Min := FOpen[k];
  E := High(OpenArray);
  k := -1;
 //������ �������� � OpenArray �� �������, ������� ���������� ������ Min
  while E > k do
  begin
  k := k + 1;
  if FOpen[k] = Min then
   begin
   //������� ������� OpenArray[k] �� ������ �������� ������ � ��������� � �������� ������
   ClosedCount := ClosedCount + 1;
   E := E - 1;
   SetLength(ClosedArray, ClosedCount);
   SetLength(ClosedGrand, ClosedCount);
   SetLength(ClosedLavels, ClosedCount);
   ClosedGrand[ClosedCount - 1] := OpenGrand[k];
   ClosedLavels[ClosedCount - 1] := OpenLavels[k];

   SetLength(ClosedArray[ClosedCount - 1], Field.Size, Field.Size);

      ClosedArray[ClosedCount - 1] := OpenArray[k];


   for l := k to OpenCount - 2 do
    begin
    OpenArray[l] := OpenArray[l + 1];
    OpenGrand[l] := OpenGrand[l + 1];
    FOpen[l] := FOpen[l + 1];
    OpenLAvels[l] := OpenLavels[l + 1];
    end;
    OpenCount := OpenCount - 1;
    SetLength(OpenArray, OpenCount);
    SetLength(OpenGrand, OpenCount);
    SetLength(OpenLavels, OpenCount);
   //����� ��������

   //�������� ��� �������

   //������ ������ ������
   for i := 0 to Field.Size - 1 do
    for j := 0 to Field.Size - 1 do
     if ClosedArray[ClosedCount - 1][i, j] = 0 then begin X := i; Y := j; end;


     for p := 1 to 4 do
      begin
      case p of
      1:
       begin
       IFL := (X - 1 >= 0) and (ClosedGrand[ClosedCount - 1] <> 3);
       X1 := -1;
       Y1 := 0;
       pot := 1;
       end;
      2:
       begin
       IFL := (X + 1 <= Field.Size - 1) and (ClosedGrand[ClosedCount - 1] <> 1);
       X1 := 1;
       Y1 := 0;
       pot := 3;
       end;
      3:
       begin
       IFL := (Y - 1 >= 0) and (ClosedGrand[ClosedCount - 1] <> 4);
       X1 := 0;
       Y1 := -1;
       pot := 2;
       end;
      4:
       begin
       IFL := (Y + 1 <= Field.Size - 1) and (ClosedGrand[ClosedCount - 1] <> 2);
       X1 := 0;
       Y1 := 1;
       pot := 4;
       end;
      end;


     if IFL then
     begin
     SetLength(New, Field.Size, Field.Size);
     for i := 0 to Field.Size - 1 do
      for j := 0 to Field.Size - 1 do
      New[i, j] := ClosedArray[ClosedCount - 1][i, j];

      New[X, Y] := New[X + X1, Y + Y1];
      New[X + X1, Y + Y1] := 0;
      //���������� ����� ������� New


      //������ New
      FN := ClosedLavels[ClosedCount - 1] + 1;
       for i := 0 to Field.Size - 1 do
        for j := 0 to Field.Size  - 1 do
         if New[i, j] <> 0 then
          begin
          //� ��� ������� ���������� i, j ������ � ����� � ���� ������
          i1 := New[i, j] mod Field.Size;
          j1 := New[i, j] div Field.Size;
          if i1 = 0 then i1 := Field.Size
          else
          j1 := j1 + 1;

          i1 := i1 - 1;
          j1 := j1 - 1;
          //����������� ������������ ���������� ����� i1, j1 � i, j � ��������� � ������

          FN := FN + Abs(i1 - i) + Abs(j1 - j);
          end;
      //������� New ������� FN
      if FN = ClosedLavels[ClosedCount - 1] + 1 then begin Grand := pot; goto Reinstatement; end;


     //� ��� ���� ������� New, ����� ���������, ���� �� ��� � �������� ��� �������� ������


      O := false;
      C := false;

      //(1)�������� �� ������� � �������� ������
      for l := 0 to OpenCount - 1 do
       begin
       T := true;
       for i := 0 to Field.Size - 1 do
        for j := 0 to Field.Size - 1 do
         if OpenArray[l][i, j] <> New[i, j] then begin T := false; Break; end;
        //���� ����� ������� ��� ���� � ������, ��
       if T then
        begin
        O := true;
        if (FN < FOpen[l]) then
         begin
         //������� ������� OpenArray[l]
         for r := l to OpenCount - 2 do
          begin
          OpenArray[r] := OpenArray[r + 1];
          OpenGrand[r] := OpenGrand[r + 1];
          FOpen[r] := FOpen[r + 1];
          OpenLavels[r] := OpenLavels[r + 1];
          end;
         OpenCount := OpenCount - 1;
         SetLength(OpenArray, OpenCount);
         SetLength(OpenGrand, OpenCount);
         SetLength(FOpen, OpenCount);
         SetLength(OpenLavels, OpenCount);
         O := false;
         Break;
         end;
       end;
       end;
       //(1)����� �������� �� ������� � �������� ������
       //�������� �� ������� � �������� ������
       for l := 0 to ClosedCount - 1 do
        begin
        T := true;
        for i := 0 to Field.Size - 1 do
         for j := 0 to Field.Size - 1 do
          if ClosedArray[l][i, j] <> New[i, j] then begin T := false; Break; end;
          if T then
           C := true;
        //����� �������� ������� � ��
        end;


      //(3)���� ������� ��� �� � �������� ������, �� � ��������,
      if not (O or C) then
       begin
       //��������� ������� � �������� ������
       OpenCount := OpenCount + 1;
       SetLength(OpenArray, OpenCount);
       SetLength(OpenArray[OpenCount - 1], Field.Size, Field.Size);
       SetLength(OpenGrand, OpenCount);
       SetLength(OpenLavels, OpenCount);
       SetLength(FOpen, OpenCount);
       FOpen[OpenCount - 1] := FN;
       OpenGrand[OpenCount - 1] := pot;
       OpenLavels[OpenCount - 1] := ClosedLavels[ClosedCount - 1];
         OpenArray[OpenCount - 1] := New;
       end;
       //����� �������� (3)
     end;
     end;


   end; //����� ��������� ����������� ������
  end;
 end;//����� ����� while

Reinstatement:
//����������� ����
SetLength(New, Field.Size, Field.Size);
for i := 0 to Field.Size - 1 do
 for j := 0 to Field.Size - 1 do
  if (i <> Field.Size - 1) or (j <> Field.Size - 1) then
  New[i, j] := j* Field.Size + i + 1
  else
  New[i, j] := 0;

//����� ������� ������ - New
X := Field.Size - 1;
Y := Field.Size - 1; //������ ������ ����� ������� New

SetLength(Way, 1);
Way[0] := Grand;
case Grand of
 1:
 begin
 New[X, Y] := New[X + 1, Y];
 New[X + 1, Y] := 0;
 X := X + 1;
 end;
 2:
 begin
 New[X, Y] := New[X, Y + 1];
 New[X, Y + 1] := 0;
 Y := Y + 1;
 end;
 3:
 begin
 New[X, Y] := New[X - 1, Y];
 New[X - 1, Y] := 0;
 X := X - 1;
 end;
 4:
 begin
 New[X, Y] := New[X, Y - 1];
 New[X, Y - 1] := 0;
 Y := Y - 1;
 end;
end;



for l := ClosedCount - 1 downto 0 do
 begin
 T := true;
 for i := 0 to Field.Size - 1 do
  for j := 0 to Field.Size - 1 do
   if New[i, j] <> ClosedArray[l][i, j] then T := false;
 if T then //�� ����� �������
  begin
  SetLength(Way, High(Way) + 2);
  Way[High(Way)] := ClosedGrand[l];


 case ClosedGrand[l] of
 1:
 begin
 New[X, Y] := New[X + 1, Y];
 New[X + 1, Y] := 0;
 X := X + 1;
 end;
 2:
 begin
 New[X, Y] := New[X, Y + 1];
 New[X, Y + 1] := 0;
 Y := Y + 1;
 end;
 3:
 begin
 New[X, Y] := New[X - 1, Y];
 New[X - 1, Y] := 0;
 X := X - 1;
 end;
 4:
 begin
 New[X, Y] := New[X, Y - 1];
 New[X, Y - 1] := 0;
 Y := Y - 1;
 end;
 end;



  end;

 end;

//������������� �������
WayCount := High(Way) + 1;
Form1.Timer1.Enabled := true;


end;
//����� A

procedure TForm1.Button1Click(Sender: TObject);
begin
Field.Access := false;
Button1.Enabled := false;
Button2.Enabled := false;
BitBtn1.Enabled := false;
A;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
 var i, j, X, Y: integer;

begin
if WayCount > 0 then
 begin
 WayCount := WayCount - 1;

 for i := 0 to Field.Size - 1 do
 for j := 0 to Field.Size - 1 do
  if Field.Mas[i, j] = 0 then begin X := i; Y := j; end;

 if Way[WayCount] = 1 then
  begin
  Field.Move(X - 1, Y, X, Y);
  X := X - 1;
  Field.DrawField;
  end;

  if Way[WayCount] = 2 then
  begin
  Field.Move(X, Y - 1, X, Y);
  Y := Y - 1;
  Field.DrawField;
  end;

  if Way[WayCount] = 3 then
  begin
  Field.Move(X + 1, Y, X, Y);
  X := X + 1;
  Field.DrawField;
  end;

  if Way[WayCount] = 4 then
  begin
  Field.Move(X, Y + 1, X, Y);
  Y := Y + 1;
  Field.DrawField;
  end;

 end
 else
 begin
 Button2.Enabled := true;
 Button1.Enabled := true;
 Field.Access := true;
 Timer1.Enabled := false;
 end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var B: array of integer;
    i, j, k, n, i1, j1: integer;
    S: integer;
begin
Randomize;
SetLength(B, Field.Size*Field.Size);
for i := 0 to Field.Size*Field.Size - 1 do
 B[i] := i;

for i := 0 to Field.Size - 1 do
 for j := 0 to Field.Size - 1 do
  begin
  n := Random(High(B) + 1);
  Field.Mas[i, j] := B[n];
  for k := n to High(B) - 1 do
   B[k] := B[k + 1];
  SetLength(B, High(B));
  end;
Field.DrawField;
//�������� �� ������������
k := 0;
S := 0;
SetLength(B, Field.Size*Field.Size);
for j := 0 to Field.Size - 1 do
 for i := 0 to Field.Size - 1 do
 begin
 k := k + 1;
 B[k - 1] := Field.Mas[i, j];
 if Field.Mas[i, j] = 0 then S := j + 1;
 end;


for k := 0 to Field.Size * Field.Size - 1 do
 if B[k] <> 0 then
 begin
 n := B[k];
 for i := k + 1 to Field.Size*Field.Size - 1 do
  if (B[i] < n) and (B[i] <> 0) then S := S + 1;
 end;

if (S mod 2 <> 0) then
 begin
 k := 0;
 //������� �� 90 ��������
 for i := Field.Size - 1 downto 0 do
  for j := 0 to Field.Size - 1 do
   begin
   Field.Mas[i, j] := B[k];
   k := k + 1;
   end;

 end;
Field.DrawField;
end;



procedure TForm1.Timer2Timer(Sender: TObject);
begin
Form1.AlphaBlendValue := Form1.AlphaBlendValue + 15;
if Form1.AlphaBlendValue = 255 then Timer2.Enabled := false;
end;

end.
