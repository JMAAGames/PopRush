class_name MusicTrackData

const KEY_BASE = 0
const KEY_PATH = 1
const KEY_BPM = 2
const KEY_TITLE = 3
const KEY_ARTIST = 4

static var total_tracks = 11 # don't forget to change the max tracks as you add them in the list!

# This is the essential data for the tracks you might want to include as a modder or something.

static var music_track_data = {
	0: {KEY_BASE: "Track0", KEY_PATH: "res://Music/02 - Hi Daddy.ogg", KEY_BPM: 126, KEY_TITLE: "Hi Daddy", KEY_ARTIST: "JMAA"},
	1: {KEY_BASE: "Track1", KEY_PATH: "res://Music/03 - Guess-A-Feel-Stain.ogg", KEY_BPM: 110, KEY_TITLE: "Guess-A-Feel-Stain", KEY_ARTIST: "JMAA"},
	2: {KEY_BASE: "Track2", KEY_PATH: "res://Music/04 - Rats! Rats! Rats!.ogg", KEY_BPM: 128, KEY_TITLE: "Rats! Rats! Rats!", KEY_ARTIST: "JMAA"},
	3: {KEY_BASE: "Track3", KEY_PATH: "res://Music/05 - Tis The Night.ogg", KEY_BPM: 128, KEY_TITLE: "Tis The Night", KEY_ARTIST: "JMAA"},
	4: {KEY_BASE: "Track4", KEY_PATH: "res://Music/06 - Burn it Down.ogg", KEY_BPM: 160, KEY_TITLE: "Burn it Down", KEY_ARTIST: "JMAA"},
	5: {KEY_BASE: "Track5", KEY_PATH: "res://Music/07 - Vampire Blowing Off.ogg", KEY_BPM: 128, KEY_TITLE: "Vampire Blowing Off", KEY_ARTIST: "JMAA"},
	6: {KEY_BASE: "Track6", KEY_PATH: "res://Music/08 - Samba de Afeminado.ogg", KEY_BPM: 140, KEY_TITLE: "Samba de Afeminado", KEY_ARTIST: "JMAA"},
	7: {KEY_BASE: "Track7", KEY_PATH: "res://Music/09 - Toys For Adults.ogg", KEY_BPM: 125, KEY_TITLE: "Toys For Adults", KEY_ARTIST: "JMAA"},
	8: {KEY_BASE: "Track8", KEY_PATH: "res://Music/10 - Berlin Club Haus X.ogg", KEY_BPM: 125, KEY_TITLE: "Berlin Club Haus X", KEY_ARTIST: "JMAA"},
	9: {KEY_BASE: "Track9", KEY_PATH: "res://Music/12 - More Funk Than Funkin'.ogg", KEY_BPM: 128, KEY_TITLE: "More Funk Than Funkin'", KEY_ARTIST: "JMAA"},
	10: {KEY_BASE: "Track10", KEY_PATH: "res://Music/13 - SuperCharge!.ogg", KEY_BPM: 160, KEY_TITLE: "SuperCharge!", KEY_ARTIST: "JMAA"}
}
