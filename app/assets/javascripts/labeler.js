(function() {

// returns a random node in the selection
d3.selection.prototype.randomNode = function() {
  return d3_selection_randomNode(this);
};

function d3_selection_randomNode(groups) {
  var group = groups[Math.floor(Math.random() * groups.length)];
  return group[Math.floor(Math.random() * group.length)];
}

d3.labeler = function() {
  var lab = [],
      anc = [],
      w, // box width
      h, // box width
      labeler = {};

  var max_move = 5.0,
      max_angle = 0.5,
      acc = 0;
      rej = 0;

  // weights
  var w_len = 0.2, // leader line length 
      w_inter = 1.0, // leader line intersection
      w_lab2 = 30.0, // label-label overlap
      w_lab_anc = 30.0; // label-anchor overlap
      w_orient = 3.0; // orientation bias

  // booleans for user defined functions
  var user_energy = false,
      user_schedule = false;

  var user_defined_energy, 
      user_defined_schedule;

  // energy function, tailored for label placement
  energy = function(label) {
    var ener = 0,
        dx = label.alpx - label.anchor.alpx,
        dy = label.anchor.alpy - label.alpy,
        dist = Math.sqrt(dx * dx + dy * dy),
        overlap = true,
        amount = 0
        theta = 0;

    // penalty for length of leader line
    if (dist > 0) ener += dist * w_len;

    // label orientation bias
    dx /= dist;
    dy /= dist;
    if (dx > 0 && dy > 0) { ener += 0 * w_orient; }
    else if (dx < 0 && dy > 0) { ener += 1 * w_orient; }
    else if (dx < 0 && dy < 0) { ener += 2 * w_orient; }
    else { ener += 3 * w_orient; }

    var x21 = label.alpx,
        y21 = label.alpy - label.height + 2.0,
        x22 = label.alpx + label.width,
        y22 = label.alpy + 2.0;
    var x11, x12, y11, y12, x_overlap, y_overlap, overlap_area;

    lab.each(function() {
      var otherLabel = this;
      if (label != otherLabel) {
        // penalty for intersection of leader lines
        overlap = intersect(label.anchor.alpx, label.alpx, otherLabel.anchor.alpx, otherLabel.alpx,
                        label.anchor.alpy, label.alpy, otherLabel.anchor.alpy, otherLabel.alpy);
        if (overlap) ener += w_inter;

        // penalty for label-label overlap
        x11 = otherLabel.alpx;
        y11 = otherLabel.alpy - otherLabel.height + 2.0;
        x12 = otherLabel.alpx + otherLabel.width;
        y12 = otherLabel.alpy + 2.0;
        x_overlap = Math.max(0, Math.min(x12,x22) - Math.max(x11,x21));
        y_overlap = Math.max(0, Math.min(y12,y22) - Math.max(y11,y21));
        overlap_area = x_overlap * y_overlap;
        ener += (overlap_area * w_lab2);
      }

      // penalty for label-anchor overlap
      x11 = otherLabel.anchor.alpx - otherLabel.anchor.r;
      y11 = otherLabel.anchor.alpy - otherLabel.anchor.r;
      x12 = otherLabel.anchor.alpx + otherLabel.anchor.r;
      y12 = otherLabel.anchor.alpy + otherLabel.anchor.r;
      x_overlap = Math.max(0, Math.min(x12,x22) - Math.max(x11,x21));
      y_overlap = Math.max(0, Math.min(y12,y22) - Math.max(y11,y21));
      overlap_area = x_overlap * y_overlap;
      ener += (overlap_area * w_lab_anc);
    })

    return ener;
  };

  pointPosition = function(currT) {
    // select a random label
    var label = lab.randomNode();

    // save old coordinates
    var x_old = label.alpx;
    var y_old = label.alpy;

    // old energy
    var old_energy;
    if (user_energy) {
      old_energy = user_defined_energy(label, lab)
    } else {
      old_energy = energy(label)
    }

    if (Math.random() < 0.5) { 
      pointTranslate(label)
    } else { 
      pointRotate(label)
    }

    // hard wall boundaries
    if (label.alpx > w) label.alpx = x_old;
    if (label.alpx < 0) label.alpx = x_old;
    if (label.alpy > h) label.alpy = y_old;
    if (label.alpy < 0) label.alpy = y_old;

    // new energy
    var new_energy;
    if (user_energy) {
      new_energy = user_defined_energy(label, lab)
    } else {
      new_energy = energy(label)
    }

    // delta E
    var delta_energy = new_energy - old_energy;

    if (delta_energy < 0 || Math.random() < Math.exp(-delta_energy / currT)) {
      acc += 1;
    } else {
      // move back to old coordinates
      label.alpx = x_old;
      label.alpy = y_old;
      rej += 1;
    }
      
  }

  pointRotate = function(label) {
    // random angle
    var angle = (Math.random() - 0.5) * max_angle;

    var s = Math.sin(angle);
    var c = Math.cos(angle);

    // translate label (relative to anchor at origin):
    label.alpx -= label.anchor.alpx
    label.alpy -= label.anchor.alpy

    // rotate label
    var x_new = label.alpx * c - label.alpy * s,
        y_new = label.alpx * s + label.alpy * c;

    // translate label back
    label.alpx = x_new + label.anchor.alpx
    label.alpy = y_new + label.anchor.alpy    
  }

  pointTranslate = function(label) {
    // random translation
    label.alpx += (Math.random() - 0.5) * max_move;
    label.alpy += (Math.random() - 0.5) * max_move;    
  }

  // returns true if two lines intersect, else false
  // from http://paulbourke.net/geometry/lineline2d/
  intersect = function(x1, x2, x3, x4, y1, y2, y3, y4) {
    var mua, mub;
    var denom, numera, numerb;

    denom = (y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1);
    numera = (x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3);
    numerb = (x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3);

    /* Is the intersection along the the segments */
    mua = numera / denom;
    mub = numerb / denom;
    if (!(mua < 0 || mua > 1 || mub < 0 || mub > 1)) {
        return true;
    }
    return false;
  }

  // linear cooling
  cooling_schedule = function(currT, initialT, nsweeps) {
    return (currT - (initialT / nsweeps));
  }

  // main simulated annealing function
  labeler.start = function(user_nsweeps) {
    var currT = 1.0,
        initialT = 1.0,
        nsweeps = 1000;
    if (user_nsweeps != undefined) {
      nsweeps = user_nsweeps;
    }

    // set bounding box
    // assume first label is a child of the SVG boundry
    var svg = d3.select(lab.node().ownerSVGElement)
    if (w === undefined) {w = +svg.attr('width')}
    if (h === undefined) {h = +svg.attr('height')}

    // initialize label attributes
    lab.each(function(){
      var label = this;
      var labelSelection = d3.select(label);
      if (label.alpx === undefined) {label.alpx = +labelSelection.attr("x")}
      if (label.alpy === undefined) {label.alpy = +labelSelection.attr("y")}
      if (label.width === undefined) {label.width = label.getBBox().width}
      if (label.height === undefined) {label.height = label.getBBox().height}
      if (label.anchor === undefined) {label.anchor = {}}
      if (label.anchor.alpx === undefined) {label.anchor.alpx = label.alpx}
      if (label.anchor.alpy === undefined) {label.anchor.alpy = label.alpy}
      if (label.anchor.label === undefined) {label.anchor.label = label}

      // XXX Fix this to be the real radius of the anchor if anchor is a point/circle
      if (label.anchor.r === undefined) {label.anchor.r = 0}
    })


    for (var i = 0; i < nsweeps; i++) {
      lab.each(function() {
        pointPosition(currT)
      })
      currT = cooling_schedule(currT, initialT, nsweeps);
    }
    return labeler;
  };

  // users insert graph width
  labeler.width = function(x) {
    if (!arguments.length) return w;
    w = x;
    return labeler;
  };

  // users insert graph height
  labeler.height = function(x) {
    if (!arguments.length) return h;
    h = x;    
    return labeler;
  };

  // users insert label positions
  labeler.label = function(x) {
    if (!arguments.length) return lab;
    lab = x;
    return labeler;
  };

  // user defined energy
  labeler.alt_energy = function(x) {
    if (!arguments.length) return energy;
    user_defined_energy = x;
    user_energy = true;
    return labeler;
  };

  // user defined cooling_schedule
  labeler.alt_schedule = function(x) {
    if (!arguments.length) return  cooling_schedule;
    user_defined_schedule = x;
    user_schedule = true;
    return labeler;
  };

  return labeler;
};

})();

