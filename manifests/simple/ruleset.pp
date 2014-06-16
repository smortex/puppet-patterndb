#
define patterndb::simple::ruleset (
  $id,
  $patterns,
  $pubdate,
  $rules,
  $pdb_name = 'default',
  $version        = 4,
# begin currently ignored
  $description    = 'generated by puppet',
  $url            = undef,
# end currently ignored
) {

  if ! defined(Class['Patterndb']) {
    include patterndb
  }

  validate_array($patterns)
  validate_array($rules)
  validate_string($url)
  validate_string($pdb_name)
  validate_string($description)
  validate_string($pubdate)
  validate_re($version, '^\d+$')
  validate_re($pubdate, '^\d+-\d+-\d+$')

  $pdb_file = "${patterndb::pdb_dir}/${pdb_name}/${name}.pdb"

  # validate rules
  patterndb_simple_rule ($rules)

  if ! defined(Patterndb::Update[$pdb_name]) {
    patterndb::update { $pdb_name: }
  }

  file {$pdb_file:
    ensure      => present,
    mode        => '0644',
    content     => template('patterndb/simple.pdb.erb'),
    notify      => Exec["patterndb::merge::${pdb_name}"]
  }
}
