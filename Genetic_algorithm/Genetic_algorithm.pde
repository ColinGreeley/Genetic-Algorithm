
// dynamic variables
float population_size = 6; // number of chromosomes
float variable_count = 4; // number of variables being solved for
float max_yield = 10; // highest number that the algorithm will test
float crossover_rate = 0.25; // %chance for each individual chromosome to preform crossover
float mutation_rate = 0.1; // %chance for each individual gene to mutate

// static variables
float[][] chromosome = new float[6][4];
float[] evaluation = new float[6];
float[] fitness = new float[6];
float total = 0;
float[] probability = new float[6];
float[] cumulative_probability = new float[6];
float[] roulette = new float[6];
float[][] new_chromosome = new float[6][4];
float[] R = new float[6];
float[] crossover_count = new float[6];
float[] crossover_point = new float[6];
float total_genes = population_size * variable_count;
float number_of_mutations = mutation_rate * total_genes;
int[] random_mutation = new int[(int)number_of_mutations];
int[] mutation_yield = new int[(int)number_of_mutations];
int[] mutation_x = new int[(int)number_of_mutations];
int[] mutation_y = new int[(int)number_of_mutations];

void setup() {
  size(800, 600);
  frameRate(100);
  for (int i = 0; i < 6; i++) {
    for (int j = 0; j < 4; j++) {
      chromosome[i][j] = (int)random(1, max_yield + 1);
    }
  }
  //noLoop();
}


void draw() {
  background(52);
  stroke(255);


  evaluate();
  selection();
  display_chromosomes();
  for (int i = 0; i < 6; i++) {
    if (evaluation[i] == 0) {
      noLoop();
      textSize(20);
      text("Solution found in chromosome[  ] ;      + (   * 2) + (   * 3) + (   * 4) = 30", 50, 450);
      fill(255, 50, 0);
      text(i, 357, 450);
      text((int)chromosome[i][0], 401, 450);
      text((int)chromosome[i][1], 456, 450);
      text((int)chromosome[i][2], 545, 450);
      text((int)chromosome[i][3], 634, 450);
    }
  }
  crossover();
  mutation();
}




void display_chromosomes() {

  textSize(20);
  text("Maximum yield: ", 450, 100);
  text((int)max_yield, 610, 100);
  text("Crossover rate:     %", 450, 130);
  text((int)(crossover_rate * 100), 602, 130);
  text("Mutation rate:     %", 450, 160);
  text((int)(mutation_rate * 100), 590, 160);
  textSize(25);
  rect(15, 12, 385, 40, 10); fill(0);
  text("f(x) = (a + 2b + 3c + 4d) - 30", 25, 40); fill(255);
  text("Generation:", 50, 400);
  text(frameCount, 200, 400);
  textSize(12);
  text("a           b           c           d", 155, 80);
  for (int i = 0; i < 6; i++) {
    textSize(12);
    text("Chromosome[  ] = ", 20, 110 + (40 * i));
    text(i, 102, 110 + (40 * i));
    for (int j = 0; j < 4; j++) {
      textSize(20);
      text((int)chromosome[i][j], 150 + (50 * j), 110 + (40 * i));
      text((int)evaluation[i], 360, 110 + (40 * i));
      textSize(25);
      text("[", 135, 110 + (40 * i));
      text("] =", 324, 110 + (40 * i));
      if (j < 3) {
        text(",", 173 + (50 * j), 115 + (40 * i));
      }
      if (evaluation[i] == 0) {
        fill(0, 100, 255);  
        textSize(12);
        text(i, 102, 110 + (40 * i));
        text("Chromosome[  ] = ", 20, 110 + (40 * i));
        textSize(20);
        text((int)chromosome[i][j], 150 + (50 * j), 110 + (40 * i));
        text((int)evaluation[i], 360, 110 + (40 * i));
        textSize(25);
        text("[", 135, 110 + (40 * i));
        text("] =", 324, 110 + (40 * i));
        if (j < 3) {
          text(",", 173 + (50 * j), 115 + (40 * i));
        }
        fill(255);
      }
    }
  }
}


void evaluate() {

  // evaluates each chromosome with an integer value
  for (int i = 0; i < 6; i++) {
    evaluation[i] = abs(((chromosome[i][0]) + (2 * chromosome[i][1]) + (3 * chromosome[i][2]) + (4 * chromosome[i][3])) - 30); // equation being solved: f(x) = (a + 2b + 3c + 4d) - 30
  }
}


void selection() {

  // calculate the fitness of each chromosome and find the sum
  for (int i = 0; i < 6; i++) {
    fitness[i] = 1 / (1 + evaluation[i]);
    total += fitness[i];
  }

  // calculates the probability of each individual chromosome being picked on the roulette-wheel
  for (int i = 0; i < 6; i++) {
    probability[i] = fitness[i] / total;
    //println(probability[i]);
  }
  //println();

  cumulative_probability[0] = probability[0];
  //println(cumulative_probability[0]);
  for (int i = 1; i < 6; i++) {
    cumulative_probability[i] = probability[i] + cumulative_probability[i - 1];
    //println(cumulative_probability[i]);
  } //println();
  for (int i = 0; i < 6; i++) {
    roulette[i] = random(0, 1);
    //println(roulette[i]);
  } //println();

  for (int i = 0; i < 6; i++) {
    if (roulette[i] < cumulative_probability[0]) {
      for (int k = 0; k < 4; k++) {
        new_chromosome[i][k] = chromosome[0][k];
        //print(new_chromosome[i][k] );
      }
    }
    for (int j = 0; j < 5; j++) {
      if ((roulette[i] > cumulative_probability[j]) && (roulette[i] < cumulative_probability[j + 1])) {
        for (int k = 0; k < 4; k++) {
          new_chromosome[i][k] = chromosome[j + 1][k];
          //print(new_chromosome[i][k] );
        }
      }
    }
    //println();
  }
  //for (int i = 0; i < 6; i++) {
  //  println();
  //  for (int j = 0; j < 4; j++) {
  //    print(new_chromosome[i][j]);
  //  }
  //}
}

void crossover() {

  for (int i = 0; i < 6; i++) {
    R[i] = random(0, 1);
    if (R[i] < crossover_rate) {
      crossover_count[i] = 1;
    }
  }

  for (int i = 0; i < 6; i++) {
    crossover_point[i] = (int)random(1, 3);
  }
  for (int i = 0; i < 6; i++) {
    if (crossover_count[i] == 1) {
      crossover_count[i] = 0;
      for (int j = i; j < 6; j++) {
        if (crossover_count[j] == 1 && crossover_count[i] == 0) {
          crossover_count[i] = 1;
          for (int k = 3; k >= crossover_point[i]; k--) {
            new_chromosome[i][k] = new_chromosome[j][k];
          }
        }
      }
    }
  }
  print(frameCount);
  for (int i = 0; i < 6; i++) {
    println();
    for (int j = 0; j < 4; j++) {
      print(new_chromosome[i][j]);
    }
  }
}

void mutation() {
  println("\n");
  for (int i = 0; i < (int)number_of_mutations; i++) {
    random_mutation[i] = (int)random(1, max_yield + 1);
  }
  for (int i = 0; i < (int)number_of_mutations; i++) {
    mutation_yield[i] = (int)random(1, total_genes);
    mutation_y[i] = floor(mutation_yield[i] / 4);
    mutation_x[i] = ((mutation_yield[i] % 4) % 6) - 1;
    if (mutation_x[i] == -1) {
      mutation_x[i] = 3;
    }
    //println(mutation_yield[i]);
    //println(floor(mutation_yield[i] / 4));
    //println((mutation_yield[i] % 4) % 6);
  }

  for (int k = 0; k < (int)number_of_mutations; k++) {
    for (int i = 0; i < 6; i++) {
      for (int j = 0; j < 4; j++) {
        if (i == mutation_y[k] && j == mutation_x[k]) {
          new_chromosome[i][j] = random_mutation[k];
        }
      }
    }
  }
  for (int i = 0; i < 6; i++) {
    for (int j = 0; j < 4; j++) {
      chromosome[i][j] = new_chromosome[i][j];
    }
  }
}