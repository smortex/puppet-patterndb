#
Puppet::Type.type(:ruleset).provide(:noop) do
  desc "This provider does absolutely nothing"
  def create
  end
  def destroy
  end
  def exists?
  end
end
