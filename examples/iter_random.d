module iter_random;

import iterators;


import std.stdio;

import std.random;

class Randoms {
private:
	Random gen;

public:
	this() {
		gen.seed(unpredictableSeed());
	}

	this(uint s) {
		gen.seed(s);
	}

	uint max() {
		return gen.max;
	}

private:
	int iter() {
		while (true) {
			yield(gen.next);
		}
		return 0;
	}
	mixin mainiter!(uint, iter);
}

class RandomsLinear {
private:
	Randoms iterator;
	const float A, B;

public:
	/** Generates floats [a; b) */
	this(Randoms iterator_, double a_, double b_)
	in {
		assert(a_ < b_);
		assert(iterator_ !is null);
	}
	body {
		iterator = iterator_;
		A = ((b_ - a_)/(iterator.max + 1.0));
		B = a_;
	}

	int iter() {
		foreach (uint x; iterator) {
			yield(A*x+B);
		}
		return 0;
	}
	mixin mainiter!(float, iter);
}

import hist;

int main(char[][] args) {
	auto r = new Randoms();

	uint i;
/+
	auto a_ = 0.0;
	auto b_ = 1.0;

	auto A = ((b_ - a_)/(iterator.max + 1.0));
	auto B = a_;

	foreach (uint x; r) {
		writefln(f);

		if (i++ > 10_000) {
			break;
		}
	}
+/

	auto h = new Histogram(0.0, 40.0, 40);
	i = 0;
	auto m = new Moments!(float)();
	foreach (float x; new RandomsLinear(r, 0.0, 40.0)) {
		m ~= x;
		h ~= x;
		if (i++ > 1_000_000) {
			break;
		}
	}

	h.dump();
	writefln("Mean: %f  Var:  %f  Std-Dev:  %f  N:  %d", m.mean, m.variance, m.deviation, m.count);

	return 0;
}
