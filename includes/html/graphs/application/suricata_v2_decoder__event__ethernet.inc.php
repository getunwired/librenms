<?php

$name = 'suricata';
$unit_text = 'Ethernet pkts/s';
$descr = 'Pkt To Small';
$descr_len = 20;
$ds = 'data';

if (isset($vars['sinstance'])) {
    $filename = Rrd::name($device['hostname'], ['app', $name, $app->app_id, 'instance_' . $vars['sinstance'] . '___decoder__event__ethernet__pkt_too_small']);
} else {
    $filename = Rrd::name($device['hostname'], ['app', $name, $app->app_id, 'totals___decoder__event__ethernet__pkt_too_small']);
}

if (! Rrd::checkRrdExists($filename)) {
    d_echo('RRD "' . $filename . '" not found');
}

require 'includes/html/graphs/generic_stats.inc.php';
