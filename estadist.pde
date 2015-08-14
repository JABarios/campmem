int[] jbh_std(int[] v1) {
  float sum_x1=0,sum_x2=0;
  
  int[] retorno;
  
  retorno=new int[2];
  sum_x1=0;
  sum_x2=0;
  
  for (int x = 0; x < v1.length-1; x++) { 
    sum_x2+=(v1[x]*v1[x]);
    sum_x1+=v1[x];
    
  }
       
  retorno[0]=int(sum_x1/v1.length);
  retorno[1]=int(sqrt(int(sum_x2 / v1.length) - (retorno[0] * retorno[0])));

  return(retorno);
}