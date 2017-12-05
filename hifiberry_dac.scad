/* d_cinch
 * raspberry & hifiberry dac case with several options
 * https://github.com/xkonni/hifiberry_dac_case
*/

// to plot a rpi + hifiberry reference
use <../hifiberry.scad>;

// level of detail
$fn=120;

/*
 * custom parameters, edit if necessary
 */
// rounding of corner, case width
corner = 3;
width  = 2;
space  = 1;
// diameter inside/outside of plugs, switch
d_cinch   = 8;
do_cinch  = 12;
d_power   = 11;
do_power  = 13;
d_switch  = 13;
do_switch = 15;
// mount
d_mount = 8;
// screws
d_screw = 2.5;
d_screwhead = 5;
h_screw = 10;
// use built-in dac cinch ports
dac_cinch = 0;
y_off = (dac_cinch) ? 0 : 10;

/*
 * static parameters
 */
// rpi_size
rpi_l = 85;
rpi_w = 56;
// case size
case_l = rpi_l + 2*width + 2*space;
case_w = rpi_w + 2*width + 2*space + ((dac_cinch) ? 35 : 55);
case_h = 35;

/* 
 * attaches to the 4 holes in the bottom plate, screw hidden
 */
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

/*
 * mount with supports
 */
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


module reinforce(rdo=10, rdi=8, rh=width) {
  difference() {
    cylinder(d=rdo, h=rh);
    cylinder(d=rdi, h=rh);
  }
}
/*
 * case with mounting border
 */
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

module cooling(cl=case_l, cw=case_w, cspace=5, cs=3, ch=width) {
/*
 * cooling holes in a waveform pattern
 */
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

module case_top() {
  difference() {
    case(ch=case_h);
    /* 
     * Cutouts
     */
    union() {
      // Top: Cooling
      translate([0, 0, case_h]) cooling(ch=2*width);
      // Back: Ethernet, USB1, USB2
      translate([0, y_off, 0]) {
        translate([case_l, 13   - 17/2, 6.5]) cube([2*width, 17.5, 14.5]);
        translate([case_l, 30.5 - 14/2, 6.5]) cube([2*width, 16, 16]);
        translate([case_l, 48.5 - 14/2, 6.5]) cube([2*width, 16, 16]);
      }
      if ( dac_cinch ) {
         // Side: Cinch
        translate([case_l - 50, -4, 27.25]) rotate([-90, 0, 0]) cylinder(d=do_cinch, h=2*width);
        translate([case_l - 33, -4, 27.25]) rotate([-90, 0, 0]) cylinder(d=do_cinch, h=2*width);
        // Back: Power plug
        translate([case_l + 2, 90, 16]) rotate([0, 90, 0]) cylinder(d=do_power, h=width);
      } 
      else {
        // Back: Cinch
        translate([case_l, y_off + 72, 9]) rotate([0, 90, 0]) cylinder(d=do_cinch, h=2*width);
        translate([case_l, y_off + 72, 23]) rotate([0, 90, 0]) cylinder(d=do_cinch, h=2*width);
        // Back: Power plug
        translate([case_l, y_off + 92, 16]) rotate([0, 90, 0]) cylinder(d=do_power, h=2*width);
      }
      // Front: Switch
      translate([-4, case_w - 20, 16]) rotate([0, 90, 0]) cylinder(d=do_switch, h=width*2);
    }
  }
  // Port reinforcements
  if ( dac_cinch ) {
     translate([case_l + 2, 90, 16]) rotate([0, 90, 0]) reinforce(rdo=do_power, rdi=d_power, rh=2*width);
  } 
  else {
    // Back: Cinch
    translate([case_l, y_off + 72,  9]) rotate([0, 90, 0]) reinforce(rdo=do_cinch, rdi=d_cinch, rh=width);
    translate([case_l, y_off + 72, 23]) rotate([0, 90, 0]) reinforce(rdo=do_cinch, rdi=d_cinch, rh=width);
    // Back: Power plug
    translate([case_l, y_off + 92, 16]) rotate([0, 90, 0]) reinforce(rdo=do_power, rdi=d_power, rh=width);
  }
  // Front: Switch
  translate([-2, case_w - 20, 16]) rotate([0, 90, 0]) reinforce(rdo=do_switch, rdi=d_switch, rh=width);


  // rpi mounts
  translate([case_l - 80.5, 15.5, case_h - width/2]) {
    translate([0, 0, 0]) rotate([0, 180, 90])
      mount(md=d_mount, mh=14, mh_s=h_screw, md_s=d_screw, mh_sup=10);
    translate([0, 49, 0]) rotate([0, 180, 0])
      mount(md=d_mount, mh=14, mh_s=h_screw, md_s=d_screw, mh_sup=10);
    translate([58, 0, 0]) rotate([0, 180, 180])
      mount(md=d_mount, mh=14, mh_s=h_screw, md_s=d_screw, mh_sup=10);
    translate([58, 49, 0]) rotate([0, 180, 270])
      mount(md=d_mount, mh=14, mh_s=h_screw, md_s=d_screw, mh_sup=10);
  }

  // assembly mounts
  translate([0, 0, case_h - width/2]) {
    translate([5, 5, 0]) rotate([0, 180, 90])
      mount(md=d_mount, mh=case_h + width/2, mh_s=h_screw, md_s=d_screw, mh_sup=case_h - width);
    translate([5, case_w - 5, 0]) rotate([0, 180, 0])
      mount(md=d_mount, mh=case_h + width/2, mh_s=h_screw, md_s=d_screw, mh_sup=case_h - width);
    translate([case_l - 5, 5, 0]) rotate([0, 180, 180])
      mount(md=d_mount, mh=case_h + width/2, mh_s=h_screw, md_s=d_screw, mh_sup=case_h - width);
    translate([case_l - 5, case_w - 5, 0]) rotate([0, 180, 270])
      mount(md=d_mount, mh=case_h + width/2, mh_s=h_screw, md_s=d_screw, mh_sup=case_h - width);
  }
} // case_top

module case_bottom() {
  cb_h = 2;
  difference() {
//    translate([case_l, 0, 0]) rotate([0, 180, 0]) case(ch=cb_h, bi=2, bo=1);
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
//translate([(case_l - rpi_l/2) + width, y_off + 30, 5]) render() {
//  pi3();
//  hifiberryDacPlus();
//}

translate([0, 0, 0]) { case_top(); }
//translate([0, 0, -35]) { case_bottom(); }

//translate([      5,       5, -45]) foot();
//translate([      0, case_w - 5, -45]) foot();
//translate([case_l - 5,       0, -45]) foot();
//translate([case_l - 5, case_w - 5, -45]) foot();
