/*
  BUILDING GLITCH / MORE NUMBERS
  Processing 4 - Java Mode

  NO EXTERNAL LIBRARIES
  3840 x 2160
  30 FPS
  10 seconds / 300 frames
*/

final int FPS = 30;
final int TOTAL_FRAMES = 300;

PFont mono;

PGraphics numbersLayer;
PGraphics geometryLayer;
PGraphics linesLayer;

BlinkNumber[] numbers;
FastShape[] shapes;
SpeedLine[] speedLines;

// MORE NUMBERS
final int NUMBER_COUNT = 112;
final int SHAPE_COUNT = 34;
final int LINE_COUNT = 125;


// =============================================================
// SETUP
// =============================================================

void setup() {

  size(3840, 2160, P2D);

  pixelDensity(1);
  smooth(8);
  frameRate(FPS);

  mono = createFont("Monospaced", 220, true);

  numbersLayer = createGraphics(width, height, P2D);
  geometryLayer = createGraphics(width, height, P2D);
  linesLayer = createGraphics(width, height, P2D);

  randomSeed(973421);

  createNumbers();
  createShapes();
  createLines();
}


// =============================================================
// CREATE NUMBERS
// =============================================================

void createNumbers() {

  numbers = new BlinkNumber[NUMBER_COUNT];

  int cols = 12;
  int rows = 8;

  float cellW = width / float(cols);
  float cellH = height / float(rows);

  int index = 0;


  // -----------------------------------------------------------
  // 96 NUMBERS DISTRIBUTED ACROSS THE WHOLE FRAME
  // -----------------------------------------------------------

  for (int row = 0; row < rows; row++) {

    for (int col = 0; col < cols; col++) {

      if (index >= NUMBER_COUNT) break;

      float x =
        (col + 0.5) * cellW +
        random(-55, 55);

      float y =
        (row + 0.5) * cellH +
        random(-45, 45);


      // MUCH WIDER SIZE RANGE
      float chance = random(1);

      float s;

      if (chance < 0.18) {
        s = random(42, 75);          // tiny
      }
      else if (chance < 0.40) {
        s = random(75, 115);         // small
      }
      else if (chance < 0.67) {
        s = random(115, 180);        // medium
      }
      else if (chance < 0.86) {
        s = random(180, 260);        // large
      }
      else if (chance < 0.96) {
        s = random(260, 360);        // very large
      }
      else {
        s = random(360, 500);        // huge
      }


      numbers[index] =
        new BlinkNumber(
          index,
          x,
          y,
          s,
          random(-7.5, 7.5),
          random(-5.0, 5.0),
          random(0.8, 3.2),
          random(1000),
          int(random(10))
        );

      index++;
    }
  }


  // -----------------------------------------------------------
  // EXTRA FLOATING NUMBERS
  // BIGGER + MORE RANDOM + OVERLAPPING
  // -----------------------------------------------------------

  while (index < NUMBER_COUNT) {

    float s;

    float chance = random(1);

    if (chance < 0.25) {
      s = random(45, 90);
    }
    else if (chance < 0.50) {
      s = random(100, 180);
    }
    else if (chance < 0.75) {
      s = random(200, 330);
    }
    else {
      s = random(350, 560);
    }


    numbers[index] =
      new BlinkNumber(
        index,
        random(-100, width + 100),
        random(-100, height + 100),
        s,
        random(-10, 10),
        random(-7, 7),
        random(0.65, 2.6),
        random(1000),
        int(random(10))
      );

    index++;
  }
}


// =============================================================
// CREATE GEOMETRY
// =============================================================

void createShapes() {

  shapes = new FastShape[SHAPE_COUNT];

  for (int i = 0; i < shapes.length; i++) {

    shapes[i] =
      new FastShape(
        i,
        random(width),
        random(height),
        random(70, 360),
        int(random(7)),
        random(1) > 0.43,
        random(-15, 15),
        random(-11, 11),
        random(TWO_PI),
        random(-0.13, 0.13),
        random(0.8, 2.3),
        random(TWO_PI)
      );
  }
}


// =============================================================
// CREATE LINES
// =============================================================

void createLines() {

  speedLines = new SpeedLine[LINE_COUNT];

  for (int i = 0; i < speedLines.length; i++) {

    boolean redLine =
      random(1) < 0.32;

    speedLines[i] =
      new SpeedLine(
        i,
        random(width),
        random(height),
        random(70, 650),
        int(random(4)),
        redLine,
        redLine ? random(18, 38) : random(10, 28),
        random(1, 5)
      );
  }
}


// =============================================================
// DRAW
// =============================================================

void draw() {

  float t =
    (frameCount - 1) /
    float(FPS);

  randomSeed(
    17000 +
    frameCount * 83
  );

  background(0);

  renderLines(t);
  renderGeometry(t);
  renderNumbers(t);


  blendMode(ADD);

  image(
    linesLayer,
    0,
    0
  );

  image(
    geometryLayer,
    0,
    0
  );


  blendMode(BLEND);

  image(
    numbersLayer,
    0,
    0
  );


  glitchLayer(
    linesLayer,
    t,
    2.0,
    100
  );

  glitchLayer(
    geometryLayer,
    t,
    1.7,
    200
  );

  glitchLayer(
    numbersLayer,
    t,
    1.35,
    300
  );


  globalGlitch(t);

  flashCuts(t);

  digitalNoise();

  scanLines();


  saveFrame(
    "frames/frame_####.png"
  );


  println(
    "FRAME " +
    frameCount +
    " / " +
    TOTAL_FRAMES
  );


  if (frameCount >= TOTAL_FRAMES) {

    println("DONE");

    exit();
  }
}


// =============================================================
// RENDER NUMBERS
// =============================================================

void renderNumbers(float t) {

  numbersLayer.beginDraw();

  numbersLayer.clear();

  numbersLayer.textFont(mono);
  numbersLayer.textAlign(CENTER, CENTER);
  numbersLayer.rectMode(CENTER);

  for (int i = 0; i < numbers.length; i++) {

    numbers[i].display(
      numbersLayer,
      t
    );
  }

  numbersLayer.endDraw();
}


// =============================================================
// RENDER GEOMETRY
// =============================================================

void renderGeometry(float t) {

  geometryLayer.beginDraw();

  geometryLayer.clear();

  geometryLayer.rectMode(CENTER);
  geometryLayer.ellipseMode(CENTER);
  geometryLayer.strokeCap(SQUARE);

  for (int i = 0; i < shapes.length; i++) {

    shapes[i].display(
      geometryLayer,
      t
    );
  }

  geometryLayer.endDraw();
}


// =============================================================
// RENDER LINES
// =============================================================

void renderLines(float t) {

  linesLayer.beginDraw();

  linesLayer.clear();

  linesLayer.strokeCap(SQUARE);


  for (int i = 0; i < speedLines.length; i++) {

    speedLines[i].display(
      linesLayer,
      t
    );
  }


  // architectural grid

  linesLayer.strokeWeight(1);

  for (int i = 1; i < 12; i++) {

    float x =
      width *
      i /
      12.0;

    linesLayer.stroke(
      255,
      15
    );

    linesLayer.line(
      x,
      0,
      x,
      height
    );
  }


  for (int i = 1; i < 7; i++) {

    float y =
      height *
      i /
      7.0;

    linesLayer.stroke(
      255,
      15
    );

    linesLayer.line(
      0,
      y,
      width,
      y
    );
  }

  linesLayer.endDraw();
}


// =============================================================
// HELPERS
// =============================================================

float ease(float value) {

  return
    value *
    value *
    (3.0 - 2.0 * value);
}


float wrapPosition(
  float value,
  float minimum,
  float maximum
) {

  float range =
    maximum - minimum;

  while (value < minimum) {
    value += range;
  }

  while (value > maximum) {
    value -= range;
  }

  return value;
}


// =============================================================
// NUMBERS
// =============================================================

class BlinkNumber {

  int id;

  float originX;
  float originY;

  float baseSize;

  float velocityX;
  float velocityY;

  float morphSpeed;

  float phase;

  int originalDigit;


  BlinkNumber(
    int id_,
    float x_,
    float y_,
    float size_,
    float vx_,
    float vy_,
    float morphSpeed_,
    float phase_,
    int digit_
  ) {

    id = id_;

    originX = x_;
    originY = y_;

    baseSize = size_;

    velocityX = vx_;
    velocityY = vy_;

    morphSpeed = morphSpeed_;

    phase = phase_;

    originalDigit = digit_;
  }


  void display(
    PGraphics pg,
    float t
  ) {

    float x =
      originX +
      velocityX *
      frameCount *
      0.60;


    float y =
      originY +
      velocityY *
      frameCount *
      0.60;


    x +=
      sin(
        t * 3.8 +
        id * 1.1
      ) *
      35;


    y +=
      cos(
        t * 3.1 +
        id * 0.83
      ) *
      25;


    x =
      wrapPosition(
        x,
        -400,
        width + 400
      );


    y =
      wrapPosition(
        y,
        -400,
        height + 400
      );


    // ---------------------------------------------------------
    // MORPH
    // ---------------------------------------------------------

    float cycle =
      t *
      morphSpeed +
      phase;


    int cycleIndex =
      floor(cycle);


    float morph =
      cycle -
      floor(cycle);


    morph =
      ease(morph);


    int digitA =
      (
        originalDigit +
        cycleIndex
      ) % 10;


    int digitB =
      (
        digitA + 1
      ) % 10;


    int digitC =
      (
        digitA + 2
      ) % 10;


    // ---------------------------------------------------------
    // WINKING
    // ---------------------------------------------------------

    float winkNoise =
      noise(
        id * 0.41,
        t * 12
      );


    float visibility =
      1.0;


    if (winkNoise > 0.70) {

      visibility =
        map(
          winkNoise,
          0.70,
          1,
          1,
          0.03
        );
    }


    if (random(1) < 0.025) {

      visibility *=
        random(
          0.02,
          0.20
        );
    }


    if (random(1) < 0.018) {

      visibility = 1.3;
    }


    // ---------------------------------------------------------
    // GLITCH
    // ---------------------------------------------------------

    float glitchNoise =
      noise(
        id * 7.2,
        t * 10
      );


    float glitch =
      0;


    if (glitchNoise > 0.52) {

      glitch =
        map(
          glitchNoise,
          0.52,
          1,
          0,
          1
        );

      glitch *= glitch;
    }


    float currentSize =
      baseSize *
      (
        1.0 +
        sin(
          t * 7 +
          id * 1.7
        ) *
        0.07
      );


    // ---------------------------------------------------------
    // MAIN DISSOLVING DIGITS
    // ---------------------------------------------------------

    pg.textSize(
      currentSize
    );


    float alphaA =
      235 *
      (1.0 - morph) *
      visibility;


    float alphaB =
      245 *
      morph *
      visibility;


    pg.fill(
      190,
      alphaA
    );

    pg.text(
      str(digitA),
      x,
      y
    );


    pg.fill(
      255,
      alphaB
    );

    pg.text(
      str(digitB),
      x,
      y
    );


    // third digit leak

    float leak =
      max(
        0,
        morph - 0.58
      ) *
      2.4;


    pg.fill(
      220,
      45 *
      leak *
      visibility
    );

    pg.text(
      str(digitC),
      x,
      y
    );


    // ---------------------------------------------------------
    // GHOST DIGITS
    // ---------------------------------------------------------

    int ghostCount =
      3 +
      int(
        glitch * 11
      );


    for (int i = 0; i < ghostCount; i++) {

      float ghostX =
        x +
        random(-10, 10) +
        random(
          -190,
          190
        ) *
        glitch;


      float ghostY =
        y +
        random(-6, 6) +
        random(
          -50,
          50
        ) *
        glitch;


      pg.textSize(
        currentSize *
        random(
          0.94,
          1.07
        )
      );


      pg.fill(
        random(
          145,
          255
        ),
        random(
          8,
          55
        ) *
        visibility
      );


      int ghostDigit;

      float choice =
        random(1);


      if (choice < 0.43) {
        ghostDigit = digitA;
      }
      else if (choice < 0.88) {
        ghostDigit = digitB;
      }
      else {
        ghostDigit = digitC;
      }


      pg.text(
        str(ghostDigit),
        ghostX,
        ghostY
      );
    }


    // ---------------------------------------------------------
    // DISSOLVE
    // ---------------------------------------------------------

    int fragmentCount =
      20 +
      int(
        sin(
          morph * PI
        ) *
        65
      ) +
      int(
        glitch * 55
      );


    pg.noStroke();


    for (int i = 0; i < fragmentCount; i++) {

      float angle =
        random(TWO_PI);


      float radius =
        random(
          currentSize * 0.05,
          currentSize * 0.60
        );


      float dissolveDistance =
        sin(
          morph * PI
        ) *
        random(
          0,
          currentSize * 0.60
        );


      float fragmentX =
        x +
        cos(angle) *
        (
          radius +
          dissolveDistance
        );


      float fragmentY =
        y +
        sin(angle) *
        (
          radius +
          dissolveDistance
        );


      fragmentX +=
        random(
          -140,
          140
        ) *
        glitch;


      pg.fill(
        random(
          165,
          255
        ),
        random(
          20,
          120
        ) *
        visibility
      );


      pg.rect(
        fragmentX,
        fragmentY,
        random(
          2,
          7 +
          glitch * 45
        ),
        random(
          2,
          18
        )
      );
    }


    // ---------------------------------------------------------
    // SMALL NUMBERS AROUND BIG ONES
    // ---------------------------------------------------------

    pg.textSize(
      max(
        16,
        currentSize * 0.10
      )
    );


    for (int i = 0; i < 10; i++) {

      float angle =
        random(TWO_PI);


      float radius =
        random(
          currentSize * 0.20,
          currentSize * 0.90
        );


      pg.fill(
        255,
        random(
          10,
          60
        ) *
        visibility
      );


      int miniDigit =
        random(1) < morph
        ? digitB
        : digitA;


      pg.text(
        str(miniDigit),

        x +
        cos(angle) *
        radius,

        y +
        sin(angle) *
        radius
      );
    }


    // ---------------------------------------------------------
    // LOCAL TEARING
    // ---------------------------------------------------------

    if (glitch > 0.08) {

      int blocks =
        5 +
        int(
          glitch * 15
        );


      for (int i = 0; i < blocks; i++) {

        pg.fill(
          255,
          random(
            25,
            110
          )
        );


        pg.rect(

          x +
          random(
            -currentSize * 0.65,
            currentSize * 0.65
          ),

          y +
          random(
            -currentSize * 0.45,
            currentSize * 0.45
          ),

          random(
            15,
            130
          ) *
          max(
            0.25,
            glitch
          ),

          random(
            2,
            10
          )
        );
      }
    }
  }
}


// =============================================================
// RED GEOMETRY
// =============================================================

class FastShape {

  int id;

  float originX;
  float originY;

  float baseSize;

  int type;

  boolean filled;

  float velocityX;
  float velocityY;

  float startRotation;
  float rotationSpeed;

  float lifeSpeed;
  float lifePhase;


  FastShape(
    int id_,
    float x_,
    float y_,
    float size_,
    int type_,
    boolean filled_,
    float vx_,
    float vy_,
    float rotation_,
    float rotationSpeed_,
    float lifeSpeed_,
    float lifePhase_
  ) {

    id = id_;

    originX = x_;
    originY = y_;

    baseSize = size_;

    type = type_;

    filled = filled_;

    velocityX = vx_;
    velocityY = vy_;

    startRotation = rotation_;

    rotationSpeed = rotationSpeed_;

    lifeSpeed = lifeSpeed_;
    lifePhase = lifePhase_;
  }


  void display(
    PGraphics pg,
    float t
  ) {

    float x =
      originX +
      velocityX *
      frameCount *
      1.1;


    float y =
      originY +
      velocityY *
      frameCount *
      1.1;


    x =
      wrapPosition(
        x,
        -400,
        width + 400
      );


    y =
      wrapPosition(
        y,
        -400,
        height + 400
      );


    float life =
      0.5 +
      0.5 *
      sin(
        t *
        lifeSpeed *
        3.2 +
        lifePhase
      );


    life =
      pow(
        life,
        1.45
      );


    float currentSize =
      baseSize *
      (
        0.65 +
        life *
        0.65
      );


    float rotation =
      startRotation +
      rotationSpeed *
      frameCount *
      1.7;


    float glitchNoise =
      noise(
        id * 5.8,
        t * 10
      );


    float glitch =
      0;


    if (glitchNoise > 0.50) {

      glitch =
        map(
          glitchNoise,
          0.50,
          1,
          0,
          1
        );

      glitch *= glitch;
    }


    pg.pushMatrix();

    pg.translate(
      x,
      y
    );

    pg.rotate(
      rotation
    );


    if (filled) {

      pg.noStroke();

      pg.fill(
        255,
        0,
        0,
        45 +
        life * 200
      );
    }

    else {

      pg.noFill();

      pg.stroke(
        255,
        0,
        0,
        110 +
        life * 145
      );

      pg.strokeWeight(
        2 +
        life * 6
      );
    }


    drawPrimitive(
      pg,
      type,
      currentSize
    );


    int copyCount =
      2 +
      int(
        glitch * 9
      );


    for (int i = 0; i < copyCount; i++) {

      pg.pushMatrix();


      pg.translate(
        random(
          -260,
          260
        ) *
        glitch,

        random(
          -100,
          100
        ) *
        glitch
      );


      pg.rotate(
        random(
          -0.30,
          0.30
        )
      );


      pg.scale(
        random(
          0.85,
          1.15
        )
      );


      if (filled) {

        pg.noStroke();

        pg.fill(
          255,
          0,
          0,
          random(
            15,
            100
          ) *
          life
        );
      }

      else {

        pg.noFill();

        pg.stroke(
          255,
          0,
          0,
          random(
            25,
            160
          ) *
          life
        );

        pg.strokeWeight(
          random(
            1,
            7
          )
        );
      }


      drawPrimitive(
        pg,
        type,
        currentSize
      );


      pg.popMatrix();
    }


    pg.popMatrix();


    int fragmentCount =
      10 +
      int(
        life * 40
      ) +
      int(
        glitch * 45
      );


    pg.noStroke();


    for (int i = 0; i < fragmentCount; i++) {

      pg.fill(
        255,
        0,
        0,
        random(
          25,
          165
        ) *
        life
      );


      pg.rect(
        x +
        random(
          -currentSize,
          currentSize
        ),

        y +
        random(
          -currentSize * 0.8,
          currentSize * 0.8
        ),

        random(
          3,
          80
        ) *
        max(
          0.25,
          glitch + 0.15
        ),

        random(
          2,
          12
        )
      );
    }
  }
}


// =============================================================
// GEOMETRIC PRIMITIVES
// =============================================================

void drawPrimitive(
  PGraphics pg,
  int type,
  float s
) {

  if (type == 0) {

    pg.rect(
      0,
      0,
      s,
      s * 0.58
    );
  }

  else if (type == 1) {

    pg.ellipse(
      0,
      0,
      s,
      s
    );
  }

  else if (type == 2) {

    pg.triangle(
      0,
      -s * 0.58,

      -s * 0.55,
      s * 0.43,

      s * 0.55,
      s * 0.43
    );
  }

  else if (type == 3) {

    pg.beginShape();

    pg.vertex(
      0,
      -s * 0.60
    );

    pg.vertex(
      s * 0.50,
      0
    );

    pg.vertex(
      0,
      s * 0.60
    );

    pg.vertex(
      -s * 0.50,
      0
    );

    pg.endShape(CLOSE);
  }

  else if (type == 4) {

    pg.beginShape();

    for (int i = 0; i < 6; i++) {

      float a =
        TWO_PI *
        i /
        6.0 +
        PI / 6.0;

      pg.vertex(
        cos(a) *
        s * 0.55,

        sin(a) *
        s * 0.55
      );
    }

    pg.endShape(CLOSE);
  }

  else if (type == 5) {

    pg.line(
      -s * 0.6,
      0,
      s * 0.6,
      0
    );

    pg.line(
      0,
      -s * 0.6,
      0,
      s * 0.6
    );
  }

  else {

    pg.rect(
      0,
      0,
      s * 1.7,
      max(
        5,
        s * 0.07
      )
    );
  }
}


// =============================================================
// SPEED LINES
// =============================================================

class SpeedLine {

  int id;

  float originX;
  float originY;

  float lineLength;

  int direction;

  boolean isRed;

  float speed;

  float thickness;


  SpeedLine(
    int id_,
    float x_,
    float y_,
    float length_,
    int direction_,
    boolean red_,
    float speed_,
    float thickness_
  ) {

    id = id_;

    originX = x_;
    originY = y_;

    lineLength = length_;

    direction = direction_;

    isRed = red_;

    speed = speed_;

    thickness = thickness_;
  }


  void display(
    PGraphics pg,
    float t
  ) {

    float x =
      originX;

    float y =
      originY;


    if (direction == 0) {

      x =
        wrapPosition(
          originX +
          frameCount *
          speed,
          -lineLength,
          width + lineLength
        );


      y +=
        sin(
          t * 8 +
          id
        ) *
        18;
    }

    else if (direction == 1) {

      y =
        wrapPosition(
          originY +
          frameCount *
          speed,
          -lineLength,
          height + lineLength
        );


      x +=
        cos(
          t * 7 +
          id
        ) *
        18;
    }

    else if (direction == 2) {

      x =
        wrapPosition(
          originX +
          frameCount *
          speed,
          -lineLength,
          width + lineLength
        );


      y =
        wrapPosition(
          originY -
          frameCount *
          speed,
          -lineLength,
          height + lineLength
        );
    }

    else {

      x =
        wrapPosition(
          originX +
          frameCount *
          speed,
          -lineLength,
          width + lineLength
        );


      y =
        wrapPosition(
          originY +
          frameCount *
          speed,
          -lineLength,
          height + lineLength
        );
    }


    float flicker =
      noise(
        id * 0.57,
        t * 14
      );


    float alpha =
      60 +
      flicker * 190;


    if (isRed) {

      pg.stroke(
        255,
        0,
        0,
        alpha
      );
    }

    else {

      pg.stroke(
        random(
          180,
          255
        ),
        alpha
      );
    }


    pg.strokeWeight(
      thickness
    );


    drawSpeedLine(
      pg,
      x,
      y,
      0,
      0
    );


    int echoes =
      isRed
      ? 3
      : 2;


    for (int i = 0; i < echoes; i++) {

      float ox =
        random(
          -70,
          70
        );


      float oy =
        random(
          -35,
          35
        );


      if (isRed) {

        pg.stroke(
          255,
          0,
          0,
          random(
            20,
            100
          )
        );
      }

      else {

        pg.stroke(
          255,
          random(
            10,
            70
          )
        );
      }


      pg.strokeWeight(
        max(
          1,
          thickness *
          random(
            0.4,
            0.8
          )
        )
      );


      drawSpeedLine(
        pg,
        x,
        y,
        ox,
        oy
      );
    }
  }


  void drawSpeedLine(
    PGraphics pg,
    float x,
    float y,
    float ox,
    float oy
  ) {

    if (direction == 0) {

      pg.line(
        x -
        lineLength * 0.5 +
        ox,

        y + oy,

        x +
        lineLength * 0.5 +
        ox,

        y + oy
      );
    }

    else if (direction == 1) {

      pg.line(
        x + ox,

        y -
        lineLength * 0.5 +
        oy,

        x + ox,

        y +
        lineLength * 0.5 +
        oy
      );
    }

    else if (direction == 2) {

      pg.line(
        x -
        lineLength * 0.5 +
        ox,

        y +
        lineLength * 0.5 +
        oy,

        x +
        lineLength * 0.5 +
        ox,

        y -
        lineLength * 0.5 +
        oy
      );
    }

    else {

      pg.line(
        x -
        lineLength * 0.5 +
        ox,

        y -
        lineLength * 0.5 +
        oy,

        x +
        lineLength * 0.5 +
        ox,

        y +
        lineLength * 0.5 +
        oy
      );
    }
  }
}


// =============================================================
// GLITCH LAYER
// =============================================================

void glitchLayer(
  PGraphics pg,
  float t,
  float strength,
  float noiseSeed
) {

  float event =
    noise(
      noiseSeed,
      t * 9.0
    );


  if (event > 0.44) {

    float power =
      map(
        event,
        0.44,
        1,
        0,
        1
      );


    power *= power;


    int sliceCount =
      int(
        map(
          power,
          0,
          1,
          7,
          50
        )
      );


    for (int i = 0; i < sliceCount; i++) {

      int sourceY =
        int(
          random(height)
        );


      int sliceHeight =
        int(
          random(
            2,
            12 +
            power * 100
          )
        );


      float horizontalShift =
        random(
          -300,
          300
        ) *
        power *
        strength;


      image(
        pg,

        horizontalShift,
        sourceY,

        width,
        sliceHeight,

        0,
        sourceY,

        width,
        min(
          height,
          sourceY +
          sliceHeight
        )
      );
    }
  }


  if (random(1) < 0.88) {

    int y =
      int(
        random(height)
      );


    int h =
      int(
        random(
          1,
          9
        )
      );


    float shift =
      random(
        -40,
        40
      ) *
      strength;


    image(
      pg,

      shift,
      y,

      width,
      h,

      0,
      y,

      width,
      min(
        height,
        y + h
      )
    );
  }
}


// =============================================================
// GLOBAL GLITCH
// =============================================================

void globalGlitch(float t) {

  float event =
    noise(
      909,
      t * 10.5
    );


  if (event < 0.54) {
    return;
  }


  float power =
    map(
      event,
      0.54,
      1,
      0,
      1
    );


  int sliceCount =
    10 +
    int(
      power * 40
    );


  for (int i = 0; i < sliceCount; i++) {

    int y =
      int(
        random(height)
      );


    int h =
      int(
        random(
          2,
          55
        )
      );


    int shift =
      int(
        random(
          -260,
          260
        ) *
        power
      );


    copy(
      0,
      y,

      width,
      h,

      shift,
      y,

      width,
      h
    );


    if (random(1) < 0.20) {

      noStroke();

      fill(
        0,
        random(
          80,
          230
        )
      );


      rect(
        random(width),
        y,
        random(
          80,
          500
        ),
        h
      );
    }


    if (random(1) < 0.18) {

      noStroke();

      fill(
        255,
        0,
        0,
        random(
          35,
          130
        )
      );


      rect(
        random(width),
        y,
        random(
          100,
          650
        ),
        random(
          2,
          18
        )
      );
    }
  }
}


// =============================================================
// FLASH CUTS
// =============================================================

void flashCuts(float t) {

  if (random(1) < 0.30) {

    noStroke();

    int amount =
      int(
        random(
          1,
          5
        )
      );


    for (int i = 0; i < amount; i++) {

      fill(
        255,
        random(
          20,
          80
        )
      );


      rect(
        0,
        random(height),
        width,
        random(
          2,
          16
        )
      );
    }
  }


  if (random(1) < 0.14) {

    stroke(
      255,
      random(
        40,
        120
      )
    );


    strokeWeight(
      random(
        2,
        8
      )
    );


    float x =
      random(width);


    line(
      x,
      0,
      x,
      height
    );
  }


  if (random(1) < 0.17) {

    noStroke();

    fill(
      255,
      0,
      0,
      random(
        40,
        130
      )
    );


    rect(
      0,
      random(height),
      width,
      random(
        3,
        22
      )
    );
  }


  if (random(1) < 0.22) {

    noStroke();

    int count =
      int(
        random(
          2,
          8
        )
      );


    for (int i = 0; i < count; i++) {

      fill(
        255,
        0,
        0,
        random(
          35,
          120
        )
      );


      rect(
        random(width),
        random(height),
        random(
          40,
          450
        ),
        random(
          3,
          15
        )
      );
    }
  }
}


// =============================================================
// NOISE
// =============================================================

void digitalNoise() {

  strokeWeight(1);


  for (int i = 0; i < 1400; i++) {

    stroke(
      random(
        150,
        255
      ),
      random(
        2,
        16
      )
    );


    point(
      random(width),
      random(height)
    );
  }


  noStroke();


  for (int i = 0; i < 80; i++) {

    if (random(1) < 0.35) {

      fill(
        255,
        random(
          5,
          25
        )
      );


      rect(
        random(width),
        random(height),
        random(
          2,
          50
        ),
        random(
          1,
          6
        )
      );
    }
  }
}


// =============================================================
// SCANLINES
// =============================================================

void scanLines() {

  strokeWeight(1);


  for (int y = 0; y < height; y += 6) {

    stroke(
      255,
      random(
        1,
        5
      )
    );


    line(
      0,
      y,
      width,
      y
    );
  }
}
