#
class { "syslogng":
    base_dir            => '/tmp/syslog-ng'
}

syslogng::pdb::simple { 'dhclient':
    ruleset_id          => 'ac5bfcf0-bfaa-4dc6-b064-e64700b50b75',
    rule_id             => 'bd63010f-b339-4106-8ad3-4eb9764116b2',
    provider            => 'remi.ferrand@cc.in2p3.fr',
    program_names       => ['dhclient', 'dhcpclient'],
    patterns            => [ 'DHCPACK from @IPv4::@' ],
    examples            => [ { program_name => 'dhclient', test_message => 'DHCPACK from 172.17.0.1 (xid=0x245abdb1)'} ],
    tags                => [ 'tagv1' ],
    #url                 => undef
}

syslogng::pdb::simple { 'test':
	ruleset_id => 'ac5bfcf0-bfaa-4dc6-b064-e64700b50b75',
	rule_id => '89e858cd-4bf6-4c1d-a092-41af271ef851',
	provider => 'me',
	program_names => [ 'a', 'b' ],
	patterns => [
		'match this @ANYSTRING@',
		'and that @ANYSTRING@'
	],
	examples => [
		{
			program_name => 'a',
			test_message => 'match this should match'
		},
		{
			program_name => 'b',
			test_message => 'and that too'
		}
	],
}

