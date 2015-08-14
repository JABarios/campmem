void adquirir(int n) {
  
//  EEG1[p_EEG1%PulseWindowWidth] = int(random(maxADC));
//  EEG2[p_EEG2%PulseWindowWidth] = int(random(maxADC));
  
  while (myPort.available() > 0) {
    myString = myPort.readStringUntil(lf);
    if (myString != null) {
           EEG1[p_EEG1%PulseWindowWidth] = int(trim(myString));
            p_EEG1++;
            p_EEG2++;  
    }
  }
  if(p_EEG1%n==0){
    pv_EEG1++;
    pv_EEG2++; 
    vEEG1[pv_EEG1%PulseWindowWidth] = EEG1[(p_EEG1-1)%PulseWindowWidth];
    vEEG2[pv_EEG2%PulseWindowWidth] = EEG1[(p_EEG1-1)%PulseWindowWidth];
 }
}



  
void busca_picos(int nivel,int paso) {
 
int npicos=0;
int yc=0;
int[] xx;

xx=jbh_std(vEEG1);
nivel=xx[0]+xx[1]*7/5;
for (int x = 0; x < marcadores.length-1; x++) { 
      marcadores[x]=0;
  }

for (int x = 0; x < vEEG1.length-1; x++) { 
  if(vEEG1[x]>nivel){
      marcadores[npicos]=x;
      x+=paso;
      npicos++;
    
  }
 }
 nmarcadores=npicos;
 for (int x = 0; x < nmarcadores; x++) { 
    yc=vEEG1[marcadores[x]];
    yc=int(CenterPulseWindow+zoom*map(yc,0,maxADC,-PulseWindowHeight/2,PulseWindowHeight/2));
   rect(marcadores[x]+margenizdo,yc,6,6);
  }
 
}

int prox_marcador() {
  // no funciona, por ser un buffer circular, 
  int diffmarc=0;
  if(nmarcadores<2)return(1);
    for (int x = 0; x < nmarcadores-2; x++) { 
      diffmarc += (marcadores[x+1]-marcadores[x]);
     }
    return(marcadores[nmarcadores-1]+diffmarc/(nmarcadores-1)); 
}