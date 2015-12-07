# encoding: utf-8
module Mongoid
  module Relations
    module LazyEager

      class HasMany < Eager::HasMany

        def preload_with_lazy_trigger
          preloader = ->(metadata, criteria) do
            @metadata = metadata
            preload_without_lazy_trigger
            id = criteria.selector[metadata.foreign_key]
            grouped_docs[id]
          end
          preloader = preloader.curry[@metadata]

          @docs.each do |doc|
            doc.send(@metadata.name).preload_with(&preloader)
          end
        end

        alias_method :preload_without_lazy_trigger, :preload
        alias_method :preload, :preload_with_lazy_trigger
      end
    end
  end
end
