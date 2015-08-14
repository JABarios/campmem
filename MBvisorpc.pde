/*
(c) Juan A. Barios, Agosto 2015
*/

import processing.serial.*;

int lf = 10;    // Linefeed in ASCII
String myString = null;
Serial myPort;  // The serial port

PFont font;
Scrollbar scaleBar,scaleBar2;

int[] EEG1;
int[] EEG2;
int p_EEG1;
int p_EEG2;
int[] vEEG1;
int[] vEEG2;
int pv_EEG1;
int pv_EEG2;
int[] PEEG1;


int[] marcadores;
int nmarcadores=0;

float zoom;      // USED WHEN SCALING PULSE WAVEFORM TO PULSE WINDOW
color eggshell = color(255, 253, 248);
int anchoBarra=35;
int anchopantalla=700;
int maxADC=1024;



int lectura1,lectura2;

//  THESE VARIABLES DETERMINE THE SIZE AND POSITION OF THE DATA WINDOWS
int PulseWindowWidth = 650;
int PulseWindowHeight = 128; 
int BPMWindowWidth = 200;
int BPMWindowHeight = 250;
int PromedioWindowWidth = 200;
int PromedioWindowHeight = 250;
int CenterPulseWindow = -1; //se calcula en el constructor
int CenterBPMWindow = -1; //se calcula en el constructor
int CenterPromedioWindow = -1; //se calcula en el constructor
int CenterYPromedioWindow = -1; //se calcula en el constructor
int CenterYBPMWindow = -1; //se calcula en el constructor
int CenterXPulseWindow = -1;

int margenizdo=(anchopantalla-PulseWindowWidth)/2;
int puntosPromedio=100;
int margen_izdo_fft;
int margen_dcho_fft;
  
// FFT
  double[] w1,w2;
  int rate=100;

void setup() {
  size(700, 600);  // Stage size
  frameRate(100);  
  font = loadFont("Arial-BoldMT-24.vlw");
  
  textFont(font);
  textAlign(CENTER);
  rectMode(CENTER);
  ellipseMode(CENTER);  

  CenterPulseWindow = height/5;
  CenterPromedioWindow = width/4*1; 
  CenterBPMWindow = width/4*3; 
  CenterYPromedioWindow = height/3*2;
  CenterXPulseWindow = width/2;
  margen_izdo_fft=CenterBPMWindow-BPMWindowWidth/2;
  margen_dcho_fft=CenterBPMWindow+BPMWindowWidth/2;
  
  

// Scrollbar constructor inputs: x,y,width,height,minVal,maxVal
 // scaleBar = new Scrollbar (CenterPromedioWindow, CenterYPromedioWindow-PromedioWindowHeight/2-anchoBarra, PromedioWindowWidth, anchoBarra, 0.05, 1.0);  // set parameters for the scale bar
  scaleBar = new Scrollbar (CenterXPulseWindow+PulseWindowWidth/2-PromedioWindowWidth/2, CenterPulseWindow+PulseWindowHeight/2+anchoBarra, PromedioWindowWidth, anchoBarra, 0.05, 1.0);  // set parameters for the scale bar
  scaleBar2 = new Scrollbar (CenterPromedioWindow, CenterYPromedioWindow+PromedioWindowHeight/2+12, PromedioWindowWidth, 12, 0.5, 1.0);  // set parameters for the scale bar
  
  EEG1 = new int[PulseWindowWidth];          // initialize raw pulse waveform array
  EEG2 = new int[PulseWindowWidth];          // initialize raw pulse waveform array
  zoom = 0.75;                               // initialize scale of heartbeat window
  p_EEG1=1;
  p_EEG2=1;
  

  vEEG1 = new int[PulseWindowWidth];          // initialize raw pulse waveform array
  vEEG2 = new int[PulseWindowWidth];          // initialize raw pulse waveform array
  zoom = 0.75;                               // initialize scale of heartbeat window
  pv_EEG1=0;
  pv_EEG2=0;
  
  PEEG1 = new int[PromedioWindowWidth];          // initialize raw pulse waveform array
  
  
  
// set the visualizer lines to 0
 for (int i=0; i<EEG1.length; i++){
    EEG1[i] = maxADC/2;      // Place BPM graph line at bottom of BPM Window
    EEG2[i] = maxADC/2;      // Place BPM graph line at bottom of BPM Window    
   }
   
 for (int i=0; i<PEEG1.length; i++){
    PEEG1[i] = maxADC/2;        
   }
  marcadores = new int[200];          
  
 
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, "/dev/ttyUSB0", 57600);
  myPort.clear();
  myString = myPort.readStringUntil(lf);
  myString = null;
  
  background(0);
  pinta_textos();
  prepara_fft();
  
}
  
void draw() {
  int salto=1;
  adquirir(salto);
  if(p_EEG1%salto==0){
   // pinta_pantallas();
    pinta_EEG();
  } 
  if(p_EEG1%10==0){
      scaleBar.update (mouseX, mouseY);
      scaleBar.display();
      zoom = scaleBar.getPos();                     
  //    pinta_textos();
      pinta_cursor();
      busca_picos(700,20);
      pinta_promedio();
      pinta_fft(margen_izdo_fft,margen_dcho_fft,450);
  }   
   
}  //end of draw loop