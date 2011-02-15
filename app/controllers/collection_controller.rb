class CollectionController < ApplicationController
  def find
    db = @context.to_database
    collection = db.collection(params[:collection])
  
    selector = params[:selector]    
    if selector.blank? || !selector.is_a?(hash)
      selector = {}      
    end

    options = {}
    options[:fields] = params[:fields] if params[:fields]
    options[:sort] = build_sort(params[:sort]) if params[:sort]
    options[:limit] = params[:limit].to_i == 0 ? 200 : params[:limit].to_i
    options[:skip] = params[:skip].to_i if params[:skip].to_i != 0
    p options
    finder = collection.find(selector, options)
    render :json => finder
  end
  def count
    db = @context.to_database
    collection = db.collection(params[:collection])
    selector = params[:selector]    
    if selector.blank? || !selector.is_a?(hash)
      selector = {}      
    end
    render :json => {:count => collection.find(selector).count }
  end
  def stats
    render :json => @context.to_database.collection(params[:collection]).stats
  end
  def get_indexes
    render :json => @context.to_database.collection(params[:collection]).index_information
  end
  
  private
  def build_sort(raw)
    raw.map{|k, v| [k, v == '1' ? :ascending : :descending]}
  end
end