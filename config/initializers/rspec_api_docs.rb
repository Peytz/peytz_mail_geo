unless Rails.env.production?
  RspecApiDocumentation.configure do |config|
    config.format = :open_api

    config.docs_dir = Rails.root.join('public', 'api', 'v1')

    config.request_headers_to_include = %w[Content-Type]
    config.response_headers_to_include = %w[Content-Type]

    config.keep_source_order = true
  end
end