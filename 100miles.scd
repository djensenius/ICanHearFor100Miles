(
SynthDef("PlayFSFile", { arg out = 0, numchans=8, pos=0, bufnum;
	b = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum));
	p = PanAz.ar(8, b, pos, 1, 2, 0.5);
    Out.ar(out, p);
}).store;
)

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
)

b.postln
o = Synth.new("PlayFSFile", [\bufnum, b[18].bufnum, \pos, 0.2])
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
