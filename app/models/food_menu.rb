# frozen_string_literal: true

# This is a model
class FoodMenu < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :user
  belongs_to :food_store

  validates :title, presence: true, uniqueness: { scope: :food_store_id, case_sensitive: false }
  validates :price, presence: true, numericality: { less_than_or_equal_to: 1000, message: 'should be less than 1000' }

  index_name "food_menus_#{Rails.env}"

  settings do
    mappings dynamic: 'false' do
      indexes :title, type: 'text'
      indexes :food_store_id, type: 'integer'
      indexes :food_category_id, type: 'integer'
    end
  end

  def as_indexed_json(_options = {})
    {
      title: title,
      food_store_id: food_store_id,
      food_category_id: food_category_id
    }
  end

  def self.basic_search(query)
    __elasticsearch__.search(
      query: {
        match: {
          title: query
        }
      }
    )
  end

  # rubocop:disable Metrics/MethodLength

  def self.filter_search(query, food_store_id = nil, food_category_id = nil)
    search_query = {
      query: {
        bool: {
          must: {
            match: {
              title: query
            }
          },
          filter: []
        }
      }
    }
    # rubocop:enable Metrics/MethodLength

    search_query[:query][:bool][:filter] << { term: { food_store_id: food_store_id } } if food_store_id.present?
    if food_category_id.present?
      search_query[:query][:bool][:filter] << { term: { food_category_id: food_category_id } }
    end

    __elasticsearch__.search(search_query)
  end
end
