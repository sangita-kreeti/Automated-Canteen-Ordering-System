# frozen_string_literal: true

Elasticsearch::Model.client = Elasticsearch::Client.new(url: 'http://localhost:9200')
