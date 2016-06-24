

// Transition elements to a new phrase
//
jQuery.fn.levenshteinTransition = function(options) {

// Helper functions

function minimum(items) {
  var x = items[0]
  for(var i = 0; i < items.length; i++) {
    y = items[i];
    if(y < x) { x = y; }
  }
  return x;
}

// Primitive string functions

function nop_(word, c, i) {
  return word;
}

function ins_(word, c, i) {
  var start = word.slice(0, i);
  var end   = word.slice(i, word.length)
  return "" + start + c + end;
}

function sub_(word, c, i) {
  var start = word.slice(0, i);
  var end   = word.slice(i+1, word.length)
  return "" + start + c + end;
}

function del_(word, i) {
  var start = word.slice(0, i);
  var end   = word.slice(i+1, word.length)
  return "" + start + end;
}

// Algorithm word functions
//
function begin(word) {
  return {
    op:     "start",
    x:      0,
    score:  0,
    word:   word
  };
}

function nop(pre) {
  return {
    op:     "nop",
    x:      pre.x + 1,
    pre:    pre,
    score:  pre.score,
    word:   pre.word
  };
}

function insertion(c, pre) {
  return {
    op:     "ins",
    x:      pre.x + 1,
    pre:    pre,
    score:  pre.score + 1,
    word:   ins_(pre.word, c, pre.x)
  };
}

function substitution(c, pre) {
  return {
    op:     "sub",
    x:      pre.x + 1,
    pre:    pre,
    score:  pre.score + 1,
    word:   sub_(pre.word, c, pre.x)
  };
}

function deletion(pre) {
  return {
    op:     "del",
    x:      pre.x,
    pre:    pre,
    score:  pre.score + 1,
    word:   del_(pre.word, pre.x)
  };
}

function getEditDistance(a, b){

  // initialize the first cell
  var words  = [ [ begin(a) ] ];

  // The first column comes from word 'a'
  // The column stays the same and the row changes
  for(var row = 1; row <= a.length; row++){
    words[row] = [ deletion(words[row-1][0]) ];
  }

  // The first row comes from word 'b'
  // The row stays the same and the column changes
  for(var col = 1; col <= b.length; col++){
    var i = col - 1;
    words[0][col] = insertion( b[i], words[0][col-1] );
  }

  // Fill in the rest of the matrix
  for(var row = 1; row <= a.length; row++){
    var j = row - 1;

    for(var col = 1; col <= b.length; col++){
      var i = col - 1;

      if(b.charAt(i) == a.charAt(j)){
        words[row][col] = nop(words[row-1][col-1])

      } else {

        var x = words[row-1][col-1].score; // substitution
        var y = words[row  ][col-1].score; // insertion
        var z = words[row-1][col  ].score; // deletion
        var m = minimum([ x, y, z ]);

        // Favour Deletion
        switch(m) {
          case z:
            words[row][col] = deletion(words[row-1][col]);
            break;
          case y:
            words[row][col] = insertion(b.charAt(i), words[row][col-1]);
            break;
          case x:
            words[row][col] = substitution(b.charAt(i), words[row-1][col-1]);
            break;
          default:
            throw("Should not happen!")
        }
      }
    }
  }

  var last_w_row  = words[words.length - 1];
  var last_w_cell = last_w_row[last_w_row.length - 1];
  return last_w_cell;
};

function walk(cell) {
	var res = [];
	var pre_word = "";
	while( cell ) {
		if(pre_word != cell.word) { res.push(cell.word); }
		pre_word = cell.word;
		cell = cell.pre;
	}
	return res.reverse();
}


// Display Functions

var settings = jQuery.extend({ minimumWait: 80
                             , maximumWaitOffset: 100
                            }, options );

if(! settings.targetPhrase ) {
  throw("Must pass in targetPhrase option.");
}

var minimumWait       = settings.minimumWait;
var maximumWaitOffset = settings.maximumWaitOffset;

function wait_time() {
  return minimumWait + Math.ceil(Math.random() * maximumWaitOffset)
}

function loop(scene,i,ed,cb) {
  scene.innerText = " " + ed[i];

  if(i < (ed.length - 1)) {
    var callback = function(){
      loop(scene,i+1, ed, cb);
    }
    setTimeout(callback, wait_time());
  } else if(cb) {
    cb()
  }
}

function transition(word1, word2) {
  var ed = getEditDistance(word1,word2);
  var result = walk(ed);
  return result;
}

this.each(function(){
  var transitions = transition(this.innerText, settings.targetPhrase);
  loop(this, 0, transitions, settings.callback);
})

return this;

};


jQuery.fn.levenshteinTransitions = function(options) {

var settings = jQuery.extend({ delay: 0
                             , initialDelay: 0
                             , includeInitialText: true
                            }, options );

if(! settings.targetPhrases ) {
  throw("Must pass in targetPhrases option.");
}

this.each(function(){

  var item          = this;
  var targetPhrases = settings.targetPhrases;
  var i             = 1;

  if(settings.includeInitialText) {
    targetPhrases = [this.innerText].concat(targetPhrases);
  }

  function callback() {
    setTimeout(loop, settings.delay);
  }

  function loop() {

    var additionalSettings = jQuery.extend({ targetPhrase: targetPhrases[i % targetPhrases.length ], callback: callback }, settings);
    i++;
    $(item).levenshteinTransition(additionalSettings);

  }

  setTimeout(function() { loop(); }, settings.initialDelay);

})

return this;

};
