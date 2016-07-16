(
SynthDef("PlayFSFile", { arg out = 0, numchans=8, pos=0, bufnum;
	b = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum));
    Out.ar(out, b);
}).store;
)

s.options.numOutputBusChannels = 8;
s.options.numBuffers = 1200;

(
var totalTime = 0;
var times = Array.fill(8, 0);

m = JSONFileReader.read("/Users/david/Code/ICanHearFor100Miles/recent.json");
//m.removeAt(0)
//m[0].postln

b = Dictionary.new();
m.do { |sound, i|
	//i.postln;
	//sound.postln;
	if (i < 1000) {
			k = sound.keys;
	k.do({|key|
		/*
		if (key == "username", {
			 "key is %, value is %".format(key, sound.at(key)).postln;
		});

		if (key == "tags", {
			"key is %, value is %".format(key, sound.at(key)).postln;
		});
		*/
		if (key == "trackMP4", {
			var soundFileName = sound.at(key).split().at(3);
			b[i] = Buffer.read(s, "/Users/david/Code/ICanHearFor100Miles/wavs/%.wav".format(soundFileName));
		});
	})
	}
};


r = Routine.new({ arg ival;
	"Initialized".postln;
	5.wait;
	"Starting".postln;
	x = 0;
	b.postln;
	o = Dictionary.new();
	b.do({ | sound, i|
		"Looping".postln;
		if (x == 8, {
			x = 0;
			"Waiting".postln;
			20.wait;
			"Done waiting".postln;
		});
		o[i] = Synth.new("PlayFSFile", [\bufnum, b[i].bufnum, \pos, 0.2, \out, x]);
		x = x  + 1;
	});
});

SystemClock.play(r);
)

b.clear
b.postln
o = Synth.new("PlayFSFile", [\bufnum, b[17].bufnum, \pos, 0.2, \out, 1])

b[17].buf
-------




(
SynthDef("PlayFSFile", { arg out = 0, numchans=8, pos=0, bufnum;
	b = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum));
	p = PanAz.ar(8, b, pos, 1, 2, 0.5);
    Out.ar(out, p);
}).store;
)

// read a soundfile
		b = Buffer.read(s, "/Users/david/Code/ICanHearFor100Miles/wavs/784379ecd3e224f1b483989cb283c14f.mp4.wav");

		// now play it
		(
		x = SynthDef("tutorial-PlayBuf",{ arg out = 0, bufnum;
			Out.ar( out,
				PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum))
			)
		}).play(s,[\bufnum, b.bufnum ]);
		)
		x.free; b.free;




b = Buffer.read(s, "/Users/david/Code/ICanHearFor100Miles/wavs/784379ecd3e224f1b483989cb283c14f.mp4.wav");
b.bufnum
o = Synth.new("PlayFSFile", [\bufnum, b.bufnum, \pos, 0.2])

(
f = { |msg, time, addr|
	var sound1, one, filePath;
	msg.postln;

	case
	{msg[0] == '/PlaySound'} {
		filePath = msg[1].abs;
		msg.postln;
		b = Buffer.read(s, filePath, action: {(
			"Done reading".postln;
			one = Synth.new("PlayFSFile", [\bufnum, b.bufnum, \pos, 0.2]);
		)}
		);

	}
};
)
thisProcess.addOSCRecvFunc(f);
s.sendMsg("/PlaySound", "blah");

n.values
d.values

d = Dictionary[\a -> "hello", \b -> "robot", \c -> [1, 2, 3]];
d.keys
d['b'].postln
d = (a: "hello", b: "robot", c: [1, 2, 3]); // equivalent
d.do { |item, i| [item, i].postln };
d.collect { |item| item + 100 };
d.reject { |item| item.size > 4 };
d.select { |item| item.size > 4 };

(
SynthDef("help-out", { arg out=0, freq=440;
    var source;
        source = SinOsc.ar(freq, 0, 0.1);

        // write to the bus, adding to previous contents
        Out.ar(out, source);

}).send(s);
)


Synth("help-out", [\freq, 500]);
Synth("help-out", [\freq, 600, \out, 1]);
Synth("help-out", [\freq, 700]);

[ Klank.ar(`[[400,500,600],[1,2,1]], z),  Klank.ar(`[[700,800,900],[1,2,1]], z)]

(
{
    var n;
    n = 8; // number of 'voices'
    Mix.new( // mix all stereo pairs down.
        Pan2.ar( // pan the voice to a stereo position
            CombL.ar( // a comb filter used as a string resonator
                Dust.ar( // random impulses as an excitation function
                    // an array to cause expansion of Dust to n channels
                    // 1 means one impulse per second on average
                    Array.fill(n, 1),
                    0.3 // amplitude
                ),
                0.01, // max delay time in seconds
                // array of different random lengths for each 'string'
                Array.fill(n, {0.004.rand+0.0003}),
                4 // decay time in seconds
            ),
            Array.fill(n,{1.0.rand2}) // give each voice a different pan position
        )
    )
}.play;
)
