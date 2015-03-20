setlistener("/sim/signals/fdm-initialized", func {
	init_b1b();
});

var init_b1b = func {

setprop("instrumentation/teravd/target-vfpm-exec", 0);
setprop("instrumentation/teravd/target-alt-exec", 0);
setprop("autopilot/settings/target-altitude-ft", 0);
setprop("autopilot/settings/vertical-speed-fpm", 0);
setprop("instrumentation/teravd/alt-reached", 1);
setprop("instrumentation/teravd/ridge-clear", 0);

setprop("controls/switches/fltdir", 0.25);
setprop("controls/switches/radar-range", 0.25);

setprop("instrumentation/tacan/frequencies/selected-channel[12]", 2);


#radardist.init();
settimer(eta_waypoint, 1);

settimer(tacan_follow, 4);

}



### tacan follow autopilot
var tacan_follow = func {
var ap_state = getprop("autopilot/locks/heading");
if (ap_state == "tacan-hold") {
var tacan_hdg = getprop("instrumentation/tacan/indicated-bearing-true-deg");
setprop("autopilot/settings/heading-bug-deg", tacan_hdg);
}
settimer(tacan_follow, 1);
}

### format waypoint data loop
#var eta_waypoint = func {
#var eta = getprop("autopilot/route-manager/wp/eta");
#if ((eta == nil) or (eta == '')) {
#  settimer(eta_waypoint, 0.1);
#  } else {
 #   var spliteta = split(":", eta);
  #  var eta0 = spliteta[0];
   # if ((eta0 == nil) or (eta0 == '')){
    #  var eta0 = 0;
     # }
  #  var eta1 = spliteta[1];
  #  if ((eta1 == nil) or (eta1 == '')){
  #    var eta1 = 0;
  #    }
 # setprop("autopilot/route-manager/wp/eta_h", eta0);
 # setprop("autopilot/route-manager/wp/eta_m", eta1);
 # settimer(eta_waypoint, 0.1);
 # }
#}



###
# flight director modes selector
###
var fltdir = func {

var fltd = getprop("controls/switches/fltdir");

if (fltd == 0.00) {
  setprop("instrumentation/adf/serviceable", "0");
  setprop("instrumentation/nav/serviceable", "0");
  setprop("instrumentation/tacan/serviceable", "0");
} elsif (fltd == 0.25) {
  setprop("instrumentation/adf/serviceable", "1");
  setprop("instrumentation/nav/serviceable", "1");
  setprop("instrumentation/tacan/serviceable", "1");
} elsif (fltd == 0.50) {
  setprop("instrumentation/adf/serviceable", "1");
  setprop("instrumentation/nav/serviceable", "1");
  setprop("instrumentation/tacan/serviceable", "0");
} elsif (fltd == 0.75) {
  setprop("instrumentation/adf/serviceable", "1");
  setprop("instrumentation/nav/serviceable", "0");
  setprop("instrumentation/tacan/serviceable", "0");
} elsif (fltd == 1.00) {
  setprop("instrumentation/adf/serviceable", "0");
#  setprop("instrumentation/nav/serviceable", "0");
  setprop("instrumentation/tacan/serviceable", "1");
}

}

var radar_range = func {

var radran = getprop("controls/switches/radar-range");

if (radran == 0.00) {
  setprop("instrumentation/radar/range[0]", "20");
} elsif (radran == 0.25) {
  setprop("instrumentation/radar/range[0]", "40");
} elsif (radran == 0.50) {
  setprop("instrumentation/radar/range[0]", "80");
} elsif (radran == 0.75) {
  setprop("instrumentation/radar/range[0]", "160");
} elsif (radran == 1.00) {
  setprop("instrumentation/radar/range[0]", "320");
}
}

##
# tacan block
##
var tacan = func(add) {
var ch2 = getprop("instrumentation/tacan/frequencies/selected-channel");
var ch21 = int(ch2 / 10);
var ch21_new = ch21;

if ((add == 1) and (ch21 <= 11.5)) {
var ch21_new = ch21 + 1;
} elsif ((add == -1) and (ch21 >= 0.5)) {
var ch21_new = ch21 - 1;
}

var ch1_new = int(ch21_new / 10);
setprop("instrumentation/tacan/frequencies/selected-channel[1]", ch1_new);

if (ch1_new >= 0.95) {
var ch2_new = ch21_new - 10;
setprop("instrumentation/tacan/frequencies/selected-channel[2]", ch2_new);
} elsif (ch1_new <= 0.95) {
var ch2_new = ch21_new;
setprop("instrumentation/tacan/frequencies/selected-channel[2]", ch2_new);
}
}

var tacanxy = func() {
var xy = getprop("instrumentation/tacan/frequencies/selected-channel[4]");
if (xy == "X") {
setprop("instrumentation/tacan/frequencies/selected-channel[4]", "Y");
} elsif (xy == "Y") {
setprop("instrumentation/tacan/frequencies/selected-channel[4]", "X");
}
}

##
# nuc switch
##
var nuc = func {
if (getprop("controls/switches/nuc") == 1) {
ltext = "Sorry, Duke Nukem not available yet on this plane(t)!";
  screen.log.write(ltext);
}
}
