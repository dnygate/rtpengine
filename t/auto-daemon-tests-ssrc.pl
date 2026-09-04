#!/usr/bin/perl

use strict;
use warnings;
use NGCP::Rtpengine::Test;
use NGCP::Rtpengine::AutoTest;
use Test::More;
use POSIX;


autotest_start(qw(--config-file=none -t -1 -i 203.0.113.1 -n 2223 -f -L 7 -E --log-level-internals=7))
		or die;


my ($sock_a, $sock_b, $port_a, $port_b, $sock_ax, $sock_bx, $port_ax, $port_bx);


# SSRC egress-to-answerer as integer in offer

($sock_a, $sock_ax, $sock_b, $sock_bx) = new_call(
	[qw(198.51.100.1 7000)],
	[qw(198.51.100.1 7001)],
	[qw(198.51.100.3 7002)],
	[qw(198.51.100.3 7003)],
);

($port_a, $port_ax) = offer('SSRC egress-to-answerer as integer in offer', { SSRC => { 'egress-to-answerer' => 0x11223344 } }, <<SDP);
v=0
o=- 1545997027 1 IN IP4 198.51.100.1
s=tester
t=0 0
m=audio 7000 RTP/AVP 8
c=IN IP4 198.51.100.1
a=sendrecv
----------------------------------
v=0
o=- 1545997027 1 IN IP4 198.51.100.1
s=tester
t=0 0
m=audio PORT RTP/AVP 8
c=IN IP4 203.0.113.1
a=rtpmap:8 PCMA/8000
a=sendrecv
a=rtcp:PORT
SDP

($port_b, $port_bx) = answer('SSRC egress-to-answerer as integer in offer', { }, <<SDP);
v=0
o=- 1545997027 1 IN IP4 198.51.100.3
s=tester
t=0 0
m=audio 7002 RTP/AVP 8
c=IN IP4 198.51.100.3
a=rtpmap:8 PCMA/8000
a=sendrecv
--------------------------------------
v=0
o=- 1545997027 1 IN IP4 198.51.100.3
s=tester
t=0 0
m=audio PORT RTP/AVP 8
c=IN IP4 203.0.113.1
a=rtpmap:8 PCMA/8000
a=sendrecv
a=rtcp:PORT
SDP

snd($sock_a, $port_b, rtp( 8, 1000, 3000+160*0, 0x1234, "\x10" . ("\x00" x 158) . "\x50"));
rcv($sock_b, $port_a, rtpm(8, 1000, 3000+160*0, 0x11223344, "\x10" . ("\x00" x 158) . "\x50"));
snd($sock_a, $port_b, rtp( 8, 1001, 3000+160*1, 0x1234, "\x10" . ("\x00" x 158) . "\x50"));
rcv($sock_b, $port_a, rtpm(8, 1001, 3000+160*1, 0x11223344, "\x10" . ("\x00" x 158) . "\x50"));
snd($sock_b, $port_a, rtp( 8, 8000, 7000+160*0, 0x6543, "\x10" . ("\x00" x 158) . "\x50"));
rcv($sock_a, $port_b, rtpm(8, 8000, 7000+160*0, 0x6543, "\x10" . ("\x00" x 158) . "\x50"));
snd($sock_b, $port_a, rtp( 8, 8001, 7000+160*1, 0x6543, "\x10" . ("\x00" x 158) . "\x50"));
rcv($sock_a, $port_b, rtpm(8, 8001, 7000+160*1, 0x6543, "\x10" . ("\x00" x 158) . "\x50"));


# SSRC egress-to-offerer as hex string in offer

($sock_a, $sock_ax, $sock_b, $sock_bx) = new_call(
	[qw(198.51.100.1 7004)],
	[qw(198.51.100.1 7005)],
	[qw(198.51.100.3 7006)],
	[qw(198.51.100.3 7007)],
);

($port_a, $port_ax) = offer('SSRC egress-to-offerer as hex string in offer', { SSRC => { 'egress-to-offerer' => '0x22334455' } }, <<SDP);
v=0
o=- 1545997027 1 IN IP4 198.51.100.1
s=tester
t=0 0
m=audio 7004 RTP/AVP 8
c=IN IP4 198.51.100.1
a=sendrecv
----------------------------------
v=0
o=- 1545997027 1 IN IP4 198.51.100.1
s=tester
t=0 0
m=audio PORT RTP/AVP 8
c=IN IP4 203.0.113.1
a=rtpmap:8 PCMA/8000
a=sendrecv
a=rtcp:PORT
SDP

($port_b, $port_bx) = answer('SSRC egress-to-offerer as hex string in offer', { }, <<SDP);
v=0
o=- 1545997027 1 IN IP4 198.51.100.3
s=tester
t=0 0
m=audio 7006 RTP/AVP 8
c=IN IP4 198.51.100.3
a=rtpmap:8 PCMA/8000
a=sendrecv
--------------------------------------
v=0
o=- 1545997027 1 IN IP4 198.51.100.3
s=tester
t=0 0
m=audio PORT RTP/AVP 8
c=IN IP4 203.0.113.1
a=rtpmap:8 PCMA/8000
a=sendrecv
a=rtcp:PORT
SDP

snd($sock_a, $port_b, rtp( 8, 1000, 3000+160*0, 0x1234, "\x10" . ("\x00" x 158) . "\x50"));
rcv($sock_b, $port_a, rtpm(8, 1000, 3000+160*0, 0x1234, "\x10" . ("\x00" x 158) . "\x50"));
snd($sock_a, $port_b, rtp( 8, 1001, 3000+160*1, 0x1234, "\x10" . ("\x00" x 158) . "\x50"));
rcv($sock_b, $port_a, rtpm(8, 1001, 3000+160*1, 0x1234, "\x10" . ("\x00" x 158) . "\x50"));
snd($sock_b, $port_a, rtp( 8, 8000, 7000+160*0, 0x6543, "\x10" . ("\x00" x 158) . "\x50"));
rcv($sock_a, $port_b, rtpm(8, 8000, 7000+160*0, 0x22334455, "\x10" . ("\x00" x 158) . "\x50"));
snd($sock_b, $port_a, rtp( 8, 8001, 7000+160*1, 0x6543, "\x10" . ("\x00" x 158) . "\x50"));
rcv($sock_a, $port_b, rtpm(8, 8001, 7000+160*1, 0x22334455, "\x10" . ("\x00" x 158) . "\x50"));


# SSRC both sides as decimal strings in offer

($sock_a, $sock_ax, $sock_b, $sock_bx) = new_call(
	[qw(198.51.100.1 7008)],
	[qw(198.51.100.1 7009)],
	[qw(198.51.100.3 7010)],
	[qw(198.51.100.3 7011)],
);

($port_a, $port_ax) = offer('SSRC both sides as decimal strings in offer', { SSRC => { 'egress-to-offerer' => '1122334455', 'egress-to-answerer' => '2233445566' } }, <<SDP);
v=0
o=- 1545997027 1 IN IP4 198.51.100.1
s=tester
t=0 0
m=audio 7008 RTP/AVP 8
c=IN IP4 198.51.100.1
a=sendrecv
----------------------------------
v=0
o=- 1545997027 1 IN IP4 198.51.100.1
s=tester
t=0 0
m=audio PORT RTP/AVP 8
c=IN IP4 203.0.113.1
a=rtpmap:8 PCMA/8000
a=sendrecv
a=rtcp:PORT
SDP

($port_b, $port_bx) = answer('SSRC both sides as decimal strings in offer', { }, <<SDP);
v=0
o=- 1545997027 1 IN IP4 198.51.100.3
s=tester
t=0 0
m=audio 7010 RTP/AVP 8
c=IN IP4 198.51.100.3
a=rtpmap:8 PCMA/8000
a=sendrecv
--------------------------------------
v=0
o=- 1545997027 1 IN IP4 198.51.100.3
s=tester
t=0 0
m=audio PORT RTP/AVP 8
c=IN IP4 203.0.113.1
a=rtpmap:8 PCMA/8000
a=sendrecv
a=rtcp:PORT
SDP

snd($sock_a, $port_b, rtp( 8, 1000, 3000+160*0, 0x1234, "\x10" . ("\x00" x 158) . "\x50"));
rcv($sock_b, $port_a, rtpm(8, 1000, 3000+160*0, 2233445566, "\x10" . ("\x00" x 158) . "\x50"));
snd($sock_a, $port_b, rtp( 8, 1001, 3000+160*1, 0x1234, "\x10" . ("\x00" x 158) . "\x50"));
rcv($sock_b, $port_a, rtpm(8, 1001, 3000+160*1, 2233445566, "\x10" . ("\x00" x 158) . "\x50"));
snd($sock_b, $port_a, rtp( 8, 8000, 7000+160*0, 0x6543, "\x10" . ("\x00" x 158) . "\x50"));
rcv($sock_a, $port_b, rtpm(8, 8000, 7000+160*0, 1122334455, "\x10" . ("\x00" x 158) . "\x50"));
snd($sock_b, $port_a, rtp( 8, 8001, 7000+160*1, 0x6543, "\x10" . ("\x00" x 158) . "\x50"));
rcv($sock_a, $port_b, rtpm(8, 8001, 7000+160*1, 1122334455, "\x10" . ("\x00" x 158) . "\x50"));


# SSRC egress-to-answerer given in answer

($sock_a, $sock_ax, $sock_b, $sock_bx) = new_call(
	[qw(198.51.100.1 7012)],
	[qw(198.51.100.1 7013)],
	[qw(198.51.100.3 7014)],
	[qw(198.51.100.3 7015)],
);

($port_a, $port_ax) = offer('SSRC egress-to-answerer given in answer', { }, <<SDP);
v=0
o=- 1545997027 1 IN IP4 198.51.100.1
s=tester
t=0 0
m=audio 7012 RTP/AVP 8
c=IN IP4 198.51.100.1
a=sendrecv
----------------------------------
v=0
o=- 1545997027 1 IN IP4 198.51.100.1
s=tester
t=0 0
m=audio PORT RTP/AVP 8
c=IN IP4 203.0.113.1
a=rtpmap:8 PCMA/8000
a=sendrecv
a=rtcp:PORT
SDP

($port_b, $port_bx) = answer('SSRC egress-to-answerer given in answer', { SSRC => { 'egress-to-answerer' => 0x33445566 } }, <<SDP);
v=0
o=- 1545997027 1 IN IP4 198.51.100.3
s=tester
t=0 0
m=audio 7014 RTP/AVP 8
c=IN IP4 198.51.100.3
a=rtpmap:8 PCMA/8000
a=sendrecv
--------------------------------------
v=0
o=- 1545997027 1 IN IP4 198.51.100.3
s=tester
t=0 0
m=audio PORT RTP/AVP 8
c=IN IP4 203.0.113.1
a=rtpmap:8 PCMA/8000
a=sendrecv
a=rtcp:PORT
SDP

snd($sock_a, $port_b, rtp( 8, 1000, 3000+160*0, 0x1234, "\x10" . ("\x00" x 158) . "\x50"));
rcv($sock_b, $port_a, rtpm(8, 1000, 3000+160*0, 0x33445566, "\x10" . ("\x00" x 158) . "\x50"));
snd($sock_a, $port_b, rtp( 8, 1001, 3000+160*1, 0x1234, "\x10" . ("\x00" x 158) . "\x50"));
rcv($sock_b, $port_a, rtpm(8, 1001, 3000+160*1, 0x33445566, "\x10" . ("\x00" x 158) . "\x50"));
snd($sock_b, $port_a, rtp( 8, 8000, 7000+160*0, 0x6543, "\x10" . ("\x00" x 158) . "\x50"));
rcv($sock_a, $port_b, rtpm(8, 8000, 7000+160*0, 0x6543, "\x10" . ("\x00" x 158) . "\x50"));
snd($sock_b, $port_a, rtp( 8, 8001, 7000+160*1, 0x6543, "\x10" . ("\x00" x 158) . "\x50"));
rcv($sock_a, $port_b, rtpm(8, 8001, 7000+160*1, 0x6543, "\x10" . ("\x00" x 158) . "\x50"));


# SSRC in rtpp-flags string syntax

($sock_a, $sock_ax, $sock_b, $sock_bx) = new_call(
	[qw(198.51.100.1 7016)],
	[qw(198.51.100.1 7017)],
	[qw(198.51.100.3 7018)],
	[qw(198.51.100.3 7019)],
);

($port_a, $port_ax) = offer('SSRC in rtpp-flags string syntax', { 'rtpp-flags' => 'SSRC=[egress-to-answerer=0x55667788]' }, <<SDP);
v=0
o=- 1545997027 1 IN IP4 198.51.100.1
s=tester
t=0 0
m=audio 7016 RTP/AVP 8
c=IN IP4 198.51.100.1
a=sendrecv
----------------------------------
v=0
o=- 1545997027 1 IN IP4 198.51.100.1
s=tester
t=0 0
m=audio PORT RTP/AVP 8
c=IN IP4 203.0.113.1
a=rtpmap:8 PCMA/8000
a=sendrecv
a=rtcp:PORT
SDP

($port_b, $port_bx) = answer('SSRC in rtpp-flags string syntax', { }, <<SDP);
v=0
o=- 1545997027 1 IN IP4 198.51.100.3
s=tester
t=0 0
m=audio 7018 RTP/AVP 8
c=IN IP4 198.51.100.3
a=rtpmap:8 PCMA/8000
a=sendrecv
--------------------------------------
v=0
o=- 1545997027 1 IN IP4 198.51.100.3
s=tester
t=0 0
m=audio PORT RTP/AVP 8
c=IN IP4 203.0.113.1
a=rtpmap:8 PCMA/8000
a=sendrecv
a=rtcp:PORT
SDP

snd($sock_a, $port_b, rtp( 8, 1000, 3000+160*0, 0x1234, "\x10" . ("\x00" x 158) . "\x50"));
rcv($sock_b, $port_a, rtpm(8, 1000, 3000+160*0, 0x55667788, "\x10" . ("\x00" x 158) . "\x50"));
snd($sock_a, $port_b, rtp( 8, 1001, 3000+160*1, 0x1234, "\x10" . ("\x00" x 158) . "\x50"));
rcv($sock_b, $port_a, rtpm(8, 1001, 3000+160*1, 0x55667788, "\x10" . ("\x00" x 158) . "\x50"));
snd($sock_b, $port_a, rtp( 8, 8000, 7000+160*0, 0x6543, "\x10" . ("\x00" x 158) . "\x50"));
rcv($sock_a, $port_b, rtpm(8, 8000, 7000+160*0, 0x6543, "\x10" . ("\x00" x 158) . "\x50"));
snd($sock_b, $port_a, rtp( 8, 8001, 7000+160*1, 0x6543, "\x10" . ("\x00" x 158) . "\x50"));
rcv($sock_a, $port_b, rtpm(8, 8001, 7000+160*1, 0x6543, "\x10" . ("\x00" x 158) . "\x50"));


# SSRC zero value is ignored

($sock_a, $sock_ax, $sock_b, $sock_bx) = new_call(
	[qw(198.51.100.1 7020)],
	[qw(198.51.100.1 7021)],
	[qw(198.51.100.3 7022)],
	[qw(198.51.100.3 7023)],
);

($port_a, $port_ax) = offer('SSRC zero value is ignored', { SSRC => { 'egress-to-answerer' => 0 } }, <<SDP);
v=0
o=- 1545997027 1 IN IP4 198.51.100.1
s=tester
t=0 0
m=audio 7020 RTP/AVP 8
c=IN IP4 198.51.100.1
a=sendrecv
----------------------------------
v=0
o=- 1545997027 1 IN IP4 198.51.100.1
s=tester
t=0 0
m=audio PORT RTP/AVP 8
c=IN IP4 203.0.113.1
a=rtpmap:8 PCMA/8000
a=sendrecv
a=rtcp:PORT
SDP

($port_b, $port_bx) = answer('SSRC zero value is ignored', { }, <<SDP);
v=0
o=- 1545997027 1 IN IP4 198.51.100.3
s=tester
t=0 0
m=audio 7022 RTP/AVP 8
c=IN IP4 198.51.100.3
a=rtpmap:8 PCMA/8000
a=sendrecv
--------------------------------------
v=0
o=- 1545997027 1 IN IP4 198.51.100.3
s=tester
t=0 0
m=audio PORT RTP/AVP 8
c=IN IP4 203.0.113.1
a=rtpmap:8 PCMA/8000
a=sendrecv
a=rtcp:PORT
SDP

snd($sock_a, $port_b, rtp( 8, 1000, 3000+160*0, 0x1234, "\x10" . ("\x00" x 158) . "\x50"));
rcv($sock_b, $port_a, rtpm(8, 1000, 3000+160*0, 0x1234, "\x10" . ("\x00" x 158) . "\x50"));
snd($sock_a, $port_b, rtp( 8, 1001, 3000+160*1, 0x1234, "\x10" . ("\x00" x 158) . "\x50"));
rcv($sock_b, $port_a, rtpm(8, 1001, 3000+160*1, 0x1234, "\x10" . ("\x00" x 158) . "\x50"));
snd($sock_b, $port_a, rtp( 8, 8000, 7000+160*0, 0x6543, "\x10" . ("\x00" x 158) . "\x50"));
rcv($sock_a, $port_b, rtpm(8, 8000, 7000+160*0, 0x6543, "\x10" . ("\x00" x 158) . "\x50"));
snd($sock_b, $port_a, rtp( 8, 8001, 7000+160*1, 0x6543, "\x10" . ("\x00" x 158) . "\x50"));
rcv($sock_a, $port_b, rtpm(8, 8001, 7000+160*1, 0x6543, "\x10" . ("\x00" x 158) . "\x50"));


#done_testing;NGCP::Rtpengine::AutoTest::terminate('f00');exit;
done_testing();
