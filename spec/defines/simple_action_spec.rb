require 'spec_helper'

describe 'patterndb::simple::action' do
  let :facts do {
    :osfamily => 'RedHat',
    :concat_basedir => '/tmp/concat-basedir'
  } end
  let :title do
    'myaction'
  end
  let :default_params do {
    :rate => '1/60',
  } end
  let :pre_condition do
    'class { "patterndb": base_dir => "/BASEDIR", }
    patterndb::simple::ruleset { "myruleset":
      id => "RULESET_ID",
      pubdate => "1970-01-01",
      patterns => [ "a", "b" ],
      rules => [
        {
          id => "myembeddedrule",
          patterns => "myembeddedpattern"
        }
      ]
    }
    patterndb::simple::rule { "myrule":
      ruleset => "myruleset",
      patterns => "mypattern",
    }
    Exec { path => ["/bin","/usr/bin"] }'
  end
  context "Simple invalid action with no rule" do
    let :params do
      default_params.merge(
        {
          :message => {}
        }
      )
    end
    it { expect {should compile}.to raise_error(/rule/m)}
  end
  context "Simple invalid action with no message" do
    let :params do
      default_params.merge(
        {
          :rule => "myrule"
        }
      )
    end
    it { expect {should compile}.to raise_error(/message/m)}
  end
  context "Simple invalid action with inexisting rule" do
    let :params do
      default_params.merge(
        {
          :message => {},
          :rule => 'this_rule_was_not_predeclared'
        }
      )
    end
    it { expect {should compile}.to raise_error(/Failed while trying to define action.*for undeclared rule/m)}
  end
  context "Simple action" do
    let :params do
      default_params.merge(
        {
          :message => {
            'values' => { 'a' => 'A' },
            'tags'   => [ 't', 'T' ],
          },
          :rule => "myrule"
        }
      )
    end
    it { 
      should contain_patterndb__simple__ruleset('myruleset')
      should contain_patterndb__simple__rule('myrule')
      should contain_patterndb__simple__action('myaction').with(
        {
          :rule => 'myrule',
        }
      )
    }
  end
  context "Simple action for embedded rule" do
    let :params do
      default_params.merge(
        {
          :message => {
            'values' => { 'a' => 'A' },
            'tags'   => [ 't', 'T' ],
          },
          :rule => "myembeddedrule"
        }
      )
    end
    it { 
      should contain_patterndb__simple__ruleset('myruleset')
      should contain_patterndb__simple__rule('myembeddedrule')
      should contain_patterndb__simple__action('myaction').with(
        {
          :rule => 'myembeddedrule',
        }
      )
    }
  end
end
