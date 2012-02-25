#!/usr/bin/groovy

import java.util.Random

def int die() {
	Random rand = new Random()

	return rand.nextInt(20) + 1;
}

def stats = [
	'S' : 6,
	'H' : 6,
	'A' : 6,
	'D' : 6,
	'P' : 6,
	'I' : 6,
	'E' : 6,
	'W' : 6
]

def decrepitude = 0

30.upto(199) {
	age -> 
	int decade = (age / 10)
	int roll = die()

	if (roll < decade + decrepitude) {
		int s = die() / 4;
		switch (s) {
		case 0: stats['S']--; break;
		case 1: stats['H']--; break;
		case 2: stats['A']--; break;
		case 3: stats['D']--; break;
		case 4: stats['P']--; break;
		}
		if (roll  < (decade + decrepitude) / 2) {
			decrepitude ++;
		}
	}
	for (i in stats.values()) {
		if (i < 1) {
			println 'Dead.'
			System.exit(0)
		}
	}
	println age + ':' + stats['S'] + stats['H'] + stats['A'] + stats['D'] + stats['P'] + " / " + decrepitude

}
