# Copyright (C) 2012-2025 Zammad Foundation, https://zammad-foundation.org/

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

  def index
    render json: sql_helper.table_search(model, params), status: :ok
  end

  def show
    row = sql_helper.table_search(model, params).first
    render json: row, status: (row.present? ? :ok : :not_found)
  end

  def columns
    render json: model.columns.to_h { |c| [c.name, c.sql_type_metadata.type] }, status: :ok
  end

  def all
    render json: models.transform_values(&:to_s), status: :ok
  end
end
