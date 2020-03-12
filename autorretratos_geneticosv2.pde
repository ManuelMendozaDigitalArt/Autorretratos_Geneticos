
int cont =0;
boolean emp = false;
int nAgentes = 16;
int resolucion = 8100;
int altoAncho = 90;
int[][] agentes = new int[nAgentes][resolucion];
int[] codigo = new int[resolucion];
color[] colores = new color[]{color( 231, 76, 60 ), color( 142, 68, 173 ), color( 93, 173, 226 ), color( 26, 188, 156 ), color(241, 196, 15), color( 245, 176, 65 ), color( 211, 84, 0 ), color( 236, 240, 241 ), color(149, 165, 166), color(127, 140, 141), color(148, 49, 38), color(108, 52, 131), color( 17, 122, 101 ), color( 214, 137, 16 ), color(144, 148, 151), color(44, 62, 80)};

//Calcular aptitudes
int[] aptitudes = new int[nAgentes];
int[] aptitudesNuevos = new int[nAgentes];

int[] menorAptitud = new int[resolucion];

//Selección
int[] seleccionados = new int[nAgentes/2];

//Nuevos genes
int[][] nuevosGenes = new int[nAgentes][resolucion];

int min;
void setup() {

  String lines[] = loadStrings("codigo.txt");
  for (int i = 0; i < lines.length; i++) {
    codigo[i]=(int(lines[i]));
  }

  noStroke();
  size(360, 360);
  for (int i=0; i<nAgentes; i++ ) {
    for (int j=0; j<resolucion; j++) {
      agentes[i][j] = int(random(0, 2));
    }
  }
  for (int i=0; i<nAgentes; i++ ) {
    for (int j=0; j<resolucion; j++) {
      nuevosGenes[i][j] =agentes[i][j];
    }
  }
}

void draw() {
  if (emp== true) {
    //Calcular aptitudes

    for (int i=0; i< agentes.length; i++ ) {
      int aptitud = 0; 
      for (int j=0; j< resolucion; j++) {
        if (agentes[i][j]== codigo[j]) aptitud++;
      }
      aptitudes[i] = aptitud;
    }
    menorAptitud = agentes[obtenerIndiceMenor(aptitudes)];

    //Selección

    int index=0;
    for (int i=0; i< aptitudes.length-1; i+=2) {
      if (aptitudes[i]<= aptitudes[i+1]) seleccionados[index]=i;
      else seleccionados[index]=i+1;
      index++;
    }

    //Nuevos genes
    for (int i=0; i<4; i++) {
      for (int j=0; j< resolucion; j++) {
        nuevosGenes[i][j] = menorAptitud[j];
      }
    }
    for (int i=4; i<10; i++) {
      int nuevo = int(random(0, seleccionados.length));
      for (int j=0; j< resolucion; j++) {
        nuevosGenes[i][j] = agentes[seleccionados[nuevo]][j];
      }
    }
    for (int i=10; i<12; i++) {
      int nuevo = int(random(0, seleccionados.length));
      for (int j=0; j< resolucion/2; j++) {
        nuevosGenes[i][j] = menorAptitud[j];
      }
      for (int j=resolucion/2; j< resolucion; j++) {
        nuevosGenes[i][j] = agentes[seleccionados[nuevo]][j];
      }
    }

    for (int i=12; i<16; i++) {
      int nuevo = int(random(0, seleccionados.length));
      int nuevo2 = int(random(0, seleccionados.length));
      for (int j=0; j< resolucion/2; j++) {
        nuevosGenes[i][j] = agentes[seleccionados[nuevo]][j];
      }
      for (int j=resolucion/2; j< resolucion; j++) {
        nuevosGenes[i][j] = agentes[seleccionados[nuevo2]][j];
      }
    }

    //Mutación
    for (int i= 0; i< nAgentes; i++) {
      for (int j=0; j< resolucion; j++) {
        float rand = random(0, 100);
        if (rand<0.02) {
          nuevosGenes[i][j] = int(random(0, 2));
        }
      }
    }



    //Actualizar 
    for (int i=0; i<nAgentes; i++ ) {
      for (int j=0; j<resolucion; j++) {
        agentes[i][j] = nuevosGenes[i][j];
      }
    }


    //Dibujar Agentes
    for (int i=0; i<4; i++ ) {
      for (int l=0; l<4; l++ ) {
        for (int j=0; j< altoAncho; j++) {
          for (int k=0; k<altoAncho; k++) {
            if (agentes[i*4+l][k* altoAncho +j]==0) fill(255);
            if (agentes[i*4+l][k* altoAncho +j]==1)fill(0);
            rect(((width/4)*i) + j, ((height/4)*l) + k, 1, 1);
          }
        }
      }
    }
    //fill(colores[i*4+l])

    printArray(aptitudes);
    println();
    println("Porcentaje promedio de similitud = " + ((8100-aptitudes[0])*100)/8100 );

    save(cont +".jpg");
    cont++;
  }
}


int obtenerIndiceMenor(int[] arreglo) {
  int indice = 0;
  int min = 10000;
  for (int i=0; i< arreglo.length; i++) {
    if (arreglo[i] < min) {
      indice =i;
      min= arreglo[i];
    }
  }

  return indice;
}

void keyPressed() {


  if (key == 'a') {
    emp= true;
  }
}
//ffmpeg -r 60 -f image2 -s 360x360 -i %d.jpg -vcodec libx264 -crf 25  -pix_fmt yuv420p test.mp4
