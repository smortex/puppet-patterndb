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
    it { expect {should compile}.to raise_error(Puppet::Error, /Must pass patterns/m)}
  end
  context "Simple ruleset without rules" do
    let :params do
      default_params.merge(
        {
          :patterns => [ 'P' ]
        }
      )
    end
    it { expect {should compile}.to raise_error(Puppet::Error, /Must pass rules/m)}
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
    it { expect {should compile}.to raise_error(Puppet::Error, /is not an Array/m)}
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
    it { expect {should compile}.to raise_error(Puppet::Error, /is not an Array/m)}
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
        /<patterndb/m
      ).with_content(
        /<\/patterndb>/m
      ).with_content(
        /name='myruleset'/m
      ).with_content(
        /id='ID'/m
      ).with_content(
        /pub_date='1970-01-01'/m
      )
    }
  end
  context "Simple ruleset with one rule and 2 examples" do
    let :params do
      default_params.merge(
        {
          :patterns => [ 'P1', 'P2' ],
          :rules => [
            {
              'id' => 'RULE_1_ID',
              'patterns' => [
                'Simple ruleset with @ESTRING:num_rules: @rule and @NUMBER:num_examples@ example',
                'Simple ruleset with @ESTRING:num_rules: @rules and @NUMBER:num_examples@ examples',
                'Simple ruleset with @ESTRING:num_rules: @rule and @NUMBER:num_examples@ examples',
                'Simple ruleset with @ESTRING:num_rules: @rules and @NUMBER:num_examples@ example'
              ],
              'examples' => [
                {
                  'test_message' => 'Simple ruleset with 2 rules and 1 example',
                  'program' => 'P1',
                  'test_values' => {
                    'num_examples' => '1',
                    'num_rules' => '2',
                  },
                },
              ]
            },{
              'id' => 'RULE_2_ID',
              'patterns' => [
                'This is a @ESTRING:type: @rule'
              ],
              'examples' => [
                {
                  'test_message' => 'This is a simple rule',
                  'program' => 'P2',
                  'test_values' => {
                    'type' => 'simple',
                  },
                },
                {
                  'test_message' => 'This is a complicated rule',
                  'program' => 'P2',
                  'test_values' => {
                    'type' => 'complicated',
                  },
                },
              ]
            }
          ]
        }
      )
    end
    #it {
    #  pp subject.resources
    #}
    it {
      should contain_patterndb__simple__example('RULE_1_ID-0')
      should_not contain_patterndb__simple__example('RULE_1_ID-1')
      should contain_patterndb__simple__example('RULE_2_ID-0')
      should contain_patterndb__simple__example('RULE_2_ID-1')
    }
  end
  context "Simple ruleset with one rule, correlation and action" do
    let :params do
      default_params.merge(
        {
          :patterns => [ 'foo' ],
          :rules => [
            {
              'id' => 'RULE_ID',
              'patterns' => [ 'this is a log message where @ESTRING:key:=@@ANYSTRING:value@' ],
              'provider' => 'PROVIDER',
              'ruleclass' => 'RULECLASS',
              'values' => { 'KEY_FOO' => 'VAL_FOO', 'KEY_BAZ' => 'VAL_BAZ' },
              'tags' => [ 'TAG_FOO', 'TAG_BAR' ],
              'context_id' => 'CTX_FOO',
              'context_timeout' => 42,
              'context_scope' => 'global',
              'actions' => [
                {
                  'trigger' => 'timeout',
                  'rate' => '1/60',
                  'condition' => '"2" > "1"',
                  'message' => {
                    'inherit_properties' => 'TRUE',
                    'values' => {
                      'MESSAGE' => 'MESSAGE_ACTION',
                    },
                    'tags' => [ 'TAG_ACTION' ],
                  }
                },
              ],
            },
          ],
        }
      )
    end
    it {
      should contain_file('BASEDIR/etc/syslog-ng/patterndb.d/myruleset.pdb').with_content(
        /<pattern>this is a log message where @ESTRING:key:=@@ANYSTRING:value@/m
      ).with_content(
        /provider='PROVIDER'/m
      ).with_content(
        /class='RULECLASS'/m
      ).with_content(
        /<value name='KEY_FOO'>VAL_FOO<\/value>/
      ).with_content(
        /<value name='KEY_BAZ'>VAL_BAZ<\/value>/
      ).with_content(
        /<tag>TAG_FOO<\/tag>/
      ).with_content(
        /<tag>TAG_BAR<\/tag>/
      ).with_content(
        /context-id='CTX_FOO'/
      ).with_content(
        /context-scope='global'/
      ).with_content(
        /context-timeout='42'/
      ).with_content(
        /<actions>/
      ).with_content(
        /<action.*trigger='timeout'.*<\/action>/m
      ).with_content(
        /<action.*rate='1\/60'.*<\/action>/m
      ).with_content(
        /<action.*condition='"2" > "1"'.*<\/action>/m
      )
    }
    it {
      should contain_file('BASEDIR/etc/syslog-ng/patterndb.d/myruleset.pdb').with_content(
        /<action.*>.*<message .*inherit-properties='TRUE'.*>.*<values>.*<value name='MESSAGE'>.*MESSAGE_ACTION.*<\/value>.*<\/values>.*<\/action>/m
      ).with_content(
        /<action.*>.*<message .*inherit-properties='TRUE'.*>.*<tags>.*<tag>.*TAG_ACTION.*<\/tag>.*<\/tags>.*<\/action>/m
      )
    }
    it {
      should contain_patterndb__simple__action('RULE_ID-0')
      should contain_patterndb__simple__action__message('RULE_ID-0-message')
    }
  end
end
