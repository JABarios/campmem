



/* 
   * Computes the discrete Fourier transform (DFT) of the given complex vector, storing the result back into the vector.
   * The vector's length must be a power of 2. Uses the Cooley-Tukey decimation-in-time radix-2 algorithm.
   */
  public static void transformRadix2(double[] real, double[] imag) {
    // Initialization
    if (real.length != imag.length)
      throw new IllegalArgumentException("Mismatched lengths");
    int n = real.length;
    int levels = 31 - Integer.numberOfLeadingZeros(n);  // Equal to floor(log2(n))
    if (1 << levels != n)
      throw new IllegalArgumentException("Length is not a power of 2");
    double[] cosTable = new double[n / 2];
    double[] sinTable = new double[n / 2];
    for (int i = 0; i < n / 2; i++) {
      cosTable[i] = Math.cos(2 * Math.PI * i / n);
      sinTable[i] = Math.sin(2 * Math.PI * i / n);
    }
    
    // Bit-reversed addressing permutation
    for (int i = 0; i < n; i++) {
      int j = Integer.reverse(i) >>> (32 - levels);
      if (j > i) {
        double temp = real[i];
        real[i] = real[j];
        real[j] = temp;
        temp = imag[i];
        imag[i] = imag[j];
        imag[j] = temp;
      }
    }
    
    // Cooley-Tukey decimation-in-time radix-2 FFT
    for (int size = 2; size <= n; size *= 2) {
      int halfsize = size / 2;
      int tablestep = n / size;
      for (int i = 0; i < n; i += size) {
        for (int j = i, k = 0; j < i + halfsize; j++, k += tablestep) {
          double tpre =  real[j+halfsize] * cosTable[k] + imag[j+halfsize] * sinTable[k];
          double tpim = -real[j+halfsize] * sinTable[k] + imag[j+halfsize] * cosTable[k];
          real[j + halfsize] = real[j] - tpre;
          imag[j + halfsize] = imag[j] - tpim;
          real[j] += tpre;
          imag[j] += tpim;
        }
      }
      if (size == n)  // Prevent overflow in 'size *= 2'
        break;
    }
  }

void prepara_fft()
{
  // no se usa, solo es para probar la fft
   w1=new double[512];
   w2=new double[512];
   
   for(int i=0;i<512;i++){
     w1[i]=(double)(0.5*Math.sin(12*6.28*i/rate))+(double)(0.5*Math.sin(6*6.28*i/rate))+(double)(0.5*Math.sin(31*6.28*i/rate));
     w2[i]=0;
   }
  transformRadix2((w1),(w2));
}