# Copyright (C) 2012-2023 Zammad Foundation, https://zammad-foundation.org/

class TablesController < ApplicationController
  prepend_before_action :authenticate_and_authorize!

  def models
    @models ||= Models.all.keys.index_by(&:table_name)
  end

  def model
    @model ||= models[params[:table]]
  end

  def sql_helper
    @sql_helper ||= ::SqlHelper.new(object: model)
  end

  def order_sql
    @order_sql ||= begin
      sort_by  = sql_helper.get_sort_by(params, 'id')
      order_by = sql_helper.get_order_by(params, 'ASC')
      sql_helper.get_order(sort_by, order_by)
    end
  end

  def index
    paginate_with(default: 500)

    generic_objects = model
    generic_objects = sql_helper.get_condition_sql(generic_objects, params)
    generic_objects = generic_objects.reorder(Arel.sql(order_sql)).offset(pagination.offset).limit(pagination.limit)
    result          = generic_objects.map(&:attributes)

    render json: result, status: :ok
  end

  def all
    render json: models.transform_values(&:to_s), status: :ok
  end
end
