/*
lp3 + boom
dark + rr + mission
*/


t = {PinkNoise.ar(0.3)}.play;
t.release

(
Document.current.createBackup;
~path = "/Users/Robert/---data---/Audio/SC-2017/Blunt/samples/";

~str.free; ~lp1.free; ~lp2.free; ~lp3.free; ~hst.free; ~bt.free; ~an.free; ~sn.free; ~th.free; ~rr1.free; ~rr2.free; ~l.free; ~i.free;
~str = Buffer.read(s, ~path ++ "strings.wav"); // tuning 1 = midi note 65
~lp1 = Buffer.read(s, ~path ++ "loop1.wav"); // tuning 1.05
~lp2 = Buffer.read(s, ~path ++ "loop2.wav");
~lp3 = Buffer.read(s, ~path ++ "loop3.wav");
~hst = Buffer.read(s, ~path ++ "hoest.wav");
~bt = Buffer.read(s, ~path ++ "beats1.wav");
~an = Buffer.read(s, ~path ++ "v anna whisper1.aif");
~sn = Buffer.read(s, ~path ++ "nin-ten-snare2.wav");
~th = Buffer.read(s, ~path ++ "Mission0.wav");
~rr1 = Buffer.read(s, ~path ++ "Roger Robinson - Paradise.wav");
~rr2 = Buffer.read(s, ~path ++ "Roger Robinson - Walk with Me.wav");
~l = Buffer.read(s, ~path ++ "Lolina - Indifference.wav");
~i = Buffer.read(s, ~path ++ "Iggy Pop - Waiting.wav");
)

(
Ndef(\dark).play(0).fadeTime_(5);
Ndef(\strings).play(0).fadeTime_(3);
Ndef(\lp1).play(0).fadeTime_(2);
Ndef(\lp2).play(0).fadeTime_(0.5);
Ndef(\lp3).play(0).fadeTime_(0.5);
Ndef(\sample1).play(0).fadeTime_(0.1);
Ndef(\sample2).play(2).fadeTime_(0.1);
Ndef(\dron1).play(0).fadeTime_(0.1);
Ndef(\dron2).play(0).fadeTime_(0.1);
Ndef(\sine).play(0).fadeTime_(1);
Ndef(\burst).play(0).fadeTime_(0.1);
Ndef(\massCom).play(0).fadeTime_(0.1);
Ndef(\ruis).play(0).fadeTime_(1);
)


(
Ndef(\dark, {
	var freq = 65.midicps * 0.5;
	var sig, local, env, feedback = 0.95;
	var cutoffVal = 20000, efxVal = 3, phaseMulVal = 1;

	local = feedback * LocalIn.ar(2);
	sig = SinOsc.ar(
		freq * [0.5, 1, 1.5],
		local * LFNoise1.ar(0.1,phaseMulVal),
		LFNoise1.ar(3,6) * 1
	).tanh;

	(efxVal-1).do {
		sig = AllpassL.ar(sig, 0.3, { Rand(0,0.2) + 0.1 } ! 2, 5);
	};
	sig = sig.tanh;
	sig = NumChannels.ar(sig);
	LocalOut.ar(sig);
	sig = RLPF.ar(sig, cutoffVal, 0.5);
	sig = sig * efxVal.linlin(1,11,0.4,1);
	// sig = Decimator.ar(sig, 10000, 7);
	// sig = sig + (sig.wrap * 0.1);
	0.3 * sig
});
);
Ndef(\dark).release

(
Ndef(\strings, {
	var sig, env, playhead, start, end;
	start = [0, 0.02] * 44100 ;
	end = 5 * 44100 + start;
	playhead = Phasor.ar(1, 1 * [1, 1.003], start, end);
	sig = BufRd.ar(2, ~str, playhead);
	// sig = sig * SinOsc.kr(0.1);
	sig = RLPF.ar(sig, 1000);
	sig * 0.4
})
)
Ndef(\strings).release

(
Ndef(\lp1, {
	var sig, env, playhead, start, end;
	start = 0 * 44100 ;
	end = 4 * 44100 + start;
	playhead = Phasor.ar(1, 1.05, start, end);
	sig = BufRd.ar(2, ~lp1, playhead);
	// sig = PitchShift.ar(sig, 0.2, 0.5, 0.01, 0.01, 2);
	// sig = sig * SinOsc.kr(20);
	// sig = RLPF.ar(sig, 2000);
	sig * 0.6
})
)
Ndef(\lp1).release

(
Ndef(\lp2, {
	var sig, env, playhead, start, end;
	start = [0.1, 0.15] * 44100 ;
	end = 4 * 44100 + start;
	playhead = Phasor.ar(1, 0.94*[1, 1.01], start, end);
	sig = BufRd.ar(2, ~lp2, playhead);
	// sig = sig * SinOsc.kr(0.1);
	sig * 0.5
})
)
Ndef(\lp2).release

(
Ndef(\lp3, {
	var sig, env, playhead, start, end;
	start = [0, 0.03] * 44100 ;
	end = 4 * 44100 + start;
	playhead = Phasor.ar(1, 1 * [1, 1], start, end);
	sig = BufRd.ar(2, ~lp3, playhead);
	// sig = PitchShift.ar(sig, 0.2, 0.5, 0.01, 0.01, 2);
	// sig = sig * SinOsc.kr(3);
	sig = LPF.ar(sig, 1500);
	sig * 1
})
)
Ndef(\lp3).release

(
Ndef(\sample1, {
	var sig, sigIn, env, playhead, start, end, local, feedVal = 0.5;
	start = 3 + [0, 0.01] * 44100 ;
	end = 3 * 44100 + start;
	playhead = Phasor.ar(1, 0.9 * [1, 1.1], start, end);
	sig = BufRd.ar(2, ~rr2, playhead);
	// sig = LPF.ar(sig, 1500);

	sigIn = Mix.ar(sig);
	sigIn = sigIn * (Amplitude.kr(sigIn) > 0.02);
	local = LocalIn.ar(2) * feedVal;
	local = Rotate2.ar(local[0], local[1], 0.2);
	local = DelayN.ar(local, 1, 1 * LFNoise1.kr(0.3).range(0.3,0.4));
	LocalOut.ar((local + sigIn).softclip);
	sig = 0.3 * local + sig;
	// sig = BPF.ar(sig, 2000, 0.1, 1);
	// sig = sig * SinOsc.kr(10);
	// sig = Decimator.ar(sig, 10000, 7);
	// sig = sig + (sig.wrap * 0.02);
	sig * 0.8
})
)
Ndef(\sample1).release

(
Ndef(\sample2, {
	var sig, sigIn, env, playhead, start, end, local, feedVal = 0.5;
	start = [0, 0.03] * 44100 ;
	end = 4 * 44100 + start;
	playhead = Phasor.ar(1, 1 * [1, 1], start, end);
	sig = BufRd.ar(2, ~th, playhead);
	// sig = PitchShift.ar(sig, 0.2, 0.5, 0.01, 0.01, 2);
	// sig = sig * SinOsc.kr(Line.kr(20, 3, 20));

	// sigIn = Mix.ar(sig);
	// sigIn = sigIn * (Amplitude.kr(sigIn) > 0.02);
	// local = LocalIn.ar(2) * feedVal;
	// local = Rotate2.ar(local[0], local[1], 0.2);
	// local = DelayN.ar(local, 1, 1 * LFNoise1.kr(0.3).range(0.3,0.4));
	// LocalOut.ar((local + sigIn).softclip);
	// sig = 0.7 * sig + local;
	sig = LPF.ar(sig, 1500);
	sig * 1
})
)
Ndef(\sample2).release

(
Ndef(\dron1, {
	var sig, sig1, sig2, env, envGen;
	env = Env.rcurve2(200, [0.1, 1],
		[0.001, 0.01], [0.2, 0.5], [0.9, 0.1]);
	envGen = EnvGen.kr(env);

	sig1 = Splay.ar(LFPulse.ar([3500, 350, 87, 10000],
		mul: [0.1, 0.1, 0.1, 0.1] * 2));
	sig2 = SinOsc.ar([86, 87] * LFNoise1.kr(0.3).range(0.95, 1.05),
		mul: 0.7);

	sig = sig1 + sig2 + BrownNoise.ar(0.1, mul: 0.1);
	sig = sig * envGen * 0.8;
	sig * 0.6
});
)
Ndef(\dron1).stop

(
Pdef(\boomPattern2,
	Pbind(
		\instrument, \boom,
		\dur, Pseq([1.1, 0.1, 0.9, 0.4, 0.45, 1.1].normalizeSum * 8,
			inf),
		\level, Pseq([3,2,3] * 0.5, inf),
	)
);
)
Pdef(\boomPattern2).play;
Pdef(\boomPattern2).stop;

(
Pdef(\tshakPattern1,
	Pbind(
		\instrument, \tshak,
		\dur, Pseq([1.1, 0.2, 0.9, 0.4, 0.45, 1.1].normalizeSum * 5,
			inf),
		\level, Pseq([3,2,3] * 0.2, inf),
	)
);
)
Pdef(\tshakPattern1).play;
Pdef(\tshakPattern1).stop;

Pdef(\tshakPattern1).reset;
Pdef(\boomPattern2).reset;

(
Pdef(\synthPatt,
	~oct = 12;
	Pbind(
		\instrument, \adcirc,
		\freq, Pwrand([
			Pseq(([65, 68, 60, 72] + ~oct).midicps, 1),
			Pseq(([65, 68, 60] + ~oct).midicps, 1)
		], [0.5, 0.5], inf),
		\dur, Pseq([1,1,1.5,1,1] * 3, inf),
		\level, 1,
		\legato, 1,
	)
);
)
Pdef(\synthPatt).play;
Pdef(\synthPatt).stop;

(
Pdef(\synthPatt2,
	~oct = -12;
	Pbind(
		\instrument, \boc,
		\freq, Pseq(([65, 70] + ~oct).midicps, inf),
		\dur, Pseq([1,1,2] * 5, inf),
		\level, 1,
		\legato, 1,
	)
);
)
Pdef(\synthPatt2).play;
Pdef(\synthPatt2).stop;

(
Ndef(\dron2, {
	var sig, levels, times, env, envGen;
	env = Env.rcurve(50, [0.1, 2], [0.01, 0.2]);
	envGen = EnvGen.kr(env);

	sig = Splay.ar(SinOscFB.ar([300, 50, 202],
			SinOsc.kr(0.1).range(0,1), mul: [1,2,1]));
	sig = sig * LFPulse.kr(SinOsc.kr(0.3).range(5, 50));
	// sig = sig * Impulse.kr(SinOsc.kr(0.3).range(5, 50), mul: 3);
	sig * envGen * 0.5
});
)
Ndef(\dron2).stop

(
Ndef(\sine, {
	Splay.ar(SinOsc.ar([100, 1001, 500, 501, 102, 1198]))
	* 0.1 * LFPulse.kr(10)
})
)
Ndef(\sine).release

(
Ndef(\burst, {
	var sig, sig1, sig2, env, envGen;
	env = Env.rcurve2(2000, [0.1, 1], [0.001, 0.01], [0.2, 0.5],
		[0.9, 0.1]);
	envGen = EnvGen.kr(env);

	sig = [ClipNoise.ar(0.9), BrownNoise.ar(0.9)];
	sig = RLPF.ar(sig,
		LFNoise0.kr(1.5).range(20000, 50000),
		LFNoise0.kr(1).range(0.6, 0.9));
	sig = sig * envGen;
	sig = sig * TWChoose.kr(Impulse.kr(2), [0,1], [0.8, 0.2]);
	sig
});
)
Ndef(\burst).release

(
Ndef(\massCom, {
	var sig, env, curve, amp, freq, hasFreq, noise, max;
	~base = 65;
	max = (~base + 2).midicps;
	env = Env.new([
		[(~base + 2).midicps, (~base + 2).midicps * 1.02],
		[~base.midicps, ~base.midicps] * 1.02,
		[~base.midicps, ~base.midicps * 1.02],
		[(~base - 4).midicps, (~base - 4).midicps * 1.02],
		[(~base - 8).midicps, (~base - 8).midicps * 1.03 ]
	],
	[0.2, 1.55, 0.03333, 1.55]).circle;
	curve = EnvGen.kr(env, 1, doneAction: 2);
	sig = LFSaw.ar(curve);
	amp = thresh(Amplitude.kr(sig[0], 0.05, 0.05), 0.01);
	# freq, hasFreq = Pitch.kr(sig[0]);
	noise = BPF.ar(
		PinkNoise.ar(LFNoise1.kr(0.2).range(4,20)),
		max(freq, max) * 32, 0.9, mul: amp * 0.5).dup();
	sig = sig + noise;
	sig = sig * Line.kr(0, 1, 30);
	sig * 0.45
})
)
Ndef(\massCom).release;

(
Ndef(\ruis, {
	var sig, sig1, sig2;
	// sig1 = GrayNoise.ar(0.3);
	sig1 = Dust.ar(100);
	sig2 = PinkNoise.ar(0.2);
	sig1 = RLPF.ar(sig1, 1500, 0.9);
	sig2 = RLPF.ar(sig2, 500, 0.9);
	sig = sig1 + sig2;
	sig = Pan2.ar(sig, LFNoise1.kr(0.2).range(-1,1));
	sig * 1
});
)
Ndef(\ruis).release;



(
~midiOutDevice = "MUL";
SetMIDIOut.new();
)

(
~mi = Pbind(
	\type,\midi,
	\chan,1,
	\midiout, ~midiOut,
	\midinote, Pseq([Pwrand([68,70],[0.9,0.1]), Prand([69,70],1)], inf),
	\legato, 1,
	\dur, 2
).play();
)
~mi.stop








