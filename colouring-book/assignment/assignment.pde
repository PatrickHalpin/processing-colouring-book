//Patrick Halpin K00192966
//Processing Main Project
//Interactive colouring book
//Lecturer John Hannafin
//Module Rich media programming

//Import libaires
import processing.video.*;
import java.awt.Color;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;


//declare vairables 
Capture cam;

Minim minim;
AudioPlayer paper;
AudioPlayer camera;
AudioPlayer pageTurn;
AudioInput input;

PGraphics pg;

//used to name sequential screen shot
int screenNo=1;
boolean takenShot=false;

//colour variables
int colourR=0;
int colourG=0;
int colourB=0;
int penColour=1;
color drawColour = color(0,0,0);
//drawing tools variables
int penWidth=2;
int newX = 0; 
int newY = 0;
int lastX=400;
int lastY=300;
//effect variables
int effect=0;

//images
PImage img;

//Weather XML setup
//Yahoo xml for tramore ireland

//String url = "http://weather.yahooapis.com/forecastrss?w=562411";

int temperature;
boolean weatherEffect = false;

void setup()
{
  size(800, 600);
  cam = new Capture(this, width, height, 30);
  cam.start();   
  
  //createGrpahics() is used to draw ontop of the captured video
  pg = createGraphics(width, height);
  
  //set up sound effects and load specifed sounds to be played later
  minim = new Minim(this);
  paper = minim.loadFile("paper.mp3");
  camera = minim.loadFile("camera.mp3");
  pageTurn = minim.loadFile("pageTurn.mp3");
  input = minim.getLineIn();
  
  //load the xml for tramores weather
  
  //XML rssFeed = loadXML(url);
  //XML channel = rssFeed.getChild("channel");
  //XML item = channel.getChild("item");
  //XML conditions = item.getChild("yweather:condition");
  //temperature = conditions.getInt("temp");
  
}

void draw()
{
  //loads the web cam to be used
  if(cam.available())
  {
   cam.read();
   loadPixels();
   cam.loadPixels();
   image(cam, 0, 0);
   
   //Searchs the entire cam for a cretain colour
   for (int x = 0; x <cam.width; x ++ )
   { 
    for (int y = 0; y < cam.height; y ++ )
    { 
      int loc = x + y*cam.width;  
      float red = red(cam.pixels[loc]);
      float green = green(cam.pixels[loc]);
      float blue = blue(cam.pixels[loc]);;  
      
      //if green is found a line is drawn where that colour is located
      if((red>50 && red<70) && (green>95 && green<100) && (blue>50 && blue<70))
       {
         newX = x; 
         newY = y;         
         pg.beginDraw(); 
         pg.strokeWeight(penWidth);  
         pg.stroke(drawColour);
         pg.line(lastX,lastY,newX, newY);
         lastX = newX;
         lastY = newY;
         pg.endDraw();
       }
     }
   } 
   
   //seraching the pixels of the top corner of the video to be searched later
   for (int x = 0; x < cam.width/4; x++ )
   {
     for (int y = 0; y < cam.height/4; y++ )
     {
       int camloc = x + y*cam.width;
       float r = red(cam.pixels[camloc]);
       float g = green(cam.pixels[camloc]);
       float b = blue(cam.pixels[camloc]);
       
       //if a colour is present perform a certain action 
        if((r<10 && r>0) && (g<5 && g>0) && (b<10 && b>1))
       {
        penColour=1;
        //print("black is present ");
 
       }
       
       if((r<10 && r>=0) && (g<50 && g>0) && (b<255 && b>100))
       {
         //print("blue is present ");
         penColour=2;
       }
       
      if((r>200 && r<225) && (g>170 && g<190) && (b>50 && b<70))
      {
        penColour=4;
        //print("yello is present ");
      } 
       
      if((r>50 && r<70) && (g>95 && g<100) && (b>50 && b<70))
      {
        penColour=5;
        //print("green is present ");
      } 
     }
   }
  }
  
   //Draws a box for the search zone
   pg.beginDraw();
   pg.strokeWeight(1);
   pg.stroke(255,102,0);
   pg.line(0,0,0,cam.height/4);
   pg.line(0,cam.height/4,cam.width/4,cam.height/4);
   pg.line(cam.width/4,cam.height/4,cam.width/4,0);
   pg.endDraw();
 
 //draw a line when the mouse is clicked
  if (mousePressed == true)
  {
    pg.beginDraw();
    pg.stroke(drawColour);
    pg.strokeWeight(penWidth);
    pg.line( mouseX, mouseY, pmouseX, pmouseY);
    pg.endDraw(); 
  }
 
 //checks to see if the special weather based effect is active
 //if so the width of the pen is changed based on current temperature in tramore
 
 //if(weatherEffect==true)
 //{
 //  penWidth=temperature/2;
 //}
 
 //checks if effect conditions are available
 if(effect==1)
 {
   turtleDrawing();
 }
 if(effect==2)
 {
   fishDrawing();
 }
 if(effect==3)
 {
   blankCanvas();
 }
 //if(effect==4)
 //{
 //  inverseEffect();
 //}
 //if(effect==5)
 //{
 //  flagEffect();
 //}
 // if(effect==6)
 //{
 //  weatherChange();
 //}
  if(effect==4)
 {
   loadDrawing();
 }
 
 //Changes pen colours
  if(penColour==1)
  {
    //black
    drawColour = color(8,3,5);
  }
   
  if(penColour==2)
  {
    //blue
    drawColour = color(0,40,123);
  }
   
  if(penColour==3)
  {
    //red
    drawColour = color(150,20,0);
  }
   
  if(penColour==4)
  {
    //yellow
    drawColour = color(255,255,0);
  }
   
  if(penColour==5)
  {
    //green
    drawColour = color(20,150,0);
  }
  
  //special pen colour based on temperature in Tramore
  if(penColour==6)
  {
   //changes colour to red if temp is hot and blue if it is cold when this effect i s active
   // 59 ferenhight = 15 deg celsius
    if(temperature<59)
    {
      //set to blue
      drawColour = color(0,40,temperature*2);
    }
    else
    //set to red
    drawColour = color(temperature*2,20,0);
  }
 
 image(pg, 0, 0);
}

//Effect functions
//adds a flag effect to the screen
void flagEffect()
{
   loadPixels();
   cam.loadPixels();
   //searches the first  3rd of the screen
    for (int x = 0; x <cam.width/3; x ++ )
    { 
       for (int y = 0; y < cam.height; y ++ )
       { 
         //picks up colours of green present in the screen
         int loc = x + y*cam.width;
         float green = green(cam.pixels[loc]);
         color newColour = color(0,green,0);
         //removes all colours bar green from the screen
         pixels[loc] = newColour;
       }
    }
    
    //search each pixel in the last 3rd of the screen
    for (int x = cam.width/3+cam.width/3; x <cam.width/3+cam.width/3+cam.width/3; x ++ )
    { 
       for (int y = 0; y < cam.height; y ++ )
       { 
         //selects pixels colours and stores them
         int loc = x + y*cam.width;
         float red = red(cam.pixels[loc]);
         float green = green(cam.pixels[loc]);;
         color newColour = color(red,green,20);
         //replaces the pixels colours with the newly updated colours
         pixels[loc] = newColour;
       }
    } 
   updatePixels();
}

void inverseEffect()
{
  loadPixels();
   cam.loadPixels();
   //searches the screen
    for (int x = 0; x <cam.width; x ++ )
    { 
       for (int y = 0; y < cam.height; y ++ )
       { 
         //picks up all colours of present in the screen
         int loc = x + y*cam.width;
         float red = red(cam.pixels[loc]);
         float green = green(cam.pixels[loc]);
         float blue= green(cam.pixels[loc]);
         color newColour = color(green,blue,red);
         //replaces colours
         pixels[loc] = newColour;
       }
    }
    updatePixels();
}

void turtleDrawing()
{
   //adds an image to the screen
  img = loadImage("turtle.jpg");
  image(img,0,0);
}

void fishDrawing()
{
  img = loadImage("fish.png");
  image(img,0,0);
}

void blankCanvas()
{
  loadPixels();
  cam.loadPixels();
  for (int x = 0; x <cam.width; x ++ )
    { 
       for (int y = 0; y < cam.height; y ++ )
       { 
         int loc = x + y*cam.width;
         float red =255;
         float green = 255;
         float blue= 255;
         color newColour = color(green,blue,red);
         pixels[loc] = newColour;
       }
    }
  updatePixels();
}

void loadDrawing()
{
  //ensures a user has taken a screenshot which can be loaded in
  if(takenShot==true)
  {
  img = loadImage("screen-"+screenNo+".png");
  image(img,0,0);
  }
  else
  effect=0;
}

void weatherChange()
{
 loadPixels();
 cam.loadPixels();
 //searches the screen
  for (int x = 0; x <cam.width; x ++ )
  { 
     for (int y = 0; y < cam.height; y ++ )
     { 
       //picks up all colours of present in the screen
       int loc = x + y*cam.width;
       float red = red(cam.pixels[loc]);
       float green = green(cam.pixels[loc]);
       float blue= green(cam.pixels[loc]);
       
       float tempCelsius = (temperature - 32)* 0.5556;
       color newColour = color(red,green,blue);
       if(tempCelsius<15)
       {
         newColour= color(red,green,blue*(tempCelsius/2));
       }
       else if (tempCelsius>15)
       {
         newColour= color(red*(tempCelsius/3),green,blue);
       }
    
       //replaces colours
       pixels[loc] = newColour;
     }
  }
  updatePixels();
}

void keyPressed()
{ 
  
  //taking in key requests to change pen size,effects and take screenshots
  if (key == CODED)
  {
    
    if(keyCode==SHIFT)
    {
      //saves a screen with a coded name
      takenShot=true;
      screenNo+=1;
      save("screen-"+screenNo+".png");
      
     //play specifed sound effect
     camera.play();
     //reload the sound to be played again
     camera = minim.loadFile("camera.mp3");
    }
    
    if(keyCode==UP)
    {
     penWidth+=1;
     //keeps pen size within a margin of 1 to 10
     if (penWidth<10)
     {
       penWidth=10;
     }
    }
    
    if(keyCode==DOWN)
    {
     penWidth-=1;
     if (penWidth<2)
     {
       penWidth=2;
     }
    }
    
    //clears all drawings on screen
    if(keyCode==CONTROL)
    {
     pg.clear();
     effect=0;
     paper.play();
     paper = minim.loadFile("paper.mp3");
    }
    
    //increases the vlaue for the effect varaible when key is pressed
    if(keyCode==RIGHT)
    {
      effect+=1;
      pageTurn.play();
      pageTurn = minim.loadFile("pageTurn.mp3");
       //ensures effect value is never greater than the amount of effects available
       //if so it resets to 0
       if(effect>7)
       {
         effect=0;
       }
    }
    
    if(keyCode==LEFT)
    {
      effect-=1;
      pageTurn.play();
      pageTurn = minim.loadFile("pageTurn.mp3");
      //ensures effect value is never less than 0
      //if so it resets to 0
      if (takenShot==true)
      {
        if(effect<0)
         {
           effect=7;
         }
      }
      //skips effect is a screenshot is not loaded
      else if (takenShot==false)
      {
        if(effect<0)
           {
             effect=6;
           }
      }
    }
  }
  
  //changes pen colour by keyboard input
  if(keyPressed)
  {
    if(key=='w')
    {
     //change colour up 1
     penColour+=1;
     println(penColour);
     if(penColour>6)
     {
       penColour=6;
     }
    }
    
    if(key=='s')
    {
     //change colour down 1
     penColour-=1;
     if(penColour<1)
     {
       penColour=1;
     }
    }
  } 
}