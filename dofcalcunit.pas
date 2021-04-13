unit DOFcalcunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Spin,
  StdCtrls, ExtCtrls, ComCtrls, math;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button_calcCoC: TButton;
    Button_calc: TButton;
    CheckBox_advanced: TCheckBox;
    CheckBox_Eyesight: TCheckBox;
    Edit_dof_tot: TEdit;
    Edit_dof_front: TEdit;
    Edit_Dofinback: TEdit;
    Edit_Dof: TEdit;
    Edit_dof_back: TEdit;
    Edit_far: TEdit;
    Edit_HyperfocalNearDistance: TEdit;
    Edit_near: TEdit;
    Edit_objectdist: TEdit;
    Edit_Df: TEdit;
    Edit_Dn: TEdit;
    Edit_HyperfocalDistance: TEdit;
    Edit_TotDOF: TEdit;
    Edit_Dofinfront: TEdit;
    FloatSpinEdit_Aperture: TFloatSpinEdit;
    FloatSpinEdit_CoC: TFloatSpinEdit;
    FloatSpinEdit_Distance: TFloatSpinEdit;
    FloatSpinEdit_FocalLength: TFloatSpinEdit;
    FloatSpinEdit_SensorSizeX: TFloatSpinEdit;
    FloatSpinEdit_Printsize: TFloatSpinEdit;
    FloatSpinEdit_SensorSizeY: TFloatSpinEdit;
    FloatSpinEdit_Viewdist: TFloatSpinEdit;
    GroupBox_info: TGroupBox;
    GroupBox_Distances: TGroupBox;
    GroupBoxCoCcalc: TGroupBox;
    GroupBox_Results: TGroupBox;
    GroupBox_common: TGroupBox;
    GroupBox_Advanced: TGroupBox;
    Image_dofimage: TImage;
    Label1: TLabel;
    Label_cocmy: TLabel;
    Label_dbprc: TLabel;
    Label_dfprc: TLabel;
    Label_distinfo: TLabel;
    Label_dofback: TLabel;
    Label_doffull: TLabel;
    Label_doffront: TLabel;
    Label_doff: TLabel;
    Label_CoC: TLabel;
    Label_Df: TLabel;
    Label_Df1: TLabel;
    Label_dofn: TLabel;
    Label_disttoo: TLabel;
    Label_hyperfocalneardist: TLabel;
    Label_Dof: TLabel;
    Label_Dofinfront: TLabel;
    Label_Dofinback: TLabel;
    Label_Distance: TLabel;
    Label_Distance1: TLabel;
    Label_Dn: TLabel;
    Label_FocalLength: TLabel;
    Label_FocalLength1: TLabel;
    Label_Printsize: TLabel;
    Label_SensorSizex: TLabel;
    Label_SensorSizey: TLabel;
    Label_Viewdist: TLabel;
    Memo_info: TMemo;
    Panel_dofimage: TPanel;
    StatusBar1: TStatusBar;
    procedure Button_calcClick(Sender: TObject);
    procedure Button_calcCoCClick(Sender: TObject);
    procedure CheckBox_advancedChange(Sender: TObject);
    procedure CheckBox_EyesightChange(Sender: TObject);
    procedure FloatSpinEdit_CoCChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    eyesight: Extended;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

//https://www.askingbox.com/tutorial/delphi-lazarus-function-to-round-number-to-any-position-after-or-before-decimal-point
function RoundEx(const AInput: extended; APlaces: integer): extended;
var
  k: extended;
begin
  if APlaces = 0 then begin
    result := round(AInput);
  end else begin
    if APlaces > 0 then begin
      k := power(10, APlaces);
      result := round(AInput * k) / k;
    end else begin
      k := power(10, (APlaces*-1));
      result := round(AInput / k) * k;
    end;
  end;
end;

procedure TForm1.Button_calcClick(Sender: TObject);
var
   Dh, Dn, Df, P, f, n, c: Extended;
   dof, dofb, doff, pdofb, pdoff: Extended;
   view_dist, print_size: Extended;
begin

  P:=FloatSpinEdit_Distance.Value/1000; //to meter
  f:=FloatSpinEdit_FocalLength.Value;
  n:=FloatSpinEdit_Aperture.Value;
  c:=FloatSpinEdit_CoC.Value;

  //“PRECISE”
  //Hyperfocal distance
  {Dh := (power(f, 2)/(n*c)) + f;
  Edit_HyperfocalDistance.Text:=FloatToStr(Dh/1000);
  //Near Limit dof
  Dn := (P*(Dh-f))/(Dh+P-2*f);
  Edit_Dn.Text:=FloatToStr(Dn);
  //Far Limit dof
  Df := (P*(Dh-f))/(Dh-P);
  Edit_Df.Text:=FloatToStr(Df);}

  //"Approx"
  {Dh:=power(f,2)/(n*c);
  Edit_HyperfocalDistance.Text:=FloatToStr(Dh/1000);
  //Near Limit dof
  Dn := (P*Dh)/(Dh+P);
  Edit_Dn.Text:=FloatToStr(Dn);
  //Far Limit dof
  Df := (P*Dh)/(Dh-P);
  Edit_Df.Text:=FloatToStr(Df);}

  //https://damienfournier.co/dof-the-simplified-formula-to-understand-dof/
//  Dh:=power(f,2)/(n*c);
//  Edit_HyperfocalDistance.Text:=FloatToStr(Dh/1000);
  //Near Limit dof
 { s:=P;
  A:=n;
  Dn := (s*(f*f)) / ( (f*f)-(A*c)*(s-f) );;
  Edit_Dn.Text:=FloatToStr(Dn);

  //Far Limit dof
  Df := (s*(f*f)) / ( (f*f)+(A*c)*(s-f) );
  Edit_Df.Text:=FloatToStr(Df);  }
                                              //0.0254
  //CoC=CoC_form*eyesight*(view_dist/0.25)*(10*unit/print_size);



  {25 > default: 25 cm
  10 > 10 cm
  50 > 50 cm
  100 > 1 m
  500 > 5 m
  1000 > 10 m
  10000 > 100 m
  50000 > 500 m }
  view_dist:=FloatSpinEdit_Viewdist.Value;
  print_size:=FloatSpinEdit_Printsize.Value;

  //c:=c*eyesight*((view_dist/100)/0.25)*(10*1/10);

  //Formel for meter på print_size
  c:=c*eyesight*((view_dist/100)/0.25)*(10*0.0254/print_size);
  Dh:= (f*f)/(n*c);// + f;

  //Omgjør til meter i utskrift
  Edit_HyperfocalDistance.Text:=FloatToStr(Dh/1000);
  Edit_HyperfocalNearDistance.Text:=FloatToStr((Dh/1000)/2);

  //dofNear=(hyperfocal*distance_mm)/(hyperfocal+(distance_mm-focal));
  Dn:=(Dh*(P*1000))/(Dh+((P*1000)-f));
  //Omgjør til meter
  //Dn:=Dn/1000;
  Edit_Dn.Text:=FloatToStr(Dn);

  //dofFar=(hyperfocal*distance_mm)/(hyperfocal-(distance_mm-focal));
  Df:=(Dh*(P*1000))/(Dh-((P*1000)-f));
  //Omgjør til meter
  //Df:=Df/1000;
  Edit_Df.Text:=FloatToStr(Df);

  Edit_TotDOF.Text:=FloatToStr(Df-Dn);

  Edit_Dofinfront.Text:=FloatToStr(FloatSpinEdit_Distance.Value-Dn);
  Edit_Dofinback.Text:=FloatToStr(Df-FloatSpinEdit_Distance.Value);
  Edit_Dof.Text:=FloatToStr( (FloatSpinEdit_Distance.Value-Dn) + (Df-FloatSpinEdit_Distance.Value) );

  //Bilde
  Edit_objectdist.Text:=FloatSpinEdit_Distance.text;
  Edit_near.Text:=Edit_Dn.Text;
  Edit_far.Text:=Edit_Df.Text;
  Edit_dof_front.Text:=Edit_Dofinfront.Text;
  Edit_dof_back.Text:=Edit_Dofinback.Text;
  Edit_dof_tot.Text:=Edit_TotDOF.Text;

  dof:=(FloatSpinEdit_Distance.Value-Dn) + (Df-FloatSpinEdit_Distance.Value);
  dofb:=Df-FloatSpinEdit_Distance.Value;
  doff:=FloatSpinEdit_Distance.Value-Dn;

  pdofb:=(dofb/dof)*100 ;
  pdofb:=RoundEx(pdofb,2);
  pdoff:=(doff/dof)*100;
  pdoff:=RoundEx(pdoff,2);
  //Back %
  Label_dbprc.Caption:=FloatToStr(pdofb) + '%';
  //Front %
  Label_dfprc.Caption:=FloatToStr(pdoff) + '%';

end;

procedure TForm1.Button_calcCoCClick(Sender: TObject);
var
  diag, fullframediag: Extended;
  multiplier: Extended;
  CoC: Extended;
begin
  diag:=sqrt(power(FloatSpinEdit_SensorSizeX.Value,2)+power(FloatSpinEdit_SensorSizeY.Value,2));
  fullframediag:=sqrt(power(36,2)+power(24,2));;
  //ShowMessage(FloatToStr(diag));
  //CoC = (CoC for 35mm format) / (Digital camera lens focal length multiplier)
  //43.3 er diagonal fra en "full frame 35mm med størrelse 24*36 mm
  //multiplier:=43.3/diag;
  multiplier:=fullframediag/diag;
  //0.03 er "standard" CoC på 24x36 fullframe camera
  CoC:=0.03/multiplier;
  FloatSpinEdit_CoC.Value:=CoC;

end;

procedure TForm1.CheckBox_advancedChange(Sender: TObject);
begin
  if CheckBox_advanced.Checked = True then begin
     CheckBox_Eyesight.Enabled:=True;
     FloatSpinEdit_Printsize.Enabled:=True;
     FloatSpinEdit_Viewdist.Enabled:=True;
  end
  else begin
       CheckBox_Eyesight.Enabled:=False;
       FloatSpinEdit_Printsize.Enabled:=False;
       FloatSpinEdit_Viewdist.Enabled:=False;
  end;
end;

procedure TForm1.CheckBox_EyesightChange(Sender: TObject);
begin
  //default: manufacturer standard = 1
  //20/20 vision = 1/3 (0.3333);
  if CheckBox_Eyesight.Checked = True then begin
     eyesight:=1/3;
     CheckBox_Eyesight.Caption:='20/20 Vision';
  end
  else begin
     eyesight:=1;
     CheckBox_Eyesight.Caption:='Default: Manufacturer Standard';
  end;
end;

procedure TForm1.FloatSpinEdit_CoCChange(Sender: TObject);
begin
  Label_cocmy.Caption:='= ' + FloatToStr(FloatSpinEdit_CoC.Value*1000) + ' µm';
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    eyesight:=1;
end;

end.

