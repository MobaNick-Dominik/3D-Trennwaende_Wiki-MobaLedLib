/*
    Projekt Name: Trennwaende fuer das Modellhaus 3723
    Modul:  Wand Suedseite Fotogeschaeft
    Projekt URL: https://github.com/Hardi-St/MobaLedLib_Docu/tree/master/3D_Daten_fuer_die_MobaLedLib/Trennwände%20für%20Häuser
    Version: 0.0.1
    Autor: Moba-Nick (mobanick@wp12085804.server-he.de)
    Lizenz: CC-BY-SA-4.0 (https://creativecommons.org/licenses/by-sa/4.0/legalcode.de)
*/
//  Alle Angaben sind immer in mm bei meinen Projekten.
//  Parameter fuer die Wand
x_all = 55;  //Breite der Wand = Breite der Grundplatte
z_all = 0.75; //Wandstaerke gibnt an, wie Dick die Wand ist. 0.75 ist dick genug um kein Licht durchzulassen, aber duenn genug um Material zu sparen.
y_erdgeschoss = 28;     //Hoehe Erdgeschoss 
y_dachschraege = 26;    // Hoehe Dachgeschoss
y_all = y_erdgeschoss + y_dachschraege;

/*  Der Parameter "$fn" sagt, wie rund die Ausschnitte von Kreisen sind. Je hoeher die Zahl desto mehr Kreispunkte werden verwendet. Minimum ist 3, Maximum ist 999 (Ich nehme nie mehr als 150 sonst wird die Berechnungszeit zu gross). Als ideal haben sich Werte zwischen 35 und 45 ergeben. 
    Bei 3 wird es ein Dreieck, bei 4 eine Raute.
*/
$fn=40;
/* 
    Hier erfolgt die eigentliche Arbeit. Als erstes wird die komplette Wand erstellt mit Hilfe des Modules "HauptWand()". 
    Danach werden alle weiteren Elemente die in der Funktion "difference()" erstellt aus dieser Wand ausgeschnitten. Dadurch ergeben sich die Oeffnungen fuer die Fenster und Tueren, damit da Licht durchscheinen kann. 
    Weitere Informatioen zur Funktion "difference()" gibt es hier https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/CSG_Modelling#difference
*/
difference(){
    HauptWand();
    
    // 1. Fenster links unten
    Fenster(-23.25,13.00,6.75,7.75);
    // 2. Fenster links unten
    Fenster(-13.75,13.00,6.75,7.75);
    
    // 1. Fenster links oben
    Fenster(-5.5,35.5,4.5,7.00);
    // 2. Fenster rechts oben
    Fenster(1.75,35.5,4.5,7.00);
    
    // Schaufenster
    Fenster(0,4,30,21.5);
}

// Kante über dem Schaufenster als Lichtschutz
translate([x_all/2-0.5,y_erdgeschoss-z_all,0-5.75]){
    cube([x_all/2+0.5,z_all,5.75],false);
}



/* 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!    
!!!!    Ab hier kommen die Module. Bitte nur aendern wann man   !!!!
!!!!    weiss was man macht.                                    !!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
/*  
    Das Module HauptWand erstellt die Wand des Hauses inkl. der Dachschraege aus einen Polyhydron. Dazu wurde im Bereich fuer die Parameter in den  Zeilen 10 - 14 die Werte fuer die Breite der Wand (x_all) sowie die Höhe des Erdgeschosses (y_erdgeschoss) und des oberen Stockwerks (y_dachschraege) angeben.
*/
module HauptWand(){   
    //  PolyPunkte gibt an wo sicher welcher Punkt befindet. 
    //  Die Korrdinaten werden immer im Format [x,y,z] uebergeben.
    PolyPunkte = [
    [0,0,0],    // 0
    [0,y_erdgeschoss,0],    // 1
    [x_all/2,y_all,0],    // 2
    [x_all,y_erdgeschoss,0],    // 3
    [x_all,0,0],    // 4
    [0,0,z_all],    // 5
    [x_all,0,z_all],    // 6
    [x_all,y_erdgeschoss,z_all],    // 7
    [x_all/2,y_all,z_all],    // 8
    [0,y_erdgeschoss,z_all]];    // 9
    
    //  PolyFlaechen gibt an welche Punkte welche Flaechen beschreiben. 
    //  Die Korrdinaten werden immer im Format [x,y,z] uebergeben.
    PolyFlaechen =[
    [0,1,2,3,4],    // Unten (Boden)
    [5,0,4,6],      // Vorne (vordere Kante)
    [6,4,3,7],      // Rechts unten (Erdgeschoss)
    [7,3,2,8],      // Rechts oben  (Dachgeschoss/Dachschraege)
    [6,7,8,9,5],    // Oben (Deckel)
    [9,1,0,5],      // Links unten  (Erdgeschoss)
    [8,2,1,9]];     // Links oben   (Dachgeschoss/Dachschraege)
      
    polyhedron( PolyPunkte, PolyFlaechen );
}

/*  
    Das Module Fenster erstellt wie der Name schon sagt, die Ausschnitte fuer die Fenster.
    Dabei gibt es 4 Variablen die uebergeben werden.
    "pos_x" gibt die Startposition des linken unteren Ecke im Bezug zur Mittelachse des Hauses an.
    "pos_y" gibt die Startposition der inken untren Ecke im Bezug zur Grundplatte an.
    "size_x" gibt die Breite des Fensters an
    "size_y" gibt die Hoehe des Fensters an
    Beispiel: Der Befehl "Fenster(10,20,15,10);" erzeugt ein Fenster 10mm von der Mitte nach Rechts, auf der Hoehe von 20mm mit einer Breite von 15mm und einer Hoehe von 10mm;
*/
module Fenster(pos_x, pos_y, size_x, size_y){
    translate([x_all/2+pos_x, pos_y, 0]){
        cube([size_x,size_y,z_all*1.25],false);
    }
}

/*  
    Das Module Fenster_rund erstellt wie der Name schon sagt, die Ausschnitte fuer die Fenster mit rundem Ausschnitt.
    Dabei gibt es 3 Variablen die uebergeben werden.
    "pos_x" gibt die Startposition der linken unteren Ecke im Bezug zur Mittelachse des Hauses an.
    "pos_y" gibt die Startposition der inken unteren Ecke im Bezug zur Grundplatte an.
    "size_x" gibt die Breite des Fensters an
    Beispiel: Der Befehl "Fenster_rund(10,20,5);" erzeugt ein Fenster 10mm von der Mitte nach Rechts, auf der Hoehe von 20mm mit einem Durchmesser von 5mm;
*/
module Fenster_Rund(pos_x, pos_y, size_x){
    
    translate([x_all/2+pos_x+size_x/2, pos_y+size_x/2, 0]){
        cylinder(h=z_all*1.25,d=size_x,false);
    }
}