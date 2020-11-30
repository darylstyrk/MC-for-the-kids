#!/usr/bin/env perl

use strict;
use warnings;
use Proc::ProcessTable;

my $running = 0;
my $proc = Proc::ProcessTable->new;
foreach ( @{ $proc->table } ) {
    if ($_->cmndline =~ /minecraft-launcher/) {
        $running = 1;
        last;
    }
}
if (!$running) {
	system("/opt/minecraft-launcher/minecraft-launcher &");
}
