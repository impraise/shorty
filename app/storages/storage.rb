require './app/storages/in_memory_adapter'

# = Storage
#
# Basic factory to return pluggable storage adapters
class Storage
  def self.instance
    @instance ||= Object.const_get(Shorty.config[:storage_adapter]).new
  end
end
