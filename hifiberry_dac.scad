/* d_cinch
 * raspberry & hifiberry dac case with several options
 * https://github.com/xkonni/hifiberry_dac_case
*/

// to plot a rpi + hifiberry reference
use <../hifiberry.scad>;

// level of detail
$fn=6;

/*
 * custom parameters, edit if necessary
 */
// rounding of corner, case width
corner   = 3;
width    = 2;
offset_y = 0;
offset_x = 5; // 5+ recommended
// diameter inside/outside of plugs, switch
d_audio35   = 10;
d_cinch     = 8;
do_cinch    = 12;
d_power_pl  = 11;
do_power_pl = 13;
d_power_sw  = 13;
do_power_sw = 15;
// mount
d_mount = 8;
// screws
d_screw     = 2.5;
d_screwhead = 5;
h_screw     = 10;
// enable port holes - use offset_y = 0
ena_m_usb      = 0;
ena_hdmi       = 0;
ena_audio35    = 0;
ena_cinch_side = 0;
ena_cinch_back = 0;
ena_power_sw   = 0;
ena_power_pl   = 0;

/* static parameters */
// rpi_size
rpi_l = 85;
rpi_w = 56;

/* dynamic parameters */
// case size
case_l = rpi_l + 2*width + offset_x;
case_w = rpi_w + 2*width + offset_y + 4 + ((ena_cinch_back) ? 20 : 0) + ((ena_power_sw || ena_power_pl) ? 20 : 0);
case_h = 30;
//echo("case: ", case_l, " x ", case_w, " x ", case_h);
// port size
size_m_usb = [10, 2*width, 5];
size_hdmi  = [17, 2*width, 8];
size_eth   = [2*width, 17.5, 14.5];
size_usb   = [2*width, 16, 16];
// port position
pos_m_usb       = [ 20   + offset_x, 0, case_h - 30];
pos_hdmi        = [ 44.5 + offset_x, 0, case_h - 30];
pos_audio35     = [ 57.5 + offset_x, 0, case_h - 27 ];
pos_eth         = [case_l, offset_y +  6.5, case_h - 28.5];
pos_usb1        = [case_l, offset_y + 25.5, case_h - 28.5];
pos_usb2        = [case_l, offset_y + 43, case_h - 28.5];
pos_cinch_side1 = [38 + offset_x, 0, case_h - 8];
pos_cinch_side2 = [55 + offset_x, 0, case_h - 8];
pos_cinch_back1 = [case_l, rpi_w + offset_y + 12, case_h - 10];
pos_cinch_back2 = [case_l, rpi_w + offset_y + 12, case_h - 22];
pos_power_pl    = [case_l, rpi_w + offset_y + 10 + ((ena_cinch_back) ? do_cinch + 8 : 0), case_h - 19];
pos_power_sw    = [0, case_w - 20, case_h - 19];

pos_rpi_mount   = [
  [case_l - 81.5, offset_y +  7.5, case_h - width/2], 
  [case_l - 81.5, offset_y + 56.5, case_h - width/2], 
  [case_l - 23.5, offset_y +  7.5, case_h - width/2], 
  [case_l - 23.5, offset_y + 56.5, case_h - width/2]];
pos_mount = [
  [         5,          5, case_h - width/2],
  [         5, case_w - 5, case_h - width/2],
  [case_l - 5,          5, case_h - width/2],
  [case_l - 5, case_w - 5, case_h - width/2]];
rot_mount = [[0, 180, 90], [0, 180, 0], [0, 180, 180], [0, 180, 270]];

/* attaches to the 4 holes in the bottom plate, screw hidden */
module foot() {
  translate([0, 0, 2]) difference() {
    cylinder(d=d_mount, h=2);
    cylinder(d=d_screw, h=2);
  }
  difference() {
    cylinder(d=12, h=2);
    cylinder(d=d_screwhead, h=2);
  }
}

/* mount with supports */
module mount(md=5, mh=10, md_s=2, mh_s=5, ml_sup=3, mh_sup=5) {
 /*
 * parameters
 *   md:     diameter
 *   mh:     height
 *   md_s:   screw diameter
 *   mh_s:   screw height
 *   ml_sup: support length
 *   mh_sup: support height
 */

//  echo("md: ", md, " mh: ", mh, " md_s: ", md_s, " mh_s: ", mh_s, " mh_sup: ", mh_sup);
  render() {
    translate([0, 0, 0]) difference() {
      cylinder(d=md, h=mh);
      translate([0, 0, mh-mh_s]) cylinder(d=md_s, h=mh_s);
    }
    translate([  0, md*0.45, 0]) cube([1,    ml_sup, mh_sup]);
    translate([ md*0.45,  0, 0]) cube([ml_sup,    1, mh_sup]);
  }
}

/* reinforce holes */
module reinforce(rdo=10, rdi=8, rh=width) {
  difference() {
    cylinder(d=rdo, h=rh);
    cylinder(d=rdi, h=rh);
  }
}
/* case with mounting border */
module case(cl=case_l, cw=case_w, ch=case_h, cwd=width, cc=corner, bo=0, bi=1, bh=width) {

 /*
 * cl:  case length
 * cw:  case width
 * ch:  case_height, plus border height
 * cwd: case wall width
 * cc:  corner radius
 * bo:  border diameter difference outside
 * bi:  border diameter difference inside
 * bh:  border height
 */
  difference() {
    hull() {
      translate([  0,   0,   0]) cylinder(d=2*cc, h=1);
      translate([  0,   0, ch]) sphere(cc);
      translate([  0, cw,   0]) cylinder(d=2*cc, h=1);
      translate([  0, cw, ch]) sphere(cc);
      translate([cl,   0,   0]) cylinder(d=2*cc, h=1);
      translate([cl,   0, ch]) sphere(cc);
      translate([cl, cw,   0]) cylinder(d=2*cc, h=1);
      translate([cl, cw, ch]) sphere(cc);
    }
    union() {
      hull() {
        translate([      cwd,       cwd,         0 ]) cylinder(d=2*cc, h=1);
        translate([      cwd,       cwd, ch - cwd]) sphere(cc);
        translate([      cwd, cw - cwd,          0]) cylinder(d=2*cc, h=1);
        translate([      cwd, cw - cwd, ch - cwd]) sphere(cc);
        translate([cl - cwd,       cwd,         0 ]) cylinder(d=2*cc, h=1);
        translate([cl - cwd,       cwd, ch - cwd]) sphere(cc);
        translate([cl - cwd, cw - cwd,          0]) cylinder(d=2*cc, h=1);
        translate([cl - cwd, cw - cwd, ch - cwd]) sphere(cc);
      }
    }
  }
  translate([0, 0, -bh]) difference() {
    hull() {
      translate([      bo,      bo, 0]) cylinder(d=2*cc, h=bh);
      translate([ cl - bo,      bo, 0]) cylinder(d=2*cc, h=bh);
      translate([      bo, cw - bo, 0]) cylinder(d=2*cc, h=bh);
      translate([ cl - bo, cw - bo, 0]) cylinder(d=2*cc, h=bh);
    }
    hull() {
      translate([      bi,      bi, 0]) cylinder(d=2*cc, h=bh);
      translate([ cl - bi,      bi, 0]) cylinder(d=2*cc, h=bh);
      translate([      bi, cw - bi, 0]) cylinder(d=2*cc, h=bh);
      translate([ cl - bi, cw - bi, 0]) cylinder(d=2*cc, h=bh);
    }
  }
}
/* cooling holes in a waveform pattern */
module cooling(cl=case_l, cw=case_w, cspace=5, cs=3, ch=width) {
  render() {
    wave = [ 0.05, 0.15, 0.35, 0.50, 0.60, 0.70, 0.75, 0.7, 0.60, 0.50, 0.35, 0.15, 0.05,
    0.15, 0.25, 0.35, 0.40, 0.35, 0.25, 0.15, 0.05 ];
    wave_n = min(cw*0.93/cspace, len(wave));
    start = cw * 0.035;
    for (i = [1:wave_n]) {
      d = wave[i-1]*cl;
      d1 = cl/2 - d/2;
      translate([d1, start + (cspace * i), 0]) hull() {
        cylinder(d=cs, ch);
        translate([d, 0, 0]) cylinder(d=cs, ch);
      }
    }
  }
}

/* top part of the case */
module case_top() {
  difference() {
    case(ch=case_h);
    /* Cutouts */
    union() {
      // Top: Cooling
      translate([0, 0, case_h]) cooling(ch=2*width);
      // Back: Ethernet, USB1, USB2
      translate(pos_eth) cube(size_eth);
      translate(pos_usb1) cube(size_usb);
      translate(pos_usb2) cube(size_usb);
      
      if (ena_m_usb) {
        translate(pos_m_usb) rotate([0, 0, 180]) cube(size_m_usb);
      }
      if (ena_hdmi) {
        translate(pos_hdmi) rotate([0, 0, 180]) cube(size_hdmi);
      }
      if (ena_audio35) {
        translate(pos_audio35) rotate([90, 0, 0]) cylinder(d=d_audio35, h=2*width);
      }
      if (ena_cinch_side) {
        translate(pos_cinch_side1) rotate([90, 0, 0]) cylinder(d=do_cinch, h=2*width);
        translate(pos_cinch_side2) rotate([90, 0, 0]) cylinder(d=do_cinch, h=2*width);
      }
      if (ena_cinch_back) {
        translate(pos_cinch_back1) rotate([0, 90, 0]) cylinder(d=do_cinch, h=2*width);
        translate(pos_cinch_back2) rotate([0, 90, 0]) cylinder(d=do_cinch, h=2*width);
      }
      if (ena_power_pl) {
        translate(pos_power_pl) rotate([0, 90, 0]) cylinder(d=do_power_pl, h=2*width);
      }
      if (ena_power_sw) {
        translate(pos_power_sw) rotate([0, -90, 0]) cylinder(d=do_power_sw, h=2*width);
      }
    }
  }
  /* Port reinforcements */
  if (ena_cinch_back) {
    translate(pos_cinch_back1) rotate([0, 90, 0]) reinforce(rdo=do_cinch, rdi=d_cinch, rh=width);
    translate(pos_cinch_back2) rotate([0, 90, 0]) reinforce(rdo=do_cinch, rdi=d_cinch, rh=width);
  }
  if (ena_power_pl) {
    translate(pos_power_pl) rotate([0, 90, 0]) reinforce(rdo=do_power_pl, rdi=d_power_pl, rh=width);
  }
  if (ena_power_sw) {
    translate(pos_power_sw) rotate([0, -90, 0]) reinforce(rdo=do_power_sw, rdi=d_power_sw, rh=width);
  }
  
//  if ( ena_power_pl ) {
//     // Back: Power plug
//     translate([case_l -2, 78, case_h - 19]) rotate([0, 90, 0]) reinforce(rdo=do_power_pl, rdi=d_power_pl, rh=width);
//  }
//  if ( ena_cinch_back) {
//    // Back: Cinch
//    translate([case_l, offset_y + 72,  case_h - 26]) rotate([0, 90, 0]) reinforce(rdo=do_cinch, rdi=d_cinch, rh=width);
//    translate([case_l, offset_y + 72, case_h - 12]) rotate([0, 90, 0]) reinforce(rdo=do_cinch, rdi=d_cinch, rh=width);
//  }
//  if ( ena_power_sw ) {
//    translate([-2, case_w - 20, case_h - 19]) rotate([0, 90, 0]) reinforce(rdo=do_switch, rdi=d_switch, rh=width);
//  }


  // rpi mounts
  translate(pos_rpi_mount[0]) rotate(rot_mount[0])
    mount(md=d_mount, mh=14, mh_s=h_screw, md_s=d_screw, mh_sup=10);
  translate(pos_rpi_mount[1]) rotate(rot_mount[1])
    mount(md=d_mount, mh=14, mh_s=h_screw, md_s=d_screw, mh_sup=10);
  translate(pos_rpi_mount[2]) rotate(rot_mount[2])
    mount(md=d_mount, mh=14, mh_s=h_screw, md_s=d_screw, mh_sup=10);
  translate(pos_rpi_mount[3]) rotate(rot_mount[3])
    mount(md=d_mount, mh=14, mh_s=h_screw, md_s=d_screw, mh_sup=10);
  
//  // assembly mounts
//  translate(pos_mount[0]) rotate(rot_mount[0])
//    mount(md=d_mount, mh=case_h + width/2, mh_s=h_screw, md_s=d_screw, mh_sup=case_h - width);
//  translate(pos_mount[1]) rotate(rot_mount[1])
//    mount(md=d_mount, mh=case_h + width/2, mh_s=h_screw, md_s=d_screw, mh_sup=case_h - width);
//  translate(pos_mount[2]) rotate(rot_mount[2])
//    mount(md=d_mount, mh=case_h + width/2, mh_s=h_screw, md_s=d_screw, mh_sup=case_h - width);
//  translate(pos_mount[3]) rotate(rot_mount[3])
//    mount(md=d_mount, mh=case_h + width/2, mh_s=h_screw, md_s=d_screw, mh_sup=case_h - width);
} // case_top

module case_bottom() {
  cb_h = 2;
  difference() {
    translate([case_l, 0, 0]) rotate([0, 180, 0]) case(ch=cb_h, bi=1, bo=0);
    union() {
      // cooling
      translate([0, 0, -6]) {
        cooling(ch=2*width);
        // feet holes
        translate([          5,          5, 0 ]) cylinder(d=8, h=2*width);
        translate([          5, case_w - 5, 0 ]) cylinder(d=8, h=2*width);
        translate([ case_l - 5,          5, 0 ]) cylinder(d=8, h=2*width);
        translate([ case_l - 5, case_w - 5, 0 ]) cylinder(d=8, h=2*width);
      }
    } // union
  } // difference
    // assembly mounts
  translate([0, 0, - cb_h - width + 0.5]) {
    translate([5, 5, 0]) rotate([0, 0, 180])
      mount(md=d_mount, mh=cb_h + width, mh_s=cb_h + width/2, md_s=d_screw, mh_sup=cb_h);
    translate([5, case_w - 5, 0]) rotate([0, 0, 90])
      mount(md=d_mount, mh=cb_h + width, mh_s=cb_h + width/2, md_s=d_screw, mh_sup=cb_h);
    translate([case_l - 5, 5, 0]) rotate([0, 0, 270])
      mount(md=d_mount, mh=cb_h + width, mh_s=cb_h + width/2, md_s=d_screw, mh_sup=cb_h);
    translate([case_l - 5, case_w - 5, 0]) rotate([0, 0, 0])
      mount(md=d_mount, mh=cb_h + width, mh_s=cb_h + width/2, md_s=d_screw, mh_sup=cb_h);
  }
}



/*
 * plot things!
 */
translate([rpi_l/2 + offset_x  + 4, rpi_w/2 + offset_y + 4, case_h - 30]) 
render() {
  pi3();
//  hifiberryDacPlus();
}

translate([0, 0, 0]) { case_top(); }
//translate([0, 0, -35]) { case_bottom(); }


//translate([      5,       5, -45]) foot();
//translate([      0, case_w - 5, -45]) foot();
//translate([case_l - 5,       0, -45]) foot();
//translate([case_l - 5, case_w - 5, -45]) foot();
