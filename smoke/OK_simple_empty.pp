#
class { 'patterndb':
  base_dir => '/tmp/'
}

patterndb::simple::ruleset { 'empty':
  id => 'ac5bfcf0-bfaa-4dc6-b064-e64700b50b75',
  patterns => [],
  pubdate => '2014-03-14',
  rules => []
}

