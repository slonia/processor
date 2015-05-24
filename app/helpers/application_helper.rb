module ApplicationHelper
  def pages_for(records)
    paginate @tasks, theme: 'twitter-bootstrap-3', pagination_class: "pagination-sm pull-right"
  end
end
