#!/usr/bin/perl

eval "use Time::HiRes qw(usleep nanosleep);1" or *usleep = sub {
	qx(sleep 1)
};

eval "use Term::ANSIColor;1" or *color = sub {
	return ""
};

$int = 1000*1000;

$thsep = 1;

if ($#ARGV == -1) {
	print <<XX;
Watching diff output in command numbers.
Usage: watchdiff.sh [options] [interval] "shell command"
	interval	in seconds (1s default). Could be used with ms suffix: 100ms
	-r		do not use thousands separator
XX
	exit;
}

while ($#ARGV > 0) {
	$sint=$ARGV[0];

	if ($sint =~ /(\d+)ms/) {
		$int=$1 * 1000;
	} elsif ($sint =~ /(\d+)/) {
		$int=$ARGV[0] * 1000 * 1000;
	} elsif ($sint == "-r") {
		$thsep = 0;
	}
	shift;
}

$cmd=$ARGV[0];

while(1) {
	$res = qx($cmd);
	#print "$res\n";
	
	my @pmatches;
	while($pres =~ /\b((0x)?[\da-fA-F]+)\b/g) {
		push @pmatches, $1;
	}
	my @matches;
	my @lmatchs;
	my @lmatche;
	while($res =~ /\b((0x)?[\da-fA-F]+)\b/g) {
		push @matches, $1;
		push @lmatchs, $-[0];
		push @lmatche, $+[0];
	}
	#print "@matches\n";
	#print "@pmatches\n";

	if ($#matches != $#pmatches) {
		print "INCONSISTENT\n$res";
		usleep($int);
		$pres = $res;
		next;
	}
	
	$dres = $res;
	$notzero = 0;
	for(my $i = $#matches; $i >= 0; $i--)
	{
		my $sval = $matches[$i];
		$sval = oct($sval) if $sval =~ /^0/;
		my $eval = $pmatches[$i];
		$eval = oct($eval) if $eval =~ /^0/;
		my $di = $sval - $eval;
		#print " xxx ".$sval."   ". $matches[$i] . " - ".$eval . "   " . $pmatches[$i] . "\n";
		if ($di != 0) {
			$notzero = 1;
		}

		my $s = $lmatchs[$i];
		my $e = $lmatche[$i];
		#print "se: $s $e\n";
		
		if ($di != 0) {
			if ($thsep) {
				$di = reverse join ',', unpack '(A3)*', reverse $di;
			}
			substr($dres, $s, $e-$s) = "<" . color("red") . "$di" . color("reset") . ">";
		}
		# $dres = $dres .  . substr($res, $s, $e-$s);
	}
	if ($notzero) {
		print "$dres";
	}else{
		print "no diff.. ";
	}

	usleep($int);
	$pres = $res;
}
