#!/usr/bin/env perl

use strict;
use warnings;
use Proc::ProcessTable;

my $is_running;
my $proc = Proc::ProcessTable->new;
foreach ( @{ $proc->table } ) {
    if ($_->cmndline =~ /minecraft-launcher/) {
        $is_running = 1;
        last;
    }
}
my $launcher_path = '/opt/minecraft-launcher/minecraft-launcher';

if (!$running) {
    if (-f $launcher_path && -x $launcher_path) {
        my @st = stat($launcher_path);
        if (@st) {
            my $mode = $st[2];
            my $is_group_writable  = $mode & 0020;
            my $is_world_writable  = $mode & 0002;

            if (!$is_group_writable && !$is_world_writable) {
                my $pid = fork();
                if (!defined $pid) {
                    warn "Failed to fork to start Minecraft launcher: $!";
                } elsif ($pid == 0) {
                    exec $launcher_path or die "Failed to exec $launcher_path: $!";
                }
            } else {
                warn "Refusing to execute insecure launcher at $launcher_path (writable by group or others)";
            }
        } else {
            warn "Unable to stat $launcher_path";
        }
    } else {
        warn "Launcher binary $launcher_path not found or not executable";
    }
}
