/*
Projekt Name: Trennwaende fuer das Modellhaus 3723
Modul:  Zwischendecke mit Halterungen fuer die WS2812
Projekt URL: https://github.com/Hardi-St/MobaLedLib_Docu/tree/master/3D_Daten_fuer_die_MobaLedLib/Trennwaende%20fuer%20Haeuser
Version: 0.0.1
Autor: Moba-Nick (mobanick@wp12085804.server-he.de)
Lizenz: CC-BY-SA-4.0 (https://creativecommons.org/licenses/by-sa/4.0/legalcode.de)
*/
// Alle Angaben sind immer in mm bei meinen Projekten.
//Parameter fuer die Grundplatte des Hauses
x_grund = 54;       // Laenge der Grundplatte
y_grund = 35;       // Breite der Grundplatte 
z_grund = 1.25;       // Staerke der Zwischendecke
wand_staerke = 1.00; // Parameter fuer die Staerke der Waende

z_zwischendecke = z_grund * 0.5; // Hoehe der Fugen
faktor_fugen = 1.25; //Faktor um den die Fugen breiter sind als die Wandstaerke
fugen_erstellen = true; // Sollen Fugen fuer das verkleben erstellt (true) oder keine Fugen erstellt (false) werden?

/*
    Bitte die nachfolgenden Zeilen nicht aendern. Diese errechnen die zusaetzlichen Parameter aus den vorhandenen Werten und legen die Abmessungen fuer die LED-Halterungen fest.
*/
x_all = x_grund; 
y_all = y_grund; 
z_all = 55 - 28 - z_grund - wand_staerke*0.625; // Gesamthoehe vom Haus - Hoehe_Erdgeschoss (Grundplatte_Haus.scad) - Hoehe Zwischendecke - Dachschraegenkompensierung
z_knie = 0; //Kniestock nicht vorhanden

// Variablen zu den LEDs und deren Halterung
led_x = 10; // Laenge der LED inkl. Platine
led_y = 10; // Breite der LED inkl. Platine
led_x_inner = 5; // Laenge der LED ohne Platine
led_y_inner = 5; // Breite der LEd ohne Platine
led_h_z = 3.2; // Abstand zwischen Grundplatte und LED-Haken 
led_h_x = 7; // Laenge des LED-Halters
led_h_y = 2; // Breite des LED-Halters
haken = 1.25; // BReite des Ueberhanges des LED-Halters

// Angaben fuer die Groesse der Kabeloeffnungen in den Waenden. setzen der Werte auf 0 deaktivieren die Funktion
kabel_x = 2.5;
kabel_y = 3.00;

/* 
    Wenn die Zwischendecke_Haus eine Oeffnung braucht, kann man hier einen Ausschnitt in der Zwischendecke_Haus dafuer vorsehen und die Position und Groesse angeben.
*/
x_cut = 6;  // Laenge der Aussparung
y_cut = 6;  // Breite der Aussparung
cut_pos_x = x_grund/2 - x_cut/2; // Punkt X der Aussparung
cut_pos_y = y_all/2 - y_cut/2; // Punkt Y der Aussparung 

/*
    Im nachfolgendem Abschnitt wird die Grundplatte und alle Waende erstellt.
    Die Angaben koennen ganz nach belieben abgeaendert werden.
*/
difference(){
    //Erstellen der Zwischendecke sowie dem Loch fuer den Kabelschacht (true = mit loch, false = ohne Loch)
    union(){
        Zwischendecke_Haus(true);
        DachSchraege_Y_Wand(0,y_grund/2-y_cut/2-wand_staerke,z_grund,x_grund,z_all,true);
    }
    if (fugen_erstellen == true){
         //Kabelschacht
        // rechts
        Wand_DIR_X(x_grund/2+x_cut/2+wand_staerke/2,y_grund/2-y_cut/2-wand_staerke-0.2,0,x_cut+wand_staerke*2,z_zwischendecke,faktor_fugen);
        //links
        Wand_DIR_X(x_grund/2-x_cut/2-wand_staerke/2,y_grund/2-y_cut/2-wand_staerke-0.1,0,x_cut+wand_staerke*2+0.2,z_zwischendecke,faktor_fugen);
        //vorne
        Wand_DIR_Y(x_grund/2-x_cut/2,y_grund/2-y_cut/2-wand_staerke/2,0,y_cut,z_zwischendecke,faktor_fugen);
        //hinten
        Wand_DIR_Y(x_grund/2-x_cut/2,y_grund/2+y_cut/2+wand_staerke/2,0,y_cut,z_zwischendecke,faktor_fugen);
        
        // Wand vorne bis Mitte
        Wand_DIR_X(x_grund/2+wand_staerke, 0,0,y_grund/2-y_cut/2,z_zwischendecke,faktor_fugen); 

        // Wand Mitte bis Hinten
        Wand_DIR_X(x_grund/2+3, y_grund/2+y_cut/2,0,y_grund/2-y_cut/2,z_zwischendecke,faktor_fugen);

        //Wand Mitte bis Rechts
        Wand_DIR_Y(x_grund/2+x_cut/2+wand_staerke/2,y_grund/2+y_cut/2+wand_staerke/2,0,x_grund/2-x_cut/2-wand_staerke/2,z_zwischendecke,faktor_fugen);
    }
    // Ausschnitt oben
    translate([0,y_all-7,0]){
        cube([x_grund/2+1.5,7,z_all],false);
    }
    // Ausschnitt links
    translate([0,5,0]){
        cube([8,y_all,z_all],false);
    }
        // Kappung um 1mm wegen Länge links
    translate([0,0,0]){
        cube([0.75,8,z_all],false);
    }
    // Oben Links Tuer/Schafenster 1
    LED_Loch(16, y_all*0.55); 
    // Oben Rechts Dunkelkammer
    LED_Loch(x_all*0.75, y_all*0.75); 
    // Unten Rechts Lager
    LED_Loch(x_all*0.75, y_all*0.25); 
    // Unten Links Tuer/Schafenster 2
    LED_Loch(16, y_all*0.25); 
  
    Kabel_Loch(x_grund/2-x_cut/2,y_grund/2-y_cut/2-wand_staerke);  
}

// Oben Links Tuer/Schafenster 1
LED_Halter_R(16, y_all*0.55,"unten");
// Oben Rechts Dunkelkammer
LED_Halter_R(x_all*0.75, y_all*0.75,"unten");
// Unten Rechts Lager
LED_Halter_R(x_all*0.75, y_all*0.25,"oben");
// Unten Links Tuer/Schafenster 2
LED_Halter_R(16, y_all*0.25,"oben"); 

/* 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!   
!!!!    Ab hier kommen die Module. Bitte nur aendern wann man   !!!!
!!!!    weiss was man macht.                                    !!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
/*  
    Das Module Zwischendecke_Haus erstellt die Grundplatte des Hauses inkl. des Aussenrandes um die Grundplatte. Dazu wurde im Bereich fuer die Parameter in den  Zeilen 10 - 37 die Werte angeben.
*/
module Zwischendecke_Haus(cutting){
        difference(){
            cube([x_grund,y_grund,z_grund],false);
            // Auschnitt aus der Grundplatte vornehmen
            if (cutting == true){
                translate([cut_pos_x,cut_pos_y,0]){
                    cube([x_cut,y_cut,z_grund],false);
                }
            }
        }
}

/*
    Das Modul "Wand_DIR_X" erstellt Waende welche auf der X-Achse (von links nach rechts) verschoben werden koennen.
    pos_x   => gibt den pospunkt auf der X-Achse an.
    pos_y   => gibt den pospunkt auf der Y-Achse an.
    pos_z   => gibt den pospunkt auf der Z-Achse an.
    width_y => gibt an wie lang die Wand werden soll.
    height  => gibt die Hoehe der Wand an.
*/
module Wand_DIR_X(pos_x, pos_y, pos_z,width_x, height, faktor){
    translate([pos_x -wand_staerke*faktor/2,pos_y,pos_z]){
        cube([wand_staerke*faktor,width_x, height]);
    }
}

/*
    Das Modul "Wand_DIR_Y" erstellt Waende welche auf der Y-Achse (von vorne nach hinten) verschoben werden koennen.  
    pos_x   => gibt den pospunkt auf der X-Achse an.
    pos_y   => gibt den pospunkt auf der Y-Achse an.
    pos_z   => gibt den pospunkt auf der Z-Achse an.
    width_y => gibt an wie lang die Wand werden soll.
    height  => gibt die Hoehe der Wand an.
*/
module Wand_DIR_Y(pos_x, pos_y, pos_z,width_y,height, faktor){
    translate([pos_x,pos_y - wand_staerke*faktor/2,pos_z]){
        cube([width_y,wand_staerke*faktor, height]);
    }
}

/*
    Das Modul "LED_Loch" erstellt die Oeffnungen fuer die LEDs, damit das Licht durch die Zwischendecke in den zu beleuchtenden Raum kommt.
    pos_x   => gibt den Mittelpunkt der Oeffnung auf der X-Achse an.
    pos_y   => gibt den Mittelpunkt der Oeffnung auf der Y-Achse an.
*/
module LED_Loch(pos_x, pos_y){
    translate([pos_x - led_x_inner/2,pos_y - led_y_inner/2,0]){
        cube([led_x_inner,led_y_inner, z_grund], center=false);
    }
}

/*
    Das Modul "LED_Halter" erstellt die Halterungen fuer die LEDs.
    pos_x   => gibt den Mittelpunkt der LED auf der X-Achse an.
    pos_y   => gibt den Mittelpunkt der LED auf der Y-Achse an.
    posh    => bestimmt ob der der Einschubbegrenzer links oder rechts aus sicht der LED ist
*/
module LED_Halter(pos_x, pos_y,posh){
    translate([pos_x - led_h_x/2,pos_y - led_y/2 - led_y_inner / 2,z_grund]){
        cube([led_h_x,led_h_y,led_h_z], center=false);
    }
    translate([pos_x - led_h_x/2,pos_y - led_y/2 - led_y_inner / 2,z_grund+led_h_z]){
        cube([led_h_x,led_h_y+haken,z_grund], center=false);
    }
    translate([pos_x - led_h_x/2,pos_y + led_y/2,z_grund]){
        cube([led_h_x,led_h_y,led_h_z], center=false);
    }
    translate([pos_x - led_h_x/2,pos_y + led_y/2-haken,z_grund+led_h_z]){
        cube([led_h_x,led_h_y+haken,z_grund], center=false);
    }

    if (posh == "rechts"){
        translate([pos_x+led_x/2,pos_y-led_h_x/2,z_grund]){
            cube([led_h_y,led_h_x,led_h_z*0.9], center=false);
        }
    }else if (posh == "links"){
        translate([pos_x-led_x/2-led_h_y,pos_y-led_h_x/2,z_grund]){
            cube([led_h_y,led_h_x,led_h_z*0.9], center=false);
        }
    }else{
        // Kein Einschubbegrenzer
    }
}

/*
    Das Modul "LED_Halter_R" erstellt die Halterungen fuer die LEDs.
    pos_x   => gibt den Mittelpunkt der LED auf der X-Achse an.
    pos_y   => gibt den Mittelpunkt der LED auf der Y-Achse an.
    posh    => bestimmt ob der der Einschubbegrenzer oben oder unten aus sicht der LED ist
*/
module LED_Halter_R(pos_x, pos_y,posh){
        translate([pos_x - led_y/2-led_h_y,pos_y - led_h_y/2 - led_y_inner / 2,z_grund]){
            cube([led_h_y,led_h_x,led_h_z], center=false);
        }
        translate([pos_x - led_y/2-led_h_y,pos_y - led_h_y/2 - led_y_inner / 2,z_grund+led_h_z]){
            cube([led_h_y+haken,led_h_x,z_grund], center=false);
        }
        translate([pos_x + led_y/2,pos_y - led_h_y/2-led_y_inner / 2,z_grund]){
            cube([led_h_y,led_h_x,led_h_z], center=false);
        }
        translate([pos_x + led_y/2 - haken,pos_y - led_h_y/2-led_y_inner / 2,z_grund+led_h_z]){
            cube([led_h_y+haken,led_h_x,z_grund], center=false);
        }

        if (posh == "oben"){
            translate([pos_x-led_h_x/2,pos_y+led_y/2-led_h_y/2,z_grund]){
                cube([led_h_x,led_h_y,led_h_z*0.9], center=false);
            }
        }else{
            translate([pos_x-led_h_x/2,pos_y-led_y/2-led_h_y/2,z_grund]){
                cube([led_h_x,led_h_y,led_h_z*0.9], center=false);
            }
        }
}
/*
    Das Modul "LED_Halter_W" erstellt die Halterungen fuer die LEDs an der Mittelwand. Der Einschubbegrenzer ist dabei immer unten.
    pos_x   => gibt den Mittelpunkt der LED auf der X-Achse an.
    pos_y   => gibt den Mittelpunkt der LED auf der Y-Achse an.
    pos_z   => gibt den Mittelpunkt der LED auf der Z-Achse an.
*/
module LED_Halter_W(pos_x, pos_y,pos_z){
        translate([pos_x-led_x/2-led_h_y,pos_y-led_h_z,pos_z-led_h_y/2]){
            cube([led_h_y,led_h_z,led_h_x], center=false);
        }
        translate([pos_x-led_x/2-led_h_y,pos_y-led_h_z-z_grund,pos_z-led_h_y/2]){
            cube([led_h_y+haken,z_grund,led_h_x], center=false);
        }
        translate([pos_x+led_x/2,pos_y-led_h_z,pos_z-led_h_y/2]){
            cube([led_h_y,led_h_z,led_h_x], center=false);
        }
        translate([pos_x+led_x/2-haken,pos_y-led_h_z-z_grund,pos_z-led_h_y/2]){
            cube([led_h_y+haken,z_grund,led_h_x], center=false);
        }

        translate([pos_x-led_h_x/2, pos_y-led_h_y ,pos_z-led_y_inner]){
            cube([led_h_x,led_h_y,led_h_z*0.9], center=false);
        }
}

/*
    Das Modul "Kabel_Loch" erstellt die Oeffnungen fuer das durchfuehren der Kabel durch die Mittelwand. Die poshoehe ist dabei immer die Oberkante der Zwischendecke.
    pos_x   => gibt den Mittelpunkt der LED auf der X-Achse an.
    pos_y   => gibt den Mittelpunkt der LED auf der Y-Achse an.
*/
module Kabel_Loch(pos_x,pos_y){
    translate([pos_x,pos_y,z_grund]){
        cube([kabel_y,wand_staerke,kabel_x],false);
    }
}

/*
    Das Modul "DachSchraege" erstellt die Waende von der Aussenseite der Zwischendecke zur Mittelwand mit einer schraegen Decke und einem Kniestock.
     * Dachschraege(X,Y,Z,LED-Halterung,Pos,LED-Oeffnung,Kabeloeffnung);
     * X => posposition X-Achse
     * Y => posposition Y-Achse
     * Z => posposition Z-Achse
     * LED-Halterung => Soll die Wand eine Halterung fuer LEDs haben? => "links", "rechts", false 
     * Pos => Befindet sich die Dachschraege vor oder hinter der Mittelwand? => "vorne", "hinten"
     * LED-Oeffnung => Hat die Wand eine Oeffnung fuer eine LED? => true, false 
     * Kabel-Oeffnung => Soll die Wand eine Oeffnung fuer Kabel haben? Die Oeffnung ist immer an bei der Mittelwand. => true, false
*/
module DachSchraege(pos_x,pos_y,pos_z,pos_led,pos_wand,led_loch,kabel_loch){
    difference(){
        /* 
         *  BEGINN union()
        */
        union(){  
            /* 
             *  BEGINN KnieStock
            */
            translate([pos_x,pos_y,pos_z]){
                cube([wand_staerke,y_all/2,z_knie],false);
            }
            // ENDE KnieStock
            
            /* 
             *  BEGINN DachSchraege
             *  "vorne"  => Die Dachschraege beginnt Anfang der
             *  Zwischendecke und geht bis zur Mitte des Daches.
             *
             *  "hinten" => Die Dachschraege beginnt in der Mitte des Daches
             *  und geht bis zum Ende der Zwischendecke.
            */
            if (pos_wand == "vorne"){
                DachPunkte = [
                  [pos_x,pos_y,pos_z + z_knie],  //0
                  [pos_x + wand_staerke,pos_y,pos_z + z_knie],  //1
                  [pos_x + wand_staerke,pos_y + y_all/2,pos_z + z_knie],  //2
                  [pos_x,pos_y+y_all/2,pos_z + z_knie],  //3
                  [pos_x,pos_y+y_all/2,pos_z + z_all],  //4
                  [pos_x + wand_staerke,pos_y+y_all/2,pos_z + z_all]]; //5
                DachFlaechen = [
                    [0,1,2,3],//Boden
                    [5,4,3,2],//links
                    [0,4,5,1],//Oben
                    [5,1,0],//hinten
                    [5,2,1]];//vorne
                  
                polyhedron( DachPunkte, DachFlaechen );
            }else{
                DachPunkte = [
                  [pos_x,pos_y,pos_z + z_knie],  //0
                  [pos_x + wand_staerke,pos_y,pos_z + z_knie],  //1
                  [pos_x + wand_staerke,pos_y + y_all/2,pos_z + z_knie],  //2
                  [pos_x,pos_y+y_all/2,pos_z + z_knie],  //3
                  [pos_x,pos_y,pos_z + z_all],  //4
                  [pos_x + wand_staerke,pos_y,pos_z + z_all]]; //5
                DachFlaechen = [
                    [0,1,2,3],//Boden
                    [5,4,3,2],//links
                    [0,4,5,1],//Oben
                    [0,3,4],//hinten
                    [5,2,1]];//vorne
                  
                polyhedron( DachPunkte, DachFlaechen );
            }
            // ENDE DachSchraege
            
            /* BEGINN LED Halter an Dachschraege
            * Led_Halter_Dach(pos_x, pos_y,pos_z,dir)
            * Die pospunkte der X, Y und Z-Achse werden von den 
            * pospunkten der Wand automatisch berechnet und muessen nicht 
            * veraendert werden.
            * pos_x    => pospunkt X-Achse
            * pos_y    => pospunkt Y-Achse
            * pos_z    => pospunkt Z-Achse
            * dir      => Halterung an der linken oder rechten Seite der Wand
            */
            if (pos_led != false){
                if (pos_wand == "vorne"){
                    Led_Halter_Dach(pos_x,pos_y+y_all/2-led_y_inner-led_h_y,z_knie+led_x_inner/2,pos_led);
                }else{
                   Led_Halter_Dach(pos_x,pos_y+led_y_inner+led_h_y,z_knie+led_x_inner/2,pos_led);
                }
            }//ENDE LED Halter an Dachschraege
        }//Ende union()
        /*
         *  BEGINN difference()
         *  Alles was ab hier kommt wird aus den Flaechen oben ausgeschnitten
        */
        
        /*
        *   BEGINN LED_Loch 
        */
        if (led_loch == true){
            if (pos_wand == "vorne"){
                    translate([pos_x,pos_y+y_all/2-led_h_y-led_y/2-led_y_inner/2,z_knie+led_x_inner/2+led_h_y/2]){
                        cube([wand_staerke,led_y_inner,led_x_inner],false);
                    }
                }else{
                   translate([pos_x,pos_y+led_y_inner/2+led_h_z/2,z_knie+led_x_inner/2+led_h_y/2]){
                        cube([wand_staerke,led_y_inner,led_x_inner],false);
                    }
                }
        }
        //  ENDE LED_Loch
        
        /*
        *   BEGINN Kabel_Loch
        */
        if (kabel_loch == true){
            if (pos_wand == "vorne"){
                    translate([pos_x,pos_y+y_all/2-wand_staerke/2-kabel_y,z_grund]){
                        cube([wand_staerke,kabel_y,kabel_x],false);
                    }
                }else{
                   translate([pos_x,pos_y+wand_staerke/2,z_grund]){
                        cube([wand_staerke,kabel_y,kabel_x],false);
                    }
                }
        }
        //  ENDE Kabel_Loch
    }
}

/*
    Das Modul "LED_Halter_Dach" erstellt die Halterungen fuer die LEDs an der Mittelwand. Der Einschubbegrenzer ist dabei immer unten.
    pos_x   => gibt den Mittelpunkt der LED auf der X-Achse an.
    pos_y   => gibt den Mittelpunkt der LED auf der Y-Achse an.
    pos_z   => gibt den Mittelpunkt der LED auf der Z-Achse an.
    dir     => git an ob die Halterung links oder rechts von der Dachsraege ist.
*/
module Led_Halter_Dach(pos_x, pos_y,pos_z,dir){
    h_diff = 0;
    if (dir == "rechts"){
        translate([pos_x+wand_staerke,pos_y-led_x/2-led_h_y,pos_z]){
            cube([led_h_z-h_diff,led_h_y,led_h_x], center=false);
        }
        translate([pos_x+wand_staerke+led_h_z-h_diff,pos_y-led_x/2-led_h_y,pos_z]){
            cube([haken,led_h_y+haken,led_h_x], center=false);
        }
        
        translate([pos_x+wand_staerke,pos_y+led_x/2,pos_z]){
            cube([led_h_z-h_diff,led_h_y,led_h_x], center=false);
        }
        translate([pos_x+wand_staerke+led_h_z-h_diff,pos_y+led_x/2-haken,pos_z]){
            cube([haken,led_h_y+haken,led_h_x], center=false);
        }
        translate([pos_x+wand_staerke,pos_y-led_h_x/2,pos_z-led_h_x/2]){
            cube([led_h_y*0.9,led_h_x,led_h_y], center=false);
        }
    }else{
        translate([pos_x-led_h_z+h_diff,pos_y-led_x/2-led_h_y,pos_z]){
            cube([led_h_z-h_diff,led_h_y,led_h_x], center=false);
        }
        translate([pos_x-led_h_z-haken+h_diff,pos_y-led_x/2-led_h_y,pos_z]){
            cube([haken,led_h_y+haken,led_h_x], center=false);
        }
        
        translate([pos_x-led_h_z+h_diff,pos_y+led_x/2,pos_z]){
            cube([led_h_z-h_diff,led_h_y,led_h_x], center=false);
        }
        translate([pos_x-led_h_z+h_diff-haken,pos_y+led_x/2-haken,pos_z]){
            cube([haken,led_h_y+haken,led_h_x], center=false);
        }
        translate([pos_x-led_h_y,pos_y-led_h_x/2,pos_z-led_h_x/2]){
            cube([led_h_y*0.9,led_h_x,led_h_y], center=false);
        }
    }
}

module DachSchraege_Y_Wand(pos_x,pos_y,pos_z,width_x,height_m,led_loch){
    difference(){
        union(){  
            //Kniestock
            if (z_knie > 0){
                translate([pos_x,pos_y,pos_z]){
                    cube([width_x,wand_staerke,z_knie],false);
                }
            }
            
            //Dachschraege
            DachPunkte = [
              [pos_x,pos_y,pos_z+z_knie],  //0
              [pos_x+width_x,pos_y,pos_z+z_knie],  //1
              [pos_x+width_x,pos_y+wand_staerke,pos_z+z_knie],  //2
              [pos_x,pos_y+wand_staerke,pos_z+z_knie],  //3
              [pos_x+width_x/2,pos_y+wand_staerke,z_all],  //4
              [pos_x+width_x/2,pos_y,z_all]]; //5
              
            DachFlaechen = [
              [0,1,2,3],  // bottom
              [5,1,0],  // front
              [5,4,2,1],  // right
              [4,3,2],  // back
              [4,5,0,3]]; // left
              
            polyhedron( DachPunkte, DachFlaechen );
            
            //LED_Halter am Dach
            //Links
            LED_Halter_W(x_grund/2,pos_y,z_all/2-2);
        }
        if (led_loch == true){
           translate([x_grund/2-led_x_inner/2,pos_y,z_all/2-2]){
              cube([led_x_inner,wand_staerke,led_y_inner],false);
           } 
        }
    }   
}
