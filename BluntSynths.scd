
Document.current.createBackup;
(
SynthDef(\boom, {
	arg level = 1, gate = 1;
	var sig, env;
	sig = 0.7 * SinOsc.ar( XLine.kr([800, 900],[50,52] * 1, 0.02)
		* LFNoise1.kr(30).range(0.97, 1.03) );
	sig = Splay.ar(sig);
	env = Env.new([0,1,0.1,0],[0.01, 1, 2]);
	// env = Env.asr(0.01, 1, 0.01);
	sig = sig * EnvGen.kr(env, gate, doneAction: 2);
	Out.ar(0, sig * level);
}).add;
);

(
SynthDef(\tshak, {
	arg level = 1, gate = 1;
	var sig, playhead, start, end;
	start = [0.03, 0.1] * 44100;
	end = 100 * 0.0102 * 44100 + start;
	playhead = Phasor.ar(1, [0.9, 0.91], start, end);
	sig = BufRd.ar(2, ~sn, playhead, 1);
	sig = NumChannels.ar(sig);
	sig = sig * EnvGen.kr(Env.asr(0.01, 1, 0.01), gate, doneAction: 2);
	Out.ar(2, sig * level);
}).add;
);

(
SynthDef(\dark, {
	arg freq, gate = 1, level = 1;
	var sig, local, env, feedback = 0.95;
	var cutoffVal = 20000, efxVal = 3, phaseMulVal = 1;

	local = feedback * LocalIn.ar(2);
	sig = SinOsc.ar(
		freq,
		// freq * [2, 1, 1, 0.25],
		local * LFNoise1.ar(0.1,phaseMulVal),
		LFNoise1.ar(3,6)
	).tanh;

	(efxVal-1).do {
		sig = AllpassL.ar(sig, 0.3, { Rand(0,0.2) + 0.1 } ! 2, 5);
	};
	sig = sig.tanh;
	sig = NumChannels.ar(sig);
	env = EnvGen.kr(Env.asr(releaseTime: 5), gate, doneAction:2);
	LocalOut.ar(sig);
	sig = RLPF.ar(sig, cutoffVal, 0.5);
	sig = sig * efxVal.linlin(1,11,0.4,1);
	// sig = Decimator.ar(sig, 10000, 7);
	// sig = sig + (sig.wrap * 0.1);

	Out.ar(0, 0.4 * sig * env * level);
}).add;
);

(
SynthDef.new(\boc, {
	arg freq, gate = 1, level = 1;
	var sig, cutoffVal = 1500, resVal = 1, flutter = 0.5, freq2,
	sigL, sigR;
	freq2 = freq * [1, 0.5, 2, 0.25];
	sig = RLPF.ar(
		Saw.ar(SinOsc.ar(flutter) * 3.01 + (freq2 + (8.midicps/128))) *
		Saw.ar(SinOsc.ar(flutter) * 3.03 + (freq2 + (5.midicps/128))) *
		Saw.ar(SinOsc.ar(flutter) * 3    + (freq2 - (3.midicps/128))),
		cutoffVal, resVal);
	sig = RLPF.ar(sig, cutoffVal, resVal);
	sig = NumChannels.ar(sig);
	sigL = Pan2.ar(sig[0], LFNoise1.ar(1).range(-0.8,0.8));
	sigR = Pan2.ar(sig[1], LFNoise1.ar(1.1).range(-0.8,0.8));
	sig = sigL + sigR;
	// sig = Decimator.ar(sig, 10000, 7);
	sig = sig + (sig.wrap * 0.05);
	sig = sig * EnvGen.kr(Env.adsr(0.1,0,1,2.0), gate, doneAction: 2);
	Out.ar(0, sig * level);
}).add;
);

(
SynthDef(\adcirc, {
	arg freq, gate = 1, cutoffBus, efxBus, level = 1;
	var sig1, sig2, sig, env, control1, control2, freq2;
	var cutoffVal = 2000, flutterVal = 0, speedVal = 0.1;

	freq2 = [freq,freq*1.002];
	freq2 = [1, 0.5, 2]*freq2;
	env = EnvGen.kr(Env.asr(0.5,1,1), gate, doneAction:2);

	control1 = LFNoise1.kr(4).range(0.5,1);
	sig1 =
	SinOscFB.ar( 1.01*SinOsc.ar(2*speedVal) + freq2, control1, 0.5) *
	SinOscFB.ar(1.02*SinOsc.ar(2*speedVal) + freq2, control1, 0.5) *
	SinOscFB.ar(SinOsc.ar(1.03*speedVal) + freq2, control1, 0.5);
	sig1 = RLPF.ar(sig1,
		LFNoise1.kr(3*speedVal).range(100,5000),
		LFNoise0.kr(5*speedVal).range(0.1, 0.9));

	control2 = LFNoise1.kr(5.5*speedVal).range(500,10000);
	sig2 =
	Saw.ar( 1.01*SinOsc.ar(2*speedVal) + freq2 ) *
	Saw.ar( 1.02*SinOsc.ar(2*speedVal) + freq2) *
	Saw.ar( SinOsc.ar(1.03*speedVal) + freq2);
	sig2 = RLPF.ar(sig2, control2);
	sig2 = RLPF.ar(sig2, control2);

	sig = Splay.ar(sig1 + sig2);
	sig = LPF.ar(sig, cutoffVal);
	sig = ( flutterVal * sig * SinOsc.kr(LFNoise1.kr(2).range(6,8)) )
	+ ( (1-flutterVal) * sig );
	// sig = Decimator.ar(sig, 10000, 7);
	// sig = sig + (sig.wrap * 0.05);

	Out.ar(0, 0.8 * sig * env * level);
}).add;
);

