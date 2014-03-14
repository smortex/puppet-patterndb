#
Puppet::Type.newtype(:pdb_ruleset) do
	@doc = %q{Creates a new syslog-ng::patterndb ruleset
  
  Example:
  
		pdb_ruleset {'myruleset':
			id => '2aa2ce11-9492-4f1d-9841-e4dcece5cce9',
			patterns => [ 'program1', 'program2' ],
		}
  }
  ensurable
	newparam(:id) do
		desc "Unique identifier of the ruleset (uuid recommended)"
		isnamevar
	end
	newparam(:patterns, :array_matching => :all) do
    validate do |value|
      if value == "dhclient"
        raise ArgumentError,
          "frack"
      end
    end
		desc "Array containing patterns matching program"
	end
end
# vim:ft=ruby
