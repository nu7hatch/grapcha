module Grapcha
  module GravatarMemoryStore
    def self.included(base)
      base.extend(ClassMethods)
    end

    def save
      self.class.storage[self.hash] = true
    end

    module ClassMethods
      def storage
        @storage ||= {}
      end

      def random(limit, insert)
        result = [ insert ]
        hashes = storage.keys.dup

        hashes.delete(insert)

        while limit > 1
          hash = hashes.delete_at(rand(hashes.size))
          result << hash
          limit -= 1
        end

        result
      end
    end
  end
end
