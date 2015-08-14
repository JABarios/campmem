
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
    int cx=int(map(x, 0, puntosPromedio, 100, 250));
    int cy=int(CenterYPromedioWindow+zoom*map(PEEG1[x], 0, maxADC, -PromedioWindowHeight/2, PromedioWindowHeight/2));
    vertex(cx, cy );
  }
  endShape();
}



void pinta_textos() {
  // PRINT cabeceros
  fill(eggshell);                                       // get ready to print text
  text("Memboost EEG Visualizer 0.1", width/2, 30);     // tell them what you are
}

void pinta_pantallas() {
  // no se usa, lo mando todo a cada una de las funciones
  noStroke();
  fill(eggshell);  // color for the window background
  rect(CenterXPulseWindow, CenterPulseWindow, PulseWindowWidth, PulseWindowHeight);
  rect(CenterPromedioWindow, height/3*2, BPMWindowWidth, BPMWindowHeight);  
  rect(CenterBPMWindow, height/3*2, BPMWindowWidth, BPMWindowHeight);
}