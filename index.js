var _ = require('lodash');
var sc = require('supercolliderjs');
var fs = require('fs');
var probe = require('node-ffprobe');

var sortedSounds = {};
//Order of tags should be... music, door, object, traffic, fireworks, food, animal, airport, electronics, talking, construction, vehicle, inside, outside
let order = ['music', 'door', 'object', 'traffic', 'fireworks', 'food', 'animal', 'airport', 'electronics', 'talking', 'construction', 'vehicle', 'inside', 'outside'];
let playOrder = order;

function processSounds(sounds) {
  var tags = [];
  _.forEach(sounds, value => {
    if (value.tags) {
      tags = _.concat(tags, value.tags);
    }
  });
  tags = _.uniq(tags);
  console.log("Unique tags", tags);
  _.forEach(order, tag => {
    var tagSounds = [];
    var sound_q = [];
    var count = [];
    var totalCount = 0;
     _.forEach(sounds, (sound, index) => {
       if (sound.tags && sound.tags.indexOf(tag) > -1) {
         totalCount++;
         if (count[tag]) {
           count[tag]++;
         } else {
           count[tag] = 1;
         }
         let track = `.${sound.trackMP4}`;
        probe(track, function(err, probeData) {
           sound.duration = probeData.format.duration;
           //CMC location: 43.6660848, -79.3886872
           sound.heading = getDegrees(43.6660848, -79.3886872, sound.latitude, sound.longitude, 0);
           //console.log(sound);
           tagSounds = _.concat(tagSounds, sound);
           sounds = _.reject(sounds, sound);
           count[tag]--;
           totalCount--;
           if (count[tag] == 0) {
             console.log("TOTALLY DONE ", tag);
             sortedSounds[tag] = tagSounds;
           }
         });
       }
     });
  });


  setTimeout(function () {
    console.log(sortedSounds);
    console.log("Completely done");
    //Arrange sounds randomly using playOrder
    //startMusic();
    console.log(sounds);
    fs.writeFile("sorted-sounds.json", JSON.stringify(sortedSounds), function(err) {
    if(err) {
        return console.log(err);
    }

    console.log("The file was saved!");
});
  }, 2000);

}

function getDegrees(lat1, long1, lat2, long2, headX) {

    var dLat = toRad(lat2-lat1);
    var dLon = toRad(long2-long1);

    lat1 = toRad(lat1);
    lat2 = toRad(lat2);

    var y = Math.sin(dLon) * Math.cos(lat2);
    var x = Math.cos(lat1)*Math.sin(lat2) -
            Math.sin(lat1)*Math.cos(lat2)*Math.cos(dLon);
    var brng = toDeg(Math.atan2(y, x));

    // fix negative degrees
    if(brng<0) {
        brng=360-Math.abs(brng);
    }

    return brng - headX;
}

function toRad(degrees) {
  return degrees * (Math.PI/180);
}

function toDeg(rads) {
  return rads * (180/Math.PI);
}

function startMusic() {
  sc.lang.boot()
    .then(function(sclang) {

      sclang.interpret('(1..8).pyramid')
        .then(function(result) {
          // result is a native javascript array
          console.log('= ' + result);
        }, function(error) {
          // syntax or runtime errors
          // are returned as javascript objects
          console.log(error);
        });

    });

  sc.server.boot()
    .then(function(server) {
      // raw send message
      server.send.msg(['/g_new', 1, 0, 0]);

      //server.bufferAllocRead(1009, "/Users/david/Code/ICanHearFor100Miles/wavs/784379ecd3e224f1b483989cb283c14f.mp4.wav", 0, -1)
       server.send.msg(['/status']);
      // using sc.msg to format them
      server.send.msg(sc.msg.groupNew(1));

      // call async messages with callAndResponse
      // and receive replies with a Promise
      server.callAndResponse(sc.msg.status())
        .then(function(reply) {
          console.log(reply);
        });
    });
}


fs.readFile('recent.json', 'utf8', function (err,data) {
  if (err) {
    return console.log(err);
  }
  processSounds(JSON.parse(data));
});
