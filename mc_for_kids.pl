#!/usr/bin/env perl

use strict;
use warnings;
use Proc::ProcessTable;

my $bedtime = (localtime)[2];
if ( $bedtime >= 20 or $bedtime < 9 ) { system("killall -15 -u minecraft && screen -wipe") } ;

my $running = 0;
my $proc = Proc::ProcessTable->new;
foreach ( @{ $proc->table } ) {
    if ($_->cmndline =~ /mc_for_kids\.jar/) {
        $running = 1;
        last;
    }
}
if (!$running) {
	chdir("/home/minecraft/mc_for_kids");
	system("/usr/bin/screen -dmS MC_For_kids /usr/bin/java -Xmx1024M -Xms1024M -jar /usr/local/bin/mc_for_kids.jar nogui");
}

