# Copyright (C) 2012-2023 Zammad Foundation, https://zammad-foundation.org/

# rubocop:disable Metrics/BlockLength, Metrics/AbcSize

TABLE_SEARCH_DATE_TYPES   = %i[datetime date].freeze
TABLE_SEARCH_STRING_TYPES = %i[string].freeze

ActiveSupport::Reloader.to_prepare do
  require_dependency 'sql_helper'

  SqlHelper.class_eval do
    def table_search(model, params)
      generic_objects = model
      generic_objects = get_condition_sql(generic_objects, params)
      generic_objects = generic_objects.reorder(Arel.sql(table_search_order_sql(params))).offset(params[:offset]).limit(params[:limit] || 500)
      generic_objects.map(&:attributes)
    end

    def table_search_order_sql(params)
      sort_by  = get_sort_by(params, 'id')
      order_by = get_order_by(params, 'ASC')
      get_order(sort_by, order_by)
    end

    def full_text_match(attribute, negated: false)
      stmt = if mysql?
               "MATCH (#{attribute}) AGAINST (?)"
             else
               "#{attribute} @@ ?"
             end

      if negated
        "NOT(#{stmt}"
      else
        stmt
      end
    end

    def object_columns
      @object_columns ||= @object.columns
    end

    def object_date_columns
      @object_date_columns ||= @object.columns.select { |c| TABLE_SEARCH_DATE_TYPES.include?(c.sql_type_metadata.type) }
    end

    def object_string_columns
      @object_string_columns ||= object_columns.select { |c| TABLE_SEARCH_STRING_TYPES.include?(c.sql_type_metadata.type) }
    end

    def get_condition_sql(relation, params)
      relation = where_exact_match(relation, params)
      relation = where_date_match(relation, params)
      relation = where_search_match(relation, params)
      relation = where_contains_match(relation, params)
      relation = where_regex_match(relation, params)
      relation = where_empty_match(relation, params)
      relation = where_null_match(relation, params)
      where_in_match(relation, params)

    end

    def where_exact_match(relation, params)
      object_columns.each do |column|
        eq = params[column.name]
        if eq.present?
          relation = relation.where(column.name => eq)
        end

        eq_not = params["#{column.name}_not"]
        if eq_not.present?
          relation = relation.where.not(column.name => eq_not)
        end
      end
      relation
    end

    def where_date_match(relation, params)
      object_date_columns.each do |column|
        lt = params["#{column.name}_lt"]
        if lt.present?
          relation = relation.where("#{column.name} < ?", lt)
        end

        le = params["#{column.name}_le"]
        if le.present?
          relation = relation.where("#{column.name} <= ?", le)
        end

        gt = params["#{column.name}_gt"]
        if gt.present?
          relation = relation.where("#{column.name} > ?", gt)
        end

        ge = params["#{column.name}_ge"]
        if ge.present?
          relation = relation.where("#{column.name} >= ?", ge)
        end
      end
      relation
    end

    def where_search_match(relation, params)
      return relation if params[:search].blank?

      sql_or   = []
      sql_bind = []
      object_string_columns.each do |column|
        sql_or << "#{column.name} LIKE ?"
        sql_bind << "%#{params[:search]}%"
        sql_or << full_text_match(column.name)
        sql_bind << params[:search]
      end
      return relation if sql_or.blank?

      relation.where(sql_or.join(' OR '), *sql_bind)
    end

    def where_contains_match(relation, params)
      object_string_columns.each do |column|
        contains = params["#{column.name}_contains"]
        if contains.present?
          relation = relation.where("#{column.name} LIKE ?", "%#{contains}%")
        end

        contains_not = params["#{column.name}_contains_not"]
        if contains_not.present?
          relation = relation.where("#{column.name} NOT LIKE ?", "%#{contains_not}%")
        end
      end
      relation
    end

    def where_regex_match(relation, params)
      object_string_columns.each do |column|
        regex = params["#{column.name}_regex"]
        if regex.present?
          relation = relation.where(regex_match(column.name), regex)
        end

        regex_not = params["#{column.name}_regex_not"]
        if regex_not.present?
          relation = relation.where(regex_match(column.name, negated: true), regex_not)
        end
      end
      relation
    end

    def where_empty_match(relation, params)
      object_string_columns.each do |column|
        empty = params["#{column.name}_empty"]
        if empty.present?
          relation = relation.where("#{column.name} = ''")
        end

        empty_not = params["#{column.name}_empty_not"]
        if empty_not.present?
          relation = relation.where("LENGTH(#{column.name}) > 0")
        end
      end
      relation
    end

    def where_null_match(relation, params)
      object_string_columns.each do |column|
        null = params["#{column.name}_null"]
        if null.present?
          relation = relation.where("#{column.name} IS NULL")
        end

        null_not = params["#{column.name}_null_not"]
        if null_not.present?
          relation = relation.where("#{column.name} IS NOT NULL")
        end
      end
      relation
    end

    def where_in_match(relation, params)
      object_columns.each do |column|
        value_in = params["#{column.name}_in"]&.split(%r{,\s*})
        if value_in.present?
          relation = relation.where("#{column.name} IN (?)", value_in)
        end

        value_in_not = params["#{column.name}_in_not"]&.split(%r{,\s*})
        if value_in_not.present?
          relation = relation.where("#{column.name} NOT IN (?)", value_in_not)
        end
      end
      relation
    end
  end
end

# rubocop:enable Metrics/BlockLength, Metrics/AbcSize
