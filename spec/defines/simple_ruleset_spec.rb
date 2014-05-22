require 'spec_helper'

describe 'patterndb::simple::ruleset' do
  let :facts do {
    :osfamily => 'RedHat'
  } end
  let :title do
    'myruleset'
  end
  let :default_params do {
    :id => 'ID',
    :pubdate => '1970-01-01',
    :version => '4',
  } end
  let :pre_condition do
    'class { "patterndb": base_dir => "BASEDIR", }'
  end
  context "Simple ruleset without patterns" do
    let :params do
      default_params.merge(
        {}
      )
    end
    it { expect {should compile}.to raise_error(Puppet::Error, /Must pass patterns/e)}
  end
  context "Simple ruleset without rules" do
    let :params do
      default_params.merge(
        {
          :patterns => [ 'P' ]
        }
      )
    end
    it { expect {should compile}.to raise_error(Puppet::Error, /Must pass rules/e)}
  end
  context "Simple ruleset with wrong type for patterns" do
    let :params do
      default_params.merge(
        {
          :patterns => { 'P' => 'V' },
          :rules => { }
        }
      )
    end
    it { expect {should compile}.to raise_error(Puppet::Error, /is not an Array/e)}
  end
  context "Simple ruleset with wrong type for rules" do
    let :params do
      default_params.merge(
        {
          :patterns => [ 'P1', 'P2' ],
          :rules => 'invalid_string_rule'
        }
      )
    end
    it { expect {should compile}.to raise_error(Puppet::Error, /is not an Array/e)}
  end
  context "Simple ruleset with empty rules and patterns" do
    let :params do
      default_params.merge(
        {
          :patterns => [],
          :rules => []
        }
      )
    end
    it { should contain_class('patterndb::update') }
    it {
      should contain_file('BASEDIR/etc/syslog-ng/patterndb.d/myruleset.pdb').that_notifies(
        'Exec[patterndb::merge]'
      ).with_content(
        /<patterndb/e
      ).with_content(
        /<\/patterndb>/e
      ).with_content(
        /name='myruleset'/e
      ).with_content(
        /id='ID'/e
      ).with_content(
        /pub_date='1970-01-01'/e
      )
    }
  end
end
