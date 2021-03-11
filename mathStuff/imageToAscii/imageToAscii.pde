// the image to asciify
PImage img,temp;
 
// sampling resolution: colors will be sampled every n pixels 
// to determine which character to display

 
// array to hold characters for pixel replacement
char[] ascii;
 
void setup() {
  img = loadImage("men.jpg");
  
  size(1600,800);
  img.resize(width/6,height/3);
  background(255);
  fill(0);
  noStroke();
   scale(3);
  // build up a character array that corresponds to brightness values
  ascii = new char[256];
  String letters = "MN@#$o;:,. ";
  for (int i = 0; i < 256; i++) {
    int index =(int)map(i, 0, 256, 0, letters.length());
    ascii[i] = letters.charAt(index);
  }
 
  PFont mono = createFont("Courier", 3);
  textFont(mono);
 temp=img.copy();
  asciify();
}
 
void asciify() {
  // since the text is just black and white, converting the image
  // to grayscale seems a little more accurate when calculating brightness
  img.filter(GRAY);
  img.loadPixels();
 
  // grab the color of every nth pixel in the image
  // and replace it with the character of similar brightness
  for (int y = 0; y < img.height; y += 1) {
    for (int x = 0; x < img.width; x += 1) {
      color pixel = img.pixels[y * img.width + x];
      text(ascii[int(brightness(pixel))], x, y);
    }
  }
}
void draw(){
noLoop();

image(temp,width/2,0,width/2,height);


}
