
syslogng::pdb::simple { 'dhclient':

    ruleset_id          => 'ac5bfcf0-bfaa-4dc6-b064-e64700b50b75',
    rule_id             => 'bd63010f-b339-4106-8ad3-4eb9764116b2',
    provider            => 'remi.ferrand@cc.in2p3.fr',
    program_names       => ['dhclient', 'dhcpclient'],
    patterns            => [ 'DHCPACK from @IPV4::@' ],
    examples            => [ ['dhclient', 'DHCPACK from 172.17.0.1 (xid=0x245abdb1)'] ],
    tags                => [ 'tagv1' ],
    #url                 => undef
}
