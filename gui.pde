/**
 * Petter - vector-graphic-based pattern generator.
 * http://www.lafkon.net/petter/
 * Copyright (C) 2015 LAFKON/Benjamin Stephan
 * 
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation; either version 2 of the License, or (at your option) any later
 * version.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 */
 
import java.util.List;
import java.util.Arrays;
import java.awt.Insets;

CallbackListener cb;
GuiImage imgMap;
Insets insets;

boolean showMENU = true;
boolean showANIMATE = false;
boolean showHELP = false;

int c = 0;
int d = 0;

int indentX = 0;
int indentY = 10;
int gapX = 10;
int gapY = 22;
int ypos = 0;
int sep = 30;
int h = 20;
int w = 180;
int imgMapHeight = 0;
int tickMarks = 11;

//color c1 = color(218, 78, 57);    // red
color c1 = color(16, 181, 198);    // blue
color c2 = color(60, 105, 97, 180);// green
color c3 = color(200, 200, 200);  //lightgray for separatorlines

ArrayList settingFiles;

Boolean settingsBoxOpened = false;
Boolean shiftPressed = false;
Boolean shiftProcessed = false;

Slider last;
Slider xTileNumSlider, yTileNumSlider, pageOffsetSlider, absTransXSlider, absTransYSlider, relTransXSlider, relTransYSlider, absRotSlider, relRotSlider, absScaSlider, relScaSlider, strokeWeightSlider;
Group main, style, animate, help, helptextbox;
DropdownList penner_rot, penner_sca, penner_tra, penner_anim, formatDropdown;
ListBox settingsFilelist;
Button currentOver, mapFrameNextButton, mapFramePrevButton, mapFrameFirstButton, mapFrameLastButton;
Button closeImgMapButton, animSetInButton, animSetOutButton, animRunButton, animExportButton, animGotoInButton, animGotoOutButton, clearInOutValuesButton;
Bang bgcolorBang, strokecolorBang, shapecolorBang;
Toggle mapScaleToggle, mapRotToggle, mapTraToggle, invertMapToggle, pageOrientationToggle, showRefToggle, showNfoToggle, showGuiExportToggle, strokeModeToggle, strokeToggle, fillToggle, nfoLayerToggle;
Textlabel dragOffset, zoomLabel, stylefillLabel, helptextLabel;
Numberbox wBox, hBox, animFrameNumBox;


// ---------------------------------------------------------------------------
//  GUI SETUP
// ---------------------------------------------------------------------------

void setupGUI() {
  gui.setColorActive(c1);
  gui.setColorBackground(color(100));
  gui.setColorForeground(color(50));
  gui.setColorLabel(color(0, 255, 0));
  gui.setColorValue(color(255, 0, 0));
  gui.setColorCaptionLabel(color(255, 255, 255));
  gui.setColorValueLabel(color(255, 255, 255));

  gui.enableShortcuts();  

// ---------------------------------------------------------------------------
//  GUI SETUP - MAIN MENU
// ---------------------------------------------------------------------------

  main = gui.addGroup("main")
           .setPosition(fwidth+12,10)
           .hideBar()
           //.setBackgroundHeight(height-38)
           //.setWidth(guiwidth-24)
           //.setBackgroundWidth(guiwidth-12)
           //.setBackgroundColor(color(255,50))
           .close()
           ;
   
  ypos += 10;
  
  formatDropdown = gui.addDropdownList("formats")
     .setGroup(main)
     .setPosition(indentX, ypos+21)
     .setSize(54, 300)
     .setItemHeight(h)
     .setBarHeight(h)
     //.activateEvent(true)
     .setBackgroundColor(color(190))
     //.addItems(formatsx)
     ;
  addFormatItems(formatDropdown);
  formatDropdown.captionLabel().style().marginTop = h/4+1;

     
  wBox = gui.addNumberbox("width")
     .setPosition(indentX+67, ypos)
     .setSize(34, h)
     .setLabel("")
     .setRange(20,2000)
     .setDecimalPrecision(0) 
     //.setMultiplier(0.1) // set the sensitifity of the numberbox
     .setValue(pdfwidth)
     .setLock(true)
     .setLabelVisible(false)
     .setGroup(main)
     ;

  hBox = gui.addNumberbox("height")
     .setPosition(indentX +107, ypos)
     .setSize(34, h)
     .setLabel("")
     .setRange(20,2000)
     .setDecimalPrecision(0) 
     //.setMultiplier(0.1) // set the sensitifity of the numberbox
     .setValue(pdfheight)
     .setLock(true)
     .setGroup(main)
     ;

   pageOrientationToggle = gui.addToggle("pageOrientation")
     .setLabel("p/l")
     .setPosition(indentX+8*h, ypos)
     .setSize(h, h)
     .setValue(true)
     .setGroup(main)
     ;
     styleLabel(pageOrientationToggle, "p/l");
     
  ypos += sep;
  

   showRefToggle = gui.addToggle("showRef")
     .setLabel("REF")
     .setPosition(indentX, ypos)
     .setSize(h, h)
     .setValue(false)
     .setGroup(main)
     ;
     styleLabel(showRefToggle, "REF");
   indentX += h*2;

   showNfoToggle = gui.addToggle("showNfo")
     .setLabel("NFO")
     .setPosition(indentX, ypos)
     .setSize(h, h)
     .setValue(false)
     .setGroup(main)
     ;
     styleLabel(showNfoToggle, "NFO");
   indentX += h*2;

   nfoLayerToggle = gui.addToggle("nfoOnTop")
     .setLabel("nfotop")
     .setPosition(indentX, ypos)
     .setMode(ControlP5.SWITCH)
     .setSize(h, h)
     .setValue(nfoOnTop)
     .setGroup(main)
     ;
     styleLabel(nfoLayerToggle, "nfotop");
     
   indentX += h*2;
     
   bgcolorBang = gui.addBang("changebgcolor")
     .setLabel("C")
     .setPosition(indentX, ypos)
     .setSize(h, h)
     .setGroup(main)
     ;
     //styleLabel(bgcolorBang, "BG");
     bgcolorBang.getCaptionLabel().setPadding(8,-14);
     bgcolorBang.setColorForeground(bgcolor[0]);


   indentX += h*2;
 
   showGuiExportToggle = gui.addToggle("guiExport")
     .setLabel("GUIEXP")
     .setPosition(indentX, ypos)
     .setSize(h, h)
     .setValue(false)
     .setGroup(main)
     ;
     styleLabel(showGuiExportToggle, "GUIEXP");


   indentX = 0;
 
   
  ypos += sep;

   pageOffsetSlider = gui.addSlider("absPageOffset")
     .setLabel("pageOffset")
     .setPosition(indentX, ypos)
     .setSize(w,h)
     .setRange(0,250) // values can range from big to small as well
     .setSliderMode(Slider.FLEXIBLE)
     .setNumberOfTickMarks(tickMarks)
     .showTickMarks(false)   
     .snapToTickMarks(false)
     .setGroup(main)
     ;
     styleLabel(pageOffsetSlider, "offset");
  ypos += sep;

   xTileNumSlider = gui.addSlider("xtilenum")
     .setLabel("xtilenum")
     .setPosition(indentX, ypos)
     .setSize(w,h)
     .setRange(0,180) // values can range from big to small as well
     .setSliderMode(Slider.FLEXIBLE)
     .setGroup(main)
     ;
     styleLabel(xTileNumSlider, "xtilenum   (LEFT/RIGHT)");
  ypos += gapY;


  yTileNumSlider = gui.addSlider("ytilenum")
     .setLabel("ytilenum")
     .setPosition(indentX, ypos)
     .setSize(w,h)
     .setRange(0,260) // values can range from big to small as well
     .setSliderMode(Slider.FLEXIBLE)
     .setGroup(main)
     ;   
     styleLabel(yTileNumSlider, "ytilenum   (UP/DOWN)");
  ypos += sep;




  absTransXSlider = gui.addSlider("absTransX")
     .setLabel("global trans X")
     .setPosition(indentX, ypos)
     .setSize(w,h)
     .setRange(-400,400)
     .setSliderMode(Slider.FLEXIBLE)
     .setDecimalPrecision(1)
     .setScrollSensitivity(0.004)
     .setNumberOfTickMarks(tickMarks)
     .showTickMarks(false)   
     .snapToTickMarks(false)
     .setGroup(main)
     ;  
     styleLabel(absTransXSlider, "global trans X");     
  ypos += gapY;
  
  absTransYSlider = gui.addSlider("absTransY")
     .setLabel("global trans Y")
     .setPosition(indentX, ypos)
     .setSize(w,h)
     .setRange(-400,400)
     .setSliderMode(Slider.FLEXIBLE)
     .setDecimalPrecision(1)
     .setScrollSensitivity(0.004)
     .setNumberOfTickMarks(tickMarks)
     .showTickMarks(false)   
     .snapToTickMarks(false)
     .setGroup(main)
     ;
     styleLabel(absTransYSlider, "global trans Y");   
  ypos += gapY;
  
  relTransXSlider = gui.addSlider("relTransX")
     .setLabel("relative trans x")
     .setPosition(indentX,ypos)
     .setSize(w,h)
     .setRange(-400, 400)
     .setSliderMode(Slider.FLEXIBLE)
     .setDecimalPrecision(1)
     .setScrollSensitivity(0.005)
     .setNumberOfTickMarks(tickMarks)
     .showTickMarks(false)   
     .snapToTickMarks(false)
     .setGroup(main)
     ;  
     styleLabel(relTransXSlider, "relative trans X");
  ypos += gapY;
  
  relTransYSlider = gui.addSlider("relTransY")
     .setLabel("relative trans y")
     .setPosition(indentX,ypos)
     .setSize(w,h)
     .setRange(-400, 400)
     .setSliderMode(Slider.FLEXIBLE)
     .setDecimalPrecision(1)
     .setScrollSensitivity(0.005)
     .setNumberOfTickMarks(tickMarks)
     .showTickMarks(false)   
     .snapToTickMarks(false)
     .setGroup(main)
     ;  
     styleLabel(relTransYSlider, "relative trans Y");
  ypos += gapY+gapY;
  
  penner_tra = gui.addDropdownList("traType")
     .setGroup(main)
     .setPosition(indentX,ypos)
     .setSize(w, 300)
     .setItemHeight(h)
     .setBarHeight(h)
     .activateEvent(true)
     .setBackgroundColor(color(190))
     ;
  addItems(penner_tra);
  penner_tra.captionLabel().style().marginTop = h/4+1;

  ypos += sep/2;








  absRotSlider = gui.addSlider("absRot")
     .setLabel("global rot")
     .setPosition(indentX, ypos)
     .setSize(w,h)
     .setRange(-180,180)
     .setSliderMode(Slider.FLEXIBLE)
     .setDecimalPrecision(1)
     .setScrollSensitivity(0.003)
     .setNumberOfTickMarks(17)
     .showTickMarks(false)
     .snapToTickMarks(false)
     .setGroup(main)
     ;  
     styleLabel(absRotSlider, "global rot");

  ypos += gapY;

  relRotSlider = gui.addSlider("relRot")
     .setLabel("relative rot")
     .setPosition(indentX,ypos)
     .setSize(w,h)
     .setRange(0,360)
     .setSliderMode(Slider.FLEXIBLE)
     .setDecimalPrecision(1)
     .setScrollSensitivity(0.003)
     .setNumberOfTickMarks(17)
     .showTickMarks(false)   
     .snapToTickMarks(false)
     .setGroup(main)
     ;  
     styleLabel(relRotSlider, "relative rot");

  ypos += gapY+gapY;

  penner_rot = gui.addDropdownList("rotType")
     .setGroup(main)
     .setPosition(indentX,ypos)
     .setSize(w, 300)
     .setItemHeight(h)
     .setBarHeight(h)
     .activateEvent(true)
     .setBackgroundColor(color(190))     
     ;
  addItems(penner_rot);
  penner_rot.captionLabel().style().marginTop = h/4+1;
  ypos += sep/2;




  absScaSlider = gui.addSlider("absScale")
     .setLabel("global scale")
     .setPosition(indentX, ypos)
     .setSize(w,h)
     .setRange(-5.0,5.0) // values can range from big to small as well
     .setSliderMode(Slider.FLEXIBLE)
     .setDecimalPrecision(1)
     .setScrollSensitivity(0.01)
     .setNumberOfTickMarks(tickMarks)
     .showTickMarks(false)   
     .snapToTickMarks(false)
     .setGroup(main)
     ;  
     styleLabel(absScaSlider, "global scale");
  ypos += gapY;
 
  relScaSlider = gui.addSlider("relScale")
     .setLabel("relative scale")
     .setPosition(indentX, ypos)
     .setSize(w,h)
     .setRange(-5.0,5.0) // values can range from big to small as well
     .setSliderMode(Slider.FLEXIBLE)
     .setDecimalPrecision(1)
     .setScrollSensitivity(0.01)
     .setNumberOfTickMarks(tickMarks)
     .showTickMarks(false)   
     .snapToTickMarks(false)
     .setGroup(main)
     ; 
     styleLabel(relScaSlider, "relative scale");
  ypos += gapY+gapY;

  penner_sca = gui.addDropdownList("scaType")
     .setGroup(main)
     .setPosition(indentX,ypos)
     .setSize(w, 300)
     .setItemHeight(h)
     .setBarHeight(h)
     .activateEvent(true)
     .setBackgroundColor(color(190))
     ;
  addItems(penner_sca);
  penner_sca.captionLabel().style().marginTop = h/4+1;
  ypos += sep;


// ---------------------------------------------------------------------------
//  GUI SETUP - IMGMAP MENU
// ---------------------------------------------------------------------------

  imgMap = new GuiImage(indentX, ypos);
  imgMap.pre();
  main.addCanvas(imgMap);

  ypos -= gapY-2;

  mapScaleToggle = gui.addToggle("sca")
     .setValue(mapScale)
     .setPosition(indentX,ypos)
     .setSize(h,h)
     .setGroup(main)
     .setLabel("S")
     .hide();
     ;
   mapScaleToggle.getCaptionLabel().setPadding(8,-14);

  mapRotToggle = gui.addToggle("rot")
     .setValue(mapRot)
     .setPosition(indentX +1*h,ypos)
     .setSize(h,h)
     .setGroup(main)
     .setLabel("R")
     .hide()
     ;
   mapRotToggle.getCaptionLabel().setPadding(8,-14);

  mapTraToggle = gui.addToggle("tra")
     .setValue(mapTra)
     .setPosition(indentX +2*h,ypos)
     .setSize(h,h)
     .setGroup(main)
     .setLabel("T")
     .hide()
     ;
   mapTraToggle.getCaptionLabel().setPadding(8,-14);
     
  invertMapToggle = gui.addToggle("invertMap")
     .setValue(invertMap)
     .setPosition(indentX +4*h,ypos)
     .setSize(h,h)
     .setGroup(main)
     .setLabel("I")
     .hide()
     ;
   invertMapToggle.getCaptionLabel().setPadding(8,-14);

  closeImgMapButton = gui.addButton("X")
     .setValue(0)
     .setPosition(indentX+w-h,ypos)
     .setSize(h, h)
     .setGroup("main")
     .hide()
     ;
   closeImgMapButton.getCaptionLabel().setPadding(8,-14);


 ypos += gapY+imgMapHeight;


  mapFramePrevButton = gui.addButton("f<")
     .setLabel("<")
     .setValue(0)
     .setPosition(indentX+w+4,ypos)
     .setSize(h, h)
     .setGroup("main")
     .hide()
     ;
  mapFramePrevButton.getCaptionLabel().setPadding(8,-14);
   
  mapFrameNextButton = gui.addButton("f>")
     .setLabel(">")
     .setValue(0)
     .setPosition(indentX+w+h+8,ypos)
     .setSize(h, h)
     .setGroup("main")
     .hide()
     ;
  mapFrameNextButton.getCaptionLabel().setPadding(8,-14);

  ypos += gapY;

  mapFrameFirstButton = gui.addButton("ffirst")
     .setLabel("<I")
     .setValue(0)
     .setPosition(indentX+w+4,ypos)
     .setSize(h, h)
     .setGroup("main")
     .hide()
     ;
  mapFrameFirstButton.getCaptionLabel().setPadding(8,-14);
   
  mapFrameLastButton = gui.addButton("flast")
     .setLabel("I>")
     .setValue(0)
     .setPosition(indentX+w+h+8,ypos)
     .setSize(h, h)
     .setGroup("main")
     .hide()
     ;
  mapFrameLastButton.getCaptionLabel().setPadding(8,-14);


  //ypos += gapY+imgMapHeight;


// ---------------------------------------------------------------------------
//  GUI SETUP - STYLE MENU
// ---------------------------------------------------------------------------

 style = gui.addGroup("style")
           .setPosition(indentX,ypos)
           .setBackgroundHeight(100)
           .activateEvent(true)
           .setGroup(main)
           //.close()
           ;
  if(disableStyle) style.open();
  else style.close();
  
  ypos += gapY;

  strokeToggle = gui.addToggle("stroke")
     .setLabel("X")
     .setValue(stroke)
     .setPosition(indentX,indentY)
     .setSize(h,h)
     .setMode(ControlP5.SWITCH_BACK)
     .setGroup(style)
     ;
     strokeToggle.getCaptionLabel().setPadding(8,-14);
     
  strokeModeToggle = gui.addToggle("strokeMode")
     .setLabel("")
     .setValue(strokeMode)
     .setPosition(indentX+h+h/2,indentY)
     .setSize(h,h)
     .setMode(ControlP5.SWITCH)
     .setGroup(style)
     ;
     
   strokecolorBang = gui.addBang("changestrokecolor")
     .setLabel("C")
     .setPosition(indentX+3*h,indentY)
     .setSize(h, h)
     .setGroup(style)
     ;
     strokecolorBang.getCaptionLabel().setPadding(8,-14);
     strokecolorBang.setColorForeground(strokecolor[0]);

  
  strokeWeightSlider = gui.addSlider("strokeWeight")
     .setLabel("strokeWeight")
     .setPosition(indentX+4.5*h,indentY)
     .setSize(w-4*h,h)
     .setRange(0f,25.0)
     .setSliderMode(Slider.FLEXIBLE)
     .setNumberOfTickMarks(tickMarks)
     .showTickMarks(false)   
     .snapToTickMarks(false)
     //.setDecimalPrecision(2)
     //.setScrollSensitivity(0.004)
     .setSensitivity(0.004)
     .setGroup(style)
     ;   
     styleLabel(strokeWeightSlider, "strokeoptions");     
     
  fillToggle = gui.addToggle("fill")
     .setLabel("X")
     .setValue(fill)
     .setPosition(indentX,indentY+sep)
     .setSize(h,h)
     .setMode(ControlP5.SWITCH_BACK)
     .setGroup(style)
     ;
     fillToggle.getCaptionLabel().setPadding(8,-14);

   shapecolorBang = gui.addBang("changeshapecolor")
     .setLabel("filloptions")
     .setPosition(indentX+h+h/2,indentY+sep)
     .setSize(h, h)
     .setGroup(style)
     ;
     styleLabel(shapecolorBang, "filloptions");
     shapecolorBang.setColorForeground(shapecolor[0]);

   
// ---------------------------------------------------------------------------
//  GUI SETUP - ANIMATE MENU
// ---------------------------------------------------------------------------   

 animate = gui.addGroup("animate")
           .setPosition(indentX, fheight-36)
           .setBackgroundHeight(100)
           .activateEvent(true)
           .setGroup(main)
           .close()
           ;

  ypos = 0+indentY;
  
  animSetInButton = gui.addButton("registerStartValues")
     .setLabel("I")
     .setPosition(indentX, ypos)
     .setSize(h, h)
     .setGroup("animate")
     ;
  animSetInButton.getCaptionLabel().setPadding(10,-14);

  animSetOutButton = gui.addButton("registerEndValues")
     .setLabel("O")
     .setPosition(indentX+1.5*h, ypos)
     .setSize(h, h)
     .setGroup("animate")
     ;
  animSetOutButton.getCaptionLabel().setPadding(8,-14);

  clearInOutValuesButton = gui.addButton("clearKeyframes")
     .setLabel("X")
     .setValue(0)
     .setPosition(indentX+3*h, ypos)
     .setSize(h/2, h)
     .setGroup("animate")
     ;
  clearInOutValuesButton.getCaptionLabel().setPadding(3,-14);
  
    
  penner_anim = gui.addDropdownList("animType")
     .setPosition(indentX+4*h, ypos+h+1)
     .setSize(104, 70)
     .setItemHeight(12)
     .setBarHeight(h)
     .activateEvent(true)
     .setBackgroundColor(color(190))
     .setGroup("animate")
     ;
  addItems(penner_anim);
  penner_anim.captionLabel().style().marginTop = h/4+1;
  
  ypos += sep;

  animGotoInButton = gui.addButton("<")
     .setValue(0)
     .setPosition(indentX, ypos)
     .setSize(h, h)
     .setGroup("animate")
     ;
  animGotoInButton.getCaptionLabel().setPadding(10,-14);

  animGotoOutButton = gui.addButton(">")
     .setValue(0)
     .setPosition(indentX+1.5*h, ypos)
     .setSize(h, h)
     .setGroup("animate")
     ;
  animGotoOutButton.getCaptionLabel().setPadding(8,-14);
  
  animFrameNumBox = gui.addNumberbox("frames")
     .setPosition(indentX+3*h, ypos)
     .setSize(34, h)
     .setLabel("f")
     .setRange(2,10000)
     .setValue(frames)
     .setLabelVisible(false)
     .setGroup("animate")
     ;
  animFrameNumBox.getCaptionLabel().style().marginLeft = 28;
  animFrameNumBox.getCaptionLabel().style().marginTop = -17;

  animRunButton = gui.addButton("RUN")
     .setValue(0)
     .setPosition(indentX+5*h, ypos)
     .setSize(2*h, h)
     .setGroup("animate")
     ;
  animRunButton.getCaptionLabel().setPadding(12,-12);

  animExportButton = gui.addButton("EXPORT")
     .setValue(0)
     .setPosition(indentX+7.2*h, ypos)
     .setSize(2*h, h)
     .setGroup("animate")
     ;
  animExportButton.getCaptionLabel().setPadding(7,-12);
  

   
// ---------------------------------------------------------------------------
//  GUI SETUP - HELP MENU
// ---------------------------------------------------------------------------   
  
  int helpwidth = 330;
  int helpheight = 560;
  
  help = gui.addGroup("help")
    .setSize(fwidth, fheight+1)
    .setPosition(0, 0)
    .setBackgroundHeight(fheight+1)
    .setBackgroundColor(color(0, 170))
    .hideBar()
    .close();

  helptextbox = gui.addGroup("helptextbox")
    .setSize(helpwidth, helpheight)
    .setPosition((fwidth-helpwidth)/2, (fheight-helpheight)/2)
    .setBackgroundHeight(helpheight)
    .setBackgroundColor(color(255))
    .hideBar()
    .setGroup(help);
  
  helptextLabel = gui.addTextlabel("shortcuts", "", 20, 20)
    .setSize(helpwidth, helpheight)
    .setMultiline(true)
    .setLineHeight(9)
    .setColorValue(color(0))
    .setGroup(helptextbox);
  
  if(helptext != null) {
    for (int i = 0; i < helptext.length; i++) {
      String s = helptext[i];
      if(s.equals("")) s = ".";
      helptextLabel.append(s, 80);
    }
  }


// ---------------------------------------------------------------------------
//  GUI SETUP - FINAL CLEANUP
// --------------------------------------------------------------------------- 

  cb = new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
       callbackEvent(theEvent);
    }
  }; 
  gui.addCallback(cb);
  
  formatDropdown.bringToFront();
  penner_sca.bringToFront();
  penner_rot.bringToFront();
  penner_tra.bringToFront();
  penner_anim.bringToFront();
  
  ControllerProperties cprop = gui.getProperties();
  cprop.remove(closeImgMapButton);
  cprop.remove(bgcolorBang);
  cprop.remove(strokecolorBang);
  cprop.remove(shapecolorBang);
  cprop.remove(animate);
  cprop.remove(animSetInButton);
  cprop.remove(animSetOutButton);
  cprop.remove(clearInOutValuesButton);
  cprop.remove(penner_anim);
  cprop.remove(animGotoInButton);
  cprop.remove(animGotoOutButton);
  cprop.remove(animFrameNumBox);
  cprop.remove(animRunButton);
  cprop.remove(animExportButton);
  cprop.remove(help);
  cprop.remove(helptextLabel);
  cprop.remove(helptextbox);
  cprop.remove(mapFramePrevButton);
  cprop.remove(mapFrameNextButton);
  cprop.remove(mapFrameFirstButton);
  cprop.remove(mapFrameLastButton);
  
  //cprop.remove(pageOrientationToggle);
  //cprop.remove(invertMapToggle);
  //cprop.remove(mapScaleToggle);
  //cprop.remove(mapRotToggle);
  //cprop.remove(mapTraToggle); 

  registerForAnimation(xTileNumSlider);
  registerForAnimation(yTileNumSlider);
  registerForAnimation(pageOffsetSlider);
  registerForAnimation(absTransXSlider);
  registerForAnimation(absTransYSlider); 
  registerForAnimation(relTransXSlider); 
  registerForAnimation(relTransYSlider); 
  registerForAnimation(absRotSlider); 
  registerForAnimation(relRotSlider); 
  registerForAnimation(absScaSlider); 
  registerForAnimation(relScaSlider);
  registerForAnimation(strokeWeightSlider);


  dragOffset = gui.addTextlabel("dragoffset" )
     .setPosition(indentX, fheight-31)
     .setText("OFFSET: 0 x 0")
     .setGroup(main)
     ;

  zoomLabel = gui.addTextlabel("zoomlabel" )
     .setPosition(indentX+guiwidth-70, fheight-31)
     .setText("ZOOM: 1.0")
     .setGroup(main)
     ;

  if(showMENU) {
    showMENU = false;
    toggleMenu();
  }
} //setupGUI



void addFormatItems(DropdownList l) {
  l.addItem("CUSTOM",  0);
  for(int i=0; i<formats.length; i++) {
    l.addItem(formats[i][0], i+1);
  }
}

void addItems(DropdownList l) {
l.addItem("Linear.easeIn   ",  0);
l.addItem("Linear.easeOut  ",  1);
l.addItem("Linear.easeInOut",  2);
l.addItem("Quad.easeIn     ",  3);
l.addItem("Quad.easeOut    ",  4);
l.addItem("Quad.easeInOut  ",  5);
l.addItem("Cubic.easeIn    ",  6);
l.addItem("Cubic.easeOut   ",  7);
l.addItem("Cubic.easeInOut ",  8);
l.addItem("Quart.easeIn    ",  9);
l.addItem("Quart.easeOut   ",  10);
l.addItem("Quart.easeInOut ",  11);
l.addItem("Quint.easeIn    ",  12);
l.addItem("Quint.easeOut   ",  13);
l.addItem("Quint.easeInOut ",  14);
l.addItem("Sine.easeIn     ",  15);
l.addItem("Sine.easeOut    ",  16);
l.addItem("Sine.easeInOut  ",  17);
l.addItem("Circ.easeIn     ",  18);
l.addItem("Circ.easeOut    ",  19);
l.addItem("Circ.easeInOut  ",  20);
l.addItem("Expo.easeIn     ",  21);
l.addItem("Expo.easeOut    ",  22);
l.addItem("Expo.easeInOut  ",  23);
l.addItem("Back.easeIn     ",  24);
l.addItem("Back.easeOut    ",  25);
l.addItem("Back.easeInOut  ",  26);
l.addItem("Bounce.easeIn   ",  27);
l.addItem("Bounce.easeOut  ",  28);
l.addItem("Bounce.easeInOut",  29);
l.addItem("Elastic.easeIn  ",  30);
l.addItem("Elastic.easeOut ",  31);
l.addItem("Elastic.easeInOut",  32);
}


void styleLabel(Controller c) {
  c.getCaptionLabel().setColorBackground(c2);
}
void styleLabel(Controller c, String text) {
  controlP5.Label l = c.getCaptionLabel();
  if(c == shapecolorBang) {
      l.setHeight(20);
      l.getStyle().setPadding(4, 4, 4, 4);
      l.getStyle().setMargin(-22, 0, 0, 164);
      l.setColorBackground(c2);
  } else {
    if (c instanceof controlP5.Toggle || c instanceof controlP5.Bang) {
      l.setHeight(10);
      l.getStyle().setPadding(2, 2, 2, 2);
      l.getStyle().setMargin(-22, 0, 0, 20);
    } 
    else {
      l.setHeight(20);
      l.getStyle().setPadding(4, 4, 4, 4);
      l.getStyle().setMargin(-4, 0, 0, 0);
      l.setColorBackground(c2);
    }
  }
    l.setText(text);
}



// ---------------------------------------------------------------------------
//  GUI GENERAL EVENTHANDLING
// ---------------------------------------------------------------------------

void callbackEvent(CallbackEvent theEvent) {
  if (theEvent.getAction() == ControlP5.ACTION_RELEASED || theEvent.getAction() == ControlP5.ACTION_RELEASEDOUTSIDE) {
    if(theEvent.getController().getParent() != animate && 
       theEvent.getController().getParent() != penner_anim) {
          undo.setUndoStep();      
       }
  } 
}

void controlEvent(ControlEvent theEvent) {
 
  if(theEvent.isController() && theEvent.getController() instanceof Slider) {
   Slider tmp =  (Slider)theEvent.getController();
   if(tmp != xTileNumSlider && tmp != yTileNumSlider) {
      last = tmp;
      if(shiftPressed && !shiftProcessed) {
        enterShiftMode();
      }
    }
  }
  if (theEvent.isFrom("formats")) {
    int num = (int)theEvent.getGroup().getValue();

    formatDropdown.setColorBackground(color(100));
    formatDropdown.getItem(num).setColorBackground(c1);

    if(formatDropdown.getItem(num).getText() == "CUSTOM") {
      wBox.setLock(false);
      hBox.setLock(false);
    } else {
      wBox.setLock(true);
      hBox.setLock(true);
      int ww = int(formats[formatDropdown.getItem(num).getValue()-1][pageOrientation?1:2]);
      int hh = int(formats[formatDropdown.getItem(num).getValue()-1][pageOrientation?2:1]);
      if(ww != fwidth || hh != fheight) {
        wBox.setValue(ww);
        hBox.setValue(hh);
        canvasResize();  
      }
    }
  } 
  else if (theEvent.isFrom("rotType")) {
    rotType = (int)theEvent.getGroup().getValue();
    penner_rot.setColorBackground(color(100));
    penner_rot.getItem(rotType).setColorBackground(c1);
  }   
  else if (theEvent.isFrom("scaType")) {
    scaType = (int)theEvent.getGroup().getValue();
    penner_sca.setColorBackground(color(100));
    penner_sca.getItem(scaType).setColorBackground(c1);
  }
  else if (theEvent.isFrom("traType")) {
    traType = (int)theEvent.getGroup().getValue();
    penner_tra.setColorBackground(color(100));
    penner_tra.getItem(traType).setColorBackground(c1);
  }    
  else if (theEvent.isFrom("animType")) {
    animType = (int)theEvent.getGroup().getValue();
    penner_anim.setColorBackground(color(100));
    penner_anim.getItem(traType).setColorBackground(c1);
  } 
  else if(theEvent.isFrom("style")) {
    toggleSvgStyle();
    disableStyle = !disableStyle;
  } 
  else if(theEvent.isFrom(pageOrientationToggle)) {
    if(pageOrientation) {
      if((fwidth > fheight)) {
        togglePageOrientation();
      }
    } else {
      if((fwidth < fheight)) {
        togglePageOrientation();
      }      
    }
  }
  else if (theEvent.isFrom(settingsFilelist)) {
    int val = (int)theEvent.group().value();
    loadSettings((String)settingFiles.get(val), true);
  } 
  else if (theEvent.isFrom(closeImgMapButton)) {
    mapScale = false;
    mapRot = false;
    mapTra = false;
    map.clear();
    //map = null;
    updateImgMap();
  } 
  else if (theEvent.isFrom(mapScaleToggle)) {
    mapScale = ((Toggle)theEvent.getController()).getState();
    updateImgMap();
  } 
  else if (theEvent.isFrom(mapRotToggle)) {
    mapRot = ((Toggle)theEvent.getController()).getState();
    updateImgMap();
  }   
  else if (theEvent.isFrom(mapTraToggle)) {
    mapTra = ((Toggle)theEvent.getController()).getState();
    updateImgMap();
  }   
  else if (theEvent.isFrom(wBox)) {
    canvasResize();
  } 
  else if (theEvent.isFrom(hBox)) {
    canvasResize();
  }
  else if(theEvent.isFrom("animate")) {
    if(gui.group("animate").isOpen())
      openAnimate();
    else
      closeAnimate();
  }   
  else if (theEvent.isFrom(animSetInButton)) {
    registerAnimStartValues();
  }   
  else if (theEvent.isFrom(animSetOutButton)) {
    registerAnimEndValues();
  }    
  else if (theEvent.isFrom(animRunButton)) {
    startSequencer(false);
  }    
  else if (theEvent.isFrom(animExportButton)) {
    startSequencer(true);
  }   
  else if (theEvent.isFrom(animGotoInButton)) {
    showInValues();
  }    
  else if (theEvent.isFrom(animGotoOutButton)) {
    showOutValues();
  } 
  else if (theEvent.isFrom(clearInOutValuesButton)) {
    deleteRegisteredValues();
  }      
  else if (theEvent.isFrom(mapFramePrevButton)) {
    prevImgMapFrame(); 
  }   
  else if (theEvent.isFrom(mapFrameNextButton)) {
    nextImgMapFrame();
  }
  else if (theEvent.isFrom(mapFrameFirstButton)) {
    firstImgMapFrame();
  }
  else if (theEvent.isFrom(mapFrameLastButton)) {
    lastImgMapFrame();
  }  
  
} //controlEvent


void catchMouseover() {
  List overs = gui.getWindow().getMouseOverList();
  ControllerInterface over = gui.getWindow().getFirstFromMouseOverList();
 
  if(over == settingsFilelist) {
    if(currentOver == null) {
      gui.getProperties().setSnapshot("tmp");
    }
    for(int i = 0; i<overs.size(); i++)
      if(overs.get(i) instanceof controlP5.Button) {
        if(currentOver == null || currentOver != overs.get(i)) {
         currentOver = (Button)overs.get(i);
         
          int val = (int)currentOver.value();
          loadSettings((String)settingFiles.get(val), false);
        break;
        }
      }
    
  } else {
    if(currentOver != null) {
      gui.getProperties().getSnapshot("tmp");
      currentOver = null;
    }
  }
}


// ---------------------------------------------------------------------------
//  GUI ACTIONS
// ---------------------------------------------------------------------------


void toggleHelp() {
  showHELP = !(gui.group("help").isOpen());
  if (showHELP) {
    help.open();
  } else {
    help.close();
  }
}

void toggleAnimate() {
  showANIMATE = !(gui.group("animate").isOpen());
  if (showANIMATE) {
    openAnimate();
  } else {
    closeAnimate();
  }
}

void openAnimate() {
  animate.setPosition(indentX, fheight-36-80);
  animate.open();
}

void closeAnimate() {
  animate.setPosition(indentX, fheight-36);
  animate.close();
}

void toggleMenu() {
  showMENU = !(gui.group("main").isOpen());
  insets = frame.getInsets();
  if (showMENU) {
    frame.setSize(fwidth+guiwidth, fheight+insets.top);
    style.setPosition(indentX, imgMap.y+imgMapHeight+h);
    gui.group("main").open();
  } else {
    frame.setSize(fwidth, fheight+insets.top);
    gui.group("main").close();
  }
}

void toggleSvgStyle() {
  if (!disableStyle) {
    for (int i = 0; i < svg.size (); i++) {
      svg.get(i).disableStyle();
    }
  } else {
    for (int i = 0; i < svg.size (); i++) {
      svg.get(i).enableStyle();
    }
  }
}

void toggleRandom() {
  random = !random;
  seed = mouseX;
}

void changebgcolor(float i) {
  if(bg_copi == null) {
    bg_copi = new ColorPicker(this, "colorpicker", 380, 300, bgcolor);
  } else {
    bg_copi.show(); 
  }
}
void changestrokecolor(float i) {
  if(stroke_copi == null) {
    stroke_copi = new ColorPicker(this, "colorpicker", 380, 300, strokecolor);
  } else {
    stroke_copi.show(); 
  }
}
void changeshapecolor(float i) {
  if(shape_copi == null) {
    shape_copi = new ColorPicker(this, "colorpicker", 380, 300, shapecolor);
  } else {
    shape_copi.show(); 
  }
}

void updatextilenumSlider() {
  xTileNumSlider.setValue(xtilenum);
  undo.setUndoStep(); 
}

void updateytilenumSlider() {
  yTileNumSlider.setValue(ytilenum);
  undo.setUndoStep(); 
}

void enterShiftMode() {
  if(last != null && !shiftProcessed) {
    last.showTickMarks(true);
    last.snapToTickMarks(true);
    shiftProcessed = true;
  } 
}
void leaveShiftMode() {
  if(last != null && shiftProcessed) {
    last.showTickMarks(false);
    last.snapToTickMarks(false); 
   shiftProcessed = false; 
  }
}

void togglePageOrientation() {
  int tmppdfwidth = (int) hBox.getValue();
  int tmppdfheight = (int) wBox.getValue();  
  wBox.setValue(tmppdfwidth);
  hBox.setValue(tmppdfheight);
  
  canvasResize();
  
  int tmp = xtilenum;
  xtilenum = ytilenum;
  ytilenum = tmp;
  
  tilewidth  = (float(fwidth -  (2*pageOffset)) / xtilenum);
  tilescale = tilewidth / svg.get(0).width;
  tileheight = svg.get(0).height * tilescale;
  
  while((tileheight * ytilenum) > fheight) {
     ytilenum--; 
  }
  
  xTileNumSlider.setValue(xtilenum);
  yTileNumSlider.setValue(ytilenum); 
 
  dropSVGadd.updateTargetRect(fwidth, fheight);
  dropSVGrep.updateTargetRect(fwidth, fheight);
  dropIMG.updateTargetRect(fwidth, fheight);
  dropNFO.updateTargetRect(fwidth, fheight);
  
  dragOffset.setPosition(indentX, fheight-31);
  zoomLabel.setPosition(indentX+guiwidth-70, fheight-31);
}

void updateImgMap() {
  if(map.size() != 0 && mapIndex < map.size() && map.get(mapIndex) != null) {
    style.setPosition(indentX, imgMap.y + ((int)(((float)map.get(mapIndex).height / (float)map.get(mapIndex).width) * (float)(w))) +h);
    closeImgMapButton.show();
    mapRotToggle.show();
    mapScaleToggle.show();
    mapTraToggle.show();
    invertMapToggle.show();
    penner_sca.setVisible(!mapScale);
    penner_rot.setVisible(!mapRot);
    penner_tra.setVisible(!mapTra);
    if(map.size() > 1) {
      frames = map.size();
      mapFramePrevButton.show();
      mapFrameNextButton.show();
      mapFrameFirstButton.show();
      mapFrameLastButton.show();
    } else {
      frames = 25;
      mapFramePrevButton.hide();
      mapFrameNextButton.hide();
      mapFrameFirstButton.hide();
      mapFrameLastButton.hide();
    }
    animFrameNumBox.setValue(frames);
  } else {
      closeImgMapButton.hide();
      mapRotToggle.hide();
      mapScaleToggle.hide();
      mapTraToggle.hide();
      invertMapToggle.hide();
      mapFramePrevButton.hide();
      mapFrameNextButton.hide();
      mapFrameFirstButton.hide();
      mapFrameLastButton.hide();
      style.setPosition(indentX, imgMap.y);
      penner_sca.show();
      penner_rot.show();
      penner_tra.show();
  }
}

  void nextImgMapFrame() {
    if(map.size() > mapIndex+1) {
      mapIndex++;
    }
  }

  void prevImgMapFrame() {
    if(mapIndex != 0) {
      mapIndex--;
    }  
  }
  
  void firstImgMapFrame() {
      mapIndex = 0;
  }
  
  void lastImgMapFrame() {
      mapIndex = map.size()-1;
  }
  
    void specImgMapFrame(int f) {
      if(map.size() != 0) {
        if(f < map.size()) {
          mapIndex = f;
        }  else {
          mapIndex = f%map.size();
        }
      }
  }
  
// ---------------------------------------------------------------------------
//  FRAME RESIZING AND ZOOM
// ---------------------------------------------------------------------------

void canvasResize() {
  pdfwidth = (int) wBox.getValue();
  pdfheight = (int) hBox.getValue();
  resizeFrame(pdfwidth, pdfheight);
}

void resizeFrame(int newW, int newH) {
  fwidth = int(newW*zoom);
  fheight = int(newH*zoom); 

  insets = frame.getInsets();
  
  if (showMENU) {
    newW = fwidth+guiwidth;
    newH = fheight+insets.top;
  } else {
    newW = fwidth;
    newH = fheight+insets.top;
  }
  frame.setSize(newW, newH);
  gui.group("main").setPosition(fwidth+12,10);
  gui.group("animate").setPosition(indentX, fheight-36- (gui.group("animate").isOpen()?80:0) );
  gui.group("help").setSize(fwidth, fheight+1);
  gui.group("helptextbox").setPosition((fwidth-helptextLabel.getWidth())/2, (fheight-helptextLabel.getHeight())/2);
  
  dropSVGadd.updateTargetRect(fwidth, fheight);
  dropSVGrep.updateTargetRect(fwidth, fheight);
  dropIMG.updateTargetRect(fwidth, fheight);
  dropNFO.updateTargetRect(fwidth, fheight);

  dragOffset.setPosition(indentX, fheight-31);
  zoomLabel.setPosition(indentX+guiwidth-70, fheight-31);
}

void scaleGUI(boolean bigger) {
  if(bigger) {
    zoom += .1;
  } else {
    if(zoom > 0.1) {
      zoom -= .1;
    }
  }
  zoomLabel.setText("ZOOM: " +nf(zoom, 1, 1));
  resizeFrame(pdfwidth, pdfheight);
}



// ---------------------------------------------------------------------------
//  SETTINGS
// ---------------------------------------------------------------------------

void toggleSettings() {
  if(settingsFilelist == null || (settingsFilelist != null && !settingsFilelist.isOpen())) {
    
    gui.getProperties().setSnapshot("tmp");
    
    if(settingsFilelist != null) {
      settingsFilelist.remove();
    }
    findSettingFiles();
    
    settingsFilelist = gui.addListBox("filelist")
//      .setPosition(width/2-90, 200)
      .setPosition(20, 40)
      .setSize(180, 260)
      .setItemHeight(15)
      .setBarHeight(15);
  
    //settingsFilelist.captionLabel().toUpperCase(true);
    settingsFilelist.captionLabel().set("LAST SAVED SETTINGS");
    settingsFilelist.captionLabel().setColor(0xffffffff);
    settingsFilelist.captionLabel().style().marginTop = 3;
    settingsFilelist.valueLabel().style().marginTop = 3;
  
    for (int i = 0; i < settingFiles.size(); i++) {
      ListBoxItem lbi = settingsFilelist.addItem((String)(settingFiles.get(i)), i);
    }
    gui.getProperties().remove(settingsFilelist);
    settingsBoxOpened = true;
 } 
 else {
    settingsFilelist.close();
    settingsFilelist.hide();
    currentOver = null;
    settingsBoxOpened = false;
 } 
}

void loadSettings(String filename, boolean close) {
  gui.loadProperties(settingspath +filename);
  if(close) {
    settingsFilelist.close();
    settingsFilelist.hide();
    settingsBoxOpened = false;
  }
}

void saveSettings(String timestamp) {
  //gui.setFormat(ControllerProperties.Format);    
   gui.saveProperties(settingspath +timestamp +".ser");
   //println(gui.getProperties().get());
}

void loadDefaultSettings() {
  gui.loadProperties("default.ser");
}


void findSettingFiles() {
  String[] allFiles = listFileNames(sketchPath("") +settingspath);
  allFiles = reverse(allFiles);
  settingFiles = new ArrayList(); 
  for (int k = 0; k < allFiles.length; k++) {
    String file = allFiles[k];
    if (file.indexOf(".ser") != -1) {
      settingFiles.add(file);
    }
  }
  allFiles = null;
  printArrayList(settingFiles); 
}


// ---------------------------------------------------------------------------
//  GENERAL UTIL
// ---------------------------------------------------------------------------

void generateName() {
    randomSeed(mouseX*mouseY*frameCount);
    if(names != null) {
      name = names[int(random((float)names.length))];
    } else {
      name = "petter"; 
    }
    randomSeed(seed);
}

void generateTimestamp() {
  timestamp = year() +"" +nf(month(), 2) +"" +nf(day(), 2) +"" +"-" +nf(hour(), 2) +"" +nf(minute(), 2) +"" +nf(second(), 2);  
}

// This function returns all the files in a directory as an array of Strings  
String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } 
  else {
    return null;
  }
}

void printArrayList(ArrayList l) {
  println("----------------------------------");
  for (int i = 0; i < l.size(); i++) {
    println(l.get(i));
  }
  println("----------------------------------");
}

float ease(int type, float a, float b, float c, float d) {
  if (type == ROT) {
    type = rotType;
  } else if (type == TRA) {
    type = traType;
  } else if (type == SCA) {
    type = scaType;
  } else /*if (type == ANM)*/ {
    type = animType;
  }

  switch(type) {
  case 0:
    return Linear.easeIn    (a, b, c, d);
  case 1:
    return Linear.easeOut   (a, b, c, d);
  case 2:
    return Linear.easeInOut (a, b, c, d);
  case 3:
    return Quad.easeIn     (a, b, c, d);
  case 4:
    return Quad.easeOut    (a, b, c, d);
  case 5:
    return Quad.easeInOut  (a, b, c, d);
  case 6:
    return Cubic.easeIn    (a, b, c, d);
  case 7:
    return Cubic.easeOut   (a, b, c, d);
  case 8:
    return Cubic.easeInOut (a, b, c, d);
  case 9:
    return Quart.easeIn    (a, b, c, d);
  case 10:
    return Quart.easeOut   (a, b, c, d);
  case 11:
    return Quart.easeInOut (a, b, c, d);
  case 12:
    return Quint.easeIn    (a, b, c, d);
  case 13:
    return Quint.easeOut   (a, b, c, d);
  case 14:
    return Quint.easeInOut (a, b, c, d);
  case 15:
    return Sine.easeIn    (a, b, c, d);
  case 16:
    return Sine.easeOut   (a, b, c, d);
  case 17:
    return Sine.easeInOut (a, b, c, d);
  case 18:
    return Circ.easeIn    (a, b, c, d);
  case 19:
    return Circ.easeOut   (a, b, c, d);
  case 20:
    return Circ.easeInOut (a, b, c, d);
  case 21:
    return Expo.easeIn    (a, b, c, d);
  case 22:
    return Expo.easeOut   (a, b, c, d);
  case 23:
    return Expo.easeInOut (a, b, c, d);
  case 24:
    return Back.easeIn    (a, b, c, d);
  case 25:
    return Back.easeOut   (a, b, c, d);
  case 26:
    return Back.easeInOut (a, b, c, d);
  case 27:
    return Bounce.easeIn    (a, b, c, d);
  case 28:
    return Bounce.easeOut   (a, b, c, d);
  case 29:
    return Bounce.easeInOut (a, b, c, d);
  case 30:
    return Elastic.easeIn    (a, b, c, d);
  case 31:
    return Elastic.easeOut   (a, b, c, d);
  case 32:
    return Elastic.easeInOut (a, b, c, d);
  default:
    return 0.0;
  }
}