
void pinta_EEG() {  
  fill(eggshell);  // color for the window background
  rect(CenterXPulseWindow, CenterPulseWindow, PulseWindowWidth, PulseWindowHeight);
  stroke(250, 0, 0);     //red                          
  noFill();
  beginShape();             
  for (int x = 0; x < vEEG1.length-1; x++) {    
    vertex(x+margenizdo, CenterPulseWindow+zoom*map(vEEG1[x], 0, maxADC, -PulseWindowHeight/2, PulseWindowHeight/2));
  }
  endShape();
}

void pinta_cursor() {
  fill(255, 0, 0);  // color for the window background
  rect(pv_EEG1%PulseWindowWidth+margenizdo, CenterPulseWindow, 1, PulseWindowHeight);

  //fill(255,0,255);  // color for the window background
  //int cc=prox_marcador();
  //if(cc>10){
  //  rect(cc+margenizdo,CenterPulseWindow,1,PulseWindowHeight);
  //}
}

void pinta_promedio() {
  noStroke();
  fill(eggshell);  // color for the window background
  rect(CenterPromedioWindow, height/3*2, BPMWindowWidth, BPMWindowHeight);  

  for (int x = 0; x < puntosPromedio; x++) PEEG1[x]=0;  
  if (nmarcadores>2) {
    for (int x = 0; x < puntosPromedio; x++) {  
      for (int y = 0; y < nmarcadores; y++) {
        PEEG1[x] += EEG1[(marcadores[y]+x)%PulseWindowWidth];
      }
    }  
    for (int x = 0; x < puntosPromedio; x++) {  
      PEEG1[x] /= nmarcadores;
    }
  }  

  stroke(250, 0, 0);     //red                          
  noFill();
  beginShape();             
  //PromedioWindowWidth
  for (int x = 0; x < puntosPromedio; x++) {  
    int cx=int(map(x, 0, puntosPromedio-1, 100, 250));
    int cy=int(CenterYPromedioWindow+zoom*map(PEEG1[x], 0, maxADC, -PromedioWindowHeight/2, PromedioWindowHeight/2));
    vertex(cx, cy );
  }
  endShape();
}

void pinta_fft(int ladoI, int ladoD, int offset)
{
     
  int x=0;
  int puntos_fft=512;
  float v_t;
  float n;
  
  for(int i=p_EEG1;i<p_EEG1+puntos_fft;i++){
     v_t=1-abs((x+1)-(puntos_fft/2))/(puntos_fft/2);  // ventana triangular, mas o menos https://en.wikipedia.org/wiki/Window_function#Rectangular_window    
     w1[x]=EEG1[i%PulseWindowWidth]*v_t;
     w2[x++]=0;
  }
  transformRadix2((w1),(w2));
 
  noStroke();
  fill(eggshell);  // color for the window background
  rect(CenterBPMWindow,height/3*2,BPMWindowWidth,BPMWindowHeight);  
  float k=-6; //calculado a ojo    
  
  beginShape();  
  for(int i=0;i<puntos_fft/2;i++){
     float cx1=(float)map(i,0,puntos_fft/2,ladoI,ladoD);     
     float y1=(float)offset+k*((float)Math.log((float)Math.pow((float)w1[i],2.0)));
     stroke(0,255,0);
     vertex(cx1,(y1>offset+50)?offset+50:y1);
   }
   endShape();  
}

void pinta_textos() {
  // PRINT cabeceros
  fill(eggshell);                                       // get ready to print text
  text("Memboost EEG Visualizer 0.1", width/2, 30);     // tell them what you are
}

void pinta_pantallas() {
  // no se usa, reparto todo a cada una de las funciones
  noStroke();
  fill(eggshell);  // color for the window background
  rect(CenterXPulseWindow, CenterPulseWindow, PulseWindowWidth, PulseWindowHeight);
  rect(CenterPromedioWindow, height/3*2, BPMWindowWidth, BPMWindowHeight);  
  rect(CenterBPMWindow, height/3*2, BPMWindowWidth, BPMWindowHeight);
}