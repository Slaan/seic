  module IdHelper

    def self.to_id(entity)
      unless entity.kind_of? Integer then entity = entity.id end
      entity
    end
  end
