#!/usr/bin/env perl

use strict;
use warnings;
use Proc::ProcessTable;

my $current_hour = (localtime)[2];
if ( $current_hour >= 20 or $current_hour < 9 ) { system("killall -15 -u minecraft && screen -wipe") } ;

my $running = 0;
my $proc = Proc::ProcessTable->new;
foreach ( @{ $proc->table } ) {
    if ($_->cmndline =~ /mc_for_kids\.jar/) {
        $running = 1;
        last;
    }
}
if (!$running) {
	chdir("/home/minecraft/mc_for_kids") or die "Cannot change directory to /home/minecraft/mc_for_kids: $!";
	my $cmd = "/usr/bin/screen -dmS MC_For_kids /usr/bin/java -Xmx1024M -Xms1024M -jar /usr/local/bin/mc_for_kids.jar nogui";
	my $status = system($cmd);
	if ($status == -1) {
	    warn "Failed to execute command to start Minecraft server: $cmd ($!)\n";
	} elsif ($status != 0) {
	    my $exit_code = $? >> 8;
	    my $signal    = $? & 127;
	    my $core      = $? & 128;
	    warn "Minecraft server command exited abnormally (exit=$exit_code, signal=$signal, core_dumped=$core): $cmd\n";
	}
}

