module Grapcha
  class SessionMemoryStore
    def storage
      @storage ||= {}
    end

    def id
      @id ||= SecureRandom.hex
    end

    def mark(hash)
      storage[id] = hash
    end

    def valid?(hash)
      storage.delete(id) == hash
    end
  end
end
