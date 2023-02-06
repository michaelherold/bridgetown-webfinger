# frozen_string_literal: true

module RodaHelper
  def app(&block)
    return @app unless block

    app = Class.new(Bridgetown::Rack::Roda)

    app.class_eval(&block)
    Rack::Lint.new(app)

    @app = app.tap(&:freeze)
  end
end
