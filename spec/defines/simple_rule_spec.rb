require 'spec_helper'

describe 'patterndb::simple::rule' do
  let :facts do {
    :osfamily => 'RedHat',
    :concat_basedir => '/tmp/concat-basedir'
  } end
  let :title do
    'myrule'
  end
  let :default_params do {
    :id => 'RULE_ID',
  } end
  let :pre_condition do
    'class { "patterndb": base_dir => "/BASEDIR", }
    patterndb::simple::ruleset { "myruleset":
      id => "RULESET_ID",
      pubdate => "1970-01-01",
      patterns => [ "a", "b" ]
    }
    Exec { path => ["/bin","/usr/bin"] }'
  end
  context "Simple invalid rule with no patterns" do
    let :params do
      default_params.merge(
        {
          :ruleset => "myruleset"
        }
      )
    end
    it { expect {should compile}.to raise_error(/Must pass patterns/m)}
  end
  context "Simple invalid rule with no ruleset" do
    let :params do
      default_params.merge(
        {
          :patterns => [ "Ford... you're turning into a penguin. Stop it." ]
        }
      )
    end
    it { expect {should compile}.to raise_error(/Must pass ruleset/m)}
  end
  context "Simple invalid rule with inexisting ruleset" do
    let :params do
      default_params.merge(
        {
          :patterns => [ "Ford... you're turning into a penguin. Stop it." ],
          :ruleset => 'this_ruleset_was_not_predeclared'
        }
      )
    end
    it { expect {should compile}.to raise_error(/Failed while trying to define rule.*for undeclared ruleset/m)}
  end
  context "Simple rule with 1 string pattern and ruleset" do
    let :params do
      default_params.merge(
        {
          :patterns => "Time is an illusion. Lunchtime doubly so.",
          :ruleset => "myruleset"
        }
      )
    end
    it { 
      should contain_patterndb__simple__ruleset('myruleset')
      should contain_patterndb__simple__rule('myrule').with(
        {
          :ruleset => 'myruleset',
          :patterns => 'Time is an illusion. Lunchtime doubly so.',
        }
      )
    }
    it {
      should contain_file('patterndb_simple_ruleset-myruleset').with(
        {
          :path => '/BASEDIR/etc/syslog-ng/patterndb.d/default/myruleset.pdb'
        }
      )
      should contain_concat__fragment('patterndb_simple_rule-myrule-header').with(
        {
          :target => 'patterndb_simple_ruleset-myruleset'
        }
      ).with_content(
        /<patterns>\s*<pattern>Time is an illusion. Lunchtime doubly so.<\/pattern>\s*<\/patterns>/m
      )
    }
  end
end
