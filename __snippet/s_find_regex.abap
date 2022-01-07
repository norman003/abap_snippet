DATA text TYPE string.
DATA moff TYPE i.
DATA mlen TYPE i.

text = '012Hello8'.

FIND REGEX 'Hello' IN text MATCH OFFSET moff
MATCH LENGTH mlen.
WRITE: / text+moff(mlen), moff, mlen.