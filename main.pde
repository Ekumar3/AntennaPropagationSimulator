import g4p_controls.*;

int numTimeSteps = 40;
double[] x0 = new double[numTimeSteps];
double[] y0 = new double[numTimeSteps];
int t0, tf, tglobal, mode, N, R;
double amp, angleLinearPol, ampRatioCircPol, f, pi;
boolean nested;
GCustomSlider sdr1, sdr2, sdr3;

void setup() {
  size(800, 800);
  noStroke();
  rectMode(CENTER);
  N = 40;
  R = 900;
  f = 0.05;
  pi = 3.1415;
  t0 = 0;
  tf = numTimeSteps-1;
  tglobal = 0;
  mode = 1;
  amp = 0.0;
  angleLinearPol = 0;
  ampRatioCircPol = 0.0;
  for (int i = 0; i < numTimeSteps; i++) {
    x0[i] = mouseX;
    y0[i] = mouseY;
  }

  GLabel instructions = new GLabel(this, 50, 50, 750, 100, "Press (1), (2), or (3) to choose which variable to change. Then press (-) or (+) to increase it's value. Reset the values with (r).");
  GLabel nestedLabel = new GLabel(this, 300, 70, 300, 100, "Enter nested-circles mode with (n).");
  GLabel amp = new GLabel(this, 90, -35, 100, 100, "Amplitdue (1)");
  sdr1 = new GCustomSlider(this, 20, 20, 200, 50, "Amplitude");
  sdr1.setShowDecor(false, false, true, true);
  sdr1.setNbrTicks(100);
  sdr1.setLimits(0, 0, 100);
  sdr1.setStyle("green_red20px");
  sdr1.addEventHandler(this, "ampHandler");

  GLabel linear = new GLabel(this, 275, -35, 200, 100, "Linear Polarization Angle (2)");
  sdr2 = new GCustomSlider(this, 250, 20, 200, 50);
  sdr2.setShowDecor(false, false, true, true);
  sdr2.setNbrTicks(73);
  sdr2.setLimits(0, 0, 365);
  sdr2.setStyle("green_red20px");
  sdr2.addEventHandler(this, "linHandler");

  GLabel circular = new GLabel(this, 505, -35, 200, 100, "Circular Polarization Angle (3)");
  sdr3 = new GCustomSlider(this, 480, 20, 200, 50);
  sdr3.setShowDecor(false, false, true, true);
  sdr3.setNbrTicks(1000);
  sdr3.setLimits(0, -5, 5);
  sdr3.setStyle("green_red20px");
  sdr3.addEventHandler(this, "circHandler");
  sdr3.setNumberFormat(G4P.DECIMAL, 10);
  
  GButton nested = new GButton(this, 700, 20, 80, 50, "Nested-Circles (n)");
  nested.addEventHandler(this, "nestedHandler");
}

public void ampHandler(GCustomSlider customslider, GEvent event) { amp = customslider.getValueF();}

public void linHandler(GCustomSlider customslider, GEvent event) { angleLinearPol = customslider.getValueF(); }

public void circHandler(GCustomSlider customslider, GEvent event) { ampRatioCircPol =  customslider.getValueF();}

public void nestedHandler(GButton button, GEvent event) { nested = !nested;}

void draw() {
  background(255);
  fill(255, 204);
  double deg2rad = pi/180;
  double alp = deg2rad*angleLinearPol;

  t0 = t0+1;
  t0 = t0 % numTimeSteps;
  tf = tf+1;
  tf = tf % numTimeSteps;
  tglobal = tglobal+1;

  if (mode == 0) {
    x0[t0]=mouseX;
    y0[t0]=mouseY;
  } else {
    
    double xelipt = amp*Math.cos(2*3.14159*f*tglobal);
    double yelipt = amp*ampRatioCircPol*Math.sin(2*3.14159*f*tglobal);
    double xlinrot = xelipt*Math.cos(alp) - yelipt*Math.sin(alp);
    double ylinrot = xelipt*Math.sin(alp) + yelipt*Math.cos(alp);
    x0[t0]=mouseX+xlinrot;
    y0[t0]=mouseY+ylinrot;
    
    fill(128, 255);
    ellipse((float)x0[t0], (float)y0[t0], 20.0, 20.0);
    for (int i = 0; i <numTimeSteps-1; i++) {
      int ti   = (t0+i+1)%numTimeSteps;
      int tip1 = (t0+i+2)%numTimeSteps;
      drawpart(x0[ti], y0[ti], x0[tip1], y0[tip1], i, numTimeSteps, R, 0);
    }
    line((float)(mouseX + xlinrot),(float) (mouseY +ylinrot) ,(float) (mouseX - xlinrot), (float)(mouseY - ylinrot));
    stroke(165);
  }
}

void drawpart(double x0i, double y0i, double x0ip1, double y0ip1, int t, int numTimeSteps, int R, int col) {
  double da = 2*pi/N;
  float g = float(t)/(numTimeSteps-1);
  double omg = 1.0-g;
  float h = float(t+1)/(numTimeSteps-1);
  double omh = 1.0-h;
  for (int i = 0; i < N; i++) {
    double a = da*i;
    double xfi = x0i+R* Math.cos(a);
    double yfi = y0i+R*Math.sin(a);
    double xfip1 = x0ip1+R*Math.cos(a);
    double yfip1 = y0ip1+R*Math.sin(a);
    double xp = g*x0i + omg*xfi;
    double yp = g*y0i + omg*yfi;
    double xq,yq;
    if (nested) {
      xq = g*x0ip1 + omg*xfip1;
      yq = g*y0ip1 + omg*yfip1;
    }else {
      xq = h*x0ip1 + omh*xfip1;
      yq = h*y0ip1 + omh*yfip1;
    }
    stroke(col);
    line((float)xp, (float)yp, (float)xq, (float)yq);
  }
}

void keyPressed() {
  int keyIndex = -1;
  if ('0' <= key && key <= '9') {
    keyIndex = key - '0';
    System.out.println("KeyIndex:" + keyIndex);
  }

  if (keyIndex == 0) {
    mode = 0;
    System.out.println(0);
  }
  if (keyIndex == 1) {
    mode = 1;
    System.out.println(1);
  }
  if (keyIndex == 2) {
    mode = 2;
    System.out.println(2);
  }
  if (keyIndex == 3) {
    mode = 3;
    System.out.println(3);
  }
  System.out.println("Key pressed:" + key);
  if (key=='r') {
    //mode = 0;
    amp = 0.0;
    sdr1.setValue((float)amp);
    angleLinearPol = 0.0;
    sdr2.setValue((float)angleLinearPol);
    ampRatioCircPol = 0.0;
    sdr3.setValue((float)ampRatioCircPol);
  }
  if (key=='=') {
    if (mode==1) {
      amp =  sdr1.getValueF() + 1;
      sdr1.setValue((float)amp);
    }
    if (mode==2) {
      angleLinearPol += 5;
      sdr2.setValue(sdr2.getValueF() + 5);
    }
    if (mode==3) {
      ampRatioCircPol =sdr3.getValueF() + 0.01;
      sdr3.setValue((float)ampRatioCircPol);
    }

    System.out.println("Amplitude = "+ amp + " angleLinearPol= " + angleLinearPol + "  ampRatioCircPol= " + ampRatioCircPol);
  }
  if(key == 'n') {
      nested = !nested;
    }
  if (key=='-') {
    if (mode==1) {
      amp =  sdr1.getValueF() - 1;
      sdr1.setValue((float)amp);
    }
    if (mode==2) {
      angleLinearPol -= 5;
      sdr2.setValue(sdr2.getValueF() - 5);
    }
    if (mode==3) {
      ampRatioCircPol =sdr3.getValueF() - 0.01;
      sdr3.setValue((float)ampRatioCircPol);
      
    }
    
    System.out.println("Amplitude = " + amp + " angleLinearPol= " + angleLinearPol + "  ampRatioCircPol= " + ampRatioCircPol);
  }
}
