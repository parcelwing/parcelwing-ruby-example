# frozen_string_literal: true

require "dotenv/load"
require "json"
require "sinatra/base"
require "parcelwing"

module ParcelWingRubyExample
  class App < Sinatra::Base
    set :root, File.dirname(__FILE__)
    set :public_folder, proc { File.join(root, "public") }
    set :views, proc { File.join(root, "views") }
    set :bind, "0.0.0.0"
    set :port, ENV.fetch("PORT", "4567").to_i

    helpers do
      def form_defaults
        {
          api_key: ENV.fetch("PARCELWING_API_KEY", ""),
          base_url: ENV.fetch("PARCELWING_BASE_URL", "https://parcelwing.com"),
          from: ENV.fetch("PARCELWING_FROM", ""),
          to: ENV.fetch("PARCELWING_TO", ""),
          subject: "Hello from Parcel Wing + Ruby",
          text: "Hi there,\n\nThis email was sent from the Parcel Wing Ruby SDK example app.\n\nHappy sending!",
          html: "<strong>Hi there,</strong><br><br>This email was sent from the <em>Parcel Wing Ruby SDK</em> example app.<br><br>Happy sending!"
        }
      end

      def h(value)
        Rack::Utils.escape_html(value.to_s)
      end

      def pretty_json(value)
        JSON.pretty_generate(value)
      end
    end

    get "/" do
      @defaults = form_defaults
      @result = nil
      @error = nil
      erb :index
    end

    post "/send" do
      @defaults = form_defaults.merge(
        api_key: params.fetch("api_key", ""),
        base_url: params.fetch("base_url", "https://parcelwing.com"),
        from: params.fetch("from", ""),
        to: params.fetch("to", ""),
        subject: params.fetch("subject", ""),
        text: params.fetch("text", ""),
        html: params.fetch("html", "")
      )

      payload = build_email_payload(@defaults)
      client = ParcelWing::Client.new(
        api_key: @defaults[:api_key],
        base_url: @defaults[:base_url]
      )

      @result = client.emails.send(payload)
      @error = nil
      erb :index
    rescue ParcelWing::Error => e
      @result = nil
      @error = {
        status: e.status,
        type: e.type,
        code: e.code,
        message: e.message,
        request_id: e.request_id,
        details: e.details
      }.compact
      erb :index
    rescue StandardError => e
      @result = nil
      @error = {
        type: e.class.name,
        message: e.message
      }
      erb :index
    end

    private

    def build_email_payload(values)
      recipients = values[:to].split(",").map(&:strip).reject(&:empty?)
      to = recipients.length == 1 ? recipients.first : recipients

      payload = {
        from: values[:from],
        to: to,
        subject: values[:subject],
        text: values[:text]
      }

      html = values[:html].to_s.strip
      payload[:html] = html unless html.empty?

      payload
    end
  end
end
