# frozen_string_literal: true

module Gitlab
  module Badge
    module Coverage
      ##
      # Class that represents a coverage badge template.
      #
      # Template object will be passed to badge.svg.erb template.
      #
      class Template < Badge::Template
        STATUS_COLOR = {
          good: '#4c1',
          acceptable: '#a3c51c',
          medium: '#dfb317',
          low: '#e05d44',
          unknown: '#9f9f9f'
        }.freeze

        def initialize(badge)
          @entity = badge.entity
          @status = badge.status
          @key_text = badge.customization.dig(:key_text)
          @key_width = badge.customization.dig(:key_width)
        end

        def key_text
          if @key_text && @key_text.size <= MAX_KEY_SIZE
            @key_text
          else
            @entity.to_s
          end
        end

        def value_text
          @status ? ("%.2f%%" % @status) : 'unknown'
        end

        def key_width
          if @key_width && @key_width.between?(1, MAX_KEY_SIZE)
            @key_width
          else
            62
          end
        end

        def value_width
          @status ? 54 : 58
        end

        def value_color
          case @status
          when 95..100 then STATUS_COLOR[:good]
          when 90..95 then STATUS_COLOR[:acceptable]
          when 75..90 then STATUS_COLOR[:medium]
          when 0..75 then STATUS_COLOR[:low]
          else
            STATUS_COLOR[:unknown]
          end
        end
      end
    end
  end
end
